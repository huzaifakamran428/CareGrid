"""End-to-end tests for localhost FAQ API, SQLite persistence and admin key."""
import json
import sys
import tempfile
import threading
import unittest
from http.server import ThreadingHTTPServer
from pathlib import Path
from urllib.error import HTTPError
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from demo_assistant_backend import DemoAssistantStore
from run_local_demo import make_handler

KEY = "test-local-admin-key-123456-not-production"


class LocalAssistantServerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.db_path = Path(cls.tmp.name) / "assistant.sqlite3"
        cls.store = DemoAssistantStore(cls.db_path)
        cls.httpd = ThreadingHTTPServer(("127.0.0.1", 0), make_handler(cls.store, KEY))
        cls.port = cls.httpd.server_address[1]
        cls.base = f"http://127.0.0.1:{cls.port}"
        cls.thread = threading.Thread(target=cls.httpd.serve_forever, daemon=True)
        cls.thread.start()

    @classmethod
    def tearDownClass(cls):
        cls.httpd.shutdown()
        cls.httpd.server_close()
        cls.thread.join(timeout=3)
        cls.tmp.cleanup()

    def call(self, route, method="GET", payload=None, key=None, origin=None):
        headers = {}
        if payload is not None:
            headers["Content-Type"] = "application/json"
        if key:
            headers["X-CareGrid-Admin-Key"] = key
        if origin:
            headers["Origin"] = origin
        body = json.dumps(payload).encode("utf-8") if payload is not None else None
        req = Request(self.base + route, data=body, method=method, headers=headers)
        try:
            with urlopen(req, timeout=5) as response:
                return response.status, json.load(response)
        except HTTPError as exc:
            return exc.code, json.load(exc)

    def test_01_health_and_roles(self):
        status, data = self.call("/api/assistant/status")
        self.assertEqual(status, 200)
        self.assertTrue(data["online"])
        self.assertEqual(data["mode"], "local-sqlite-demo")
        self.assertTrue(data["adminKeyConfigured"])
        code, data = self.call("/api/assistant/faqs?role=lab")
        self.assertEqual(code, 200)
        self.assertTrue(all("lab" in f["roles"] and f["enabled"] for f in data["faqs"]))
        self.assertEqual(self.call("/api/assistant/faqs")[0], 400)
        self.assertEqual(self.call("/api/assistant/faqs?role=random")[0], 400)

    def test_02_admin_protected(self):
        self.assertEqual(self.call("/api/assistant/admin/state")[0], 401)
        self.assertEqual(self.call("/api/assistant/admin/state", key="wrong")[0], 401)
        code, state = self.call("/api/assistant/admin/state", key=KEY)
        self.assertEqual(code, 200)
        self.assertTrue(len(state["faqs"]) >= 6)
        self.assertIn("retainHistory", state["criteria"])
        self.assertIsInstance(state["history"], list)

    def test_03_shared_redacted_history_persists_after_new_store(self):
        code, reply = self.call("/api/assistant/reply", "POST",
            {"role": "ngo", "question": "How do I register a beneficiary?",
             "sessionId": "tab-ngo"})
        self.assertEqual(code, 200)
        self.assertIn("Walk-in Registration", reply["text"])
        code, reply = self.call("/api/assistant/reply", "POST",
            {"role": "lab", "question": "My CNIC 35202-1234567-8: need test advice",
             "sessionId": "tab-lab"})
        self.assertEqual(code, 200)
        after = DemoAssistantStore(self.db_path)
        hist = after.get_history()
        self.assertGreaterEqual(len(hist), 2)
        self.assertEqual(hist[-1]["role"], "lab")
        self.assertIn("[redacted CNIC]", hist[-1]["question"])
        self.assertNotIn("1234567", json.dumps(hist))
        self.assertIn(hist[-2]["role"], ("ngo", "lab"))

    def test_04_admin_edit_updates_other_role_and_reloads(self):
        state = self.call("/api/assistant/admin/state", key=KEY)[1]
        faqs = state["faqs"]
        faqs.insert(0, {"id": "test-faq", "question": "Who is the test-team?",
            "answer": "The demo team answers from server SQLite.", "keywords": "test-team",
            "roles": ["pharmacy"], "enabled": True, "category": "Testing"})
        code, result = self.call("/api/assistant/admin/faqs", "PUT",
                                 {"faqs": faqs}, key=KEY)
        self.assertEqual(code, 200)
        self.assertEqual(len(result["faqs"]), len(faqs))
        self.assertIn("test-faq", [f["id"] for f in DemoAssistantStore(self.db_path).get_faqs()])
        code, reply = self.call("/api/assistant/reply", "POST",
                                {"role": "pharmacy", "question": "test-team", "sessionId": "pharm"})
        self.assertEqual(code, 200)
        self.assertEqual(reply["text"], "The demo team answers from server SQLite.")
        self.assertNotEqual(self.call("/api/assistant/reply", "POST",
            {"role": "ngo", "question": "test-team", "sessionId": "ngo"})[1]["text"], reply["text"])

    def test_05_criteria_and_history_delete(self):
        crit = self.store.get_criteria()
        crit["minimumMatches"] = 3
        crit["fallback"] = "No demonstration rule matches."
        code, body = self.call("/api/assistant/admin/criteria", "PUT",
                               {"criteria": crit}, key=KEY)
        self.assertEqual(code, 200)
        self.assertEqual(body["criteria"]["minimumMatches"], 3)
        response = self.call("/api/assistant/reply", "POST",
                             {"role": "pharmacy", "question": "test-team"})[1]
        self.assertEqual(response["text"], "No demonstration rule matches.")
        self.assertEqual(self.call("/api/assistant/admin/history", "DELETE")[0], 401)
        code, body = self.call("/api/assistant/admin/history", "DELETE", key=KEY)
        self.assertEqual(code, 200)
        self.assertEqual(body["history"], [])
        self.assertEqual(self.store.get_history(), [])

    def test_06_input_validation_and_origin(self):
        self.assertEqual(self.call("/api/assistant/reply", "POST",
            {"role": "random", "question": "hello"})[0], 400)
        self.assertEqual(self.call("/api/assistant/reply", "POST",
            {"role": "lab", "question": "A" * 1100})[0], 400)
        self.assertEqual(self.call("/api/assistant/reply", "POST",
            {"role": "lab", "question": "hello"}, origin="https://evil.example")[0], 403)
        self.assertEqual(self.call("/api/assistant/admin/faqs", "PUT",
            {"faqs": [{"id": "a", "question": "q", "answer": "a", "keywords": "a",
                       "roles": ["not-a-role"], "enabled": True, "category": "x"}]},
            key=KEY)[0], 400)

    def test_07_emptied_faqs_dont_reseed(self):
        code, body = self.call("/api/assistant/admin/faqs", "PUT",
                               {"faqs": []}, key=KEY)
        self.assertEqual(code, 200)
        self.assertEqual(body["faqs"], [])
        self.assertEqual(DemoAssistantStore(self.db_path).get_faqs(), [])
        self.assertEqual(self.call("/api/assistant/faqs?role=ngo")[1]["faqs"], [])


if __name__ == "__main__":
    unittest.main()

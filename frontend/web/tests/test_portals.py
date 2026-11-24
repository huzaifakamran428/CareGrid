import pathlib
import re
import unittest

ROOT=pathlib.Path(__file__).resolve().parents[1]

class WebPortalSmokeTests(unittest.TestCase):
    def test_shared_assistant_on_all_role_pages(self):
        files = {
            "ngo_portal/index.html":"ngo",
            "admin_portal/index.html":"admin",
            "pharmacy_portal/index.html":"pharmacy",
            **{f"labs/templates/{p}.html":"lab" for p in (
                "dashboard","appointments","lab_report_upload","lab_requests",
                "lab_test_catalog","request_details")},
            "chatbot/templates/chatbot.html":"lab",
        }
        for file,role in files.items():
            with self.subTest(file=file):
                page=ROOT/file
                self.assertTrue(page.is_file(),file)
                html=page.read_text(encoding='utf8')
                self.assertIn(f'data-caregrid-role="{role}"',html)
                links=re.findall(r'<script[^>]+src="([^"]+)"',html)
                shared=[v for v in links if v.endswith("shared/assistant.js")]
                self.assertEqual(len(shared),1)
                self.assertTrue((page.parent/shared[0]).is_file())
    def test_admin_controls_exist(self):
        page=(ROOT/"admin_portal/assistant_control.html").read_text()
        for name in ("criteria-form","faq-form","history-body","history-role"):
            self.assertIn(name,page)
        self.assertIn("assistant_control.html",(ROOT/"admin_portal/assets/app.js").read_text())
    def test_single_origin_runner(self):
        text=(ROOT/"run_local_demo.py").read_text()
        self.assertIn('"127.0.0.1"',text)
        self.assertIn('ThreadingHTTPServer((HOST, PORT)',text)

if __name__ == "__main__":
    unittest.main()

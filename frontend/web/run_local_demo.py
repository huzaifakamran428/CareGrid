#!/usr/bin/env python3
"""Single-origin CareGrid LOCAL demo server with a SQLite FAQ assistant.

NOT production authentication. Binds to loopback only. Never expose this server
on a network or use it for real personal, patient, CNIC or financial records.
"""
from __future__ import annotations

import hmac
import json
import os
import sqlite3
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlsplit

from demo_assistant_backend import DemoAssistantStore, InvalidRequest

ROOT = Path(__file__).resolve().parent
HOST, PORT = "127.0.0.1", 8000
DB_PATH = Path(os.getenv("CAREGRID_DEMO_DB", "~/.caregrid_demo/assistant.sqlite3")).expanduser()
ADMIN_KEY = os.getenv("CAREGRID_DEMO_ADMIN_KEY", "").strip()
MAX_JSON = 512 * 1024


def make_handler(store: DemoAssistantStore, admin_key: str, root=ROOT):
    """Injectable handler factory for isolated HTTP tests."""
    class LocalDemoHandler(SimpleHTTPRequestHandler):
        def __init__(self, *args, **kwargs):
            super().__init__(*args, directory=str(root), **kwargs)

        def log_message(self, format, *args):
            # Do not log request bodies or security keys. Default logs only path/status.
            super().log_message(format, *args)

        def list_directory(self, path):
            self.send_error(403, "Directory browsing disabled")
            return None

        def end_headers(self):
            self.send_header("Cache-Control", "no-store")
            self.send_header("X-Content-Type-Options", "nosniff")
            self.send_header("Referrer-Policy", "no-referrer")
            self.send_header("X-Frame-Options", "DENY")
            super().end_headers()

        def _json(self, status, data):
            body = json.dumps(data, ensure_ascii=False).encode("utf-8")
            self.send_response(status)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)

        def _valid_local_request(self):
            # Mitigate DNS rebinding / cross-origin requests in this local-only demo.
            host = self.headers.get("Host", "").lower()
            actual_port = self.server.server_address[1]
            if host not in (f"127.0.0.1:{actual_port}", f"localhost:{actual_port}"):
                self._json(403, {"error": "Use the documented loopback host"})
                return False
            if self.command in ("POST", "PUT", "DELETE"):
                origin = self.headers.get("Origin")
                if origin and origin != f"http://{host}":
                    self._json(403, {"error": "Cross-origin requests are not supported"})
                    return False
            return True

        def _admin(self):
            if len(admin_key) < 16:
                self._json(503, {"error": "Set CAREGRID_DEMO_ADMIN_KEY (16+ characters) when starting the demo server"})
                return False
            supplied = self.headers.get("X-CareGrid-Admin-Key", "")
            if not hmac.compare_digest(supplied, admin_key):
                self._json(401, {"error": "Invalid local demo administrator key"})
                return False
            return True

        def _body(self):
            content_type = self.headers.get("Content-Type", "").split(";")[0].strip().lower()
            if content_type != "application/json":
                raise InvalidRequest("Content-Type must be application/json")
            try:
                length = int(self.headers.get("Content-Length", "0"))
            except ValueError:
                raise InvalidRequest("Invalid request size") from None
            if length <= 0 or length > MAX_JSON:
                raise InvalidRequest("Request JSON is empty or too large")
            try:
                data = json.loads(self.rfile.read(length).decode("utf-8"))
            except (UnicodeDecodeError, ValueError):
                raise InvalidRequest("Invalid JSON body") from None
            if not isinstance(data, dict):
                raise InvalidRequest("Expected a JSON object")
            return data

        def _dispatch(self):
            if not self._valid_local_request():
                return
            parsed = urlsplit(self.path)
            path = parsed.path
            try:
                if self.command == "GET" and path == "/api/assistant/status":
                    self._json(200, {"online": True, "mode": "local-sqlite-demo",
                                     "adminKeyConfigured": len(admin_key) >= 16})
                    return
                if self.command == "GET" and path == "/api/assistant/faqs":
                    role = parse_qs(parsed.query).get("role", [""])[0]
                    if role not in ("ngo", "admin", "lab", "pharmacy"):
                        raise InvalidRequest("A valid role query parameter is required")
                    self._json(200, {"faqs": store.get_faqs(role)})
                    return
                if self.command == "POST" and path == "/api/assistant/reply":
                    req = self._body()
                    self._json(200, store.reply(req.get("role"), req.get("question"),
                                                req.get("sessionId", "")))
                    return
                if path.startswith("/api/assistant/admin/"):
                    if not self._admin():
                        return
                    if self.command == "GET" and path == "/api/assistant/admin/state":
                        self._json(200, {"faqs": store.get_faqs(), "criteria": store.get_criteria(),
                                         "history": store.get_history()})
                        return
                    if self.command == "PUT" and path == "/api/assistant/admin/faqs":
                        body = self._body()
                        self._json(200, {"faqs": store.replace_faqs(body.get("faqs"))})
                        return
                    if self.command == "PUT" and path == "/api/assistant/admin/criteria":
                        body = self._body()
                        self._json(200, {"criteria": store.replace_criteria(body.get("criteria"))})
                        return
                    if self.command == "DELETE" and path == "/api/assistant/admin/history":
                        store.clear_history()
                        self._json(200, {"history": []})
                        return
                    self._json(404, {"error": "Unknown admin endpoint"})
                    return
                if path.startswith("/api/"):
                    self._json(404, {"error": "Unknown assistant endpoint"})
                    return
                if self.command == "GET":
                    if path == "/":
                        self.send_response(302)
                        self.send_header("Location", "/ngo_portal/index.html")
                        self.end_headers()
                        return
                    return super().do_GET()
                self._json(405, {"error": "Method not supported"})
            except InvalidRequest as exc:
                self._json(400, {"error": str(exc)})
            except sqlite3.Error:
                self._json(503, {"error": "Local demo database is unavailable"})

        def do_GET(self):
            self._dispatch()

        def do_POST(self):
            self._dispatch()

        def do_PUT(self):
            self._dispatch()

        def do_DELETE(self):
            self._dispatch()

    return LocalDemoHandler


if __name__ == "__main__":
    if ADMIN_KEY and len(ADMIN_KEY) < 16:
        raise SystemExit("CAREGRID_DEMO_ADMIN_KEY must have 16+ characters (or be unset for read-only mode).")
    store = DemoAssistantStore(DB_PATH)
    with ThreadingHTTPServer((HOST, PORT), make_handler(store, ADMIN_KEY)) as server:
        print("CareGrid localhost prototype — fictional records ONLY")
        print(f"NGO      http://{HOST}:{PORT}/ngo_portal/index.html")
        print(f"Admin    http://{HOST}:{PORT}/admin_portal/index.html")
        print(f"Controls http://{HOST}:{PORT}/admin_portal/assistant_control.html")
        print(f"Lab      http://{HOST}:{PORT}/labs/templates/dashboard.html")
        print(f"Pharmacy http://{HOST}:{PORT}/pharmacy_portal/index.html")
        print(f"SQLite demo FAQ/history database: {DB_PATH}")
        print("Admin control:", "enabled (demo key required)" if ADMIN_KEY else "read-only; set CAREGRID_DEMO_ADMIN_KEY to edit")
        print("NO login or verified role identity. No production use. Ctrl+C to stop.")
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            print("\nLocal demo server stopped.")

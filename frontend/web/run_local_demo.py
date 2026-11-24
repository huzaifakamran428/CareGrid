#!/usr/bin/env python3
"""Serve all fictional CareGrid web previews at ONE loopback-only origin.

Only for local frontend demonstrations. There is no login or role enforcement.
Do not put real beneficiaries, patients, identity numbers, or private data here.
"""
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlsplit

ROOT = Path(__file__).resolve().parent
HOST = "127.0.0.1"
PORT = 8000


class LocalDemoHandler(SimpleHTTPRequestHandler):
    def list_directory(self, path):
        self.send_error(403, "Directory browsing disabled")
        return None

    def end_headers(self):
        self.send_header("Cache-Control", "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("Referrer-Policy", "no-referrer")
        super().end_headers()

    def do_GET(self):
        if urlsplit(self.path).path == "/":
            self.send_response(302)
            self.send_header("Location", "/ngo_portal/index.html")
            self.end_headers()
            return
        super().do_GET()


if __name__ == "__main__":
    handler = partial(LocalDemoHandler, directory=str(ROOT))
    with ThreadingHTTPServer((HOST, PORT), handler) as server:
        print("CareGrid frontend-only local demo (fictional data only)")
        print(f"NGO      http://{HOST}:{PORT}/ngo_portal/index.html")
        print(f"Admin    http://{HOST}:{PORT}/admin_portal/index.html")
        print(f"Controls http://{HOST}:{PORT}/admin_portal/assistant_control.html")
        print(f"Labs     http://{HOST}:{PORT}/labs/templates/dashboard.html")
        print(f"Pharmacy http://{HOST}:{PORT}/pharmacy_portal/index.html")
        print(f"Chat     http://{HOST}:{PORT}/chatbot/templates/chatbot.html")
        print("All previews share the same browser origin for LOCAL demo FAQ settings/history.")
        print("NO authentication, database or cross-device synchronization. Ctrl+C to stop.")
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            print("\nCareGrid demo server stopped.")

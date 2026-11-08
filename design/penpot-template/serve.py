#!/usr/bin/env python3
"""Serves this folder for Penpot with the CORS headers plugins need.

Usage: python3 serve.py  ->  http://<this-machine-ip>:4400/manifest.json
(set HOST=127.0.0.1 to only accept local connections)
"""
import functools
import http.server
import os

PORT = 4400


class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "*")
        # Chrome's Private Network Access: lets https://design.penpot.app reach localhost.
        self.send_header("Access-Control-Allow-Private-Network", "true")
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def do_OPTIONS(self):
        self.send_response(204)
        self.end_headers()


if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    handler = functools.partial(Handler, directory=here)
    # 0.0.0.0 so other machines on the LAN (e.g. a browser on another PC) can reach it.
    host = os.environ.get("HOST", "0.0.0.0")
    with http.server.ThreadingHTTPServer((host, PORT), handler) as httpd:
        print(f"Plugin ready on port {PORT} (Ctrl+C to stop):")
        print(f"  this machine : http://localhost:{PORT}/manifest.json")
        print(f"  other machine: http://<this-machine-ip>:{PORT}/manifest.json")
        httpd.serve_forever()

#!/usr/bin/env python3
"""Simple HTTP server to trigger actions from an iPhone.

Run this script on a machine accessible from your iPhone. It starts an
HTTP server on port 8000 with a single `/run` endpoint. Visiting this
endpoint from the iPhone (via Safari, Shortcuts, etc.) will execute the
`perform_action` function.
"""

from http.server import BaseHTTPRequestHandler, HTTPServer


def perform_action():
    """Action executed when `/run` is accessed."""
    # Placeholder for whatever command you want to run.
    # For demonstration, we'll just return a message.
    return "Remote action triggered!"


class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/run":
            message = perform_action()
            self.send_response(200)
            self.send_header("Content-type", "text/plain; charset=utf-8")
            self.end_headers()
            self.wfile.write(message.encode("utf-8"))
        else:
            self.send_response(404)
            self.end_headers()

    def log_message(self, format, *args):
        """Silence default logging for cleaner output."""
        return


def main(host: str = "0.0.0.0", port: int = 8000):
    server = HTTPServer((host, port), RequestHandler)
    print(f"Listening on {host}:{port} - visit /run to trigger the action.")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down server.")


if __name__ == "__main__":
    main()

import json
from http.server import BaseHTTPRequestHandler

# Firebase Cloud Functions (if deployed via Firebase CLI)
try:
    from firebase_functions import https_fn
    from firebase_functions.options import set_global_options
    set_global_options(max_instances=10)
except ImportError:
    pass

try:
    from firebase_admin import initialize_app
except ImportError:
    pass


# Vercel Serverless Function HTTP Handler
class handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.end_headers()
        response_data = {
            "status": "success",
            "message": "Wedding Flowers Decoration API",
        }
        self.wfile.write(json.dumps(response_data).encode("utf-8"))

    def do_POST(self):
        self.send_response(200)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.end_headers()
        response_data = {
            "status": "success",
            "message": "Wedding Flowers Decoration API",
        }
        self.wfile.write(json.dumps(response_data).encode("utf-8"))


# Vercel WSGI Application Handler
def app(environ, start_response):
    status = "200 OK"
    response_headers = [("Content-type", "application/json; charset=utf-8")]
    start_response(status, response_headers)
    return [b'{"status":"success","message":"Wedding Flowers Decoration API"}']


application = app

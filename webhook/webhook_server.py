import json
import hmac
import hashlib
from http.server import BaseHTTPRequestHandler, HTTPServer
from datetime import datetime
import os
import logging

# 💡 Set your webhook secret (same as in Cashfree dashboard)
WEBHOOK_SECRET = "your_webhook_secret_here"   # Replace with your real Cashfree webhook secret

# 📁 File paths for logs
BASE_DIR = os.path.dirname(__file__)
LOG_DIR = os.path.join(BASE_DIR, "..", "webhook_logs")
LOG_FILE = os.path.join(LOG_DIR, "webhook_data.json")
SERVER_LOG_FILE = os.path.join(LOG_DIR, "server_log.txt")

# ✅ Setup Logging
os.makedirs(LOG_DIR, exist_ok=True)
logging.basicConfig(
    filename=SERVER_LOG_FILE,
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# ✅ Helper: Print to console and log file together
def log_console(message):
    """Print to console and log file."""
    try:
        print(message)
        logging.info(message)
    except Exception as e:
        print(f"[LOGGING ERROR] {e}")

# ✅ Main Webhook Handler
class WebhookHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        try:
            # Read and decode the incoming payload
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length).decode('utf-8')
            signature = self.headers.get('x-webhook-signature', '')

            # ✅ Verify webhook signature
            computed_sig = hmac.new(
                WEBHOOK_SECRET.encode('utf-8'),
                post_data.encode('utf-8'),
                hashlib.sha256
            ).hexdigest()

            if signature != computed_sig:
                log_console("❌ Invalid signature – ignoring webhook.")
                self.send_response(400)
                self.end_headers()
                self.wfile.write(b'Invalid Signature')
                return

            # Parse the webhook payload
            data = json.loads(post_data)
            order_id = data.get("order_id")
            order_status = data.get("order_status")

            log_console(f"\n✅ Webhook received for Order: {order_id}")
            log_console(f"💰 Status: {order_status}")

            # Add timestamp and structure for storage
            record = {
                "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                "order_id": order_id,
                "status": order_status,
                "data": data
            }

            # Ensure log directory exists
            os.makedirs(LOG_DIR, exist_ok=True)

            # Read previous webhook logs if any
            if os.path.exists(LOG_FILE):
                with open(LOG_FILE, "r") as f:
                    try:
                        logs = json.load(f)
                    except json.JSONDecodeError:
                        logs = []
            else:
                logs = []

            # Append new webhook entry
            logs.append(record)
            with open(LOG_FILE, "w") as f:
                json.dump(logs, f, indent=4)

            log_console(f"📝 Logged webhook data to {LOG_FILE}")

            # Send HTTP 200 OK response
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'Webhook Received Successfully')

        except Exception as e:
            log_console(f"⚠️ Error processing webhook: {e}")
            self.send_response(500)
            self.end_headers()
            self.wfile.write(b'Internal Server Error')

# ✅ Server start function
def start_webhook_server(port=5000):
    log_console(f"🌐 Starting webhook server on port {port}...")
    server = HTTPServer(('0.0.0.0', port), WebhookHandler)
    log_console(f"✅ Webhook server is live at http://localhost:{port}")
    logging.info("Server started and ready to receive requests.")
    server.serve_forever()

# ✅ Run server automatically when file is executed
if __name__ == "__main__":
    start_webhook_server()

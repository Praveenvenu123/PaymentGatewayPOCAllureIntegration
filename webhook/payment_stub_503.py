from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/orders", methods=["POST"])
def orders():
    return jsonify({"error": "Payment service temporarily unavailable"}), 503

if __name__ == "__main__":
    print("⚠️  Mock Payment Server DOWN running on port 5001")
    # bind explicitly to 127.0.0.1 and port 5001
    app.run(host="127.0.0.1", port=5001)

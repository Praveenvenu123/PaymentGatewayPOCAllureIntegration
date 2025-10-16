from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route("/pay", methods=["POST"])
def pay():
    data = request.get_json()
    return jsonify({
        "success": True,
        "transaction_id": "TXN12345",
        "amount": data.get("amount", 0)
    }), 200

if __name__ == "__main__":
    print("✅ Mock Payment Server UP running on port 5001")
    app.run(port=5001)

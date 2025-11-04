import requests

BASE_URL = "https://fakestoreapi.com/products/1"

def apply_promo(price, promo_code):
    price = float(price)
    if promo_code == "FREE50":
        discounted_price = max(price - 50, 0)
        return {
            "original_price": price,
            "final_price": discounted_price,
            "message": "Promo applied successfully"
        }
    else:
        return {
            "original_price": price,
            "error": "Invalid promo code"
        }

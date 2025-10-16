import jwt
from jwt.exceptions import InvalidSignatureError, ExpiredSignatureError, InvalidAudienceError, InvalidIssuerError, InvalidTokenError

class JwtValidator:
    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'

    def decode_and_validate_jwt(self, token, secret, *algorithms, audience=None, issuer=None):
        """
        Performs Type 1: Structural and Cryptographic Validation.
        Verifies signature, expiration (exp), audience (aud), and issuer (iss).
        Returns the decoded payload dictionary on success.
        
        The '*algorithms' collects all positional arguments (e.g., 'HS256') into a tuple.
        """
        if not algorithms:
            raise AssertionError("Algorithm(s) must be provided for JWT decoding.")
            
        try:
            # PyJWT requires the 'algorithms' argument to be a list/iterable
            payload = jwt.decode(
                token,
                secret,
                algorithms=list(algorithms), # Convert the collected tuple to a list
                audience=audience,
                issuer=issuer
            )
            return payload
        except InvalidSignatureError:
            raise AssertionError("JWT Validation Failed: Invalid signature (token integrity failed).")
        except ExpiredSignatureError:
            raise AssertionError("JWT Validation Failed: Token has expired (exp claim failed).")
        except (InvalidAudienceError, InvalidIssuerError, InvalidTokenError) as e:
            # Catches aud/iss and other standard claim failures
            raise AssertionError(f"JWT Validation Failed: Standard claim check failed: {e}")
        except Exception as e:
            raise AssertionError(f"An unexpected error occurred during JWT validation: {e}")

    def validate_payload_claim(self, payload, claim_key, expected_value):
        """
        Performs Type 2: Payload Claim Validation (Business Logic).
        Checks if a specific claim in the decoded payload matches the expected value.
        """
        expected = str(expected_value)
        
        if claim_key not in payload:
            raise AssertionError(f"Payload validation failed: Claim '{claim_key}' not found in payload.")
        
        actual = str(payload[claim_key])
        
        if actual != expected:
            raise AssertionError(f"Payload validation failed for claim '{claim_key}'. Expected: '{expected}', Got: '{actual}'.")
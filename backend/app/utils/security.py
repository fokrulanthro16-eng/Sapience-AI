"""
security.py — Security utility helpers for Sapience AI Backend.

IMPORTANT PRODUCTION NOTE:
---------------------------
The encryption stubs below are placeholders showing WHERE encryption
belongs in the flow. In production, use a proper key-management system
such as AWS KMS, HashiCorp Vault, or Google Cloud KMS.
Never roll your own crypto for patient-adjacent data.
"""

import hashlib
import hmac
import os
import base64
import logging

logger = logging.getLogger(__name__)


def hash_user_id(user_id: str) -> str:
    """
    Return a one-way hash of a user ID for logging purposes.
    Lets you correlate logs without exposing the raw UUID.
    """
    return hashlib.sha256(user_id.encode()).hexdigest()[:16]


def constant_time_compare(val1: str, val2: str) -> bool:
    """Timing-safe string comparison — prevents timing-attack leaks."""
    return hmac.compare_digest(val1.encode(), val2.encode())


# ---------------------------------------------------------------------------
# Encryption stubs
# Production: replace these with real symmetric encryption (e.g. Fernet,
# AES-256-GCM) and load the key from an environment variable or KMS.
# ---------------------------------------------------------------------------

def encrypt_summary(plaintext: str, key: bytes | None = None) -> str:
    """
    STUB — encode summary as base64 for transport.

    Production replacement:
        from cryptography.fernet import Fernet
        f = Fernet(key)  # key from env / KMS
        return f.encrypt(plaintext.encode()).decode()
    """
    logger.warning(
        "encrypt_summary is using a stub (base64 only). "
        "Replace with real encryption before going to production."
    )
    encoded = base64.b64encode(plaintext.encode()).decode()
    return encoded


def decrypt_summary(ciphertext: str, key: bytes | None = None) -> str:
    """
    STUB — decode base64. Matches the stub above.

    Production replacement:
        from cryptography.fernet import Fernet
        f = Fernet(key)
        return f.decrypt(ciphertext.encode()).decode()
    """
    logger.warning(
        "decrypt_summary is using a stub (base64 only). "
        "Replace with real decryption before going to production."
    )
    return base64.b64decode(ciphertext.encode()).decode()

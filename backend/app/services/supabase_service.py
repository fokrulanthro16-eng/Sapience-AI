"""
supabase_service.py — All Supabase interactions live here.

The client is lazy-loaded on the first actual API call, NOT at import time.
This means the server starts cleanly even when credentials are missing,
and /health always works regardless of Supabase configuration.
"""

import threading
import logging
from typing import Optional

from supabase import create_client, Client
from app.config import settings

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Lazy client state — all mutations are protected by _lock
# ---------------------------------------------------------------------------
_supabase: Optional[Client] = None
_client_error: Optional[str] = None
_initialized: bool = False          # True once we've attempted to connect
_lock = threading.Lock()


def _credentials_present() -> bool:
    return bool(settings.SUPABASE_URL.strip() and settings.SUPABASE_KEY.strip())


def get_client() -> Optional[Client]:
    """
    Return the shared Supabase client, creating it on first call.
    Returns None (and sets _client_error) if credentials are missing or invalid.
    Thread-safe.
    """
    global _supabase, _client_error, _initialized

    # Fast path — already resolved
    if _initialized:
        return _supabase

    with _lock:
        # Double-check after acquiring the lock
        if _initialized:
            return _supabase

        _initialized = True

        if not _credentials_present():
            _client_error = (
                "Supabase credentials are not configured. "
                "Add SUPABASE_URL and SUPABASE_KEY to backend/.env and restart the server."
            )
            logger.warning(_client_error)
            return None

        try:
            _supabase = create_client(
                settings.SUPABASE_URL.strip(),
                settings.SUPABASE_KEY.strip(),
            )
            logger.info("Supabase client created successfully.")
        except Exception as exc:
            _client_error = f"Failed to connect to Supabase: {exc}"
            logger.error(_client_error)
            _supabase = None

        return _supabase


def supabase_status() -> dict:
    """Return a dict describing the current Supabase configuration state."""
    if not _credentials_present():
        return {"configured": False, "reason": "credentials missing"}
    if _initialized and _supabase is None:
        return {"configured": False, "reason": _client_error}
    if _initialized and _supabase is not None:
        return {"configured": True}
    return {"configured": "unknown", "reason": "not yet tested"}


# ---------------------------------------------------------------------------
# Helper used inside every function below
# ---------------------------------------------------------------------------

def _unconfigured(operation: str) -> dict:
    return {
        "success": False,
        "message": _client_error or "Supabase is not available.",
        "hint": "Set SUPABASE_URL and SUPABASE_KEY in backend/.env and restart the server.",
    }


# ---------------------------------------------------------------------------
# Auth helpers
# ---------------------------------------------------------------------------

def register_user(email: str, password: str) -> dict:
    """Create a new user account via Supabase Auth."""
    client = get_client()
    if client is None:
        return _unconfigured("register_user")
    try:
        response = client.auth.sign_up({"email": email, "password": password})
        if response.user:
            return {"success": True, "user_id": response.user.id}
        return {"success": False, "message": "Registration failed — no user returned."}
    except Exception as exc:
        logger.error("register_user error: %s", exc)
        return {"success": False, "message": "Registration error. Please try again."}


def login_user(email: str, password: str) -> dict:
    """Sign in an existing user and return session tokens."""
    client = get_client()
    if client is None:
        return _unconfigured("login_user")
    try:
        response = client.auth.sign_in_with_password(
            {"email": email, "password": password}
        )
        if response.session:
            return {
                "success": True,
                "access_token": response.session.access_token,
                "refresh_token": response.session.refresh_token,
                "user_id": response.user.id,
            }
        return {"success": False, "message": "Login failed — please check your credentials."}
    except Exception as exc:
        logger.error("login_user error: %s", exc)
        return {"success": False, "message": "Login error. Please try again."}


# ---------------------------------------------------------------------------
# Health report sync
# ---------------------------------------------------------------------------

def sync_health_report(
    user_id: str,
    report_date: str,
    data_type: str,
    stability_score: int,
    encrypted_summary: str,
) -> dict:
    """
    Insert one encrypted health report row into Supabase.
    Raw audio / raw typing logs NEVER come here — only the encrypted summary.
    """
    client = get_client()
    if client is None:
        return _unconfigured("sync_health_report")
    try:
        payload = {
            "user_id": user_id,
            "report_date": report_date,
            "data_type": data_type,
            "stability_score": stability_score,
            "encrypted_summary": encrypted_summary,
        }
        result = client.table("health_reports").insert(payload).execute()
        if result.data:
            return {"success": True, "inserted_id": result.data[0].get("id")}
        return {"success": False, "message": "Insert returned no data."}
    except Exception as exc:
        logger.error("sync_health_report error: %s", exc)
        return {"success": False, "message": "Could not sync report. Please try later."}

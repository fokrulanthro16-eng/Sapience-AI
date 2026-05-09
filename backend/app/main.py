"""
main.py — Sapience AI FastAPI Backend entry point.

Run with:
    uvicorn app.main:app --reload --workers 1

Keep --workers 1 on low-RAM Windows machines to avoid loading the
LLM model multiple times into RAM.

/health always responds, even without Supabase credentials.
/register, /login, /sync-report return a clear JSON error when credentials
are missing — they do NOT crash the server.
"""

import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.config import settings
from app.schemas import RegisterRequest, LoginRequest, SyncReportRequest, ApiResponse
from app.services import supabase_service

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Lifespan — runs once at startup and once at shutdown
# ---------------------------------------------------------------------------
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: check credentials without connecting (lazy-load still applies)
    url = settings.SUPABASE_URL.strip()
    key = settings.SUPABASE_KEY.strip()
    if not url or not key:
        logger.warning(
            "Supabase credentials are NOT set. "
            "/register, /login, and /sync-report will return errors. "
            "Add SUPABASE_URL and SUPABASE_KEY to backend/.env, then restart."
        )
    else:
        logger.info(
            "Supabase credentials found. Client will connect on first request."
        )
    logger.info("Sapience AI backend started. /health is always available.")
    yield
    # Shutdown — nothing to clean up


# ---------------------------------------------------------------------------
# App setup
# ---------------------------------------------------------------------------
app = FastAPI(
    title=settings.APP_NAME,
    version="0.1.0",
    description="Local-first health wellness backend. Not a medical diagnosis service.",
    lifespan=lifespan,
)

# Allow the Flutter app (or localhost dev) to call this API.
# Tighten allow_origins to your Flutter app's origin in production.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ---------------------------------------------------------------------------
# Global error handler — return clean JSON on unexpected exceptions
# ---------------------------------------------------------------------------
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error("Unhandled exception on %s: %s", request.url, exc)
    return JSONResponse(
        status_code=500,
        content={"success": False, "message": "An unexpected error occurred."},
    )


# ---------------------------------------------------------------------------
# Routes
# ---------------------------------------------------------------------------

@app.get("/health", response_model=ApiResponse)
async def health_check():
    """
    Liveness check — always returns 200 regardless of Supabase status.
    The 'supabase' field tells you whether credentials are configured.
    """
    return ApiResponse(
        success=True,
        message="ok",
        data={
            "app": settings.APP_NAME,
            "environment": settings.ENVIRONMENT,
            "supabase": supabase_service.supabase_status(),
        },
    )


@app.post("/register", response_model=ApiResponse)
async def register(body: RegisterRequest):
    """
    Create a new user account via Supabase Auth.
    Returns a clear JSON error (not a crash) if Supabase is not configured.
    """
    result = supabase_service.register_user(body.email, body.password)
    if not result["success"]:
        raise HTTPException(
            status_code=503 if "not configured" in result.get("message", "") else 400,
            detail=result,
        )
    return ApiResponse(
        success=True,
        message="Account created! Please check your email to confirm.",
        data={"user_id": result.get("user_id")},
    )


@app.post("/login", response_model=ApiResponse)
async def login(body: LoginRequest):
    """
    Sign in and receive session tokens.
    Returns a clear JSON error (not a crash) if Supabase is not configured.
    """
    result = supabase_service.login_user(body.email, body.password)
    if not result["success"]:
        raise HTTPException(
            status_code=503 if "not configured" in result.get("message", "") else 401,
            detail=result,
        )
    return ApiResponse(
        success=True,
        message="Logged in successfully.",
        data={
            "access_token": result["access_token"],
            "user_id": result["user_id"],
        },
    )


@app.post("/sync-report", response_model=ApiResponse)
async def sync_report(body: SyncReportRequest):
    """
    Upload one encrypted wellness summary to Supabase.
    Raw audio / raw typing data must NEVER be sent here — only encrypted summaries.
    Returns a clear JSON error (not a crash) if Supabase is not configured.
    """
    result = supabase_service.sync_health_report(
        user_id=body.user_id,
        report_date=str(body.report_date),
        data_type=body.data_type,
        stability_score=body.stability_score,
        encrypted_summary=body.encrypted_summary,
    )
    if not result["success"]:
        raise HTTPException(
            status_code=503 if "not configured" in result.get("message", "") else 500,
            detail=result,
        )
    return ApiResponse(
        success=True,
        message="Report synced successfully.",
        data={"inserted_id": result.get("inserted_id")},
    )

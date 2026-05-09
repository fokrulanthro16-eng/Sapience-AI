# Sapience AI — Backend

FastAPI backend handling auth and encrypted report sync via Supabase.

## Windows Setup

```powershell
# 1. Create virtual environment
python -m venv .venv

# 2. Activate it
.venv\Scripts\activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Set up environment variables
copy .env.example .env
# Then open .env and fill in your Supabase URL and key

# 5. Start the server (use --workers 1 on low-RAM machines)
uvicorn app.main:app --reload --workers 1
```

## Endpoints

| Method | Path          | Description                          |
|--------|---------------|--------------------------------------|
| GET    | /health       | Liveness check                       |
| POST   | /register     | Create a new user account            |
| POST   | /login        | Sign in, receive session token       |
| POST   | /sync-report  | Upload encrypted wellness summary    |

## Interactive API Docs

While the server is running, open: http://127.0.0.1:8000/docs

## Important Notes

- This is NOT a medical diagnosis service.
- Raw audio and raw typing logs must NEVER be sent to this backend.
- Only encrypted wellness summaries are stored in Supabase.
- Use `--workers 1` to avoid loading heavy models multiple times.

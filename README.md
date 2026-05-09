# Sapience AI

A local-first wellness monitoring ecosystem that detects early wellness changes
by analyzing vocal stability, typing rhythm, and gait patterns.

**Not a medical diagnosis tool.** All outputs are wellness signals only.

---

## Architecture

```
┌──────────────────────────────────────────┐
│             User's Device                │
│                                          │
│  Flutter App  ──▶  Local Python AI       │
│       │               (librosa + GGUF)   │
│       ▼                     │            │
│    SQLite               Score only       │
│  (raw data,                 │            │
│  stays here)                │            │
└─────────────────────────────┼────────────┘
                              │ encrypted summary
                              ▼
                   FastAPI + Supabase
                   (scores + encrypted
                    summaries only)
```

---

## Folder Structure

```
Sapience-AI/
├── backend/          FastAPI backend (auth + report sync)
├── local_ai/         Local Python vocal analysis + LLM advice
├── database/         SQLite and Supabase schema files
├── flutter_app/      Architecture notes for future Flutter app
├── docs/             Project docs, privacy policy, UI guide
├── .gitignore
└── README.md
```

---

## Quick Start — Windows

### 1. Backend

```powershell
cd backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
copy .env.example .env
# Edit .env with your Supabase URL and key
uvicorn app.main:app --reload --workers 1
```

API docs: http://127.0.0.1:8000/docs

### 2. Local Vocal Engine

```powershell
cd local_ai
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt

cd vocal_engine
python test_vocal_engine.py path\to\recording.wav
```

---

## Environment Variables

### backend/.env

| Variable | Description |
|---|---|
| `APP_NAME` | Display name (default: Sapience AI Backend) |
| `ENVIRONMENT` | development or production |
| `SUPABASE_URL` | Your Supabase project URL |
| `SUPABASE_KEY` | Your Supabase anon or service role key |

### local_ai environment

| Variable | Description |
|---|---|
| `SAPIENCE_GGUF_MODEL_PATH` | Full path to your GGUF model file (optional) |

---

## Supabase Setup

1. Create a free project at https://supabase.com
2. Open SQL Editor and run `database/supabase_schema.sql`
3. Copy your Project URL and anon key into `backend/.env`

---

## Privacy

| Data | Where it lives | Sent to cloud? |
|---|---|---|
| Raw audio | Device only (temp) | Never |
| Raw typing / gait | Device SQLite | Never |
| Stability score | Device + cloud | Yes (integer only) |
| Encrypted summary | Device + cloud | Yes (encrypted) |

---

## Grandma Theory

The UI and advice language must be:
- Simple enough for a grandparent with no tech experience
- Calm — no scary alerts, no red warnings, no medical jargon
- Bengali-first
- One clear action per screen

See `docs/grandma_theory_ui_guide.md` for full details.

---

## Medical Disclaimer

Sapience AI is a personal wellness monitoring tool.
It does not diagnose, treat, cure, or prevent any disease.
If you have health concerns, please consult a qualified healthcare professional.

---

## Next Steps

1. Set up Supabase and fill in `backend/.env`
2. Run backend and verify `/health` returns `{ "status": "ok" }`
3. Record a short WAV file and test the vocal engine
4. (Optional) Download a GGUF model and set `SAPIENCE_GGUF_MODEL_PATH`
5. Start building the Flutter app using `flutter_app/architecture_notes.md`

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | FastAPI, Supabase, Python 3.11+ |
| Local AI | librosa, numpy, scipy, llama-cpp-python |
| Local DB | SQLite |
| Cloud DB | Supabase PostgreSQL |
| Mobile App | Flutter (planned) |

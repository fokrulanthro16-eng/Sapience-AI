# Sapience AI — Project Overview

## What Is Sapience AI?

Sapience AI is a local-first health wellness monitoring system.
It detects early wellness changes by analyzing three behavioral signals:

1. **Vocal stability** — small changes in how steady your voice is
2. **Typing stability** — rhythm and latency between keystrokes
3. **Gait stability** — regularity and cadence of walking steps

It is **not** a medical diagnosis app. It provides wellness signals only.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                 User's Device                   │
│                                                 │
│  ┌──────────┐    ┌──────────────────────────┐   │
│  │ Flutter  │───▶│   Local Python Engine    │   │
│  │   App    │    │  (vocal / gait / typing) │   │
│  └────┬─────┘    └──────────┬───────────────┘   │
│       │                     │                   │
│       ▼                     ▼                   │
│  ┌──────────────────────────────────────────┐   │
│  │         SQLite (on-device)               │   │
│  │  Stores raw scores + encrypted summaries │   │
│  └──────────────────────────────────────────┘   │
│       │                                         │
│       │  (encrypted summary only, over HTTPS)   │
└───────┼─────────────────────────────────────────┘
        │
        ▼
┌───────────────────────────────┐
│      FastAPI Backend          │
│   (hosted / cloud)            │
│                               │
│  ┌─────────────────────────┐  │
│  │  Supabase Auth          │  │
│  │  Supabase PostgreSQL    │  │
│  │  (encrypted summaries   │  │
│  │   + scores only)        │  │
│  └─────────────────────────┘  │
└───────────────────────────────┘
```

---

## Local AI Role

The local Python engine (`local_ai/`) does all heavy lifting on-device:

- **librosa** analyzes audio files for pitch (F0), jitter, and stability
- **llama-cpp-python** runs a GGUF language model to generate Bengali advice
- Results are an integer score (0–100) and a Bengali wellness message
- Raw audio is analyzed in memory and then discarded — never uploaded

---

## Backend Role

The FastAPI backend (`backend/`) is lightweight:

- Supabase Auth handles user registration and login
- `/sync-report` stores only: `(user_id, date, type, score, encrypted_summary)`
- No raw audio, no raw typing logs, no raw gait data ever reaches the cloud

---

## Privacy-First Design

| Data type | Stored locally | Sent to cloud |
|---|---|---|
| Raw audio files | Yes (temp, deleted after analysis) | Never |
| Raw keystroke logs | Yes (SQLite) | Never |
| Raw accelerometer frames | Yes (SQLite) | Never |
| Stability score (integer) | Yes (SQLite) | Yes |
| Encrypted wellness summary | Yes (SQLite) | Yes |

---

## Safety Disclaimer

Sapience AI is a wellness monitoring tool, not a medical device.
It does not diagnose diseases. If unusual scores persist, the app
gently suggests consulting a healthcare professional.

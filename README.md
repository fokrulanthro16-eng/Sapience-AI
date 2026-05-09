# Sapience AI

Sapience AI is a local-first AI wellness monitoring system that analyzes voice stability, typing rhythm, and gait patterns.

The project is designed to help users understand daily wellness changes in a simple, privacy-focused way.

---

## Project Overview

Sapience AI observes three daily behavior signals:

- Voice stability
- Typing stability
- Walking / gait stability

The goal is not to diagnose disease, but to provide simple wellness insights using AI and local-first architecture.

---

## Key Features

- Futuristic Flutter frontend
- Voice Check screen
- Typing Test screen
- Gait Test screen
- Daily Report screen
- Insights screen
- Settings & Privacy screen
- FastAPI backend
- SQLite local database schema
- Supabase-ready cloud sync
- Python local AI engine
- Librosa-based vocal analysis
- Local LLM concept using GGUF models

---

## Core Philosophy

### Grandma Theory

The app should be simple enough for anyone to use.

Main UI ideas:

- Simple words
- Big buttons
- Clean layout
- Easy wellness score
- No complex medical language

### Local-First AI

Sensitive raw data should stay on the user's device.

Raw data that should stay local:

- Voice recordings
- Typing logs
- Walking sensor data

Only encrypted summaries should be synced to the cloud.

---

## Technologies Used

### Frontend

- Flutter
- Dart
- Material UI

### Backend

- FastAPI
- Python
- Pydantic
- Supabase

### Local AI

- Python
- Librosa
- NumPy
- SciPy
- llama-cpp-python concept

### Database

- SQLite
- Supabase / PostgreSQL

---

## Folder Structure

```text
Sapience-AI/
├── backend/
│   └── FastAPI backend
├── flutter_app/
│   └── Flutter frontend app
├── local_ai/
│   └── Local AI and vocal analysis
├── database/
│   └── SQLite and Supabase schemas
├── docs/
│   └── Project documentation
├── README.md
└── .gitignore
```

---

## How to Run the Flutter Frontend

Go to the Flutter app folder:

```bash
cd flutter_app
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

For Chrome:

```bash
flutter run -d chrome
```

---

## How to Run the Backend

Go to the backend folder:

```bash
cd backend
```

Create a virtual environment:

```bash
py -3.11 -m venv .venv
```

Activate the environment:

```bash
.\.venv\Scripts\activate
```

Install dependencies:

```bash
python -m pip install -r requirements.txt
```

Run the FastAPI server:

```bash
python -m uvicorn app.main:app --reload
```

Open in browser:

```text
http://127.0.0.1:8000/health
```

---

## Backend API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | `/health` | Backend health check |
| POST | `/register` | User registration |
| POST | `/login` | User login |
| POST | `/sync-report` | Sync encrypted wellness report |

---

## Local AI Engine

The local AI engine is designed to process sensitive data on the user's device.

Current AI-related components:

- Voice analysis module
- Fundamental frequency analysis
- Jitter calculation
- Stability score generation
- Local LLM advice generation concept

---

## Privacy First Design

Sapience AI follows a privacy-first approach.

- Raw audio is not uploaded to cloud
- Raw typing data is not uploaded to cloud
- Raw walking sensor data is not uploaded to cloud
- Only encrypted summaries should be synced

---

## Medical Safety Note

Sapience AI is not a medical diagnosis app.

It does not diagnose diseases or medical conditions. It only provides general wellness insights. If unusual results continue for several days, users should consult a qualified doctor.

---

## Future Improvements

- Connect Flutter frontend with FastAPI backend
- Add real microphone data collection
- Add accelerometer-based gait analysis
- Add real typing rhythm tracking
- Connect Supabase authentication
- Improve local AI model
- Add encrypted report syncing
- Add dashboard analytics

---

## Project Status

Completed:

- Flutter UI prototype
- FastAPI backend
- Local AI architecture
- Database schemas
- Documentation
- GitHub repository setup

---

## Author

Created by Fokrul.

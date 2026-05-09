# Sapience AI — Flutter App

> Status: Architecture planning phase. No Flutter code yet.

This folder will contain the cross-platform mobile/desktop app.

## Planned Platforms

- Android (primary target)
- iOS
- Windows desktop (optional)

## Planned Tech Stack

| Layer | Technology |
|---|---|
| UI framework | Flutter (Dart) |
| Local database | `sqflite` (SQLite) |
| State management | Riverpod |
| Audio recording | `record` package |
| Accelerometer | `sensors_plus` |
| Local Python bridge | `flutter_process` or local HTTP server |
| Backend sync | `http` + Supabase Dart client |

## Grandma Theory UI Principles

1. **Big text** — minimum 18sp body text
2. **Large tap targets** — buttons at least 56dp tall
3. **Calm color palette** — soft greens, blues, and warm whites
4. **Simple Bengali labels** — avoid English medical words
5. **One action per screen** — no overwhelming menus
6. **Friendly icons** — no warning triangles or red crosses for wellness signals

## Privacy Architecture

```
Flutter App
    │
    ├── Record audio (microphone)
    │     └── Send to local Python engine (HTTP 127.0.0.1)
    │           └── Returns score only (integer)
    │
    ├── Capture accelerometer frames
    │     └── Analyze locally
    │
    ├── Measure keystroke latency
    │     └── Analyze locally
    │
    ├── SQLite (on-device)
    │     └── Stores scores, encrypted summaries
    │
    └── Backend sync (HTTPS)
          └── Sends only: user_id, date, data_type, score, encrypted_summary
              Raw data NEVER leaves the device.
```

## Next Steps

1. Scaffold Flutter project: `flutter create sapience_app`
2. Add dependencies to `pubspec.yaml`
3. Build home screen following Grandma Theory guidelines
4. Implement audio recording → score pipeline
5. Connect to backend API

See `architecture_notes.md` for detailed design notes.

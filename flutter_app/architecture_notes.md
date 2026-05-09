# Flutter App — Architecture Notes

## Core Data Flow

```
User presses "Record" button
    → Flutter captures audio via `record` package
    → Saves .wav to app-private temp directory
    → Sends file path to local Python engine (localhost HTTP)
    → Python returns { stability_score: 82, risk_level: "low" }
    → Flutter displays Bengali wellness message
    → Stores score in SQLite
    → On next sync: sends encrypted summary to backend
    → Deletes temp audio file
```

## Local Python Bridge Options

Since Flutter cannot directly call Python libraries, we use one of:

### Option A — Local HTTP Server (Recommended for Desktop/Windows)
- Run `uvicorn local_engine_api:app --port 8765` as a background process
- Flutter calls `http://127.0.0.1:8765/analyze-voice`
- Simple, language-agnostic, easy to debug

### Option B — Platform Channel (Advanced, Android only)
- Use Android JNI to call a compiled native library
- Complex but eliminates Python process dependency

### Option C — Pre-computed scores
- Run analysis in a scheduled background script
- Flutter only reads the SQLite results
- Best for battery life

## Screen Flow (Grandma Theory)

```
Home Screen
│
├── "কণ্ঠ পরীক্ষা" (Voice Check) → Recording screen → Result screen
├── "হাঁটার পরীক্ষা" (Gait Check) → Walking capture → Result screen
├── "টাইপিং পরীক্ষা" (Typing Check) → Typing pad → Result screen
│
└── "আমার রিপোর্ট" (My Reports) → History screen (graph + messages)
```

## Bengali UI Examples

| Screen element | Bengali text |
|---|---|
| Start button | "শুরু করুন" |
| Stop recording | "থামুন" |
| High score message | "আজ খুব ভালো! 😊" |
| Medium score message | "একটু বিশ্রাম নিন" |
| Low score message | "চিন্তা নেই, কাল আবার চেষ্টা করুন" |
| Sync button | "তথ্য সংরক্ষণ করুন" |
| Settings | "সেটিংস" |

## Keystroke Latency Capture

- Flutter `TextField` with a custom `TextInputFormatter`
- Record timestamp of each `onChanged` callback
- Calculate inter-key intervals (IKI)
- Compute mean and standard deviation of IKI
- High std → lower stability score

## Accelerometer / Gait Capture

- Use `sensors_plus` package: `accelerometerEvents`
- Capture 30–60 seconds while user walks
- Extract step rhythm via peak detection on Z-axis
- Compute step regularity and cadence

## SQLite Schema (Dart side)

Use `sqflite` + `path_provider`.

Tables mirror `database/sqlite_schema.sql`.

```dart
// Example query
final scores = await db.query(
  'local_health_metrics',
  where: 'user_id = ? AND measured_at > ?',
  whereArgs: [userId, sevenDaysAgo],
  orderBy: 'measured_at DESC',
);
```

## State Management (Riverpod)

```
analysisStateProvider    — current recording/analysis status
scoreHistoryProvider     — list of past scores from SQLite
syncStatusProvider       — pending/synced count
settingsProvider         — user language, notifications, etc.
```

## Notifications

- Use `flutter_local_notifications`
- Gentle daily reminder: "আজ কি পরীক্ষা করা হয়েছে?"
- Never send scary push notifications about low scores

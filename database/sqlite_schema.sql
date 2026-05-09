-- sqlite_schema.sql
-- Local SQLite database — stores raw sensitive health data on-device only.
-- This data never goes to the cloud in raw form.

PRAGMA journal_mode = WAL;
PRAGMA foreign_keys = ON;

-- -----------------------------------------------------------------------
-- local_health_metrics
-- One row per analysis session (voice / typing / gait).
-- -----------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS local_health_metrics (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         TEXT    NOT NULL,
    metric_type     TEXT    NOT NULL CHECK(metric_type IN ('voice', 'typing', 'gait')),
    stability_score INTEGER NOT NULL CHECK(stability_score BETWEEN 0 AND 100),
    risk_level      TEXT    NOT NULL CHECK(risk_level IN ('low', 'medium', 'high', 'unknown')),
    encrypted_summary TEXT,
    sync_status     TEXT    NOT NULL DEFAULT 'pending'
                            CHECK(sync_status IN ('pending', 'synced', 'failed')),
    measured_at     TEXT    NOT NULL DEFAULT (datetime('now')),
    created_at      TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_lhm_user_date
    ON local_health_metrics(user_id, measured_at);

-- -----------------------------------------------------------------------
-- raw_audio_logs
-- Stores the file path to recorded audio — NOT the audio bytes.
-- Raw audio never leaves this device.
-- -----------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS raw_audio_logs (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         TEXT    NOT NULL,
    raw_file_path   TEXT    NOT NULL,
    duration_sec    REAL,
    sample_rate     INTEGER,
    linked_metric_id INTEGER REFERENCES local_health_metrics(id),
    measured_at     TEXT    NOT NULL DEFAULT (datetime('now'))
);

-- -----------------------------------------------------------------------
-- typing_metrics
-- Keystroke latency and rhythm data — never uploaded raw.
-- -----------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS typing_metrics (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         TEXT    NOT NULL,
    metric_type     TEXT    NOT NULL DEFAULT 'typing',
    stability_score INTEGER NOT NULL CHECK(stability_score BETWEEN 0 AND 100),
    avg_latency_ms  REAL,
    std_latency_ms  REAL,
    keypress_count  INTEGER,
    risk_level      TEXT    NOT NULL DEFAULT 'unknown',
    encrypted_summary TEXT,
    sync_status     TEXT    NOT NULL DEFAULT 'pending',
    measured_at     TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_tm_user_date
    ON typing_metrics(user_id, measured_at);

-- -----------------------------------------------------------------------
-- gait_metrics
-- Accelerometer-based walking rhythm data.
-- -----------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS gait_metrics (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         TEXT    NOT NULL,
    metric_type     TEXT    NOT NULL DEFAULT 'gait',
    stability_score INTEGER NOT NULL CHECK(stability_score BETWEEN 0 AND 100),
    step_regularity REAL,
    cadence_spm     REAL,
    risk_level      TEXT    NOT NULL DEFAULT 'unknown',
    encrypted_summary TEXT,
    sync_status     TEXT    NOT NULL DEFAULT 'pending',
    measured_at     TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_gm_user_date
    ON gait_metrics(user_id, measured_at);

-- -----------------------------------------------------------------------
-- local_reports
-- Aggregated daily wellness reports generated on-device.
-- Only the encrypted_summary column is ever sent to the cloud.
-- -----------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS local_reports (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         TEXT    NOT NULL,
    report_date     TEXT    NOT NULL,
    data_type       TEXT    NOT NULL CHECK(data_type IN ('voice', 'typing', 'gait', 'combined')),
    stability_score INTEGER NOT NULL CHECK(stability_score BETWEEN 0 AND 100),
    f0_mean         REAL,
    f0_std          REAL,
    jitter          REAL,
    pitch_stability REAL,
    encrypted_summary TEXT,
    sync_status     TEXT    NOT NULL DEFAULT 'pending'
                            CHECK(sync_status IN ('pending', 'synced', 'failed')),
    created_at      TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_lr_user_date_type
    ON local_reports(user_id, report_date, data_type);

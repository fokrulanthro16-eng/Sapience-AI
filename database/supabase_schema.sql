-- supabase_schema.sql
-- Cloud PostgreSQL schema for Sapience AI.
-- Only encrypted summaries and scores are stored here.
-- Raw audio, raw typing logs, and raw gait data NEVER reach this database.

-- -----------------------------------------------------------------------
-- profiles
-- One row per authenticated user — extends Supabase auth.users.
-- -----------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
    id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT,
    language    TEXT NOT NULL DEFAULT 'bn',   -- 'bn' = Bengali
    timezone    TEXT NOT NULL DEFAULT 'Asia/Dhaka',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Users can only read and update their own profile
CREATE POLICY "profiles_select_own"
    ON public.profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "profiles_insert_own"
    ON public.profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

CREATE POLICY "profiles_update_own"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id);

-- -----------------------------------------------------------------------
-- health_reports
-- One row per daily encrypted wellness summary per data type.
-- -----------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.health_reports (
    id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    report_date       DATE        NOT NULL,
    data_type         TEXT        NOT NULL CHECK (data_type IN ('voice', 'typing', 'gait')),
    stability_score   INTEGER     NOT NULL CHECK (stability_score BETWEEN 0 AND 100),
    encrypted_summary TEXT        NOT NULL,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Prevent duplicate reports (same user + date + type)
CREATE UNIQUE INDEX IF NOT EXISTS uidx_health_reports_user_date_type
    ON public.health_reports (user_id, report_date, data_type);

-- Query performance indexes
CREATE INDEX IF NOT EXISTS idx_health_reports_user_id
    ON public.health_reports (user_id);

CREATE INDEX IF NOT EXISTS idx_health_reports_report_date
    ON public.health_reports (report_date);

CREATE INDEX IF NOT EXISTS idx_health_reports_data_type
    ON public.health_reports (data_type);

-- Row Level Security — users can only touch their own rows
ALTER TABLE public.health_reports ENABLE ROW LEVEL SECURITY;

CREATE POLICY "health_reports_select_own"
    ON public.health_reports FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "health_reports_insert_own"
    ON public.health_reports FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "health_reports_update_own"
    ON public.health_reports FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "health_reports_delete_own"
    ON public.health_reports FOR DELETE
    USING (auth.uid() = user_id);

"""
local_vocal_engine.py — Sapience AI vocal stability analyzer.

Analyzes a WAV file and returns wellness signals.
This is NOT a medical diagnostic tool.
Results are wellness indicators only.

Usage:
    from local_vocal_engine import analyze_voice_file
    result = analyze_voice_file("recording.wav")
"""

import os
import logging
import numpy as np

try:
    import librosa
except ImportError:
    librosa = None  # Checked at runtime

logger = logging.getLogger(__name__)

# Minimum number of voiced frames required for a meaningful analysis
MIN_VOICED_FRAMES = 30

# F0 search range (Hz) — covers most adult voices
F0_MIN_HZ = 60.0
F0_MAX_HZ = 400.0


def _empty_result(message: str) -> dict:
    """Return a safe zero-filled result with an explanatory message."""
    return {
        "f0_mean": 0.0,
        "f0_std": 0.0,
        "jitter": 0.0,
        "pitch_stability": 0.0,
        "stability_score": 0,
        "risk_level": "unknown",
        "message": message,
    }


def _score_to_risk(score: int) -> str:
    if score >= 70:
        return "low"
    if score >= 40:
        return "medium"
    return "high"


def _score_to_message(score: int) -> str:
    """Plain, calm wellness message — no medical language."""
    if score >= 70:
        return (
            "আজ আপনার কণ্ঠ বেশ স্থির ছিল। ভালো লাগছে। "
            "নিয়মিত এভাবেই ছোট পরীক্ষা চালিয়ে যান।"
        )
    if score >= 40:
        return (
            "আজ আপনার কণ্ঠ একটু কম স্থির মনে হয়েছে। "
            "ভয় পাওয়ার কিছু নেই। একটু বিশ্রাম নিন, "
            "পানি পান করুন, আর কাল আবার পরীক্ষা করুন।"
        )
    return (
        "আজ আপনার ফল একটু কম এসেছে। চিন্তা করবেন না। "
        "কয়েক দিন এমন থাকলে একজন ডাক্তারের সাথে "
        "কথা বলা ভালো।"
    )


def analyze_voice_file(audio_path: str) -> dict:
    """
    Load a WAV/MP3 file and compute vocal stability metrics.

    Parameters
    ----------
    audio_path : str
        Path to the audio file on disk.

    Returns
    -------
    dict with keys:
        f0_mean, f0_std, jitter, pitch_stability,
        stability_score (0-100), risk_level, message
    """
    # --- Guard: librosa installed? ---
    if librosa is None:
        return _empty_result(
            "librosa is not installed. Run: pip install librosa"
        )

    # --- Guard: file exists? ---
    if not os.path.isfile(audio_path):
        return _empty_result(f"Audio file not found: {audio_path}")

    # --- Load audio ---
    try:
        y, sr = librosa.load(audio_path, sr=None, mono=True)
    except Exception as exc:
        logger.error("Failed to load audio: %s", exc)
        return _empty_result("Could not read the audio file. Please try a different recording.")

    # --- Guard: silent audio ---
    rms = float(np.sqrt(np.mean(y ** 2)))
    if rms < 1e-5:
        return _empty_result(
            "The recording appears to be silent. "
            "Please speak clearly into the microphone and try again."
        )

    # --- Estimate F0 using pyin ---
    try:
        f0, voiced_flag, _ = librosa.pyin(
            y,
            fmin=F0_MIN_HZ,
            fmax=F0_MAX_HZ,
            sr=sr,
        )
    except Exception as exc:
        logger.error("pyin failed: %s", exc)
        return _empty_result("Could not analyze the audio. Please record again in a quiet place.")

    # --- Filter to voiced frames only ---
    voiced_f0 = f0[voiced_flag & ~np.isnan(f0)]

    if len(voiced_f0) < MIN_VOICED_FRAMES:
        return _empty_result(
            "Not enough voiced speech detected. "
            "Please speak for at least 5 seconds and try again."
        )

    # --- Core metrics ---
    f0_mean = float(np.mean(voiced_f0))
    f0_std = float(np.std(voiced_f0))

    # Jitter: average frame-to-frame absolute difference relative to mean F0
    # Higher jitter = less stable pitch cycle
    if len(voiced_f0) > 1 and f0_mean > 0:
        frame_diffs = np.abs(np.diff(voiced_f0))
        jitter = float(np.mean(frame_diffs) / f0_mean)
    else:
        jitter = 0.0

    # Pitch stability: coefficient of variation inverted to [0, 1]
    # cv = std / mean; lower cv = more stable
    cv = f0_std / f0_mean if f0_mean > 0 else 1.0
    pitch_stability = float(np.clip(1.0 - cv, 0.0, 1.0))

    # --- Composite stability score 0-100 ---
    # 70 % weight on pitch_stability, 30 % penalty for high jitter
    jitter_penalty = np.clip(jitter * 10, 0.0, 1.0)
    raw_score = 0.7 * pitch_stability + 0.3 * (1.0 - jitter_penalty)
    stability_score = int(np.clip(raw_score * 100, 0, 100))

    risk_level = _score_to_risk(stability_score)
    message = _score_to_message(stability_score)

    return {
        "f0_mean": round(f0_mean, 2),
        "f0_std": round(f0_std, 2),
        "jitter": round(jitter, 6),
        "pitch_stability": round(pitch_stability, 4),
        "stability_score": stability_score,
        "risk_level": risk_level,
        "message": message,
    }

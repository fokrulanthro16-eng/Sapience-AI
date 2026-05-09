"""
local_llm_advice.py — Generates calm Bengali wellness advice.

Uses a local GGUF model when available.
Falls back to pre-written messages when the model is not loaded.

Rules:
- NEVER diagnose a disease.
- Always be calm and encouraging.
- Suggest a doctor only if low scores persist for several days.
- Keep language simple enough for a grandparent to understand.
"""

import logging
from local_ai.llm.model_manager import run_inference

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Fallback advice (used when LLM is not available)
# ---------------------------------------------------------------------------

_FALLBACK: dict[str, dict[str, str]] = {
    "voice": {
        "high": (
            "আজ আপনার কণ্ঠ বেশ স্থির ছিল। ভালো লাগছে। "
            "নিয়মিত এভাবেই ছোট পরীক্ষা চালিয়ে যান।"
        ),
        "medium": (
            "আজ আপনার কণ্ঠ একটু কম স্থির মনে হয়েছে। "
            "ভয় পাওয়ার কিছু নেই। একটু বিশ্রাম নিন, "
            "পানি পান করুন, আর কাল আবার পরীক্ষা করুন।"
        ),
        "low": (
            "আজ আপনার ফল একটু কম এসেছে। চিন্তা করবেন না। "
            "কয়েক দিন এমন থাকলে একজন ডাক্তারের সাথে "
            "কথা বলা ভালো।"
        ),
    },
    "typing": {
        "high": (
            "আজ আপনার টাইপিং বেশ মসৃণ ছিল। খুব ভালো! "
            "এভাবেই প্রতিদিন একটু পরীক্ষা করুন।"
        ),
        "medium": (
            "আজ টাইপিং একটু ধীর মনে হয়েছে। "
            "হয়তো একটু ক্লান্তি আছে। একটু বিশ্রাম নিন।"
        ),
        "low": (
            "আজ টাইপিং-এ কিছুটা অসামঞ্জস্য দেখা গেছে। "
            "চিন্তা করবেন না। কয়েক দিন এমন থাকলে "
            "একজন ডাক্তারের সাথে কথা বলুন।"
        ),
    },
    "gait": {
        "high": (
            "আজ আপনার হাঁটার ছন্দ বেশ স্থির ছিল। চমৎকার! "
            "প্রতিদিন একটু হাঁটার চেষ্টা করুন।"
        ),
        "medium": (
            "আজ হাঁটার ভারসাম্য একটু কম মনে হয়েছে। "
            "সাবধানে হাঁটুন। প্রয়োজনে কারো সাহায্য নিন।"
        ),
        "low": (
            "আজ হাঁটার স্থিতিশীলতা কিছুটা কম এসেছে। "
            "ভয় নেই। কয়েক দিন এমন থাকলে ডাক্তারের সাথে "
            "কথা বলুন।"
        ),
    },
}


def _score_to_band(score: int) -> str:
    if score >= 70:
        return "high"
    if score >= 40:
        return "medium"
    return "low"


def _build_prompt(score: int, data_type: str, band: str) -> str:
    """Build a short Bengali-instruction prompt for the local LLM."""
    return (
        f"তুমি Sapience AI-র সহায়ক। তুমি কখনো রোগ নির্ণয় করো না। "
        f"শুধু সুস্থতার পরামর্শ দাও, সহজ বাংলায়, শান্তভাবে।\n\n"
        f"ব্যবহারকারীর {data_type} স্কোর আজ {score}/100 ({band})। "
        f"একটি ছোট, সদয়, উৎসাহজনক বার্তা লেখো (৩-৪ লাইনের বেশি নয়)।\n\n"
        f"বার্তা:"
    )


def generate_sapience_advice(score: int, data_type: str) -> str:
    """
    Return a calm Bengali wellness message for the given score and data type.

    Parameters
    ----------
    score : int
        Stability score 0–100.
    data_type : str
        One of: "voice", "typing", "gait".

    Returns
    -------
    str
        Bengali wellness advice string.
    """
    safe_type = data_type if data_type in _FALLBACK else "voice"
    band = _score_to_band(score)

    # Try local LLM first
    prompt = _build_prompt(score, safe_type, band)
    llm_response = run_inference(prompt, max_tokens=150)

    if llm_response and len(llm_response.strip()) > 10:
        logger.info("Using LLM-generated advice for score=%d type=%s", score, data_type)
        return llm_response.strip()

    # Fallback to pre-written messages
    logger.info("Using fallback advice for score=%d type=%s band=%s", score, data_type, band)
    return _FALLBACK[safe_type][band]


if __name__ == "__main__":
    # Quick sanity check without LLM
    for dtype in ("voice", "typing", "gait"):
        for s in (85, 55, 25):
            advice = generate_sapience_advice(s, dtype)
            print(f"[{dtype} | {s}] {advice}\n")

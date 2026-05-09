"""
model_manager.py — Lazy-loads a local GGUF model with thread safety.

The model is loaded only once and shared across all inference calls.
A threading.Lock prevents two threads from loading simultaneously.
A semaphore limits how many inferences can run at the same time,
protecting low-RAM Windows machines from swapping to death.

Set the model path in your .env or system environment:
    SAPIENCE_GGUF_MODEL_PATH=C:/models/mistral-7b-instruct.Q4_K_M.gguf
"""

import os
import threading
import logging

logger = logging.getLogger(__name__)

# How many simultaneous LLM inferences are allowed.
# Keep at 1 on machines with < 8 GB RAM.
MAX_CONCURRENT_INFERENCES = 1

_model = None
_model_lock = threading.Lock()
_inference_semaphore = threading.Semaphore(MAX_CONCURRENT_INFERENCES)
_model_load_attempted = False


def _get_model_path() -> str | None:
    return os.environ.get("SAPIENCE_GGUF_MODEL_PATH", "").strip() or None


def load_model():
    """
    Lazy-load the GGUF model on first call.
    Subsequent calls return immediately (model already in RAM).
    Thread-safe via lock — only one thread loads at a time.
    """
    global _model, _model_load_attempted

    if _model is not None:
        return _model

    with _model_lock:
        # Double-check after acquiring lock
        if _model is not None:
            return _model

        if _model_load_attempted:
            # Already tried and failed — don't retry on every call
            return None

        _model_load_attempted = True
        model_path = _get_model_path()

        if not model_path:
            logger.warning(
                "SAPIENCE_GGUF_MODEL_PATH is not set. "
                "LLM advice will use fallback text. "
                "Set this env variable to enable local AI advice."
            )
            return None

        if not os.path.isfile(model_path):
            logger.error("GGUF model file not found at: %s", model_path)
            return None

        try:
            from llama_cpp import Llama  # type: ignore

            logger.info("Loading GGUF model from: %s", model_path)
            _model = Llama(
                model_path=model_path,
                n_ctx=1024,       # Context window — small to save RAM
                n_threads=4,      # CPU threads; adjust for your machine
                verbose=False,
            )
            logger.info("GGUF model loaded successfully.")
            return _model

        except ImportError:
            logger.error(
                "llama-cpp-python is not installed. "
                "Run: pip install llama-cpp-python"
            )
        except Exception as exc:
            logger.error("Failed to load GGUF model: %s", exc)

        return None


def run_inference(prompt: str, max_tokens: int = 200) -> str | None:
    """
    Run a text-completion inference with the loaded model.
    Returns None if the model is unavailable.

    The semaphore ensures only MAX_CONCURRENT_INFERENCES calls
    run at the same time, preventing RAM exhaustion.
    """
    model = load_model()
    if model is None:
        return None

    with _inference_semaphore:
        try:
            output = model(prompt, max_tokens=max_tokens, stop=["</s>", "\n\n"])
            return output["choices"][0]["text"].strip()
        except Exception as exc:
            logger.error("Inference error: %s", exc)
            return None

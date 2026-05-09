# Sapience AI — Local AI Engine

Runs entirely on your Windows machine. No internet required.
Raw audio never leaves your device.

## Components

| Module | Purpose |
|---|---|
| `vocal_engine/local_vocal_engine.py` | F0/jitter analysis via librosa |
| `vocal_engine/test_vocal_engine.py` | CLI test script |
| `llm/model_manager.py` | Thread-safe GGUF model loader |
| `llm/local_llm_advice.py` | Bengali wellness advice generator |

## Windows Setup

```powershell
# From the local_ai/ folder:
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

> **llama-cpp-python on Windows**: If the pip install fails, try the
> pre-built wheel from the llama-cpp-python GitHub releases page matching
> your Python version and CPU type.

## Run Vocal Analysis Test

```powershell
cd vocal_engine
python test_vocal_engine.py C:\path\to\your\recording.wav
```

## Configure the GGUF Model (Optional)

Set this in your environment or create a `.env` file:

```
SAPIENCE_GGUF_MODEL_PATH=C:\models\mistral-7b-instruct.Q4_K_M.gguf
```

If not set, the app uses pre-written Bengali fallback advice instead.
The app will NOT crash if the model is missing.

## Recommended Free Models

- `Mistral-7B-Instruct-v0.2.Q4_K_M.gguf` (~4 GB) — good balance
- `Phi-3-mini-4k-instruct.Q4_K_M.gguf` (~2 GB) — lighter option

Download from HuggingFace (search "GGUF" + model name).

## Privacy

- Audio files are read locally and then discarded from memory.
- No audio data is sent to any server.
- Only the computed score (an integer) is shared with the backend.

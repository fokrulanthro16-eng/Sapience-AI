"""
test_vocal_engine.py — Quick CLI test for the vocal stability engine.

Usage:
    python test_vocal_engine.py path/to/audio.wav

The script prints the full analysis result to the console.
"""

import sys
import json
import os

# Make sure we can import local_vocal_engine from the same folder
sys.path.insert(0, os.path.dirname(__file__))

from local_vocal_engine import analyze_voice_file


def main():
    if len(sys.argv) < 2:
        print("Usage: python test_vocal_engine.py <path_to_audio_file>")
        print("Example: python test_vocal_engine.py my_voice.wav")
        sys.exit(1)

    audio_path = sys.argv[1]
    print(f"\nAnalyzing: {audio_path}\n")

    result = analyze_voice_file(audio_path)

    print("=== Sapience AI — Vocal Analysis Result ===")
    print(json.dumps(result, ensure_ascii=False, indent=2))
    print()
    print(f"Stability Score : {result['stability_score']} / 100")
    print(f"Risk Level      : {result['risk_level']}")
    print(f"Message         : {result['message']}")
    print()
    print("NOTE: This is a wellness signal, not a medical diagnosis.")


if __name__ == "__main__":
    main()

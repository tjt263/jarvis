#!/usr/bin/env bash

echo "[+] Activating Jarvis venv..."
source /opt/jarvis/venv/bin/activate

echo "[+] Recording for 5 seconds..."
arecord -f cd -d 5 voice.wav

echo "[+] Transcribing with Whisper..."
whisper voice.wav --model tiny --output_format txt

echo "[+] Transcribed:"
cat voice.txt

echo "[+] Sending to Jarvis..."
python3 /opt/jarvis/jarvis.py "$(cat voice.txt)"

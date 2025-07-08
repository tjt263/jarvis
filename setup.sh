#!/usr/bin/env bash
echo "[+] Installing Jarvis to /opt/jarvis"
sudo mkdir -p /opt/jarvis
sudo cp -r * /opt/jarvis/
sudo chown -R $USER:$USER /opt/jarvis
cd /opt/jarvis
mkdir -p snippets logs
echo 'print("Init block")' > snippets/init.py
echo 'print("Main block")' > snippets/main.py
echo 'print("CLI block")' > snippets/cli.py
chmod +x pystrap.sh record.sh github_deploy.sh set_jarvis_keys.sh

echo "[+] Creating .env template..."
echo "export OPENAI_API_KEY=\"YOUR_OPENAI_API_KEY\"" > .env
echo "export GH_TOKEN=\"YOUR_GITHUB_TOKEN\"" >> .env
echo "export SSH_KEY_PATH=\"~/.ssh/github_id_ed25519\"" >> .env

echo "[+] Verifying files exist before creating symlinks..."
if [ -f pystrap.sh ] && [ -f record.sh ] && [ -f github_deploy.sh ]; then
  sudo ln -sf /opt/jarvis/pystrap.sh /usr/local/bin/pystrap
  sudo ln -sf /opt/jarvis/record.sh /usr/local/bin/jarvis-record
  sudo ln -sf /opt/jarvis/github_deploy.sh /usr/local/bin/jarvis-deploy
fi

echo "[+] Checking for venv..."
if [ ! -d "/opt/jarvis/venv" ]; then
  echo "[+] Creating Python virtual environment..."
  python3 -m venv /opt/jarvis/venv
fi

echo "[+] Activating virtual environment and installing Whisper..."
source /opt/jarvis/venv/bin/activate
pip install openai-whisper

echo "[+] Checking for ffmpeg..."
if ! command -v ffmpeg &> /dev/null; then
  echo "[+] Installing ffmpeg..."
  sudo apt-get update && sudo apt-get install -y ffmpeg
fi

echo "[+] Checking for arecord..."
if ! command -v arecord &> /dev/null; then
  echo "[+] arecord (ALSA) not found — installing alsa-utils..."
  sudo apt-get update && sudo apt-get install -y alsa-utils
fi

echo "[+] Running set_jarvis_keys.sh..."
bash set_jarvis_keys.sh
echo "[+] Setup complete."

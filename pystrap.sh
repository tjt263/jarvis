#!/usr/bin/env bash
REPO_URL="$1"
REPO_NAME=$(basename "$REPO_URL" .git)
DEST="/opt/$REPO_NAME"
echo "[+] Cloning $REPO_URL into $DEST"
git clone "$REPO_URL" "$DEST"
cd "$DEST" || exit 1
echo "[+] Creating virtual environment"
python3 -m venv venv
source venv/bin/activate
echo "[+] Installing requirements"
if [ -f requirements.txt ]; then
    pip install -r requirements.txt
fi
echo "[+] Detecting main script"
MAIN=$(grep -irl 'if __name__ == "__main__"' . | head -n1)
echo "[+] Main script: $MAIN"
echo "[+] Creating launcher in /usr/local/bin"
echo -e "#!/bin/bash\nsource $DEST/venv/bin/activate\npython $DEST/$MAIN \"\$@\"" | sudo tee "/usr/local/bin/$REPO_NAME"
sudo chmod +x "/usr/local/bin/$REPO_NAME"
echo "[+] Done. Run with: $REPO_NAME"

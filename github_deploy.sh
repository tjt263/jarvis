#!/usr/bin/env bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_id_ed25519
source .env

echo "[+] Initializing Git repo..."
git init
git add .
git commit -m "Jarvis v0.1"
git branch -M main

echo "[+] Forcing Git identity for safety..."
git config --global user.name "tjt263"
git config --global user.email "tjt263@users.noreply.github.com"

echo "[+] Checking if GitHub repo exists..."
if gh repo view tjt263/jarvis > /dev/null 2>&1; then
  echo "[+] Repo exists — skipping creation."
else
  echo "[+] Creating GitHub repo..."
  gh repo create tjt263/jarvis --public --source=. --remote=origin --push
fi

echo "[+] Forcing correct 'origin' remote..."
git remote remove origin 2>/dev/null
git remote add origin git@github.com:tjt263/jarvis.git

echo "[+] FORCE PUSHING to GitHub..."
git push --force -u origin main

echo "[+] Deploy complete."

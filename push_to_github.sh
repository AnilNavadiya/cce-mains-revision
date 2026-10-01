#!/bin/bash
# Helper script to link and push CCE Mains Revision to your GitHub repository

if [ -z "$1" ]; then
  if git remote get-url origin >/dev/null 2>&1; then
    echo "Pushing latest commits to existing origin: $(git remote get-url origin)..."
    git add .
    git commit -m "Daily update: CCE revision notes and web app" || true
    git push origin main
    echo "✅ Pushed to GitHub successfully! GitHub Actions is now updating your web portal."
    exit 0
  else
    echo "Usage: ./push_to_github.sh <github_repository_url>"
    echo "Example: ./push_to_github.sh https://github.com/anilnavadiya/cce-mains-revision.git"
    exit 1
  fi
fi

REPO_URL="$1"
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"
git branch -M main
echo "Pushing to $REPO_URL..."
git push -u origin main

echo ""
echo "=========================================================="
echo "✅ Code successfully pushed to GitHub!"
echo "🌐 Automated GitHub Actions will now build and deploy the web portal."
echo "👉 Check your repository Actions tab to watch the build."
echo "=========================================================="

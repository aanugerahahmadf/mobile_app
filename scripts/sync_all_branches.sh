#!/usr/bin/env bash
set -e

# List 4 branches target
BRANCHES=("main" "chore/complete-mobile-tests-and-chat" "dependabot/npm_and_yarn/functions/npm_and_yarn-a18cab04ac" "v0/mobile-fullstack-ci")

COMMIT_MSG="${1:-}"
DISCORD_WEBHOOK="${2:-}"

# Load from .env if empty
if [ -z "$DISCORD_WEBHOOK" ] && [ -f ".env" ]; then
    DISCORD_WEBHOOK=$(grep -E '^DISCORD_WEBHOOK_URL=' .env | cut -d '=' -f2- | tr -d '\r"')
fi

echo "=========================================================="
echo " SINKRONISASI PULL, COMMIT, DAN PUSH KE 4 BRANCH"
echo "=========================================================="

INITIAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Branch awal: $INITIAL_BRANCH"

if [ -n "$(git status --porcelain)" ]; then
    if [ -z "$COMMIT_MSG" ]; then
        COMMIT_MSG="chore: sync all 4 branches"
    fi
    echo "Menyimpan perubahan dengan commit: '$COMMIT_MSG'..."
    git add -A
    git commit -m "$COMMIT_MSG"
fi

git fetch origin

SUCCESS=()
FAILED=()

echo "--> Memperbarui 'main'..."
if git checkout main && git pull origin main --no-edit && git push origin main; then
    SUCCESS+=("main")
else
    FAILED+=("main")
fi

for b in "${BRANCHES[@]}"; do
    if [ "$b" = "main" ]; then continue; fi
    echo "--> Memproses branch '$b'..."
    if git checkout "$b" && git pull origin "$b" --no-edit && git merge main --no-edit && git push origin "$b"; then
        SUCCESS+=("$b")
    else
        FAILED+=("$b")
    fi
done

git checkout "$INITIAL_BRANCH"

echo "======================= RINGKASAN ======================="
echo "Berhasil (${#SUCCESS[@]}): ${SUCCESS[*]}"
if [ ${#FAILED[@]} -gt 0 ]; then
    echo "Gagal (${#FAILED[@]}): ${FAILED[*]}"
fi
echo "=========================================================="

if [ -n "$DISCORD_WEBHOOK" ]; then
    echo "Mengirim notifikasi ke Discord..."
    LAST_COMMIT=$(git log -1 --pretty=format:"%s (%h by %an)")
    PAYLOAD=$(cat <<EOF
{
  "username": "GitHub Sync Bot",
  "avatar_url": "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
  "embeds": [
    {
      "title": "Git Sync: 4 Branch Berhasil Disinkronkan & Di-Push",
      "description": "**Hasil Sinkronisasi:**\n- Berhasil: ${SUCCESS[*]}\n\n**Commit Terakhir:** ${LAST_COMMIT}",
      "color": 3066993,
      "footer": {
        "text": "Timeless Florals"
      },
      "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    }
  ]
}
EOF
    )
    curl -s -H "Content-Type: application/json" -X POST -d "$PAYLOAD" "$DISCORD_WEBHOOK" || true
    echo "Selesai!"
fi

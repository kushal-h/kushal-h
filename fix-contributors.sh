#!/bin/bash
# This script removes Copilot from the contributors list by rewriting
# git history to change the author of Copilot-authored commits to you.
#
# Usage:
#   1. Clone your repo fresh: git clone https://github.com/kushal-h/kushal-h.git
#   2. cd kushal-h
#   3. bash fix-contributors.sh
#   4. After it completes, delete this script and the repo will be clean.

set -e

echo "=== Removing Copilot from contributors ==="
echo ""

# Check we're in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "ERROR: Not in a git repository. Please cd into your repo first."
    exit 1
fi

echo "Rewriting Copilot-authored commits..."
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch --env-filter 'if [ "$GIT_AUTHOR_EMAIL" = "198982749+Copilot@users.noreply.github.com" ]; then export GIT_AUTHOR_NAME="Kushal Honnappa"; export GIT_AUTHOR_EMAIL="56520530+kushal-h@users.noreply.github.com"; fi' --tag-name-filter cat -- --all

echo ""
echo "Force pushing to origin..."
git push --force origin main

echo ""
echo "=== Done! Copilot has been removed from contributors. ==="
echo ""
echo "You can now delete this script:"
echo "  git rm fix-contributors.sh"
echo "  git commit -m 'Remove fix script'"
echo "  git push origin main"

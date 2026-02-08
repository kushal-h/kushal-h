@echo off
REM This script removes Copilot from the contributors list.
REM Run this in Windows CMD from inside your cloned repo.
REM
REM Usage:
REM   1. git clone https://github.com/kushal-h/kushal-h.git
REM   2. cd kushal-h
REM   3. fix-contributors.bat

echo === Removing Copilot from contributors ===
echo.

git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo ERROR: Not in a git repository. Please cd into your repo first.
    exit /b 1
)

echo Rewriting Copilot-authored commits...
set FILTER_BRANCH_SQUELCH_WARNING=1
git filter-branch -f --env-filter "if test $GIT_AUTHOR_EMAIL = 198982749+Copilot@users.noreply.github.com; then GIT_AUTHOR_NAME='Kushal Honnappa' && GIT_AUTHOR_EMAIL='56520530+kushal-h@users.noreply.github.com' && export GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL; fi" -- --all

if errorlevel 1 (
    echo.
    echo ERROR: filter-branch failed.
    echo.
    echo Try using Git Bash instead:
    echo   1. Right-click in this folder, select "Open Git Bash here"
    echo   2. Type: bash fix-contributors.sh
    exit /b 1
)

echo.
echo Force pushing to origin...
git push --force origin main

echo.
echo === Done! Copilot has been removed from contributors. ===
echo.
echo You can now delete the fix scripts:
echo   git rm fix-contributors.sh fix-contributors.bat
echo   git commit -m "Remove fix scripts"
echo   git push origin main

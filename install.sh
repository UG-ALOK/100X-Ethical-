#!/bin/sh

============================================================

100X ETHICAL SECURITY

Termux / Linux Installer

Python 3.8+ | No root required

============================================================

YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
RESET='\033[0m'

say() {
printf '%b\n' "${YELLOW}$*${RESET}"
}

ok() {
printf '%b\n' "${GREEN}[OK] $*${RESET}"
}

warn() {
printf '%b\n' "${YELLOW}[!] $*${RESET}"
}

err() {
printf '%b\n' "${RED}[ERROR] $*${RESET}" >&2
}

Resolve the directory containing this installer

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd) || {
err "Cannot resolve project directory."
exit 1
}

APP="$DIR/Security 100.py"

Banner

printf '%b\n' "$YELLOW"
printf '%s\n' '============================================================'
printf '%s\n' ' __   ___   ___  __  '
printf '%s\n' ' \ \ / / | / _ |  /  |'
printf '%s\n' '  \ V /| || | | | |/| |'
printf '%s\n' '   | | | || || | |  | |'
printf '%s\n' '   || |_| _/||  ||'
printf '%s\n' '         100X ETHICAL SECURITY'
printf '%s\n' '              INSTALLER'
printf '%s\n' '============================================================'
printf '%b\n\n' "$RESET"

Detect environment

ENVNAME="Linux/Unix"

case "${PREFIX:-}" in
com.termux) ENVNAME="Termux" ;;
esac

if [ -n "${TERMUX_VERSION:-}" ] || [ -d /data/data/com.termux ]; then
ENVNAME="Termux"
fi

say "[1/5] Environment"
ok "Detected: $ENVNAME"

Locate Python 3.8+

say ""
say "[2/5] Checking Python"

PY=""

for candidate in python3 python; do
if command -v "$candidate" >/dev/null 2>&1 &&
"$candidate" -c 
'import sys; sys.exit(0 if sys.version_info >= (3, 8) else 1)' 
>/dev/null 2>&1
then
PY="$candidate"
break
fi
done

if [ -z "$PY" ]; then
if [ "$ENVNAME" = "Termux" ] && command -v pkg >/dev/null 2>&1; then
printf '%b' "${YELLOW}Install Python using pkg? [y/N]: ${RESET}"
read -r answer || answer=n

    case "$answer" in
        y|Y|yes|YES)
            pkg install -y python || {
                err "Python installation failed."
                exit 1
            }
            ;;
        *)
            err "Install Python with: pkg install python"
            exit 1
            ;;
    esac

    for candidate in python3 python; do
        if command -v "$candidate" >/dev/null 2>&1 &&
           "$candidate" -c \
           'import sys; sys.exit(0 if sys.version_info >= (3, 8) else 1)' \
           >/dev/null 2>&1
        then
            PY="$candidate"
            break
        fi
    done
else
    err "Python 3.8+ is required."
    say "Install Python using your Linux package manager."
    exit 1
fi

fi

if [ -z "$PY" ]; then
err "Python 3.8+ could not be found."
exit 1
fi

ok "$("$PY" --version 2>&1)"

Check required project files

say ""
say "[3/5] Checking project files"

if [ ! -f "$APP" ]; then
err "Security 100.py was not found."
say "Keep Security 100.py and install.sh in the same folder."
exit 1
fi

if [ ! -f "$DIR/README.md" ]; then
warn "README.md was not found."
fi

ok "Security 100.py found"

Check Python syntax

if ! "$PY" -c 
'import ast,sys; ast.parse(open(sys.argv[1], encoding="utf-8").read())' 
"$APP"
then
err "Python syntax check failed."
exit 1
fi

ok "Python syntax is valid"

Check standard-library imports

say ""
say "[4/5] Checking Python libraries"

if ! "$PY" -c '
import ssl
import socket
import sqlite3
import json
import hashlib
import hmac
import ipaddress
import html.parser
import http.server
import urllib.request
import zlib
import threading
import base64
'; then
err "A required Python library is unavailable."
exit 1
fi

ok "Standard-library checks passed"
say "No pip packages are installed by this installer."

Verify the application's feature registry

say ""
say "[5/5] Verifying application"

if "$PY" "$APP" --verify; then
ok "Application verification passed"
else
err "Application verification failed."
say "Check the --verify option and feature registry in Security 100.py."
exit 1
fi

Finish

say ""
printf '%b\n' "$GREEN"
printf '%s\n' '============================================================'
printf '%s\n' '           INSTALLATION CHECK COMPLETE'
printf '%s\n' '============================================================'
printf '%b\n' "$RESET"

say "Project: $DIR"
say "Application: Security 100.py"
say ""
say "Launch command:"
printf "cd '%s' && '%s' '%s'\n" "$DIR" "$PY" "$APP"
say ""
say "Educational use and authorized security testing only."

exit 0

#!/bin/sh

============================================================

100X Ethical 

Termux / Linux | Python 3.8+ | No root required

============================================================

ANSI colors

YELLOW='\033[1;33m'
GOLD='\033[0;93m'
RED='\033[1;31m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'
RESET='\033[0m'

say()  { printf "${YELLOW}%s${RESET}\n" "$"; }
ok()   { printf "${GREEN}[OK]${RESET} %s\n" "$"; }
warn() { printf "${GOLD}[!]${RESET} %s\n' "$"; }
err()  { printf "${RED}[ERROR]${RESET} %s\n" "$" >&2; }

Resolve project directory

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd) || {
err "Cannot resolve installer directory."
exit 1
}

clear 2>/dev/null || true

printf "${YELLOW}"
printf '%s\n' '============================================================'
printf '%s\n' '  _  ___   ___   ___  _   _  ___  ___  '
printf '%s\n' ' | |/ / | / / | / / || | / _ | _ \ '
printf '%s\n' ' |   <| |/ /| |/ /| __ | | () |   / '
printf '%s\n' ' ||__/ |/ ||||  ___/||_\ '
printf '%s\n' '          100 FEATURES ETHICAL TOOL'
printf '%s\n' '              INSTALLER v2.0'
printf '%s\n' '============================================================'
printf "${RESET}\n"

Detect environment

ENVNAME="Linux/Unix"

case "${PREFIX:-}" in
com.termux) ENVNAME="Termux" ;;
esac

[ -n "${TERMUX_VERSION:-}" ] && ENVNAME="Termux"
[ -d /data/data/com.termux ] && ENVNAME="Termux"

say "[1/5] Environment detection"
ok "Environment: $ENVNAME"

if [ "$(id -u 2>/dev/null)" = "0" ]; then
warn "Root detected. Root access is not required."
fi

Locate Python 3.8+

say ""
say "[2/5] Checking Python"

PY=""

for candidate in python3 python; do
if command -v "$candidate" >/dev/null 2>&1 &&
"$candidate" -c 'import sys; sys.exit(0 if sys.version_info >= (3,8) else 1)' >/dev/null 2>&1
then
PY=$candidate
break
fi
done

if [ -z "$PY" ]; then
warn "Python 3.8+ is not installed."

if [ "$ENVNAME" = "Termux" ] && command -v pkg >/dev/null 2>&1; then
    printf "${YELLOW}Install Python using pkg install python? [y/N]: ${RESET}"
    read -r answer || answer=n

    case "$answer" in
        y|Y|yes|YES)
            pkg install -y python || {
                err "Python installation failed. Try pkg update and retry."
                exit 1
            }

            for candidate in python3 python; do
                if command -v "$candidate" >/dev/null 2>&1 &&
                   "$candidate" -c 'import sys; sys.exit(0 if sys.version_info >= (3,8) else 1)' >/dev/null 2>&1
                then
                    PY=$candidate
                    break
                fi
            done
            ;;
        *)
            err "Install Python with: pkg install python"
            exit 1
            ;;
    esac
fi

fi

if [ -z "$PY" ]; then
err "Python 3.8+ is required."
say "Termux: pkg install python"
say "Debian/Ubuntu: install python3 using your package manager."
exit 1
fi

ok "Python: $("$PY" --version 2>&1)"

Check required application file

say ""
say "[3/5] Checking project files"

APP="$DIR/Security 100.py"

if [ ! -f "$APP" ]; then
err "Security 100.py was not found."
say "Keep these files together in one folder:"
say "  Security 100.py"
say "  install.sh"
say "  README.md"
exit 1
fi

ok "Found Security 100.py"

Syntax validation

if ! "$PY" -c 'import ast,sys; ast.parse(open(sys.argv[1], encoding="utf-8").read())' "$APP"; then
err "Syntax check failed. Fix Security 100.py before running."
exit 1
fi

ok "Python syntax is valid"

Check standard library

say ""
say "[4/5] Checking Python libraries"

if ! "$PY" -c '
import ssl, socket, sqlite3, json, hashlib, hmac
import ipaddress, html.parser, http.server, urllib.request
import zlib, threading, base64
'; then
err "A required Python standard-library module is unavailable."
exit 1
fi

ok "Standard-library checks passed"
say "No pip packages are required by this installer."

Optional application self-test

say ""
say "[5/5] Final verification"

if "$PY" "$APP" --help >/dev/null 2>&1; then
ok "Application help command works"
else
warn "No working --help option detected, or the application uses another interface."
fi

Do not assume --verify exists or run the interactive application.

say ""
printf "${GREEN}"
printf '%s\n' '============================================================'
printf '%s\n' '             INSTALLATION CHECK COMPLETE'
printf '%s\n' '============================================================'
printf "${RESET}\n"

say "Project directory: $DIR"
say "Application: Security 100.py"
say ""
say "To launch the tool:"
printf "${WHITE}cd '%s' && '%s' '%s'\n${RESET}" "$DIR" "$PY" "$APP"
say ""
say "Disclaimer: Use only for education and authorized security testing."
say "The developer is not responsible for illegal activity or misuse."
say "============================================================"

exit 0
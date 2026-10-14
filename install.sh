#!/bin/sh

YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
RESET='\033[0m'

say() { printf '%b\n' "${YELLOW}$${RESET}"; }
ok() { printf '%b\n' "${GREEN}[OK] $${RESET}"; }
err() { printf '%b\n' "${RED}[ERROR] $*${RESET}" >&2; }

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd) || {
err "Cannot find project directory."
exit 1
}

APP="$DIR/Security 100.py"

printf '%b\n' "$YELLOW"
printf '%s\n' '========================================'
printf '%s\n' '       100X ETHICAL SECURITY'
printf '%s\n' '            INSTALLER'
printf '%s\n' '========================================'
printf '%b\n' "$RESET"

say "[1/4] Checking environment"

if [ -n "${TERMUX_VERSION:-}" ] || [ -d /data/data/com.termux ]; then
ok "Termux detected"
else
ok "Linux/Unix detected"
fi

say ""
say "[2/4] Checking Python"

PY=""

for CANDIDATE in python3 python; do
if command -v "$CANDIDATE" >/dev/null 2>&1; then
if "$CANDIDATE" -c 'import sys; sys.exit(0 if sys.version_info >= (3,8) else 1)' >/dev/null 2>&1; then
PY="$CANDIDATE"
break
fi
fi
done

if [ -z "$PY" ]; then
err "Python 3.8 or newer is required."
say "Termux command: pkg install python"
exit 1
fi

ok "$("$PY" --version 2>&1)"

say ""
say "[3/4] Checking application"

if [ ! -f "$APP" ]; then
err "Security 100.py not found."
say "Keep install.sh and Security 100.py in the same folder."
exit 1
fi

if ! "$PY" -c 'import ast,sys; ast.parse(open(sys.argv[1], encoding="utf-8").read())' "$APP"; then
err "Python syntax check failed."
exit 1
fi

ok "Security 100.py syntax is valid"

say ""
say "[4/4] Checking standard libraries"

if ! "$PY" -c 'import ssl,socket,sqlite3,json,hashlib,hmac,ipaddress,http.server,urllib.request,threading,base64'; then
err "A required Python library is unavailable."
exit 1
fi

ok "Standard libraries are available"

say ""
ok "Installation checks completed."
say "No pip packages installed."
say ""
say "Run your tool with:"
printf "'%s' '%s'\n" "$PY" "$APP"
say ""
say "Educational use and authorized testing only."

exit 0

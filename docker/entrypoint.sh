#!/usr/bin/env bash
set -e

# Fix ownership of data and workspace directories if mounted
if [ "$(id -u)" = "0" ]; then
    mkdir -p /home/orca/.config/orca /home/orca/.local/share/orca /workspace
    chown -R orca:orca /home/orca /workspace
    mkdir -p /run/dbus
    dbus-daemon --system --fork 2>/dev/null || true
    exec runuser -u orca -- "$0" "$@"
fi

PAIRING_ADDR="${ORCA_PAIRING_ADDRESS:-http://127.0.0.1:6768}"
PORT="${ORCA_PORT:-6768}"

EXTRA_ARGS=()
if [ -n "$ORCA_NO_PAIRING" ]; then
    EXTRA_ARGS+=(--no-pairing)
fi

echo "=========================================================="
echo " Starting Orca Web Server on port ${PORT}..."
echo " Advertised Pairing Address: ${PAIRING_ADDR}"
echo "=========================================================="

exec xvfb-run -a /opt/orca/AppRun --no-sandbox serve \
    --port "$PORT" \
    --pairing-address "$PAIRING_ADDR" \
    "${EXTRA_ARGS[@]}"

#!/bin/sh
# Bring up WireGuard after upstream interface is available and time is valid.

[ "$ACTION" = "ifup" ] || exit 0
[ "$INTERFACE" = "wwan" ] || [ "$INTERFACE" = "wan" ] || exit 0

sleep 5

YEAR="$(date +%Y)"
[ "$YEAR" -ge 2024 ] || exit 0

if ifstatus wg0 | grep -q '"up": true'; then
    logger -t wg-sync "wg0 already up; no action needed"
else
    logger -t wg-sync "wg0 down; starting WireGuard after time sync"
    ifup wg0
fi

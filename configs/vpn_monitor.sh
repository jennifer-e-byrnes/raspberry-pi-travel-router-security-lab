#!/bin/sh
# Monitor WireGuard tunnel health and attempt recovery if the tunnel becomes stale.

WG_IF="wg0"
WAN_IF="wwan"
MAX_AGE=120
PING_IP="1.1.1.1"

# Exit quietly if the WireGuard interface is unavailable.
wg show "$WG_IF" >/dev/null 2>&1 || exit 0

# Get latest handshake epoch.
AGE="$(wg show "$WG_IF" latest-handshakes | awk '{print $2}')"
AGE="${AGE%% *}"
NOW="$(date +%s)"

# If the handshake is blank or zero, treat it as stale.
if [ -z "$AGE" ] || [ "$AGE" = "0" ]; then
    DELTA=999999
else
    DELTA=$((NOW - AGE))
fi

# Quick connectivity test.
ping -c 1 -W 3 "$PING_IP" >/dev/null 2>&1
PING_OK=$?

# Healthy state: recent handshake and successful connectivity test.
if [ "$DELTA" -le "$MAX_AGE" ] && [ "$PING_OK" -eq 0 ]; then
    exit 0
fi

logger -t vpn-monitor "Stale tunnel or connectivity failure detected (handshake_age=${DELTA}s, ping_ok=$PING_OK); restarting $WAN_IF"

# Bounce upstream Wi-Fi first, since upstream recovery was the most effective fix during testing.
ifdown "$WAN_IF"
sleep 5
ifup "$WAN_IF"

# Allow upstream connectivity and hotplug logic time to recover WireGuard.
sleep 20

# Re-check connectivity.
ping -c 1 -W 3 "$PING_IP" >/dev/null 2>&1
PING_OK=$?

if [ "$PING_OK" -ne 0 ]; then
    logger -t vpn-monitor "Connectivity still down after $WAN_IF restart; restarting $WG_IF"
    ifdown "$WG_IF" 2>/dev/null
    sleep 3
    ifup "$WG_IF" 2>/dev/null
fi

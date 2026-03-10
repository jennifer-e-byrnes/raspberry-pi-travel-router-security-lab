#!/bin/sh
# Delayed Wi-Fi reload to recover wireless services after boot.

sleep 25
logger -t wifi-recover "Delayed wifi reload starting"
wifi down
sleep 3
wifi up
logger -t wifi-recover "Delayed wifi reload finished"

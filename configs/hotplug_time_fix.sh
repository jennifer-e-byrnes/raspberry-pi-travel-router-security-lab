#!/bin/sh
# Restart time-dependent services after interface comes up.

[ "$ACTION" = "ifup" ] && {
  service sysntpd restart
  service cron restart
}

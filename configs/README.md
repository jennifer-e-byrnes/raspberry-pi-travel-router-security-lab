# Router Configuration Artifacts

This folder contains sanitized configuration snapshots and automation scripts from the OpenWrt travel router used in this project.

Sensitive values such as private keys, Wi-Fi credentials, and endpoint identifiers have been redacted.

## Configuration Snapshots

| File | Purpose |
|-----|-----|
| network_config_sanitized.txt | Core network interface configuration including LAN, WWAN uplink, and WireGuard interface |
| firewall_policy_sanitized.txt | Firewall zones, forwarding rules, and DNS enforcement redirects |
| dhcp_dns_config_sanitized.txt | DHCP service configuration and DNSMasq settings including DNSSEC validation |
| wireless_config_sanitized.txt | Wireless configuration showing AP mode for clients and station mode for upstream connectivity |

## Automation Scripts

| Script | Purpose |
|------|------|
| vpn_monitor.sh | Monitors WireGuard handshake age and connectivity and attempts automated recovery |
| wifi_recover_at_boot.sh | Performs delayed Wi-Fi restart during boot to recover wireless services |
| hotplug_wg_after_ntp.sh | Ensures the VPN interface starts only after upstream connectivity and time synchronization |
| hotplug_time_fix.sh | Restarts time-dependent services after interface state changes |

These artifacts illustrate how the router enforces VPN-first routing, DNS control, and firewall segmentation.

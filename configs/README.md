# Router Configuration Artifacts

This directory contains **sanitized configuration snapshots and automation scripts** from the OpenWrt-based Raspberry Pi travel router used in this security lab project.

These files illustrate how the router enforces:

- **VPN-first routing**
- **DNS control and leak prevention**
- **Firewall segmentation**
- **Automated VPN and connectivity recovery**

All sensitive values such as **private keys, Wi-Fi credentials, endpoint identifiers, and unique network metadata have been redacted** before publication.

These files are provided as **reference artifacts for architecture documentation**, not as production-ready configuration files.

---

# Configuration Snapshots

These files represent key portions of the router's OpenWrt configuration.

| File | Description |
|-----|-----|
| `network_config_sanitized.txt` | Defines router interfaces including LAN bridge, upstream Wi-Fi uplink (WWAN), and the WireGuard VPN interface. |
| `firewall_policy_sanitized.txt` | Firewall zones, forwarding policies, and rules enforcing LAN → VPN routing while preventing direct WAN bypass. |
| `dhcp_dns_config_sanitized.txt` | DHCP server and DNSMasq configuration used to control client DNS resolution and enable DNSSEC validation. |
| `wireless_config_sanitized.txt` | Wireless configuration defining the router's client access point and upstream Wi-Fi connection to external networks. |

### Key Security Properties Demonstrated

The configuration snapshots show several important design choices:

**VPN-first routing**

LAN clients are allowed to forward traffic only to the VPN zone.

LAN → VPN → Internet

Direct forwarding from LAN to WAN is explicitly blocked in the firewall policy (`firewall_policy_sanitized.txt`).

**DNS control**

Client DNS requests are redirected to the router's DNS resolver to prevent DNS bypass or DNS leaks.  
This behavior is enforced using DNS redirect rules in `firewall_policy_sanitized.txt`.

**DNSSEC validation**

DNSMasq is configured to perform DNSSEC validation for additional protection against DNS manipulation.  
This configuration appears in `dhcp_dns_config_sanitized.txt`.

**IPv6 leak prevention**

IPv6 forwarding from the LAN is disabled to prevent traffic from bypassing the VPN tunnel.  
This control is implemented in `firewall_policy_sanitized.txt`.

---

# Automation Scripts

These scripts were created to improve **reliability and resilience of the travel router** when operating on unstable or hostile networks.

| Script | Description |
|------|------|
| `vpn_monitor.sh` | Monitors WireGuard tunnel health and attempts recovery if the VPN becomes stale or connectivity is lost. |
| `wifi_recovery_at_boot.sh` | Performs a delayed Wi-Fi restart during boot to recover wireless services. |
| `hotplug_wg_after_ntp.sh` | Ensures the VPN interface starts only after upstream connectivity and time synchronization. |
| `hotplug_time_fix.sh` | Restarts time-dependent services when network interfaces come online. |

### Automated Recovery Behavior

The router includes several automated recovery mechanisms:

**VPN tunnel health monitoring**

The VPN monitor script checks WireGuard handshake age and connectivity to detect stale tunnels (`vpn_monitor.sh`).

**Upstream network recovery**

If connectivity fails, the router attempts to reset the upstream Wi-Fi interface before restarting the VPN.  
This recovery logic is implemented in `vpn_monitor.sh`.

**Startup sequencing**

Hotplug scripts ensure that time-dependent services and the VPN interface start in the correct order after the network becomes available (`hotplug_wg_after_ntp.sh`, `hotplug_time_fix.sh`).

**Wireless service stabilization**

A delayed Wi-Fi restart is used to recover wireless services that occasionally fail during system boot (`wifi_recovery_at_boot.sh`).

---

# Security Considerations

To prevent disclosure of sensitive information, the following data has been removed:

- WireGuard private keys
- VPN endpoint identifiers
- Wi-Fi credentials
- Device identifiers and unique network metadata

These artifacts are provided for **educational and architectural reference only**.

---

## Relationship to the Project

These configuration artifacts support the architecture documented in:

- [`/diagrams`](../diagrams) — Architecture, network, trust boundary, and threat model diagrams
- [`/docs`](../docs) — Full architecture and security analysis documentation

They provide **technical evidence of the security controls and network segmentation described in the project documentation**.

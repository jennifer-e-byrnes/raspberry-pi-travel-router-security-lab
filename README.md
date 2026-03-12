# 📄 Raspberry Pi Travel Router Security Lab

![OpenWrt](https://img.shields.io/badge/OpenWrt-router--os-blue)
![WireGuard](https://img.shields.io/badge/WireGuard-VPN-orange)
![Raspberry Pi](https://img.shields.io/badge/Raspberry%20Pi-hardware-red)
![Network Security](https://img.shields.io/badge/Security-Network%20Architecture-green)

A portable network security lab implementing **VPN-first routing, DNS enforcement, and firewall segmentation** using **OpenWrt on a Raspberry Pi**.

📄 **Full Project Documentation**  
[Travel Router Security Architecture Lab](./docs/travel-router-security-architecture-lab.pdf)

---

# Security Concepts Demonstrated

This project demonstrates several practical network security architecture concepts:

| Concept | Implementation |
|-------|----------------|
| VPN-first routing | Firewall forwarding restricts LAN traffic to the WireGuard interface |
| DNS enforcement | Firewall redirects force all DNS queries to the router resolver |
| DNSSEC validation | DNSMasq configured to validate DNS responses |
| IPv6 leak prevention | IPv6 DHCP, RA, and SLAAC disabled |
| Firewall segmentation | Separate LAN, WAN, and VPN zones |
| Secure management surface | SSH and LuCI restricted to LAN |
| Rogue DHCP protection | Firewall rules block unauthorized DHCP responses |
| Network trust boundary | Router enforces centralized security controls for all clients |

---

# Table of Contents

- [Project Overview](#project-overview)
- [Security Controls Implemented](#security-controls-implemented)
- [System Architecture](#system-architecture)
- [Network Architecture](#network-architecture)
- [Trust Boundary](#trust-boundary)
- [Core Components](#core-components)
- [Testing Methodology](#testing-methodology)
- [Limitations](#limitations)
- [Future Improvements](#future-improvements)
- [Skills Demonstrated](#skills-demonstrated)
- [Repository Structure](#repository-structure)
- [Author](#author)

---

# Repository Structure

Project artifacts are organized into the following directories:

- [LICENSE](LICENSE) — repository license
- [README.md](README.md) — project overview and navigation

- **configs/**
  - [README.md](configs/README.md) — explanation of configuration artifacts and scripts
  - [dhcp_dns_config_sanitized.txt](configs/dhcp_dns_config_sanitized.txt)
  - [firewall_policy_sanitized.txt](configs/firewall_policy_sanitized.txt)
  - [hotplug_time_fix.sh](configs/hotplug_time_fix.sh)
  - [hotplug_wg_after_ntp.sh](configs/hotplug_wg_after_ntp.sh)
  - [network_config_sanitized.txt](configs/network_config_sanitized.txt)
  - [vpn_monitor.sh](configs/vpn_monitor.sh)
  - [wifi_recovery_at_boot.sh](configs/wifi_recovery_at_boot.sh)
  - [wireless_config_sanitized.txt](configs/wireless_config_sanitized.txt)

- **diagrams/**
  - [README.md](diagrams/README.md) — explanation of architecture and security diagrams
  - [data_flow.png](diagrams/data_flow.png)
  - [network_architecture.png](diagrams/network_architecture.png)
  - [security_controls.png](diagrams/security_controls.png)
  - [system_architecture.png](diagrams/system_architecture.png)
  - [threat_model.png](diagrams/threat_model.png)
  - [trust_boundary.png](diagrams/trust_boundary.png)

- **docs/**
  - [travel-router-security-architecture-lab.pdf](docs/travel-router-security-architecture-lab.pdf) — compiled architecture and security documentation

Project artifacts are organized into the following directories:

- [`docs`](./docs) — Full project documentation and architecture report  
- [`diagrams`](./diagrams) — Architecture, data flow, trust boundary, and threat model diagrams  
- [`configs`](./configs) — Sanitized OpenWrt configuration snapshots and automation scripts  

---

# Project Overview

Public networks (hotels, airports, cafés, and temporary housing) are environments where users have little control over the underlying infrastructure.

Even when a device-level VPN is enabled, traffic can still behave unpredictably due to:

- DNS queries leaving the VPN tunnel
- IPv6 alternate routing paths
- fallback routes when a VPN disconnects
- exposure to upstream network scanning

Instead of relying on each individual device to configure its own security settings, this project enforces security controls **at the network gateway itself**.

A **Raspberry Pi running OpenWrt** acts as a travel router that:

- routes all traffic through a **WireGuard VPN**
- enforces **centralized DNS resolution**
- prevents **LAN → WAN traffic bypass**
- restricts **administrative access**
- reduces **IPv6 routing leakage**

By centralizing routing and DNS policies at the gateway, all connected devices automatically follow the same security controls without requiring configuration changes on each endpoint.

This architecture mirrors how many organizations implement **network security controls at trusted boundaries**, where routing policy, DNS enforcement, and segmentation are centralized within network infrastructure.

---

# Security Controls Implemented

| Security Control | Implementation |
|---|---|
| **VPN-first routing** | Firewall rules enforce LAN → VPN and block LAN → WAN |
| **DNS leak prevention** | DNS redirect rules force TCP/UDP 53 through dnsmasq |
| **IPv6 leak reduction** | DHCPv6, RA, and SLAAC disabled |
| **Firewall segmentation** | Zone-based firewall separating LAN / WAN / VPN |
| **Restricted administration** | SSH and LuCI limited to the LAN network |

Together these controls ensure that **all client traffic follows the intended encrypted routing path**.

---

# System Architecture

The router acts as an intermediary gateway between client devices and upstream networks.

**Client traffic flow**

```text
Client Device
     │
     ▼
Travel Router (OpenWrt)
     │
     ▼
WireGuard VPN Tunnel
     │
     ▼
Internet
```

### System Architecture Diagram

![System Architecture](./diagrams/system_architecture.png)

The architecture enforces centralized control over:

- routing behavior
- DNS resolution
- firewall policy
- administrative access

---

# Network Architecture

The network architecture illustrates how the router interfaces with the private LAN, upstream network, and VPN tunnel.

![Network Architecture](./diagrams/network_architecture.png)

The router maintains multiple network interfaces:

- **LAN bridge** for connected client devices
- **WAN interface (wwan)** for upstream network connectivity
- **WireGuard interface (wg0)** for encrypted VPN routing

Firewall zones enforce segmentation between these networks.

---

# Trust Boundary

The trust boundary diagram highlights how the router separates **trusted client devices** from **untrusted upstream networks**.

![Trust Boundary](./diagrams/trust_boundary.png)

The Raspberry Pi router functions as a **policy enforcement gateway**, controlling how traffic flows between zones.

Security policies applied at this boundary include:

- firewall rule enforcement
- VPN-first routing
- DNS control
- administrative access restrictions

---

# Core Components

| Component | Purpose |
|---|---|
| **Raspberry Pi 4** | Hardware platform hosting the router |
| **OpenWrt** | Router operating system and network control plane |
| **WireGuard** | Encrypted VPN tunnel for outbound traffic |
| **Mullvad VPN** | Upstream VPN provider |
| **dnsmasq** | DNS resolver and DHCP service |
| **fw4 / nftables** | Zone-based firewall |
| **Dropbear** | SSH management access |
| **LuCI** | Web configuration interface |

---

# Testing Methodology

After configuration, several tests validated that routing and DNS controls behaved as expected.

| Test | Validation |
|---|---|
| DNS server assignment | `dig google.com @10.81.81.1` |
| VPN routing | `ip route` and firewall rules |
| DNS leak testing | Online DNS leak tools |
| External IP verification | `curl ifconfig.me` |
| VPN tunnel health | `wg show` |
| Fail-closed testing | Disable VPN interface |

Results confirmed that:

- all DNS queries are routed through the router
- outbound traffic exits through the VPN tunnel
- LAN → WAN bypass is blocked
- administrative access is LAN-only

Configuration artifacts supporting these controls can be found in [`configs`](./configs).

---

# Limitations

This implementation focuses primarily on **routing and DNS control**, not full network monitoring.

Known limitations include:

- single-device gateway architecture
- limited traffic visibility
- dependency on VPN availability
- no deep packet inspection or IDS
- hardware performance limits of Raspberry Pi

---

# Future Improvements

Planned future enhancements include:

- Suricata IDS integration
- Zeek network telemetry
- centralized logging
- VPN health monitoring
- VLAN segmentation for device classes

These additions would further expand the system into a **portable network security experimentation platform**.

---

# Skills Demonstrated

This project demonstrates practical experience in:

- Linux networking
- VPN configuration (WireGuard)
- firewall policy design
- DNS enforcement
- network segmentation
- troubleshooting complex routing behavior
- translating security goals into infrastructure controls

---

# Author

Jennifer Byrnes  
Cybersecurity Portfolio Project  
March 2026

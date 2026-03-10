# 📄 Raspberry Pi Travel Router Security Lab

![OpenWrt](https://img.shields.io/badge/OpenWrt-router--os-blue)
![WireGuard](https://img.shields.io/badge/WireGuard-VPN-orange)
![Raspberry Pi](https://img.shields.io/badge/Raspberry%20Pi-hardware-red)
![Network Security](https://img.shields.io/badge/Security-Network%20Architecture-green)

A portable network security lab implementing **VPN-first routing, DNS enforcement, and firewall segmentation** using **OpenWrt on a Raspberry Pi**.

📄 **Full Project Documentation**  
[Travel Router Security Architecture Lab](docs/travel-router-security-architecture-lab.pdf)

---

## Security Concepts Demonstrated

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

## Table of Contents

- [Project Overview](#project-overview)
- [Security Controls Implemented](#security-controls-implemented)
- [System Architecture](#system-architecture)
- [Core Components](#core-components)
- [Testing Methodology](#testing-methodology)
- [Limitations](#limitations)
- [Future Improvements](#future-improvements)
- [Skills Demonstrated](#skills-demonstrated)
- [Author](#author)

## Repository Structure

```text
raspberry-pi-travel-router-security-lab
│
├── README.md
├── LICENSE
│
├── docs/
│   └── travel-router-security-architecture-lab.pdf
│
├── diagrams/
│   └── (architecture diagrams)
│
└── configs/
    └── (router configuration snapshots)
```
---

## Project Overview

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

## Security Controls Implemented

| Security Control | Implementation |
|---|---|
| **VPN-first routing** | Firewall rules enforce LAN → VPN and block LAN → WAN |
| **DNS leak prevention** | DNS redirect rules force TCP/UDP 53 through dnsmasq |
| **IPv6 leak reduction** | DHCPv6, RA, and SLAAC disabled |
| **Firewall segmentation** | Zone-based firewall separating LAN / WAN / VPN |
| **Restricted administration** | SSH and LuCI limited to the LAN network |

Together these controls ensure that **all client traffic follows the intended encrypted routing path**.

---

## System Architecture

The router acts as an intermediary gateway between client devices and upstream networks.

**Client traffic flow:**

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

The architecture enforces centralized control over:

- routing behavior
- DNS resolution
- firewall policy
- administrative access

---

## Core Components

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

## Testing Methodology

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

---

## Limitations

This implementation focuses primarily on **routing and DNS control**, not full network monitoring.

Known limitations include:

- single-device gateway architecture
- limited traffic visibility
- dependency on VPN availability
- no deep packet inspection or IDS
- hardware performance limits of Raspberry Pi

---

## Future Improvements

Planned future enhancements include:

- Suricata IDS integration
- Zeek network telemetry
- centralized logging
- VPN health monitoring
- VLAN segmentation for device classes

These additions would further expand the system into a **portable network security experimentation platform**.

---

## Skills Demonstrated

This project demonstrates practical experience in:

- Linux networking
- VPN configuration (WireGuard)
- firewall policy design
- DNS enforcement
- network segmentation
- troubleshooting complex routing behavior
- translating security goals into infrastructure controls

---

## Author

Jennifer Byrnes  
Cybersecurity Portfolio Project  
March 2026



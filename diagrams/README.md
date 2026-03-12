# Architecture Diagrams

This folder contains architecture and security diagrams for the Raspberry Pi Travel Router security lab.

Each diagram represents a different architectural perspective used in security design and threat modeling.

| Diagram | Purpose |
|------|------|
| [`system_architecture.png`](./system_architecture.png) | High-level view of the system components and their relationships. |
| [`network_architecture.png`](./network_architecture.png) | Network interfaces, routing paths, and connectivity between LAN, VPN, and upstream networks. |
| [`data_flow.png`](./data_flow.png) | Logical flow of client traffic through the router and VPN tunnel. |
| [`trust_boundary.png`](./trust_boundary.png) | Security zones and trust boundaries between client devices, the router, upstream networks, and the internet. |
| [`security_controls.png`](./security_controls.png) | Security mechanisms implemented by the router including firewall policy, DNS control, and VPN enforcement. |
| [`threat_model.png`](./threat_model.png) | Potential attack paths and defensive controls protecting the router and client devices. |

These diagrams are referenced throughout the project documentation and provide visual context for the router configuration artifacts located in [`/configs`](../configs).

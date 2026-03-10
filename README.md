# Enterprise Network & Security Lab: Hybrid Infrastructure & Secure Access

## 🚀 Project Overview
This project demonstrates the design, implementation, and auditing of a segmented enterprise network infrastructure. Using **pfSense** as the core security gateway, the lab integrates a **Windows Server 2022** Active Directory environment with **Linux-based microservices** (Docker/Nginx) in a hardened DMZ. 

The primary goal was to achieve a **Zero-Trust** management model where sensitive administrative interfaces are only accessible via a cryptographically secure **OpenVPN** tunnel, effectively mitigating common hypervisor-level security leaks.

```mermaid
graph TD
    subgraph External_Network [Internet / WAN]
        UD[Ubuntu Desktop Admin <br/> 10.0.2.10]
    end

    UD -- "OpenVPN Tunnel (tun0)" --> PF

    subgraph Infrastructure [ ]
        PF{pfSense Firewall <br/> Core Gateway}
        
        subgraph LAN_Zone [LAN - 10.10.10.0/24]
            WS[Windows Server 2022 <br/> AD DS / DNS]
        end

        subgraph DMZ_Zone [DMZ - 10.10.50.0/24]
            US[Ubuntu Server <br/> Docker / Nginx]
        end

        subgraph MGMT_Zone [MGMT - 192.168.56.0/24]
            GUI[WebGUI Administration]
        end

        PF --- LAN_Zone
        PF --- DMZ_Zone
        PF --- MGMT_Zone
    end

    style PF fill:#f20,stroke:#333,stroke-width:2px
    style UD fill:#3498db,color:#fff
    style MGMT_Zone fill:color:#fff
```

## 🏗️ Network Architecture
The infrastructure is divided into four distinct security zones:
* **WAN (External):** Simulated public network with strict "Deny All" ingress policies.
* **LAN (Internal):** Corporate segment hosting the Identity Provider (Active Directory `shield.corp`).
* **DMZ (Public Services):** Isolated segment for web services (Docker/Nginx).
* **MGMT (Administrative):** A private management network used exclusively for firewall and server auditing.

## 🗺️ Project Roadmap
Click on each phase to view the detailed technical documentation and evidence:

1. [**Phase 01: pfSense Installation & Base Configuration**](./docs/phase-01-pfsense-setup.md)
2. [**Phase 02: Windows Server 2022 & Active Directory Deployment**](./docs/phase-02-windows-server-ad.md)
3. [**Phase 03: Ubuntu Server & DMZ Environment Setup**](./docs/phase-03-ubuntu-server-dmz.md)
4. [**Phase 04: Active Directory Hardening & GPO Implementation**](./docs/phase-04-active-directory-hardening.md)
5. [**Phase 05: Docker Microservices & Containerization**](./docs/phase-05-docker-services.md)
6. [**Phase 06: Firewall Rules, Aliases & Security Policies**](./docs/phase-06-firewall-rules-aliases.md)
7. [**Phase 07: Static Routing & Inter-VLAN Management**](./docs/phase-07-static-routing.md)
8. [**Phase 08: NAT, Port Forwarding & Service Publication**](./docs/phase-08-nat-and-port-forwarding.md)
9. [**Phase 09: Remote Access VPN & PKI Infrastructure**](./docs/phase-09-openvpn-pki-config.md)
10. [**Phase 10: Final Audit, Troubleshooting & Automation**](./docs/phase-10-final-audit-automation.md)

## 🛠️ Tech Stack & Skills
* **Firewall/Routing:** pfSense (VLANs, NAT, OpenVPN, Stateful Inspection).
* **Identity Management:** Windows Server 2022 (AD DS, DNS, DHCP).
* **Containerization:** Docker Engine & Docker Compose (Nginx Alpine).
* **Operating Systems:** Ubuntu Server 24.04 (Hardened), Windows Server 2022 (Desktop Experience).
* **Security Auditing:** Traceroute analysis, Firewall log correlation, and GPO forensics.

## 🧠 Key Technical Challenges & Solutions
### 1. The Hypervisor Routing Leak
* **Challenge:** Identified a security flaw where the VirtualBox NAT engine implicitly routed management traffic, bypassing pfSense's WAN rules.
* **Solution:** Developed a custom Bash script (`vpn-start.sh`) that programmatically isolates the host by removing default gateways and enforcing traffic encapsulation through the `tun0` interface.

### 2. Linux Routing & Permission Conflict
* **Challenge:** Persistent `route add failed` errors when initializing the VPN client on Ubuntu Desktop.
* **Solution:** Implemented the `--route-noexec` flag combined with manual route injection to maintain strict control over the system's routing table.

## 📂 Repository Structure
* `assets/`: Network diagrams and evidence screenshots.
* `docs/`: Detailed step-by-step documentation for all 10 Phases.
* `scripts/`: Automation scripts for secure VPN management (`vpn-start.sh`, `vpn-stop.sh`, `ipconfig.sh`).

---
*Developed for professional showcase by Carles Comas Pérez*
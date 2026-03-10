# Phase 01: pfSense Installation & Base Configuration

## 🎯 Objective
The primary goal of this phase was to deploy and configure the core security gateway: the **pfSense CE** firewall. This virtual appliance manages traffic between four distinct security zones, acting as the perimeter defense and the "brain" of the entire network infrastructure.

## ⚙️ Virtual Hardware Specifications
The firewall was deployed as a Virtual Machine (VM) in VirtualBox with the following specifications to ensure stability and efficiency:
* **Operating System:** FreeBSD (64-bit)
* **RAM:** 1024 MB
* **CPU:** 1 Core
* **Storage:** 16 GB VDI

## 🌐 Network Architecture (Interface Mapping)
A real-world enterprise environment was simulated by configuring four separate network adapters, each serving a specific security purpose:

1. **WAN (Simulated Internet):** Configured using a **VirtualBox NAT Network** to simulate an external ISP environment.
2. **LAN (Secure Internal):** Set to **Internal Network** for the corporate user segment.
3. **DMZ (Public Zone):** Set to **Internal Network** for isolated public-facing servers.
4. **MGMT (Management):** Set to **Host-Only Adapter** to provide a dedicated, out-of-band path for administrative access.

![VirtualBox Network Configuration](../assets/screenshots/vbox-network-config-1.png)
![VirtualBox Network Configuration](../assets/screenshots/vbox-network-config-2.png)
![VirtualBox Network Configuration](../assets/screenshots/vbox-network-config-3.png)
![VirtualBox Network Configuration](../assets/screenshots/vbox-network-config-4.png)


## 🛠️ Implementation & Post-Install Configuration

### 1. OS Installation
The installation was performed using the official pfSense CE ISO. To ensure a clean deployment, the boot order was verified, and the installation media was unmounted immediately after the initial setup to avoid boot loops.

### 2. Interface and IP Assignment
Once the OS was live, I used the console menu to assign the physical adapters to their logical roles and set static IP addresses:
* **WAN (em0):** Assigned via DHCP **10.0.2.15/24**.
* **LAN (em1):** Static IP **10.10.10.1/24**.
* **DMZ (em2):** Static IP **10.10.50.1/24**.
* **MGMT (em3):** Static IP **192.168.56.10/24**.

![pfSense Console Interface Assignment](../assets/screenshots/pfsense-console-interfaces.png)


## ⚠️ Challenges & Troubleshooting

### The Admin Lockout Issue
**Problem:** By default, pfSense security policies block WebGUI access from any interface other than the LAN. Since my design uses a dedicated MGMT segment, I was initially locked out.
**Solution:** I accessed the pfSense shell and temporarily disabled the firewall filter using the command `pfctl -d`. This allowed me to log in once, create a permanent **Pass Rule** for HTTPS traffic on the MGMT interface, and then re-enable the filter.

![Firewall Rule for Management Access](../assets/screenshots/pfsense-mgmt-rule.png)

### NIC Mapping Correlation
**Problem:** VirtualBox adapter numbering does not always match the OS interface names (`em0`, `em1`, etc.).
**Solution:** I cross-referenced the MAC addresses provided by VirtualBox settings with the "Assign Interfaces" utility in the pfSense console to ensure each network segment was physically mapped to the correct virtual cable.

![pfSense Final Dashboard Status](../assets/screenshots/pfsense-dashboard-status.png)

## ✅ Validation

  * **Management Access:** Confirmed the WebGUI is fully operational at `https://192.168.56.10` from the host machine.
* **Interface Status:** Verified via the console that all 4 interfaces are "Up" with their respective IP addresses.



---
[⬅️ Back to README](../README.md)
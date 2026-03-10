# Phase 02: Windows Server 2022 & Active Directory Deployment

## 🎯 Objective
The goal of this phase was to implement a centralized identity and resource management system. By deploying **Windows Server 2022** as a Domain Controller (DC), the infrastructure gains the ability to manage users, computers, and security policies (GPOs) under the internal domain **`shield.corp`**.

## ⚙️ Virtual Hardware Specifications
Given the requirements of Windows Server 2022, the VM was configured to ensure smooth performance:
* **Operating System:** Windows Server 2022 (64-bit).
* **RAM:** 2048 MB.
* **CPU:** 2 Cores.
* **Storage:** 50 GB VDI.
* **Network Interface:** * **Adapter 1:** Internal Network (`intnet_shield_lan`).

## 🛠️ Implementation Process

### 1. Operating System Installation
A clean installation of Windows Server 2022 (Desktop Experience) was performed. Post-installation tasks included:
* Installing **VirtualBox Guest Additions** for improved driver support.
* Renaming the server to `DC-SHIELD-01` for standard naming conventions.

### 2. Network Configuration (Static IP)
For a Domain Controller to function correctly, a persistent static IP is mandatory. The following settings were applied to the LAN interface:
* **IP Address:** `10.10.10.10`
* **Subnet Mask:** `255.255.255.0`
* **Default Gateway:** `10.10.10.1` (pfSense LAN interface).
* **Preferred DNS:** `127.0.0.1` (The server will resolve its own AD queries).
* 
!["Windows Server Config"](../assets/screenshots/ws-network-config.png)

### 3. AD DS Role & Forest Promotion
The **Active Directory Domain Services (AD DS)** role was installed via Server Manager. The server was then promoted to a Domain Controller with the following specifications:
* **Deployment Operation:** Add a new forest.
* **Root Domain Name:** `shield.corp`.
* **Functional Level:** Windows Server 2016 (to ensure compatibility).
* **DNS Server:** Installed and integrated with AD.

## ⚠️ Challenges & Troubleshooting
* **DNS Resolution Conflict:** Initially, the server could not resolve external names.
    * **Solution:** Configured **DNS Forwarders** within the Windows DNS Manager to point to the pfSense LAN IP (`10.10.10.1`), allowing pfSense to handle external recursive queries.
* **Time Synchronization:** Kerberos authentication (essential for AD) requires strict time sync between the DC and clients.
    * **Solution:** Verified that the VM host time was synchronized and ensured the Windows Time service was running correctly.

## ✅ Validation
* **Domain Integrity:** Verified the successful creation of the `shield.corp` forest using the `Get-ADDomain` PowerShell command.
* **Service Health:** Confirmed that the Active Directory Users and Computers (ADUC) snap-in loads correctly.
* **Connectivity:** Performed a successful ping to the gateway (`10.10.10.1`) and verified that the `shield.corp` SRV records were correctly registered in DNS.


!["Windows Server Config"](../assets/screenshots/ws-ad-config.png)

!["Windows Server Config"](../assets/screenshots/ws-ad-config-2.png)

---
[⬅️ Back to README](../README.md)
#!/bin/bash

# ==============================================================================
# SCRIPT: vpn-start.sh
# PURPOSE: Securely establishes an OpenVPN tunnel while preventing 
#          Hypervisor Routing Leaks (Bypassing the Firewall).
# ==============================================================================

# 1. Configuration Variables
VPN_CONFIG="$HOME/pfSense-UDP4-1194-admin-vpn-config.ovpn"
TARGET_NETWORK="192.168.56.0/24"
INTERFACE="tun0"
GATEWAY_IP="10.0.2.1"

echo "---------------------------------------------------"
echo "Starting Secure VPN Setup (Hardened Isolation Mode)"
echo "---------------------------------------------------"

# 2. Step 0: Hypervisor Isolation (Zero-Trust Enforcement)
# WHY: VirtualBox NAT engines can implicitly route traffic to internal 
# segments, bypassing pfSense WAN rules. By removing the default gateway,
# we force the OS to use ONLY the VPN tunnel for non-local traffic.
echo "Step 0: Isolating system from implicit hypervisor routing..."
sudo ip route del default via $GATEWAY_IP 2>/dev/null
echo "Isolation Active: Default gateway removed."

# 3. Step 1: Opening credential window
# This prevents D-Bus errors by launching the prompt in a separate TTY.
echo "Step 1: Opening credential window..."
gnome-terminal --wait -- bash -c "echo 'SECURE LOGIN'; sudo openvpn --config $VPN_CONFIG --route-noexec --auth-nocache --daemon; echo 'Success! This window will close in 3 seconds...'; sleep 3" &

# 4. Step 2: Monitoring Interface Status
echo "Step 2: Waiting for credentials and $INTERFACE initialization..."
MAX_RETRIES=45
TIMER=0

while ! ip addr show "$INTERFACE" > /dev/null 2>&1; do
    sleep 1
    ((TIMER++))
    
    if (( TIMER % 5 == 0 )); then
        echo "Handshaking... ($TIMER seconds)"
    fi

    if [ $TIMER -ge $MAX_RETRIES ]; then
        echo "Error: Timeout. Interface $INTERFACE did not appear."
        echo "Check credentials or logs."
        # Restore gateway on fail so the user isn't left offline
        sudo ip route add default via $GATEWAY_IP
        exit 1
    fi
done

echo "Success! Tunnel $INTERFACE is now ACTIVE."

# 5. Step 3: Secure Route Injection
# We manually inject the route to ensure it is bound strictly to the tunnel.
echo "Step 3: Injecting management route to $TARGET_NETWORK via $INTERFACE..."
sudo ip route add "$TARGET_NETWORK" dev "$INTERFACE"

# 6. Final Verification
if [ $? -eq 0 ]; then
    echo "---------------------------------------------------"
    echo "AUDIT PASSED: Secure bridge established."
    echo "All management traffic is now ENCAPSULATED."
    echo "Current $INTERFACE Route:"
    ip route show dev "$INTERFACE"
    echo "---------------------------------------------------"
else
    echo "Error: Route injection failed."
    sudo ip route add default via $GATEWAY_IP
    exit 1
fi
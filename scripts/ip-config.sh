#!/bin/bash

# 1. Configuration Variables
# Update these if the network environment changes
INTERFACE="enp0s3"
IP_ADDR="10.0.2.10/24"
GATEWAY="10.0.2.1"

echo "---------------------------------------------------"
echo "Initializing Network Configuration for $INTERFACE"
echo "---------------------------------------------------"

# 2. Check for Root Privileges
# Network configuration commands require administrative power
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run with sudo." 
   exit 1
fi

# 3. Assign IP Address and Subnet Mask
echo "Step 1: Assigning IP address $IP_ADDR to $INTERFACE..."
sudo ip addr add "$IP_ADDR" dev "$INTERFACE"

# 4. Bring the Interface Up
# Ensuring the physical/virtual link is active
echo "Step 2: Enabling interface $INTERFACE..."
sudo ip link set "$INTERFACE" up

# 5. Set the Default Gateway
# Directing all external traffic through the gateway
echo "Step 3: Setting default gateway to $GATEWAY..."
sudo ip route add default via "$GATEWAY"

# 6. Verification
if [ $? -eq 0 ]; then
    echo "---------------------------------------------------"
    echo "SUCCESS: Network configuration applied successfully."
    echo "Current IP status:"
    ip addr show "$INTERFACE"
    echo "---------------------------------------------------"
else
    echo "Error: Network configuration failed. Check your interface name."
    exit 1
fi
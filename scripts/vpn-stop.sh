#!/bin/bash

# Configuration
TARGET_NETWORK="192.168.56.0/24"

echo "Stopping Management VPN..."

# 1. Remove the static route
sudo ip route del $TARGET_NETWORK > /dev/null 2>&1

# 2. Kill the background OpenVPN process
sudo killall openvpn

echo "MGMNT Network Disconnected and Routes Cleaned."
#!/bin/bash

LOGFILE="/var/log/update-indonesia.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

{
echo "=== Update Indonesia IPs: $DATE ==="

echo "[INFO] Downloading IPv4 and IPv6 CIDR..."
wget -q https://raw.githubusercontent.com/herrbischoff/country-ip-blocks/master/ipv4/id.cidr -O /root/id4.cidr
wget -q https://raw.githubusercontent.com/herrbischoff/country-ip-blocks/master/ipv6/id.cidr -O /root/id6.cidr
echo "[INFO] Download completed."

# =====================
# Create ipsets if not exist
# =====================
ipset list id4 &>/dev/null || ipset create id4 hash:net
ipset list id6 &>/dev/null || ipset create id6 hash:net family inet6

echo "[INFO] Flushing old ipsets..."
ipset flush id4
ipset flush id6
echo "[INFO] Flush completed."

echo "[INFO] Adding IPv4 CIDR to ipset..."
while read -r ip; do
    ipset add id4 "$ip"
done < /root/id4.cidr
echo "[INFO] IPv4 update done."

echo "[INFO] Adding IPv6 CIDR to ipset..."
while read -r ip; do
    ipset add id6 "$ip"
done < /root/id6.cidr
echo "[INFO] IPv6 update done."

echo "[INFO] Reloading UFW..."
ufw reload > /dev/null 2>&1
echo "[INFO] UFW reload done."

echo "=== Update finished: $DATE ==="
echo ""
} 2>&1 | tee -a "$LOGFILE"

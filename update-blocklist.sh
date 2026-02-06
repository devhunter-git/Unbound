#!/bin/bash
set -euo pipefail

BASE_DIR="/etc/unbound/unbound.conf.d"
CACHE_FILE="/tmp/unbound_cache.txt"
ERROR=0

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# ===============================
# PREREQUISITE CHECK
# ===============================
for cmd in wget curl unbound-control unbound-checkconf systemctl; do
    command -v "$cmd" >/dev/null 2>&1 || {
        log "[!] Command tidak ditemukan: $cmd"
        exit 1
    }
done

# ===============================
# BACKUP CACHE
# ===============================
trap 'rm -f "$CACHE_FILE"' EXIT
log "[?] Backup DNS cache..."
unbound-control dump_cache > "$CACHE_FILE" 2>/dev/null || true

# ===============================
# FOLDER KATEGORI
# ===============================
mkdir -p "$BASE_DIR/malware"
mkdir -p "$BASE_DIR/zzz-whitelist"
rm -f "$BASE_DIR/malware"/*.conf
rm -f "$BASE_DIR/zzz-whitelist"/*.conf

# ===============================
# BLOCKLISTS DEVHUNTER
# ===============================
declare -A LISTS

# Lokal / DevHunter
LISTS["malware/01-DevHunter-BlockListDev-Lokal.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/devhunter-BlockListDev.conf"

# OISD
LISTS["malware/01-DevHunter-oisd-big.conf"]="https://big.oisd.nl/unbound"
LISTS["malware/01-DevHunter-oisd-nsfw.conf"]="https://nsfw.oisd.nl/unbound"

# Anti-ADs
LISTS["malware/01-DevHunter-anti-ad.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/anti-ad.conf"

# Hagezi
LISTS["malware/01-DevHunter-hagezi-tif.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-tif.conf"
LISTS["malware/01-DevHunter-hagezi-dga7.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-dga7.conf"
LISTS["malware/01-DevHunter-hagezi-pro.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-pro.conf"
LISTS["malware/01-DevHunter-hagezi-gambling.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-gambling.conf"
LISTS["malware/01-DevHunter-hagezi-spam-tlds.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-spam-tlds.conf"
LISTS["malware/01-DevHunter-hagezi-nosafesearch.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-nosafesearch.conf"

# romainmarcoux
LISTS["malware/01-DevHunter-romainmarcoux-full-aa-ab-ac.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/romainmarcoux-full-aa-ab-ac.conf"

# 1hosts
LISTS["malware/01-DevHunter-1hosts-lite.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/1hosts-lite.conf"

# shadowwhisperer
LISTS["malware/01-DevHunter-shadowwhisperer-scam.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-scam.conf"
LISTS["malware/01-DevHunter-shadowwhisperer-malware.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-malware.conf"
LISTS["malware/01-DevHunter-shadowwhisperer-typo.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-typo.conf"
LISTS["malware/01-DevHunter-shadowwhisperer-gambling.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-gambling.conf"

# Malware World
LISTS["malware/01-DevHunter-malwareworld-dga.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/malwareworld-dga.conf"
LISTS["malware/01-DevHunter-malwareworld-malware.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/malwareworld-malware.conf"
LISTS["malware/01-DevHunter-malwareworld-spammer.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/malwareworld-spammer.conf"
LISTS["malware/01-DevHunter-malwareworld-phishing.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/malwareworld-phishing.conf"

# CertPL
LISTS["malware/01-DevHunter-certpl.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/certpl.conf"

# CyberHost
LISTS["malware/01-DevHunter-cyberhost.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/cyberhost.conf"

# ThreatFox
LISTS["malware/01-DevHunter-threatfox.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/threatfox.conf"

# phishdestroy
LISTS["malware/01-DevHunter-phishdestroy.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/phishdestroy.conf"

# pi-hole
LISTS["malware/01-DevHunter-pi-hole-c2.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/pi-hole-c2.conf"
LISTS["malware/01-DevHunter-pi-hole-banking-trojan.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/pi-hole-banking-trojan.conf"
LISTS["malware/01-DevHunter-pi-hole-malware.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/pi-hole-malware.conf"
LISTS["malware/01-DevHunter-pi-hole-phishing.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/pi-hole-phishing.conf"

# NRD
LISTS["malware/01-DevHunter-NRD-7D-Host.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/nrd-7d.conf"

# Accomplist
LISTS["malware/01-DevHunter-Accomplist-Gambling.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/Accomplist%20Gambling%20Unbound.conf"

# stalkerware
LISTS["malware/01-DevHunter-stalkerware-quad9.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/stalkerware-quad9.conf"
LISTS["malware/01-DevHunter-stalkerware.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/stalkerware.conf"

# trustpositif-gambling-id
#LISTS["malware/01-DevHunter-trustpositif-gambling-id.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/trustpositif-gambling-id.conf"

# trustpositif-gambling-au
LISTS["malware/01-DevHunter-trustpositif-gambling-au.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/trustpositif-gambling-au.conf"

# URLHaus / Sefinek
LISTS["malware/01-DevHunter-urlhaus-abuse.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/abuse/urlhaus.abuse.ch/hostfile.fork.conf"
LISTS["malware/01-DevHunter-urlhaus-malware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/malware-filter/urlhaus-filter-hosts-online.fork.conf"

# Useless Website / Sefinek
LISTS["malware/01-DevHunter-jarelllama-parked-domains.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/useless-websites/jarelllama/parked-domains.fork.conf"
LISTS["malware/01-DevHunter-Sefinek-useless-websites.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/useless-websites/sefinek.hosts.conf"

# Ransomware / Sefinek / blocklistproject
LISTS["malware/01-DevHunter-ransomware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ransomware/blocklistproject/ransomware.fork.conf"
LISTS["malware/01-DevHunter-malware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/blocklistproject/malware.fork.conf"

# redirect / Sefinek / blocklistproject
LISTS["malware/01-DevHunter-redirect.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/redirect/blocklistproject/redirect.fork.conf"

# Ph00lt0
LISTS["malware/01-DevHunter-ph00lt0.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/ph00lt0-blocklist.conf"

# Stevenblack / Sefinek / gambling
LISTS["malware/01-DevHunter-StevenBlack.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/StevenBlack/hosts.fork.conf"

# MajkiIT / Sefinek / gambling
LISTS["malware/01-DevHunter-MajkiIT.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/MajkiIT/gambling-hosts.fork.conf"

# blocklistproject / Sefinek / gambling
LISTS["malware/01-DevHunter-blocklistproject-gambling.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/blocklistproject/hosts.fork.conf"

# Spam404 / Sefinek
LISTS["malware/01-DevHunter-Spam404-malware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/Spam404/main-blacklist.fork.conf"

# RPiList / Sefinek
LISTS["malware/01-DevHunter-RPiList-malware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/RPiList/Malware.fork.conf"
LISTS["malware/01-DevHunter-RPiList-Phishing.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/RPiList/Phishing-Angriffe.fork.conf"
LISTS["malware/01-DevHunter-Army-Phishing.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/phishing.army/blocklist-extended.fork.conf"
LISTS["malware/01-DevHunter-RPiList-spam-mails.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/spam/RPiList/spam-mails.fork.conf"

# ===============================
# WHITELIST
# ===============================
LISTS["zzz-whitelist/zzzz-devhunter-whitelist.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/devhunter-whitelist.conf"
LISTS["zzz-whitelist/zzzz-hagezi-referral-whitelist.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/hagezi-referral-whitelist.conf"
LISTS["zzz-whitelist/zzzz-shadowwhisperer-whitelist.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/shadowwhisperer-whitelist.conf"

# ===============================
# DOWNLOAD & VALIDASI
# ===============================
for path in "${!LISTS[@]}"; do
    url="${LISTS[$path]}"
    tmp="/tmp/$(basename "$path")"
    dest="$BASE_DIR/$path"

    log "[+] Download $path"
    wget -qO "$tmp" "$url" || curl -fsSL "$url" -o "$tmp" || {
        log "[!] Gagal download: $path"
        ERROR=1
        continue
    }

    [ -s "$tmp" ] || { log "[!] File kosong: $path"; ERROR=1; continue; }

    mv "$tmp" "$dest"

    # cek sintaks
    if ! unbound-checkconf "$dest" >/dev/null 2>&1; then
        log "[!] Syntax error: $dest"
        ERROR=1
    fi
done

# ===============================
# RELOAD UNBOUND HANYA JIKA TIDAK ADA ERROR
# ===============================
if [ "$ERROR" -eq 0 ]; then
    log "[?] Reload Unbound..."
    if systemctl reload unbound; then
        log "[?] Reload berhasil"
        unbound-control load_cache < "$CACHE_FILE" 2>/dev/null || true
    else
        log "[!] Reload gagal, restart Unbound..."
        systemctl restart unbound
        log "[?] Restart berhasil"
        unbound-control load_cache < "$CACHE_FILE" 2>/dev/null || true
    fi
else
    log "[!] Ditemukan error pada config, UNBOUND TIDAK DIRELOAD/RESTART!"
fi

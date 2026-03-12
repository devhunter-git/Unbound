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
mkdir -p "$BASE_DIR/00-safesearch"
mkdir -p "$BASE_DIR/zzz-whitelist"
mkdir -p "$BASE_DIR/zzz-block-lokal"
rm -f "$BASE_DIR/malware"/*.conf
rm -f "$BASE_DIR/00-safesearch"/*.conf
rm -f "$BASE_DIR/zzz-whitelist"/*.conf
rm -f "$BASE_DIR/zzz-block-lokal"/*.conf

# ===============================
# BLOCKLISTS DEVHUNTER
# ===============================
declare -A LISTS

# Lokal / DevHunter
LISTS["zzz-block-lokal/zzzz-DevHunter-BlockListDev-Lokal.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/devhunter-BlockListDev.conf"

# SAFESEARCH
LISTS["00-safesearch/00-DevHunter-SAFESEARCH.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/safesearch.conf"

# OISD
LISTS["malware/01-DevHunter-OISD-Big.conf"]="https://big.oisd.nl/unbound"
LISTS["malware/01-DevHunter-OISD-nsfw.conf"]="https://nsfw.oisd.nl/unbound"

# 1Hosts
LISTS["malware/01-DevHunter-1Hosts-Lite.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/1hosts-lite.conf"

# CertPL
LISTS["malware/01-DevHunter-CertPL.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/certpl.conf"

# Cyberhost
LISTS["malware/01-DevHunter-Cyberhost.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/cyberhost.conf"

# ThreatFox
LISTS["malware/01-DevHunter-ThreatFox.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/threatfox.conf"

# Hagezi
LISTS["malware/01-DevHunter-hagezi-dga7.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-dga7.conf"
LISTS["malware/01-DevHunter-hagezi-pro.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-pro.conf"
LISTS["malware/01-DevHunter-hagezi-tif.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-tif.conf"
LISTS["malware/01-DevHunter-hagezi-spam-tlds.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-spam-tlds.conf"
LISTS["malware/01-DevHunter-hagezi-gambling.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-gambling.conf"
LISTS["malware/01-DevHunter-hagezi-nosafesearch.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-nosafesearch.conf"

# shadowwhisperer
LISTS["malware/01-DevHunter-shadowwhisperer-malware.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-malware.conf"
LISTS["malware/01-DevHunter-shadowwhisperer-scam.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-scam.conf"
LISTS["malware/01-DevHunter-shadowwhisperer-typo.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-typo.conf"
LISTS["malware/01-DevHunter-shadowwhisperer-gambling.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-gambling.conf"

# romainmarcoux
LISTS["malware/01-DevHunter-romainmarcoux.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/romainmarcoux-full-aa-ab-ac.conf"

# anti-ad
LISTS["malware/01-DevHunter-anti-ad.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/anti-ad.conf"

# Tempest-Solutions-Company
LISTS["malware/01-DevHunter-pi-hole-all-malicious.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/pi-hole-all-malicious.conf"

# phishdestroy
LISTS["malware/01-DevHunter-phishdestroy.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/phishdestroy.conf"

# MalwareWorld
LISTS["malware/01-DevHunter-malwareworld-phishing.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/malwareworld-phishing.conf"
LISTS["malware/01-DevHunter-malwareworld-malware.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/malwareworld-malware.conf"
LISTS["malware/01-DevHunter-malwareworld-DGA.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/malwareworld-dga.conf"

# stalkerware
LISTS["malware/01-DevHunter-stalkerware.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/stalkerware.conf"
LISTS["malware/01-DevHunter-stalkerware-quad9.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/stalkerware-quad9.conf"

# NRD
LISTS["malware/01-DevHunter-nrd-1d.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/nrd-1d.conf"
LISTS["malware/01-DevHunter-nrd-3d.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/nrd-3d.conf"

# RPiList
LISTS["malware/01-DevHunter-RPiList-Malware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/RPiList/Malware.fork.conf"
LISTS["malware/01-DevHunter-RPiList-Phishing.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/RPiList/Phishing-Angriffe.fork.conf"

# useless-websites
LISTS["malware/01-DevHunter-useless-websites-parked-domains.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/useless-websites/jarelllama/parked-domains.fork.conf"
LISTS["malware/01-DevHunter-useless-websites-sefinek.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/useless-websites/sefinek.hosts.conf"

# blocklistproject
LISTS["malware/01-DevHunter-blocklistproject-redirect.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/redirect/blocklistproject/redirect.fork.conf"
LISTS["malware/01-DevHunter-blocklistproject-ransomware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ransomware/blocklistproject/ransomware.fork.conf"
LISTS["malware/01-DevHunter-blocklistproject-malware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/blocklistproject/malware.fork.conf"

# Accomplist
LISTS["malware/01-DevHunter-Accomplist-gambling.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/Accomplist%20Gambling%20Unbound.conf"
LISTS["malware/01-DevHunter-Accomplist-Malicious-Dom.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/Accomplist%20Malicious-Dom%20Top-N%20Unbound.conf"

# Trustpositif Alsyundawy
LISTS["malware/01-DevHunter-Alsyundawy-TrustPositif-gambling.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/Alsyundawy%20TrustPositif%20Gambling%20Indonesia.conf"

# Trustpositif AU
LISTS["malware/01-DevHunter-trustpositif-gambling-au.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/trustpositif-gambling-au.conf"

# StevenBlack
LISTS["malware/01-DevHunter-StevenBlack.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/other/StevenBlack/fakenews-gambling-porn.fork.conf"

# ===============================
# WHITELIST
# ===============================
LISTS["zzz-whitelist/zzzz-devhunter-whitelist.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/devhunter-whitelist.conf"
LISTS["zzz-whitelist/zzzz-devhunter-shadowwhisperer-whitelist.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/shadowwhisperer-whitelist.conf"
LISTS["zzz-whitelist/zzzz-devhunter-hagezi-whitelist.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/hagezi-referral-whitelist.conf"

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

CACHE_FILE="/var/lib/unbound/cache.dump"

if [ "$ERROR" -eq 0 ]; then
    log "[?] Dump cache sebelum reload..."
    unbound-control dump_cache > "$CACHE_FILE" 2>/dev/null || true

    log "[?] Reload Unbound (keep cache)..."

    if unbound-control reload_keep_cache 2>/dev/null; then
        log "[✓] Reload berhasil, cache tetap dipertahankan"

    else
        log "[!] reload_keep_cache tidak tersedia atau gagal, mencoba reload biasa..."

        if systemctl reload unbound; then
            log "[?] Reload berhasil, restore cache..."
            unbound-control load_cache < "$CACHE_FILE" 2>/dev/null || true

        else
            log "[!] Reload gagal, restart Unbound..."
            systemctl restart unbound
            log "[?] Restart berhasil, restore cache..."
            unbound-control load_cache < "$CACHE_FILE" 2>/dev/null || true
        fi
    fi

else
    log "[!] Ditemukan error pada config, UNBOUND TIDAK DIRELOAD/RESTART!"
fi

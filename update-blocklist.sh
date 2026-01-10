#!/bin/bash
set -euo pipefail

BASE_DIR="/etc/unbound/unbound.conf.d/malware"
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
# KATEGORI
# ===============================
CATEGORIES=("devhunter")

for cat in "${CATEGORIES[@]}"; do
    mkdir -p "$BASE_DIR/$cat"
    rm -f "$BASE_DIR/$cat"/*.conf
done

# ===============================
# BLOCKLIST (ASLI)
# ===============================
declare -A LISTS

LISTS["devhunter/Sefinek-ads-sefinek-hosts.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/sefinek.hosts.conf"
LISTS["devhunter/OISD-big-oisd.conf"]="https://big.oisd.nl/unbound"
LISTS["devhunter/OISD-big-nsfw-oisd.conf"]="https://nsfw.oisd.nl/unbound"

LISTS["devhunter/DevHunter-Sefinek-urlhaus.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/malware-filter/urlhaus-filter-hosts-online.fork.conf"
LISTS["devhunter/DevHunter-Sefinek-spam404.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/Spam404/main-blacklist.fork.conf"
LISTS["devhunter/DevHunter-Sefinek-stalkerware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/AssoEchap/stalkerware-indicators.fork.conf"
LISTS["devhunter/DevHunter-Sefinek-hostsVN.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/bigdargon/hostsVN.fork.conf"
LISTS["devhunter/DevHunter-Sefinek-dandelion.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/DandelionSprout-AntiMalwareHosts.fork.conf"
LISTS["devhunter/DevHunter-Sefinek-reported-norton.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/reported-by-norton.conf"
LISTS["devhunter/DevHunter-Sefinek-mw-sefinek1.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/sefinek.hosts1.conf"
LISTS["devhunter/DevHunter-Sefinek-mw-sefinek2.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/sefinek.hosts2.conf"
LISTS["devhunter/DevHunter-Sefinek-phishing.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/phishing.conf"

LISTS["devhunter/DevHunter-Sefinek-toxic-domains.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/spam/stopforumspam/toxic-domains-whole.fork.conf"
LISTS["devhunter/DevHunter-Sefinek-add-spam.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/spam/FadeMind/add-Spam.fork.conf"

LISTS["devhunter/DevHunter-Sefinek-discord-phishing.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/Dogino/Discord-Phishing-URLs-phishing.fork.conf"
LISTS["devhunter/DevHunter-Sefinek-phishing-army.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/phishing.army/blocklist-extended.fork.conf"

LISTS["devhunter/DevHunter-Sefinek-easyprivacy.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/tracking-and-telemetry/0Zinc/easyprivacy.fork.conf"
LISTS["devhunter/DevHunter-Sefinek-adguard-mobile-host.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/tracking-and-telemetry/MajkiIT/adguard-mobile-host.fork.conf"

LISTS["devhunter/DevHunter-hagezi-tif.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-tif.conf"
LISTS["devhunter/DevHunter-hagezi-spam-tlds.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-spam-tlds.conf"
LISTS["devhunter/DevHunter-hagezi-nosafesearch.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-nosafesearch.conf"
LISTS["devhunter/DevHunter-hagezi-popupads.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-popupads.conf"
LISTS["devhunter/DevHunter-hagezi-pro.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-pro.conf"
LISTS["devhunter/DevHunter-hagezi-nsfw.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-nsfw.conf"
LISTS["devhunter/DevHunter-hagezi-gambling.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-gambling.conf"
LISTS["devhunter/DevHunter-hagezi-dyndns.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-dyndns.conf"
LISTS["devhunter/DevHunter-hagezi-doh.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-doh.conf"

LISTS["devhunter/DevHunter-devhunter-BlockListDev.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/devhunter-BlockListDev.conf"

LISTS["devhunter/DevHunter-shadowwhisperer-scam.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-scam.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-malware.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-malware.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-ads.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-ads.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-gambling.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-gambling.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-adult.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-adult.conf"

LISTS["devhunter/DevHunter-romainmarcoux-full-aa-ab-ac.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/romainmarcoux-full-aa-ab-ac.conf"
LISTS["devhunter/DevHunter-1hosts-lite.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/1hosts-lite.conf"
LISTS["devhunter/DevHunter-anti-ad.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/anti-ad.conf"

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

    unbound-checkconf "$dest" >/dev/null 2>&1 || {
        log "[!] Syntax error: $dest"
        ERROR=1
    }
done

# ===============================
# RELOAD ? RESTART FALLBACK
# ===============================
log "[?] Reload Unbound..."
if systemctl reload unbound; then
    log "[?] Reload berhasil"
    unbound-control load_cache < "$CACHE_FILE" 2>/dev/null || true
else
    log "[!] Reload gagal (kemungkinan duplicate domain)"
    log "[?] Restart Unbound..."
    systemctl restart unbound
    log "[?] Restart berhasil"
    unbound-control load_cache < "$CACHE_FILE" 2>/dev/null || true
fi

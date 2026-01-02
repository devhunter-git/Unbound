#!/bin/bash

BASE_DIR="/etc/unbound/unbound.conf.d/malware"
# --- BACKUP CACHE ---
CACHE_FILE="/tmp/unbound_cache.txt"
# ------------------------------------

# ===============================
# FUNCTION LOG DENGAN TIMESTAMP
# ===============================
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# ===============================================================
# TAMBAHAN: SIMPAN CACHE SEBELUM PROSES Dimulai
# ===============================================================
log "[?] Menyimpan cache DNS agar internet tidak lambat..."
unbound-control dump_cache > "$CACHE_FILE" 2>/dev/null

# ===============================
# 1. KATEGORI
# ===============================
CATEGORIES=("devhunter" "zzzz-whitelist")

# Buat folder kategori & hapus file lama
for cat in "${CATEGORIES[@]}"; do
    mkdir -p "$BASE_DIR/$cat"
    rm -f "$BASE_DIR/$cat"/*.conf
done

# ===============================
# 2. LIST URL + RENAME FILE
# ===============================
declare -A LISTS

# Whitelist
LISTS["zzzz-whitelist/zzzz-hagezi-referral.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/hagezi-referral-whitelist.conf"
LISTS["zzzz-whitelist/zzzz-shadowwhisperer-whitelist.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/shadowwhisperer-whitelist.conf"
LISTS["zzzz-whitelist/zzzz-hagezi-native-tiktok-extended.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/hagezi-native-tiktok-extended.conf"
LISTS["zzzz-whitelist/zzzz-hagezi-native-tiktok.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/hagezi-native-tiktok.conf"
LISTS["zzzz-whitelist/zzzz-hagezi-native-amazon.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/hagezi-native-amazon.conf"

# Ads / Trackers
LISTS["devhunter/Sefinek-0Zinc-easylist.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/0Zinc/easylist.fork.conf"
LISTS["devhunter/Sefinek-adaway-hosts.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/adaway/hosts.fork.conf"
LISTS["devhunter/Sefinek-blocklistproject-hosts.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/blocklistproject/hosts.fork.conf"
LISTS["devhunter/Sefinek-firebog-Easylist.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/firebog/Easylist.fork.conf"
LISTS["devhunter/Sefinek-sefinek-hosts.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/sefinek.hosts.conf"

# Gambling
LISTS["devhunter/Sefinek-stevenblack.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/StevenBlack/hosts.fork.conf"
LISTS["devhunter/Sefinek-blocklistproject.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/blocklistproject/hosts.fork.conf"
LISTS["devhunter/Sefinek-majkiit.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/MajkiIT/gambling-hosts.fork.conf"
LISTS["devhunter/Sefinek-sefinek.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/sefinek.hosts.conf"
LISTS["devhunter/Sefinek-sefinek2.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/sefinek.hosts2.conf"

# NSFW / Porn
LISTS["devhunter/Sefinek-StevenBlack.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/StevenBlack/porn.fork.conf"
LISTS["devhunter/Sefinek-BlocklistProject.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/blocklistproject/porn.fork.conf"
LISTS["devhunter/Sefinek-OISD.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/oisd/nsfw.fork.conf"
LISTS["devhunter/Sefinek-Sefinek1.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/sefinek.hosts.conf"
LISTS["devhunter/Sefinek-Sefinek2.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/sefinek.hosts2.conf"
LISTS["devhunter/Sefinek-Sinfonietta.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/Sinfonietta/pornography-hosts.fork.conf"
LISTS["devhunter/Sefinek-4skinSkywalker.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/4skinSkywalker/hosts.fork.conf"

# Malicious
LISTS["devhunter/Sefinek-urlhaus.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/malware-filter/urlhaus-filter-hosts-online.fork.conf"
LISTS["devhunter/Sefinek-spam404.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/Spam404/main-blacklist.fork.conf"
LISTS["devhunter/Sefinek-rpilist-malware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/RPiList/Malware.fork.conf"
LISTS["devhunter/Sefinek-notrack-malware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/quidsup/notrack-malware.fork.conf"
LISTS["devhunter/Sefinek-malware-project.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/blocklistproject/malware.fork.conf"
LISTS["devhunter/Sefinek-stalkerware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/AssoEchap/stalkerware-indicators.fork.conf"
LISTS["devhunter/Sefinek-hostsVN.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/bigdargon/hostsVN.fork.conf"
LISTS["devhunter/Sefinek-dandelion.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/DandelionSprout-AntiMalwareHosts.fork.conf"
LISTS["devhunter/Sefinek-disconnect-malvertising.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/disconnectme/simple-malvertising.fork.conf"
LISTS["devhunter/Sefinek-reported-norton.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/reported-by-norton.conf"
LISTS["devhunter/Sefinek-sefinek1.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/sefinek.hosts1.conf"
LISTS["devhunter/Sefinek-sefinek2.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/sefinek.hosts2.conf"
LISTS["devhunter/Sefinek-suspicious.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/suspicious.conf"
LISTS["devhunter/Sefinek-web-attacks.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/web-attacks.conf"
LISTS["devhunter/Sefinek-phishing.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/phishing.conf"

# Crypto
LISTS["devhunter/Sefinek-crypto-prigent.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/crypto/cryptojacking/firebog/Prigent/Crypto.fork.conf"
LISTS["devhunter/Sefinek-nocoin.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/crypto/cryptojacking/hoshsadiq/adblock-nocoin-list.fork.conf"
LISTS["devhunter/Sefinek-crypto-streams.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/crypto/cryptojacking/Snota418/Crypto-streams.fork.conf"

# Ransomware
LISTS["devhunter/Sefinek-ransomware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ransomware/blocklistproject/ransomware.fork.conf"

# Redirect
LISTS["devhunter/Sefinek-redirect.fork.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/redirect/blocklistproject/redirect.fork.conf"

# Spam
LISTS["devhunter/Sefinek-rpilist-spam.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/spam/RPiList/spam-mails.fork.conf"
LISTS["devhunter/Sefinek-toxic-domains.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/spam/stopforumspam/toxic-domains-whole.fork.conf"
LISTS["devhunter/Sefinek-add-spam.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/spam/FadeMind/add-Spam.fork.conf"

# Phishing
LISTS["devhunter/Sefinek-phishing-project.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/blocklistproject/phishing.fork.conf"
LISTS["devhunter/Sefinek-discord-phishing.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/Dogino/Discord-Phishing-URLs-phishing.fork.conf"
LISTS["devhunter/Sefinek-phishing-army.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/phishing.army/blocklist-extended.fork.conf"
LISTS["devhunter/Sefinek-rpilist-phishing.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/RPiList/Phishing-Angriffe.fork.conf"

# LGBTQ+
LISTS["devhunter/Sefinek-lgbtqplus.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/sites/lgbtqplus.conf"
LISTS["devhunter/Sefinek-lgbtqplus2.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/sites/lgbtqplus2.conf"

# useless-websites
LISTS["devhunter/Sefinek-useless-websites-parked-domains.fork.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/useless-websites/jarelllama/parked-domains.fork.conf"
LISTS["devhunter/Sefinek-useless-websites-sefinek.hosts.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/useless-websites/sefinek.hosts.conf"

# OISD lists
LISTS["devhunter/OISD-big-oisd.conf"]="https://big.oisd.nl/unbound"
LISTS["devhunter/OISD-nsfw-oisd.conf"]="https://nsfw.oisd.nl/unbound"

# DevHunter lists
LISTS["devhunter/DevHunter-1hosts-lite.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/1hosts-lite.conf"
LISTS["devhunter/DevHunter-abpindo-adult.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/abpindo-adult.conf"
LISTS["devhunter/DevHunter-anti-ad.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/anti-ad.conf"
LISTS["devhunter/DevHunter-hagezi-doh-vpn-tor-proxy.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-doh-vpn-tor-proxy.conf"
LISTS["devhunter/DevHunter-hagezi-doh.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-doh.conf"
LISTS["devhunter/DevHunter-hagezi-gambling.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-gambling.conf"
LISTS["devhunter/DevHunter-hagezi-hoster.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-hoster.conf"
LISTS["devhunter/DevHunter-hagezi-light.conf"]="https://github.com/devhunter-git/Unbound/raw/refs/heads/main/BlockList_DB/hagezi-light.conf"
LISTS["devhunter/DevHunter-hagezi-native-apple.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-native-apple.conf"
LISTS["devhunter/DevHunter-hagezi-native-huawei.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-native-huawei.conf"
LISTS["devhunter/DevHunter-hagezi-native-lgwebos.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-native-lgwebos.conf"
LISTS["devhunter/DevHunter-hagezi-native-oppo-realme.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-native-oppo-realme.conf"
LISTS["devhunter/DevHunter-hagezi-native-roku.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-native-roku.conf"
LISTS["devhunter/DevHunter-hagezi-native-samsung.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-native-samsung.conf"
LISTS["devhunter/DevHunter-hagezi-native-vivo.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-native-vivo.conf"
LISTS["devhunter/DevHunter-hagezi-native-winoffice.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-native-winoffice.conf"
LISTS["devhunter/DevHunter-hagezi-native-xiaomi.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-native-xiaomi.conf"
LISTS["devhunter/DevHunter-hagezi-nosafesearch.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-nosafesearch.conf"
LISTS["devhunter/DevHunter-hagezi-nsfw.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-nsfw.conf"
LISTS["devhunter/DevHunter-hagezi-popupads.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-popupads.conf"
LISTS["devhunter/DevHunter-hagezi-pro.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-pro.conf"
LISTS["devhunter/DevHunter-hagezi-spam-tlds.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-spam-tlds.conf"
LISTS["devhunter/DevHunter-hagezi-tif.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/hagezi-tif.conf"
LISTS["devhunter/DevHunter-romainmarcoux-full-aa-ab-ac.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/romainmarcoux-full-aa-ab-ac.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-ads.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-ads.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-adult.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-adult.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-cryptocurrency.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-cryptocurrency.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-gambling.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-gambling.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-malware.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-malware.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-scam.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-scam.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-typo.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-typo.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-urlshortener.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-urlshortener.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-wild-ads.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-wild-ads.conf"
LISTS["devhunter/DevHunter-shadowwhisperer-wild-tunnel.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/BlockList_DB/shadowwhisperer-wild-tunnel.conf"

# ===============================
# 3. DOWNLOAD, RENAME, CHECK
# ===============================
ERROR=0
for path in "${!LISTS[@]}"; do
    url="${LISTS[$path]}"
    category=$(dirname "$path")
    filename=$(basename "$path")
    temp_file="/tmp/$filename"

    log "[+] Download $category/$filename"
    wget --quiet -O "$temp_file" "$url"

    if [ ! -s "$temp_file" ]; then
        log "[!] Download gagal atau file kosong: $filename"
        ERROR=1
        continue
    fi

    # Pindahkan & rename
    mv "$temp_file" "$BASE_DIR/$path"

    # Cek sintaks
    unbound-checkconf "$BASE_DIR/$path" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        log "[!] Error syntax: $BASE_DIR/$path"
        ERROR=1
    fi
done

# ===============================
# 4. RELOAD / RESTART UNBOUND
# ===============================
log "[?] Mencoba reload Unbound..."
systemctl reload unbound
if [ $? -eq 0 ]; then
    log "[?] Unbound berhasil direload!"

    # TAMBAHAN: KEMBALIKAN CACHE SETELAH RELOAD BERHASIL
    log "[?] Mengembalikan cache DNS..."
    unbound-control load_cache < "$CACHE_FILE" 2>/dev/null
else
    log "[!] Reload gagal, mencoba restart..."
    systemctl restart unbound
    if [ $? -eq 0 ]; then
        log "[?] Unbound berhasil direstart!"
        # TAMBAHAN: KEMBALIKAN CACHE SETELAH RESTART BERHASIL
        unbound-control load_cache < "$CACHE_FILE" 2>/dev/null
    else
        log "[!] Restart juga gagal! Periksa konfigurasi Unbound."
    fi
fi

# Bersihkan file sampah
rm -f "$CACHE_FILE"

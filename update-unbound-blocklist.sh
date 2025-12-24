#!/bin/bash

BASE_DIR="/etc/unbound/unbound.conf.d/malware"

# ===============================
# FUNCTION LOG DENGAN TIMESTAMP
# ===============================
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# ===============================
# 1. KATEGORI
# ===============================
CATEGORIES=("malicious" "phishing" "ransomware" "crypto" "abuse" "scam" "suspicious" "redirect" "fraud" "spam" "piracy" "oisd" "devhunter" "gambling" "fakenews" "lgbtq" "ads")

# Buat folder kategori & hapus file lama
for cat in "${CATEGORIES[@]}"; do
    mkdir -p "$BASE_DIR/$cat"
    rm -f "$BASE_DIR/$cat"/*.conf
done

# ===============================
# 2. LIST URL + RENAME FILE
# ===============================
declare -A LISTS

# Ads / Trackers
LISTS["ads/0Zinc-easylist.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/0Zinc/easylist.fork.conf"
LISTS["ads/adaway-hosts.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/adaway/hosts.fork.conf"
LISTS["ads/blocklistproject-hosts.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/blocklistproject/hosts.fork.conf"
LISTS["ads/craiu-mobiletrackers.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/craiu/mobiletrackers.fork.conf"
LISTS["ads/crazy-max-spy.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/crazy-max/spy.fork.conf"
LISTS["ads/DandelionSprout-GameConsole.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/DandelionSprout.GameConsoleAdblockList.conf"
LISTS["ads/disconnectme-simple-ad.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/disconnectme/simple-ad.fork.conf"
LISTS["ads/FadeMind-UncheckyAds.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/FadeMind/UncheckyAds.fork.conf"
LISTS["ads/firebog-AdguardDNS.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/firebog/AdguardDNS.fork.conf"
LISTS["ads/firebog-Admiral.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/firebog/Admiral.fork.conf"
LISTS["ads/firebog-Easylist.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/firebog/Easylist.fork.conf"
LISTS["ads/firebog-PrigentAds.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/firebog/Prigent-Ads.fork.conf"
LISTS["ads/MajkiIT-SmartTV.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/MajkiIT/SmartTV-ads.fork.conf"
LISTS["ads/ray-AdguardMobileAds.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/r-a-y/AdguardMobileAds.fork.conf"
LISTS["ads/sefinek-hosts.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/sefinek.hosts.conf"
LISTS["ads/ShadowWhisperer-Ads.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/ShadowWhisperer/Ads.fork.conf"
LISTS["ads/yoyo-ads-trackers.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ads/yoyo/ads-trackers-etc.fork.conf"

# Malicious
LISTS["malicious/stalkerware-indicators.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/AssoEchap/stalkerware-indicators.fork.conf"
LISTS["malicious/hostsVN.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/bigdargon/hostsVN.fork.conf"
LISTS["malicious/malware-project.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/blocklistproject/malware.fork.conf"
LISTS["malicious/dandelion-antimalware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/DandelionSprout-AntiMalwareHosts.fork.conf"
LISTS["malicious/disconnect-malvertising.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/disconnectme/simple-malvertising.fork.conf"
LISTS["malicious/urlhaus.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/malware-filter/urlhaus-filter-hosts-online.fork.conf"
LISTS["malicious/notrack-malware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/quidsup/notrack-malware.fork.conf"
LISTS["malicious/norton-reported.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/reported-by-norton.conf"
LISTS["malicious/rpilist-malware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/RPiList/Malware.fork.conf"
LISTS["malicious/sefinek-hosts1.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/sefinek.hosts1.conf"
LISTS["malicious/sefinek-hosts2.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/sefinek.hosts2.conf"
LISTS["malicious/spam404.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/Spam404/main-blacklist.fork.conf"
LISTS["malicious/suspicious.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/suspicious.conf"
LISTS["malicious/web-attacks.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/web-attacks.conf"
LISTS["malicious/phishing.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/malicious/phishing.conf"

# Phishing
LISTS["phishing/phishing-project.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/blocklistproject/phishing.fork.conf"
LISTS["phishing/discord-phishing.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/Dogino/Discord-Phishing-URLs-phishing.fork.conf"
LISTS["phishing/phishing-army.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/phishing.army/blocklist-extended.fork.conf"
LISTS["phishing/rpilist-phishing.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/phishing/RPiList/Phishing-Angriffe.fork.conf"

# Ransomware
LISTS["ransomware/ransomware.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/ransomware/blocklistproject/ransomware.fork.conf"

# Fakenews
LISTS["fakenews/StevenBlack-hosts.fork.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/fakenews/StevenBlack/hosts.fork.conf"
LISTS["fakenews/marktron-hosts.fork.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/fakenews/marktron/hosts.fork.conf"

# Crypto
LISTS["crypto/crypto-prigent.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/crypto/cryptojacking/firebog/Prigent/Crypto.fork.conf"
LISTS["crypto/nocoin.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/crypto/cryptojacking/hoshsadiq/adblock-nocoin-list.fork.conf"
LISTS["crypto/crypto-streams.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/crypto/cryptojacking/Snota418/Crypto-streams.fork.conf"

# Abuse
LISTS["abuse/abuse-blocklist.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/abuse/blocklistproject/hosts.fork.conf"
LISTS["abuse/abuse-urlhaus.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/abuse/urlhaus.abuse.ch/hostfile.fork.conf"

# Scam
LISTS["scam/scam-project.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/scam/blocklistproject/scam.fork.conf"
LISTS["scam/discord-scam.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/scam/Dogino/Discord-Phishing-URLs-scam.fork.conf"
LISTS["scam/durablenapkin-scam.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/scam/durablenapkin/scamblocklist.fork.conf"
LISTS["scam/jarell-scam.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/scam/jarelllama/scam.fork.conf"
LISTS["scam/sefinek-scam.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/scam/sefinek.hosts.conf"

# Suspicious
LISTS["suspicious/risks.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/suspicious/FadeMind/add-Risk.fork.conf"
LISTS["suspicious/w3kbl.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/suspicious/firebog/w3kbl.fork.conf"
LISTS["suspicious/sefinek-suspicious.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/suspicious/sefinek.hosts.conf"

# Redirect
LISTS["redirect/redirect.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/redirect/blocklistproject/redirect.fork.conf"

# Fraud
LISTS["fraud/fraud-blocklist.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/fraud/blocklistproject/hosts.fork.conf"

# Spam
LISTS["spam/rpilist-spam.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/spam/RPiList/spam-mails.fork.conf"
LISTS["spam/toxic-domains.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/spam/stopforumspam/toxic-domains-whole.fork.conf"
LISTS["spam/add-spam.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/spam/FadeMind/add-Spam.fork.conf"

# Piracy
LISTS["piracy/piracy-project.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/piracy/blocklistproject/piracy.fork.conf"
LISTS["piracy/sefinek-piracy.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/piracy/sefinek.hosts.conf"

# Gambling
LISTS["gambling/stevenblack.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/StevenBlack/hosts.fork.conf"
LISTS["gambling/blocklistproject.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/blocklistproject/hosts.fork.conf"
LISTS["gambling/majkiit.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/MajkiIT/gambling-hosts.fork.conf"
LISTS["gambling/sefinek.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/sefinek.hosts.conf"
LISTS["gambling/trustpositif-id.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/TrustPositif/gambling-indonesia.fork.conf"
LISTS["gambling/sefinek2.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/sefinek.hosts2.conf"

# LGBTQ+
LISTS["lgbtq/lgbtqplus.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/sites/lgbtqplus.conf"
LISTS["lgbtq/lgbtqplus2.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/sites/lgbtqplus2.conf"

# OISD lists
LISTS["oisd/big-oisd.conf"]="https://big.oisd.nl/unbound"
LISTS["oisd/nsfw-oisd.conf"]="https://nsfw.oisd.nl/unbound"

# DevHunter lists
LISTS["devhunter/hagezi-tif.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/hagezi-tif.conf"
LISTS["devhunter/1hosts-lite.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/1hosts-lite.conf"
LISTS["devhunter/hagezi-pro.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/hagezi-pro.conf"
LISTS["devhunter/hagezi-light.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/hagezi-light.conf"
LISTS["devhunter/hagezi-xiaomi-native.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/hagezi-native-xiaomi.conf"
LISTS["devhunter/hagezi-apple-native.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/hagezi-native-apple.conf"
LISTS["devhunter/hagezi-huawei-native.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/hagezi-native-huawei.conf"
LISTS["devhunter/hagezi-oppo-realme-native.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/hagezi-native-oppo-realme.conf"
LISTS["devhunter/hagezi-samsung-native.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/hagezi-native-samsung.conf"
LISTS["devhunter/hagezi-vivo-native.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/hagezi-native-vivo.conf"

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
else
    log "[!] Reload gagal, mencoba restart..."
    systemctl restart unbound
    if [ $? -eq 0 ]; then
        log "[?] Unbound berhasil direstart!"
    else
        log "[!] Restart juga gagal! Periksa konfigurasi Unbound."
    fi
fi

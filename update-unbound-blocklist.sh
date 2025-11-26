#!/bin/bash

BASE_DIR="/etc/unbound/unbound.conf.d/malware"

# ===============================
# 1. KATEGORI
# ===============================
CATEGORIES=("malicious" "phishing" "ransomware" "crypto" "abuse" "scam" "suspicious" "redirect" "gambling" "fakenews" "porn")

# Buat folder kategori & hapus file lama
for cat in "${CATEGORIES[@]}"; do
    mkdir -p "$BASE_DIR/$cat"
    rm -f "$BASE_DIR/$cat"/*.conf
done

# ===============================
# 2. LIST URL + RENAME FILE
# ===============================
declare -A LISTS

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

# Gambling
LISTS["gambling/gambling-stevenblack.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/StevenBlack/hosts.fork.conf"
LISTS["gambling/gambling-project.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/blocklistproject/hosts.fork.conf"
LISTS["gambling/gambling-majki.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/MajkiIT/gambling-hosts.fork.conf"
LISTS["gambling/gambling-sefinek.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/sefinek.hosts.conf"
LISTS["gambling/gambling-indonesia.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/TrustPositif/gambling-indonesia.fork.conf"
LISTS["gambling/gambling-sefinek2.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/gambling/sefinek.hosts2.conf"

# Fakenews
LISTS["fakenews/fakenews-stevenblack.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/fakenews/StevenBlack/hosts.fork.conf"
LISTS["fakenews/fakenews-marktron.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/fakenews/marktron/hosts.fork.conf"

# Porn
LISTS["porn/porn-stevenblack.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/StevenBlack/porn.fork.conf"
LISTS["porn/porn-project.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/blocklistproject/porn.fork.conf"
LISTS["porn/porn-chadmayfield.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/chadmayfield/pi-blocklist-porn-all.fork.conf"
LISTS["porn/porn-oisd.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/oisd/nsfw.fork.conf"
LISTS["porn/porn-sefinek.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/sefinek.hosts.conf"
LISTS["porn/porn-sefinek2.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/sefinek.hosts2.conf"
LISTS["porn/porn-sinfonietta.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/Sinfonietta/pornography-hosts.fork.conf"
LISTS["porn/porn-4skin.conf"]="https://blocklist.sefinek.net/generated/v1/unbound/porn/4skinSkywalker/hosts.fork.conf"

# ===============================
# 3. DOWNLOAD, RENAME, CHECK
# ===============================
ERROR=0
for path in "${!LISTS[@]}"; do
    url="${LISTS[$path]}"
    category=$(dirname "$path")
    filename=$(basename "$path")
    temp_file="/tmp/$filename"

    echo "[+] Download $category/$filename"
    wget --quiet -O "$temp_file" "$url"

    if [ ! -s "$temp_file" ]; then
        echo "[!] Download gagal atau file kosong: $filename"
        ERROR=1
        continue
    fi

    # Pindahkan & rename
    mv "$temp_file" "$BASE_DIR/$path"

    # Cek sintaks
    unbound-checkconf "$BASE_DIR/$path" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "[!] Error syntax: $BASE_DIR/$path"
        ERROR=1
    fi
done

# ===============================
# 4. RESTART UNBOUND
# ===============================
if [ $ERROR -eq 0 ]; then
    echo "[✓] Semua file valid, restart Unbound..."
    systemctl restart unbound
    echo "[✓] Unbound berhasil direstart!"
else
    echo "[!] Ada file error, Unbound tidak direstart!"
fi

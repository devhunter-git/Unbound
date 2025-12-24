#!/bin/bash

# Folder tujuan
WHITELIST_DIR="/etc/unbound/unbound.conf.d/zzz-whitelist"
WHITELIST_FILE="zzzzz-whitelist.conf"
URL="https://raw.githubusercontent.com/devhunter-git/Unbound/main/devhunter-whitelist.conf"

# ===============================
# FUNCTION LOG DENGAN TIMESTAMP
# ===============================
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# ===============================
# Buat folder jika belum ada
# ===============================
mkdir -p "$WHITELIST_DIR"

# ===============================
# Download whitelist
# ===============================
TEMP_FILE="/tmp/$WHITELIST_FILE"
log "[+] Downloading whitelist dari $URL ..."
wget --quiet -O "$TEMP_FILE" "$URL"

if [ ! -s "$TEMP_FILE" ]; then
    log "[!] Download gagal atau file kosong!"
    exit 1
fi

# ===============================
# Pindahkan ke folder whitelist dengan nama baru
# ===============================
mv "$TEMP_FILE" "$WHITELIST_DIR/$WHITELIST_FILE"
log "[+] Whitelist tersimpan di $WHITELIST_DIR/$WHITELIST_FILE"

# ===============================
# Cek syntax Unbound
# ===============================
unbound-checkconf "$WHITELIST_DIR/$WHITELIST_FILE" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    log "[!] Error syntax di $WHITELIST_FILE"
    exit 1
fi

# ===============================
# Reload Unbound
# ===============================
log "[+] Reload Unbound ..."
systemctl reload unbound
if [ $? -eq 0 ]; then
    log "[+] Unbound berhasil direload!"
else
    log "[!] Reload gagal, coba restart..."
    systemctl restart unbound
    if [ $? -eq 0 ]; then
        log "[+] Unbound berhasil direstart!"
    else
        log "[!] Restart juga gagal! Periksa konfigurasi."
    fi
fi

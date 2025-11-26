#!/bin/bash

# Base directory
BASE_DIR="/etc/unbound/unbound.conf.d/malware"

# List of malware categories
CATEGORIES=(
    "malicious"
    "phishing"
    "ransomware"
    "crypto"
    "abuse"
    "scam"
    "suspicious"
    "redirect"
    "gambling"
    "fakenews"
    "porn"
)

# Membuat direktori jika belum ada
for category in "${CATEGORIES[@]}"; do
    DIR="$BASE_DIR/$category"
    if [ ! -d "$DIR" ]; then
        mkdir -p "$DIR"
        echo "Direktori dibuat: $DIR"
    else
        echo "Direktori sudah ada: $DIR"
    fi

    # Membuat file konfigurasi default (opsional)
    CONFIG_FILE="$DIR/$category.conf"
    if [ ! -f "$CONFIG_FILE" ]; then
        cat <<EOF > "$CONFIG_FILE"
# Konfigurasi default untuk kategori $category
server:
    local-zone: "example.$category" static
EOF
        echo "File konfigurasi dibuat: $CONFIG_FILE"
    else
        echo "File konfigurasi sudah ada: $CONFIG_FILE"
    fi
done

echo "Selesai membuat direktori dan file konfigurasi."

#!/bin/bash
set -euo pipefail

# ===============================
# KONFIGURASI
# ===============================
WHITELIST_DIR="/etc/unbound/unbound.conf.d/zzz-whitelist"

declare -A WHITELISTS=(
  ["zzzzz-devhunter-whitelist.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/devhunter-whitelist.conf"
  ["zzzzz-hagezi-referral-whitelist.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/hagezi-referral-whitelist.conf"
  ["zzzzz-shadowwhisperer-whitelist.conf"]="https://raw.githubusercontent.com/devhunter-git/Unbound/refs/heads/main/WhiteList%20DB/shadowwhisperer-whitelist.conf"
)

# ===============================
# PREP
# ===============================
CACHE_FILE="$(mktemp)"
TMP_DIR="$(mktemp -d)"
BACKUP_DIR="$(mktemp -d)"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

cleanup() {
  rm -f "$CACHE_FILE"
  rm -rf "$TMP_DIR" "$BACKUP_DIR"
}
trap cleanup EXIT

command -v unbound-control >/dev/null || { log "[?] unbound-control tidak ditemukan"; exit 1; }
command -v unbound-checkconf >/dev/null || { log "[?] unbound-checkconf tidak ditemukan"; exit 1; }

# ===============================
# BACKUP CACHE
# ===============================
log "[?] Backup DNS cache..."
unbound-control dump_cache > "$CACHE_FILE" 2>/dev/null || true

# ===============================
# DOWNLOAD WHITELIST (TEMP)
# ===============================
log "[?] Download whitelist..."

for FILE in $(printf "%s\n" "${!WHITELISTS[@]}" | sort); do
  URL="${WHITELISTS[$FILE]}"
  DEST="$TMP_DIR/$FILE"

  log "[+] $FILE"
  curl -fsSL \
    --connect-timeout 10 \
    --max-time 30 \
    "$URL" -o "$DEST"

  [ -s "$DEST" ] || { log "[?] File kosong: $FILE"; exit 1; }
done

# ===============================
# BACKUP WHITELIST LAMA
# ===============================
log "[?] Backup whitelist lama..."
mkdir -p "$WHITELIST_DIR"
cp -a "$WHITELIST_DIR/." "$BACKUP_DIR/" 2>/dev/null || true

# ===============================
# DEPLOY BARU (ATOMIC)
# ===============================
log "[?] Deploy whitelist baru..."
rm -f "$WHITELIST_DIR"/*
cp -a "$TMP_DIR/." "$WHITELIST_DIR/"

# ===============================
# VALIDASI KONFIG
# ===============================
log "[?] Validasi konfigurasi Unbound..."
unbound-checkconf > /dev/null

# ===============================
# RELOAD FAIL-SAFE
# ===============================
log "[?] Reload Unbound..."
if systemctl reload unbound; then
  log "[?] Reload sukses"
else
  log "[!] Reload gagal ? rollback whitelist"

  rm -f "$WHITELIST_DIR"/*
  cp -a "$BACKUP_DIR/." "$WHITELIST_DIR/"

  log "[?] Restart Unbound (last resort)..."
  if systemctl restart unbound; then
    log "[?] Restart sukses setelah rollback"
  else
    log "[?] Restart gagal — DNS DOWN"
    exit 1
  fi
fi

# ===============================
# RESTORE CACHE
# ===============================
log "[?] Restore DNS cache..."
unbound-control load_cache < "$CACHE_FILE" 2>/dev/null || true

# ===============================
# HEALTH CHECK
# ===============================
unbound-control status > /dev/null || {
  log "[?] Unbound tidak healthy setelah update"
  exit 1
}

log "[?] Semua whitelist ter-update dengan aman"

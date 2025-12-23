#!/bin/bash

BACKUP_DEV="/dev/sdb1"
MOUNT_POINT="/media/backup"
UMBREL_DIR="/home/umbrel/umbrel"
SLEEP=2   # počet sekund mezi operacemi

log() {
    echo -e "\n[INFO] $1"
}

ok() {
    echo "[OK] $1"
}

err() {
    echo "[ERROR] $1"
    exit 1
}

pause() {
    sleep "$SLEEP"
}

log "Vytvářím mount point: $MOUNT_POINT"
mkdir -p "$MOUNT_POINT" && ok "Adresář vytvořen" || err "Nelze vytvořit adresář"
pause

log "Připojuji zařízení $BACKUP_DEV"
if mount "$BACKUP_DEV" "$MOUNT_POINT"; then
    ok "Disk připojen"
else
    err "Disk se nepodařilo připojit – je správně vložen?"
fi
pause

log "Spouštím rsync zálohu..."
if rsync -rtuv --delete --size-only "$UMBREL_DIR/" "$MOUNT_POINT/"; then
    ok "Záloha proběhla úspěšně"
else
    err "Chyba při rsync operaci"
fi
pause

log "Odpojuji disk..."
if umount "$MOUNT_POINT"; then
    ok "Disk byl odpojen"
else
    err "Disk se nepodařilo odpojit"
fi

log "Hotovo! 🎉"

#!/bin/bash

MOUNT_POINT="/media/backup"
UMBREL_DIR="/umbrel-root"
SLEEP=2

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

log "Připojuji disk"
mount "$MOUNT_POINT" && ok "Disk připojen" || err "Mount selhal"
pause

log "Spouštím rsync zálohu..."
rsync -rtuv --delete --size-only "$UMBREL_DIR/" "$MOUNT_POINT/" \
    && ok "Záloha proběhla úspěšně" \
    || err "Chyba při rsync operaci"
pause

log "Odpojuji disk..."
umount "$MOUNT_POINT" && ok "Disk odpojen" || err "Unmount selhal"

log "Hotovo! 🎉"

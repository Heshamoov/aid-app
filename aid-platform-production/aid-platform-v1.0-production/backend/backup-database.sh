#!/bin/bash

# Aid Platform Database Backup Script
# Creates timestamped backups of the PocketBase database

set -e

BACKEND_DIR="$HOME/aid-app/backend"
DB_FILE="$BACKEND_DIR/pb_data/data.db"
BACKUP_DIR="$BACKEND_DIR/pb_data/backups"
EXPORT_DIR="$HOME/aid-app/exports"
LOG_FILE="$BACKEND_DIR/pb_data/backup.log"

# Create backup directories
mkdir -p "$BACKUP_DIR"
mkdir -p "$EXPORT_DIR"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check if database exists
if [ ! -f "$DB_FILE" ]; then
    log "❌ Database file not found: $DB_FILE"
    exit 1
fi

# Get database size
DB_SIZE=$(du -h "$DB_FILE" | cut -f1)

log "========================================="
log "Starting database backup"
log "Database size: $DB_SIZE"
log "========================================="

# Create timestamped backup filename
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/data_${TIMESTAMP}.db"
EXPORT_FILE="$EXPORT_DIR/aid_platform_backup_${TIMESTAMP}.db"

# Create backup using SQLite backup command (safer than cp while DB is in use)
log "Creating local backup..."
if command -v sqlite3 &> /dev/null; then
    # Use SQLite's backup command for safe online backup
    sqlite3 "$DB_FILE" ".backup '$BACKUP_FILE'"
    log "✅ Local backup created: $BACKUP_FILE"
else
    # Fallback to simple copy
    cp "$DB_FILE" "$BACKUP_FILE"
    log "✅ Local backup created (using cp): $BACKUP_FILE"
fi

# Create export copy (for external storage/transfer)
cp "$BACKUP_FILE" "$EXPORT_FILE"
log "✅ Export backup created: $EXPORT_FILE"

# Compress export backup to save space
if command -v gzip &> /dev/null; then
    gzip -f "$EXPORT_FILE"
    log "✅ Export backup compressed: ${EXPORT_FILE}.gz"
    EXPORT_SIZE=$(du -h "${EXPORT_FILE}.gz" | cut -f1)
    log "   Compressed size: $EXPORT_SIZE"
fi

# Clean up old local backups (keep last 24 hourly backups = 1 day)
log "Cleaning up old local backups..."
cd "$BACKUP_DIR"
ls -t data_*.db 2>/dev/null | tail -n +25 | xargs -r rm -f
LOCAL_COUNT=$(ls -1 data_*.db 2>/dev/null | wc -l)
log "✅ Local backups: $LOCAL_COUNT files retained"

# Clean up old export backups (keep last 30 daily backups = 1 month)
log "Cleaning up old export backups..."
cd "$EXPORT_DIR"
ls -t aid_platform_backup_*.db.gz 2>/dev/null | tail -n +31 | xargs -r rm -f
EXPORT_COUNT=$(ls -1 aid_platform_backup_*.db.gz 2>/dev/null | wc -l)
log "✅ Export backups: $EXPORT_COUNT files retained"

# Calculate total backup size
TOTAL_LOCAL=$(du -sh "$BACKUP_DIR" 2>/dev/null | cut -f1)
TOTAL_EXPORT=$(du -sh "$EXPORT_DIR" 2>/dev/null | cut -f1)

log "========================================="
log "Backup completed successfully"
log "Local backups total: $TOTAL_LOCAL"
log "Export backups total: $TOTAL_EXPORT"
log "========================================="

exit 0


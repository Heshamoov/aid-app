#!/bin/bash

# Aid Platform Auto-Update Script
# Checks for updates from GitHub and applies them safely with rollback capability

set -e  # Exit on error

APP_DIR="$HOME/aid-app"
REPO_URL="git@github.com:Heshamoov/aid-app.git"
UPDATE_LOG="$APP_DIR/logs/update.log"
UPDATE_CHECK_FILE="$APP_DIR/.last_update_check"
UPDATE_INTERVAL=86400  # Check once per day (in seconds)
BACKUP_DIR="$APP_DIR/backups"

# Create logs directory if it doesn't exist
mkdir -p "$APP_DIR/logs"
mkdir -p "$BACKUP_DIR"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$UPDATE_LOG"
}

# Function to check if internet is available
check_internet() {
    if ping -c 1 -W 2 8.8.8.8 &> /dev/null || ping -c 1 -W 2 1.1.1.1 &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to check if we should check for updates
should_check_updates() {
    # If force flag is set, always check
    if [ "$FORCE_UPDATE" = "true" ]; then
        return 0
    fi
    
    if [ ! -f "$UPDATE_CHECK_FILE" ]; then
        return 0
    fi
    
    last_check=$(cat "$UPDATE_CHECK_FILE")
    current_time=$(date +%s)
    time_diff=$((current_time - last_check))
    
    if [ $time_diff -gt $UPDATE_INTERVAL ]; then
        return 0
    else
        return 1
    fi
}

# Function to rollback to previous version
rollback() {
    log "❌ Update failed! Rolling back to previous version..."
    
    if [ -d "$LATEST_BACKUP" ]; then
        log "Restoring from backup: $LATEST_BACKUP"
        
        # Stop services
        "$APP_DIR/stop-aid-app.sh" 2>/dev/null || true
        
        # Restore frontend
        if [ -d "$LATEST_BACKUP/frontend" ]; then
            rm -rf "$APP_DIR/frontend"
            cp -r "$LATEST_BACKUP/frontend" "$APP_DIR/"
            log "✅ Frontend restored"
        fi
        
        # Restore backend (excluding database)
        if [ -d "$LATEST_BACKUP/backend" ]; then
            # Backup current database
            if [ -f "$APP_DIR/backend/pb_data/data.db" ]; then
                cp "$APP_DIR/backend/pb_data/data.db" "/tmp/data.db.backup"
            fi
            
            rm -rf "$APP_DIR/backend"
            cp -r "$LATEST_BACKUP/backend" "$APP_DIR/"
            
            # Restore database
            if [ -f "/tmp/data.db.backup" ]; then
                mkdir -p "$APP_DIR/backend/pb_data"
                cp "/tmp/data.db.backup" "$APP_DIR/backend/pb_data/data.db"
                rm "/tmp/data.db.backup"
            fi
            log "✅ Backend restored (database preserved)"
        fi
        
        # Restart services
        "$APP_DIR/start-aid-app.sh"
        log "✅ Rollback completed successfully"
    else
        log "❌ No backup found for rollback!"
        exit 1
    fi
}

# Parse command line arguments
FORCE_UPDATE=false
if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
    FORCE_UPDATE=true
    log "========================================="
    log "Aid Platform Manual Update"
    log "========================================="
else
    log "========================================="
    log "Aid Platform Auto-Update Check"
    log "========================================="
fi

# Check if internet is available
if ! check_internet; then
    log "⚠️  No internet connection. Skipping update check."
    log "   App will continue to work offline."
    exit 0
fi

log "✅ Internet connection detected"

# Check if we should check for updates
if ! should_check_updates; then
    log "ℹ️  Update check not needed yet (last check was recent)"
    exit 0
fi

log "Checking for updates from GitHub..."

cd "$APP_DIR"

# Check if git is initialized
if [ ! -d ".git" ]; then
    log "⚠️  Git repository not initialized"
    log "   To enable auto-updates, run: git init && git remote add origin $REPO_URL"
    exit 0
fi

# Fetch latest changes
log "Fetching latest changes from remote..."
if ! git fetch origin main 2>&1 | tee -a "$UPDATE_LOG"; then
    log "⚠️  Failed to fetch updates. Continuing with current version."
    exit 0
fi

# Check if there are updates
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main 2>/dev/null)

if [ -z "$REMOTE" ]; then
    log "⚠️  Could not determine remote version"
    exit 0
fi

if [ "$LOCAL" = "$REMOTE" ]; then
    log "✅ App is already up to date (version: ${LOCAL:0:7})"
    date +%s > "$UPDATE_CHECK_FILE"
    exit 0
fi

log "🔄 New version available!"
log "   Current: ${LOCAL:0:7}"
log "   Latest:  ${REMOTE:0:7}"
log ""

# Create backup before updating
LATEST_BACKUP="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$LATEST_BACKUP"
log "Creating backup at: $LATEST_BACKUP"

# Backup frontend
if [ -d "$APP_DIR/frontend" ]; then
    cp -r "$APP_DIR/frontend" "$LATEST_BACKUP/"
    log "✅ Frontend backed up"
fi

# Backup backend (excluding large database files)
if [ -d "$APP_DIR/backend" ]; then
    mkdir -p "$LATEST_BACKUP/backend"
    rsync -a --exclude='pb_data/data.db' --exclude='pb_data/logs' "$APP_DIR/backend/" "$LATEST_BACKUP/backend/"
    log "✅ Backend backed up (database excluded)"
fi

# Set trap to rollback on error
trap rollback ERR

# Stop the app
log "Stopping services..."
"$APP_DIR/stop-aid-app.sh" 2>&1 | tee -a "$UPDATE_LOG" || true

# Pull updates
log "Downloading updates..."
git pull origin main 2>&1 | tee -a "$UPDATE_LOG"

# Install frontend dependencies if package.json changed
if git diff --name-only $LOCAL $REMOTE | grep -q "frontend/package.json"; then
    log "Installing frontend dependencies..."
    cd "$APP_DIR/frontend"
    pnpm install 2>&1 | tee -a "$UPDATE_LOG"
    cd "$APP_DIR"
fi

# Run database migrations if needed
if [ -d "$APP_DIR/backend/pb_migrations" ]; then
    log "Database migrations will be applied on next PocketBase start"
fi

# Restart the app
log "Restarting services..."
"$APP_DIR/start-aid-app.sh" 2>&1 | tee -a "$UPDATE_LOG"

# Wait for services to start
sleep 5

# Verify services are running
if pgrep -f "pocketbase serve" > /dev/null && pgrep -f "vite dev" > /dev/null; then
    log "✅ Services started successfully"
else
    log "⚠️  Warning: Some services may not have started properly"
    log "   Check manually with: ps aux | grep -E '(pocketbase|vite)'"
fi

# Update last check time
date +%s > "$UPDATE_CHECK_FILE"

# Clean up old backups (keep last 5)
log "Cleaning up old backups..."
cd "$BACKUP_DIR"
ls -t | tail -n +6 | xargs -r rm -rf
log "✅ Old backups cleaned (kept last 5)"

log ""
log "========================================="
log "✅ Update completed successfully!"
log "========================================="
log "Updated from ${LOCAL:0:7} to ${REMOTE:0:7}"
log "Backup saved at: $LATEST_BACKUP"
log ""
log "Access the app at: http://localhost:5173"
log ""

# Remove error trap
trap - ERR

exit 0


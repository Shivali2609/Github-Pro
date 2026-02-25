#!/bin/bash
set -euo pipefail

# ==========================
# PROJECT SETTINGS
# ==========================
PROJECT_NAME="Github-Pro"
SOURCE_DIR="$HOME/$PROJECT_NAME"
BASE_BACKUP_DIR="$HOME/backups/$PROJECT_NAME"
LOG_FILE="$HOME/backups/backups.log"

# ==========================
# GOOGLE DRIVE
# ==========================
GDRIVE_REMOTE="gdrive:Backups/$PROJECT_NAME"

# ==========================
# RETENTION POLICY (Days)
# ==========================
DAILY_RETENTION=7
WEEKLY_RETENTION=28     # 4 weeks
MONTHLY_RETENTION=90    # 3 months approx

# ==========================
# WEBHOOK
# ==========================
WEBHOOK_URL="https://webhook.site/3753c441-7fd1-4722-84d4-fbd2f91f01a0"

# ==========================
# DATE VARIABLES
# ==========================
DATE=$(date +%Y%m%d_%H%M%S)
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
DOW=$(date +%u)   # 7 = Sunday

# ==========================
# DIRECTORIES
# ==========================

BACKUP_ROOT="$HOME/backups/$PROJECT_NAME"

DAILY_DIR="$BACKUP_ROOT/daily/$YEAR/$MONTH/$DAY"
WEEKLY_DIR="$BACKUP_ROOT/weekly/$YEAR/$MONTH/$DAY"
MONTHLY_DIR="$BACKUP_ROOT/monthly/$YEAR/$MONTH/$DAY"

mkdir -p "$DAILY_DIR" "$WEEKLY_DIR" "$MONTHLY_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

ARCHIVE_NAME="${PROJECT_NAME}_${DATE}.zip"
ARCHIVE_PATH="$DAILY_DIR/$ARCHIVE_NAME"

log() {
  echo "$(date '+%F %T') - $1" | tee -a "$LOG_FILE"
}

log "Backup started"

# ==========================
# VALIDATION
# ==========================
if [[ ! -d "$SOURCE_DIR" ]]; then
  log "ERROR: Source directory does not exist"
  exit 1
fi

# ==========================
# CREATE ZIP BACKUP
# ==========================
(
  cd "$HOME"
  zip -r "$ARCHIVE_PATH" "$PROJECT_NAME" >/dev/null
)

log "Backup created: $ARCHIVE_NAME"

# ==========================
# WEEKLY / MONTHLY COPIES
# ==========================
if [[ "$DOW" == "7" ]]; then
  WEEKLY_DIR="$BASE_BACKUP_DIR/weekly/$YEAR/$MONTH/$DAY"
  mkdir -p "$WEEKLY_DIR"
  cp "$ARCHIVE_PATH" "$WEEKLY_DIR/"
  log "Weekly backup saved"
fi

if [[ "$DAY" == "01" ]]; then
  MONTHLY_DIR="$BASE_BACKUP_DIR/monthly/$YEAR/$MONTH/$DAY"
  mkdir -p "$MONTHLY_DIR"
  cp "$ARCHIVE_PATH" "$MONTHLY_DIR/"
  log "Monthly backup saved"
fi

# ==========================
# UPLOAD TO GOOGLE DRIVE
# ==========================
if rclone copy "$ARCHIVE_PATH" "$GDRIVE_REMOTE/daily/$YEAR/$MONTH/$DAY"; then
  log "Uploaded daily backup to Google Drive"
else
  log "ERROR: Failed to upload daily backup"
fi

if [[ "$DOW" == "7" ]]; then
  rclone copy "$WEEKLY_DIR/$ARCHIVE_NAME" "$GDRIVE_REMOTE/weekly/$YEAR/$MONTH/$DAY" \
    && log "Uploaded weekly backup to Google Drive"
fi

if [[ "$DAY" == "01" ]]; then
  rclone copy "$MONTHLY_DIR/$ARCHIVE_NAME" "$GDRIVE_REMOTE/monthly/$YEAR/$MONTH/$DAY" \
    && log "Uploaded monthly backup to Google Drive"
fi

# ==========================
# ROTATION POLICY (Local)
# ==========================
log "Applying retention policy"

find "$BASE_BACKUP_DIR/daily" -type f -name "*.zip" -mtime +$DAILY_RETENTION -delete
find "$BASE_BACKUP_DIR/weekly" -type f -name "*.zip" -mtime +$WEEKLY_RETENTION -delete
find "$BASE_BACKUP_DIR/monthly" -type f -name "*.zip" -mtime +$MONTHLY_RETENTION -delete

log "Old backups cleaned"

# ==========================
# WEBHOOK NOTIFICATION
# ==========================
curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"project\":\"$PROJECT_NAME\",\"date\":\"$DATE\",\"status\":\"BackupSuccessful\"}" \
  "$WEBHOOK_URL"
log "Webhook notification sent"
log "Backup completed successfully"

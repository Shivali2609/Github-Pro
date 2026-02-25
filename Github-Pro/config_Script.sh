#!/bin/bash

# ---------------- CONFIGURATION ----------------

PROJECT_NAME="MyProject"
SOURCE_DIR="$HOME/Github-Pro"
BASE_BACKUP_DIR="$HOME/backups"
GDRIVE_REMOTE="gdrive:Backups/$PROJECT_NAME"
LOG_FILE="$HOME/backup.log"

# Retention Settings
DAILY_RETENTION=7
WEEKLY_RETENTION=28
MONTHLY_RETENTION=90

WEBHOOK_URL="https://webhook.site/#!/view/3753c441-7fd1-4722-84d4-fbd2f91f01a0"s

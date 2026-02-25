Backup Management Script
Overview

This project provides an automated backup management solution for a GitHub-hosted project.
The script creates timestamped backups, uploads them to Google Drive using rclone, applies a rotational retention policy (daily, weekly, monthly), logs all operations, and optionally sends a webhook notification upon successful completion.

Features

Creates compressed .zip backups

Timestamped naming format:

ProjectName_YYYYMMDD_HHMMSS.zip


Structured local storage:

~/backups/ProjectName/YYYY/MM/DD/


Google Drive integration using rclone

Rotational retention policy:

Daily backups (last 7)

Weekly backups (last 4 Sundays)

Monthly backups (last 3 months)

Webhook notification via cURL

Detailed logging in backup.log

Optional --no-notify flag

Installation
1. Install rclone
curl https://rclone.org/install.sh | sudo bash

2. Configure Google Drive
rclone config


Steps:

Select n to create a new remote

Choose drive

Complete OAuth authentication

Assign a remote name (e.g., gdrive)

Usage

Make the script executable:

chmod +x backup_script.sh


Run manually:

./backup_script.sh

Retention Configuration

Modify these variables in the configuration file or script:

DAILY_RETENTION=7
WEEKLY_RETENTION=4
MONTHLY_RETENTION=3


These values determine how many backups are preserved before older ones are deleted.

Example Log Output
[Date] Created backup: project3_20260215_130101.zip
[Date] Upload successful
[Date] Daily retention cleanup done
[Date] Weekly retention cleanup done
[Date] Monthly retention cleanup done
[Date] Notification sent
[Date] Backup completed successfully

Sample Webhook Payload
{
  "project": "project3",
  "date": "20260215_130101",
  "status": "BackupSuccessful"
}

Sample cURL Webhook Request
curl -X POST -H "Content-Type: application/json" \
-d '{
  "project": "project3",
  "date": "20260215_140501",
  "status": "BackupSuccessful"
}' \
https://webhook.site/your-unique-url


This allows integration with:

Monitoring systems

Slack / Microsoft Teams bots

CI/CD dashboards

Incident management tools

Security Considerations
Deletion Safety (Retention Policy)

Backup deletion must be carefully scoped to prevent accidental data loss.

Measures implemented:

find command restricted to:

~/backups/ProjectName/


Only .zip files are targeted

Retention values are configurable

Source project files are never deleted

Script should be executed using a non-root user

Testing retention values with small limits is recommended before production use.

Google Drive Access Security

rclone uses OAuth credentials stored locally.

Best practices:

Use a dedicated Google account for backups

Restrict access to a specific Drive folder

Protect credential file:

~/.config/rclone/rclone.conf


Set secure permissions:

chmod 600 ~/.config/rclone/rclone.confBackup Management Script
Overview

This project provides an automated backup management solution for a GitHub-hosted project.
The script creates timestamped backups, uploads them to Google Drive using rclone, applies a rotational retention policy (daily, weekly, monthly), logs all operations, and optionally sends a webhook notification upon successful completion.

Features

Creates compressed .zip backups

Timestamped naming format:

ProjectName_YYYYMMDD_HHMMSS.zip


Structured local storage:

~/backups/ProjectName/YYYY/MM/DD/


Google Drive integration using rclone

Rotational retention policy:

Daily backups (last 7)

Weekly backups (last 4 Sundays)

Monthly backups (last 3 months)

Webhook notification via cURL

Detailed logging in backup.log

Optional --no-notify flag

Installation
1. Install rclone
curl https://rclone.org/install.sh | sudo bash

2. Configure Google Drive
rclone config


Steps:

Select n to create a new remote

Choose drive

Complete OAuth authentication

Assign a remote name (e.g., gdrive)

Usage

Make the script executable:

chmod +x backup_script.sh


Run manually:

./backup_script.sh


Disable webhook notification:

./backup_script.sh --no-notify

Retention Configuration

Modify these variables in the configuration file or script:

DAILY_RETENTION=7
WEEKLY_RETENTION=4
MONTHLY_RETENTION=3


These values determine how many backups are preserved before older ones are deleted.

Example Log Output
[Date] Created backup: project3_20260215_130101.zip
[Date] Upload successful
[Date] Daily retention cleanup done
[Date] Weekly retention cleanup done
[Date] Monthly retention cleanup done
[Date] Notification sent
[Date] Backup completed successfully

Sample Webhook Payload
{
  "project": "project3",
  "date": "20260215_130101",
  "status": "BackupSuccessful"
}

Sample cURL Webhook Request
curl -X POST -H "Content-Type: application/json" \
-d '{
  "project": "project3",
  "date": "20260215_140501",
  "status": "BackupSuccessful"
}' \
https://webhook.site/your-unique-url


This allows integration with:

Monitoring systems

Slack / Microsoft Teams bots

CI/CD dashboards

Incident management tools

Security Considerations
Deletion Safety (Retention Policy)

Backup deletion must be carefully scoped to prevent accidental data loss.

Measures implemented:

find command restricted to:

~/backups/ProjectName/


Only .zip files are targeted

Retention values are configurable

Source project files are never deleted

Script should be executed using a non-root user

Testing retention values with small limits is recommended before production use.

Google Drive Access Security

rclone uses OAuth credentials stored locally.

Best practices:

Use a dedicated Google account for backups

Restrict access to a specific Drive folder

Protect credential file:

~/.config/rclone/rclone.conf


Set secure permissions:

chmod 600 ~/.config/rclone/rclone.conf

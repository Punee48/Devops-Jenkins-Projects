#!/bin/bash

# Create Variables
Log_Dir="/var/logs/apt"
Archive_Dir="/var/logs/apt/archive"
hostName=$(hostname)
Retention_days=7

# Notification Settings
Email="puneethkumar482000@gmail.com"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/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"

# Create archive directory if not exists
mkdir -p "$Archive_Dir"

# Set Status Message
Status="Log Rotation Successful on $hostName at $(date)"
error_flag=0

# Iterate over log files
for file in "$Log_Dir"/*.log; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        timestamp=$(date +"%Y-%m-%d_%H-%M")

        if mv "$file" "$Archive_Dir/${filename}_${timestamp}" && gzip "$Archive_Dir/${filename}_${timestamp}.gz"; then
            touch "$file"
        else
            Status="Error: Log Rotation is unsuccessful for $file on $hostName at $(date)"
            error_flag=1
        fi
    fi
done

# Delete old logs
find "$Archive_Dir" -type f -mtime +$Retention_days -exec rm {} \;

#Email Notification

echo "$Status" | mail -s "Log Rotation Report - $hostname" $Email


# Send Slack Notification
curl -X POST -H 'Content-type: application/json' \
--data "{\"text\":\"$Status\"}" "$SLACK_WEBHOOK_URL"

# Print to Console
echo "$Status"


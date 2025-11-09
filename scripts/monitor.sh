#!/bin/bash
set -ex

THRESHOLD=80

LOG_FILE="./logs/disk_usage_report.log"

# Current timestamp
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo " " >> "$LOG_FILE"
echo "===============================================" >> "$LOG_FILE"
echo "Disk Usage Report - $TIMESTAMP" >> "$LOG_FILE"
echo " " >> "$LOG_FILE"

# Command to list disk usage excluding tmpfs and efivarfs
disk_report=$(df -h --exclude-type=tmpfs --exclude-type=efivarfs | awk 'NR>1 {print $1, $5, $6}')

# Initialize a flag to track warnings
# alert_flag=false

# Loop through each filesystem and check usage
while read -r filesystem usage mountpoint; do
  echo  $filesystem $usage $mountpoint
  # Remove '%' from usage
  usage_value=${usage%\%}

  # Compare with threshold
  if [ "$usage_value" -ge "$THRESHOLD" ]; then
    echo "ALERT: $filesystem mounted on $mountpoint is ${usage_value}% > $THRESHOLD full!" | tee -a "$LOG_FILE"
    alert_flag=true
  else
    echo "OK: $filesystem mounted on $mountpoint is at ${usage_value}% < $THRESHOLD usage." >> "$LOG_FILE"
  fi
done <<< "$disk_report"

# If any alerts were found
if [ "$alert_flag" = true ]; then
  echo "----------------------------------------------" >> "$LOG_FILE"
  echo "Some partitions exceeded the threshold!" >> "$LOG_FILE"
  echo "Please take action to free up space." >> "$LOG_FILE"
else
  echo "All partitions are within safe usage limits." >> "$LOG_FILE"
fi

# Print summary to console
echo ""
echo "Disk usage analysis complete. Log saved to: $LOG_FILE"
echo ""

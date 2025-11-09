## Script Overview

This Bash script (monitor.sh) automatically checks the disk usage of all mounted filesystems on a Linux system.
If any partition exceeds a defined usage threshold (default: 80%), it logs an alert message and stores the report in ./logs/disk_usage_report.log.

## How It Works

- Uses the df command to fetch disk usage information.
- Filters unnecessary filesystems like tmpfs and devtmpfs.
- Uses awk to extract key columns — filesystem, usage, and mount point.
- Loops through each filesystem using while read, compares usage with the threshold, and writes results to a log file.
- Prints alerts for partitions that exceed the limit.

## How to Run

```bash
chmod +x scripts/monitor.sh
./scripts/monitor.sh
```

```bash
# To view Logs
cat ./log/disk_usage_report.log
```

## Purpose

This script demonstrates Linux system administration and Bash scripting skills, including:

- Use of loops and conditionals
- Log management
- File system monitoring and reporting
#!/bin/bash

# Server health monitoring thresholds

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Services to monitor
SERVICES=("sshd" "crond")

# Log file location
LOG_FILE="$HOME/Project01-Linux-Health-Monitor/logs/health.log"

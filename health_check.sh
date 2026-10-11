
#!/bin/bash

set -u

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Create log directory if missing
mkdir -p "$(dirname "$LOG_FILE")"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Calculate CPU utilization using two samples
read -r cpu user nice system idle iowait irq softirq steal rest < /proc/stat
IDLE1=$((idle + iowait))
TOTAL1=$((user + nice + system + idle + iowait + irq + softirq + steal))

sleep 1

read -r cpu user nice system idle iowait irq softirq steal rest < /proc/stat
IDLE2=$((idle + iowait))
TOTAL2=$((user + nice + system + idle + iowait + irq + softirq + steal))

TOTAL_DIFF=$((TOTAL2 - TOTAL1))
IDLE_DIFF=$((IDLE2 - IDLE1))

if (( TOTAL_DIFF > 0 )); then
    CPU_USAGE=$(( (100 * (TOTAL_DIFF - IDLE_DIFF)) / TOTAL_DIFF ))
else
    CPU_USAGE=0
fi

# Calculate memory utilization
MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')

# Calculate root filesystem disk utilization
DISK_USAGE=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')

# Begin report
{
    echo "=================================================="
    echo "Timestamp: $TIMESTAMP"
    echo "Hostname: $(hostname)"
    echo "CPU Usage: ${CPU_USAGE}%"
    echo "Memory Usage: ${MEMORY_USAGE}%"
    echo "Root Disk Usage: ${DISK_USAGE}%"

    # Threshold checks
    if (( CPU_USAGE >= CPU_THRESHOLD )); then
        echo "ALERT: CPU usage is above threshold"
    else
        echo "OK: CPU usage is normal"
    fi

    if (( MEMORY_USAGE >= MEMORY_THRESHOLD )); then
        echo "ALERT: Memory usage is above threshold"
    else
        echo "OK: Memory usage is normal"
    fi

    if (( DISK_USAGE >= DISK_THRESHOLD )); then
        echo "ALERT: Disk usage is above threshold"
    else
        echo "OK: Disk usage is normal"
    fi

    # Service checks
    for SERVICE in "${SERVICES[@]}"; do
        if systemctl is-active --quiet "$SERVICE"; then
            echo "OK: Service $SERVICE is running"
        else
            echo "ALERT: Service $SERVICE is not running"
        fi
    done

    echo "=================================================="
    echo
} | tee -a "$LOG_FILE"


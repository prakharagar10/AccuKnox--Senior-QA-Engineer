#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90

# Log file location
LOG_FILE="/var/log/system_health.log"

# Function to log alerts
log_alert() {
            local message=$1
                echo "$(date) : $message" | tee -a $LOG_FILE
        }

        # Check CPU usage
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
        if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
                    log_alert "ALERT: CPU usage is above threshold! Usage: $cpu_usage%"
        fi

        # Check memory usage
        mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
        if (( $(echo "$mem_usage > $MEM_THRESHOLD" | bc -l) )); then
                    log_alert "ALERT: Memory usage is above threshold! Usage: $mem_usage%"
        fi

        # Check disk space usage
        disk_usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
        if [ $disk_usage -gt $DISK_THRESHOLD ]; then
                    log_alert "ALERT: Disk space usage is above threshold! Usage: $disk_usage%"
        fi

        # Check the number of running processes
        process_count=$(ps aux | wc -l)
        log_alert "INFO: Current number of running processes: $process_count"
        echo $disk_usage
        echo $mem_usage
        echo $cpu_usage
        echo "System health check completed!"

#!/bin/bash

# Application URL to check
URL="http://localhost:80"

# Log file location
LOG_FILE="/var/log/app_health.log"

# Function to log the application status
log_status() {
            local message=$1
                echo "$(date) : $message" | tee -a $LOG_FILE
        }

        # Make an HTTP request and get the status code
        status_code=$(curl -o /dev/null -s -w "%{http_code}" $URL)

        # Check the HTTP status code and determine the application's health
        if [ "$status_code" -eq 200 ]; then
                    log_status "Application is UP. Status code: $status_code"
            else
                        log_status "Application is DOWN or not responding. Status code: $status_code"
        fi

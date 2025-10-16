#!/bin/bash
LOG_FILE="/var/log/petfinder.log"
ALERT_FILE="/var/log/petfinder_alerts.log"
THRESHOLD=5       # Number of errors in 1 minute to trigger alert
TEMP_FILE="/tmp/petfinder_errors.tmp"

# Create alert log file if it doesn't exist
touch $ALERT_FILE
rotate_logs() {
    if [ -f "$LOG_FILE" ]; then
        TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
        mv "$LOG_FILE" "${LOG_FILE}.${TIMESTAMP}"
        touch "$LOG_FILE"
        echo "[$(date)] Log rotated: ${LOG_FILE}.${TIMESTAMP}" >> "$ALERT_FILE"
    fi
}

monitor_errors() {
    # Count HTTP 500 errors in the last 1 minute
    ERROR_COUNT=$(tail -n 1000 "$LOG_FILE" | grep "HTTP/1.[01]\" 500" | wc -l)

    if [ "$ERROR_COUNT" -ge "$THRESHOLD" ]; then
        echo "[$(date)] ALERT: High error rate detected! Count: $ERROR_COUNT" >> "$ALERT_FILE"
    fi
}

while true; do
    monitor_errors
    rotate_logs
    sleep 60
done


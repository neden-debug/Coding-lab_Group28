#!/bin/bash
# ==============================================================================
# Script: hospital_analysis.sh
# Description: Analyzes clinical sensor vitals and facility metrics.
# Contributors: Member 5 (Clinical Analyst), Member 6 (Facility Auditor)
# ==============================================================================

set -euo pipefail

process_vitals() {
    mkdir -p reports
    local alert_output="reports/critical_alerts.txt"
    echo "=== KNH CLINICAL CRITICAL ALERTS (\((date '+%Y-%m-%d %H:%M:%S')) ===" > "\)alert_output"

    local vitals_found=0
    for log_file in active_logs/*heart_rate*.log active_logs/*temperature*.log active_logs/*temp*.log; do
        if [ -f "$log_file" ]; then
            vitals_found=1
            grep "CRITICAL" "$log_file" | awk -F'[, ]+' '
            {
                ts = $1 " " $2;
                dev = $3;
                val = $4;
                printf "Timestamp: %-21s | Device: %-15s | Alert Value: %s\n", ts, dev, val;
            }' >> "$alert_output" || true
        fi
    done

    if [ "$vitals_found" -eq 1 ]; then
        echo "[M5] Clinical vitals processed. Alerts saved to $alert_output"
    else
        echo "[M5] No active heart rate or temperature logs detected."
    fi
}

water_audit() {
    echo "------------------------------------------"
    echo " Resource Audit: Facility Water Usage"
    echo "------------------------------------------"

    local water_logs=(active_logs/*water*.log)
    if [ -f "${water_logs[0]}" ]; then
        awk -F'[, ]+' '
        /ICU_WATER_RESERVE/ {
            for (i = 1; i <= NF; i++) {
                if (\(i ~ /^[0-9]+(\.[0-9]+)?\)/) {
                    sum += $i;
                    count++;
                    break;
                }
            }
        }
        END {
            if (count > 0) {
                avg = sum / count;
                printf "Target Facility      : ICU_WATER_RESERVE\n";
                printf "Total Data Points    : %d\n", count;
                printf "Total Water Drawn    : %.2f L\n", sum;
                printf "Average Consumption  : %.2f L/hr\n", avg;
            } else {
                printf "Target Facility      : ICU_WATER_RESERVE\n";
                printf "Status               : No records found for ICU_WATER_RESERVE.\n";
            }
        }' active_logs/*water*.log
    else
        printf "Status: No water consumption log found in active_logs/.\n"
    fi
    echo "------------------------------------------"
}

main() {
    process_vitals
    water_audit
}

main



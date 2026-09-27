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
            # Filter for CRITICAL alert entries
            grep "CRITICAL" "$log_file" || true
        fi
    done
}

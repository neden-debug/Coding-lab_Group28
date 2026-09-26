#!/usr/bin/env bash

set -o pipefail

ACTIVE_LOGS="${ACTIVE_LOGS:-active_logs}"
REPORTS="${REPORTS:-reports}"
CRITICAL_REPORT="$REPORTS/critical_alerts.txt"

process_vitals() {
    local -a vital_logs=()
    local log_file

    mkdir -p "$REPORTS" || return 1
    printf 'Timestamp,Device_ID,Value\n' > "$CRITICAL_REPORT" || return 1

    while IFS= read -r -d '' log_file; do
        vital_logs+=("$log_file")
    done < <(find "$ACTIVE_LOGS" -maxdepth 1 -type f \
        \( -iname '*heart*rate*.log' -o -iname '*temperature*.log' \) -print0 2>/dev/null)

    if ((${#vital_logs[@]} == 0)); then
        printf 'No heart rate or temperature logs found in %s.\n' "$ACTIVE_LOGS"
        return 0
    fi

    grep -h 'CRITICAL' "${vital_logs[@]}" |
        awk -F',' '
            {
                for (field = 1; field <= 3 && field <= NF; field++) {
                    gsub(/^[[:space:]]+|[[:space:]]+$/, "", $field)
                }
                if (NF >= 3) {
                    printf "%s,%s,%s\n", $1, $2, $3
                }
            }
        ' >> "$CRITICAL_REPORT"

    if [[ $(wc -l < "$CRITICAL_REPORT") -eq 1 ]]; then
        printf 'No critical vitals found; empty report saved to %s.\n' "$CRITICAL_REPORT"
    else
        printf 'Critical alerts saved to %s.\n' "$CRITICAL_REPORT"
    fi
}

water_audit() {
    local -a water_logs=()
    local log_file

    while IFS= read -r -d '' log_file; do
        water_logs+=("$log_file")
    done < <(find "$ACTIVE_LOGS" -maxdepth 1 -type f \
        \( -iname '*water*.log' -o -iname '*usage*.log' \) -print0 2>/dev/null)

    if ((${#water_logs[@]} == 0)); then
        printf 'No water usage logs found in %s.\n' "$ACTIVE_LOGS"
        return 0
    fi

    grep 'ICU_WATER_RESERVE' "${water_logs[@]}" |
        awk -F',' '
            {
                for (field = 1; field <= NF; field++) {
                    gsub(/^[[:space:]]+|[[:space:]]+$/, "", $field)
                }
                if ($2 == "ICU_WATER_RESERVE" && $3 ~ /^-?[0-9]+([.][0-9]+)?$/) {
                    total += $3
                    count++
                }
            }
            END {
                if (count > 0) {
                    printf "ICU_WATER_RESERVE average usage: %.2f (%d readings)\n", total / count, count
                } else {
                    printf "No numeric ICU_WATER_RESERVE readings found.\n"
                }
            }
        '
}

process_vitals
water_audit
#!/bin/bash
# ==============================================================================
# Script: hospital_archive.sh
# Description: Rotates active logs to archived_logs with timestamping.
# Contributor: Member 4 (The Archivist)
# ==============================================================================

set -euo pipefail

rotate_logs() {
    mkdir -p active_logs archived_logs
    local timestamp
    timestamp=$(date '+%Y%m%d_%H%M')
    echo "=== Initiating Log Rotation at $timestamp ==="

    shopt -s nullglob
    local files=(active_logs/*.log)
    shopt -u nullglob

    if [ ${#files[@]} -eq 0 ]; then
        echo "No active log files to rotate in active_logs/."
        return 0
    fi

    for file in "${files[@]}"; do
        local filename
        filename=\((basename "\)file")
        local name="${filename%.*}"
        local ext="${filename##*.}"

        local archive_destination="archived_logs/\({name}_\){timestamp}.${ext}"
        echo "Moving: \(file ->\)archive_destination"
        mv "\(file" "\)archive_destination"

        # System continuity: recreate empty log file so Python engine keeps logging
        touch "$file"
        echo "Recreated empty active log for continuity: $file"
    done

    echo "=== Rotation Complete ==="
}

rotate_logs

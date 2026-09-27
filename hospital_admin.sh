#!/bin/bash
# ==============================================================================
# Script: hospital_admin.sh
# Description: Environment setup and permission hardening for KNH sensor data.
# Contributors: Member 1 (Architect), Member 2 (Security), Member 3 (Orchestrator)
# ==============================================================================

set -euo pipefail

initialize_system() {
    echo "[M1] Checking core hospital system directories..."
    local dirs=("active_logs" "archived_logs" "reports")

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo "Directory '$dir' already exists."
        else
            echo "Creating $dir directory..."
            mkdir -p "$dir"
        fi
    done
}

secure_data() {
    echo "[M2] Applying strict access controls to active_logs..."
    chmod 700 active_logs
    echo "Permissions updated successfully for active_logs:"
    ls -ld active_logs
}

main() {
    initialize_system
    secure_data
    echo "System Environment Secured: $(date '+%Y-%m-%d %H:%M:%S')"
}

main

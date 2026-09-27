#!/bin/bash
# KNH Digital Infrastructure - Admin & Setup Script

set -euo pipefail

initialize_system() {
    echo "[M1] Checking core hospital system directories..."
    local dirs=("active_logs" "archived_logs" "reports")

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo "Directory '$dir' already exists."
        else
            mkdir -p "$dir"
        fi
    done
}

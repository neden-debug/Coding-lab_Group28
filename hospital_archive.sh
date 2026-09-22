#!/bin/bash
# hospital_archive.sh - Member 4 (The Archivist)
# Moves logs from active_logs to archived_logs with a timestamp,
# then recreates empty logs so the Python engine can keep recording.

ACTIVE_DIR="active_logs"
ARCHIVE_DIR="archived_logs"

echo "Starting log archiving process..."

if [ ! -d "$ACTIVE_DIR" ]; then
    echo "Error: $ACTIVE_DIR not found. Run hospital_admin.sh first."
    exit 1
fi
mkdir -p "$ARCHIVE_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M")

shopt -s nullglob
logs=("$ACTIVE_DIR"/*.log)
if [ ${#logs[@]} -eq 0 ]; then
    echo "No log files found in $ACTIVE_DIR. Nothing to archive."
    exit 0
fi

for log_file in "${logs[@]}"; do
    filename=$(basename "$log_file")
    base="${filename%.log}"
    new_name="${base}_${TIMESTAMP}.log"

    echo "Archiving $filename to $ARCHIVE_DIR/$new_name"
    mv "$log_file" "$ARCHIVE_DIR/$new_name"

    touch "$ACTIVE_DIR/$filename"
    echo "Recreated empty $filename in $ACTIVE_DIR/"
done

echo "Log rotation complete - $(date)"

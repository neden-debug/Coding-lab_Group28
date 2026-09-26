#!/bin/bash

initialize_system() {
    if [ ! -d "active_logs" ]; then
        echo "Creating active_logs directory..."
        mkdir "active_logs"
    else
        echo "Directory active_logs already exists."
    fi

    if [ ! -d "archived_logs" ]; then
        echo "Creating archived_logs directory..."
        mkdir "archived_logs"
    else
        echo "Directory archived_logs already exists."
    fi

    if [ ! -d "reports" ]; then
        echo "Creating reports directory..."
        mkdir "reports"
    else
        echo "Directory reports already exists."
    fi
}

initialize_system



#!/bin/bash

initialize_system() {
    if [ ! -d "active_logs" ]; then
        mkdir "active_logs"
    fi

    if [ ! -d "archived_logs" ]; then
        mkdir "archived_logs"
    fi

    if [ ! -d "reports" ]; then
        mkdir "reports"
    fi
}

initialize_system

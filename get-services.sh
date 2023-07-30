#!/bin/bash

status="all"  # Default status (all services)

print_services_json() {
    local status="$1"
    local services_list
    if [[ "$status" == "all" ]]; then
        services_list=$(systemctl list-units --type=service --all --no-pager --plain --no-legend)
    else
        services_list=$(systemctl list-units --type=service --state="$status" --no-pager --plain --no-legend)
    fi

    local json_output='{"services": ['
    local first=true
    while read -r unit load active sub description; do
        if $first; then
            first=false
        else
            json_output+=","
        fi
        json_output+="\n{\"unit\": \"$unit\", \"load\": \"$load\", \"active\": \"$active\", \"sub\": \"$sub\", \"description\": \"$description\"}"
    done <<< "$services_list"

    json_output+="\n]}"
    echo -e "$json_output" | jq .
}

if [[ $# -eq 1 ]]; then
    case "$1" in
        running)
            status="running"
            ;;
        exited)
            status="exited"
            ;;
        all)
            status="all"
            ;;
        *)
            echo "Invalid status option. Usage: $0 [running|exited|all]"
            exit 1
            ;;
    esac
fi

print_services_json "$status"

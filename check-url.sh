#!/bin/bash

if ! command -v torsocks &> /dev/null; then
    read -p "Torsocks is not installed. Do you want to install it? [y/n]: " torsocks_response
    if [[ $torsocks_response == "y" ]]; then
        sudo apt install torsocks -y
    else
        echo "Torsocks is required to run this script. Exiting..."
        exit 1
    fi
fi

if [[ -z "$1" ]]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

url="$1"
response=$(torsocks curl -s -I "$url" --max-time 10)
echo "$response"

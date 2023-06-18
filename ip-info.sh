#!/bin/bash
#
# This bash script is used to get the location of a IP address.
#
# Author: Cavoq
#
# Usage: ./ip-info.sh <ip_address>

IP_API="http://ip-api.com/json"

if [ $# -ne 1 ]; then
    echo "Usage: ./get_location.sh <ip_address>"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    sudo apt install curl -y
fi

if ! command -v jq &> /dev/null; then
    sudo apt install jq -y
fi

ip_address="$1"

response=$(curl -s "https://ipinfo.io/$ip_address/json")
echo "$response" | jq

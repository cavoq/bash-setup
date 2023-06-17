#!/bin/bash
#
# This bash script is used to obtain basic info from github of a user.
#
# Author: Cavoq
#
# Usage: ./gihub-info.sh <username>

GITHUB_API="https://api.github.com"

if [ $# -ne 1 ]; then
    echo "Usage: ./github-info.sh <username>"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    sudo apt install curl -y
fi

if ! command -v jq &> /dev/null; then
    sudo apt install jq -y
fi

echo "Getting info for user: $1..."

if ! curl -s "$GITHUB_API/users/$1" | jq; then
    echo "Failed to get info for user: $1..."
    exit 1
fi

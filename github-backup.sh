#!/bin/bash
#
# This bash script is used to backup all repositories of a user.
# It will create a tarball of all repositories in the specified directory.
# To recover the repositories, simply untar the tarball.
#
# Author: Cavoq
#
# Usage: ./gihub-backup.sh <username> <backup_dir> <github_token>

GITHUB_API="https://api.github.com"

if [ $# -ne 3 ]; then
    echo "Usage: ./github-backup.sh <username> <backup_dir> <token>"
    exit 1
fi

username="$1"
backup_dir="$2"
token="$3"

mkdir -p "$backup_dir"

echo "Retrieving repositories..."
repos=$(curl -s -H "Authorization: token $token" "$GITHUB_API/users/$username/repos?type=all&per_page=100" | jq -r '.[].name')

for repo in $repos; do
    echo "Backing up $repo..."
    git clone "https://github.com/$username/$repo.git" "$backup_dir/$repo"
done

backup_file="$backup_dir/github_backup_$(date +"%Y%m%d%H%M%S").tar.gz"
tar -czvf "$backup_file" -C "$backup_dir" .

for repo in $repos; do
    rm -rf "$backup_dir/$repo"
done

echo "Backup completed! Tarball created: $backup_file"

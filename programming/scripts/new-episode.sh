#!/bin/bash
# Usage: ./scripts/new-episode.sh "episode-slug"
# Creates a new episode log file from template.

SLUG=${1:-"untitled-episode"}
DATE=$(date +"%Y-%m-%d")
FILENAME="culture/episodes/${DATE}-${SLUG}.md"

cp culture/episodes/YYYY-MM-DD-example-episode.md "$FILENAME"
sed -i "s/YYYY-MM-DD/${DATE}/g" "$FILENAME"

echo "Created: $FILENAME"

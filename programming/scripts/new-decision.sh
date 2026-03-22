#!/bin/bash
# Usage: ./scripts/new-decision.sh "my-decision-slug"
# Creates a new design decision file from template.

SLUG=${1:-"untitled-decision"}
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
FILENAME="culture/decisions/${TIMESTAMP}-${SLUG}.md"

cp genome/schemas/decision-entry.md "$FILENAME"
sed -i "s/YYYY-MM-DD-HHMM-<slug>/${TIMESTAMP}-${SLUG}/g" "$FILENAME"
sed -i "s/YYYY-MM-DD/$(date +%Y-%m-%d)/g" "$FILENAME"

echo "Created: $FILENAME"

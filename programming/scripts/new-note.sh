#!/bin/bash
# Usage: ./scripts/new-note.sh "topic-slug"
# Creates a new learning note from template.

SLUG=${1:-"untitled-note"}
DATE=$(date +"%Y-%m-%d")
FILENAME="learning/notes/${DATE}-${SLUG}.md"

cat > "$FILENAME" << NOTEEOF
---
date: ${DATE}
topic: ${SLUG}
source: 
tags: []
---

# $(echo $SLUG | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); print}')

## Key insight


## Details


## Questions / open threads
- ?

## Connection to project

NOTEEOF

echo "Created: $FILENAME"

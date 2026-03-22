---
pattern: librarian-distillation
version: 0.1.0
tags: [memory, meta, maintenance]
---

# Librarian Distillation Pattern

## Overview
A periodic maintenance loop that converts raw cultural artifacts (episodes, inbox) into durable insights, and proposes genome updates when patterns stabilize.

## Cycle
```
[culture/episodes/]  [culture/inbox/]
         |                 |
         +--------+--------+
                  | (weekly or on-demand)
                  v
           [Librarian Agent]
                  |
                  v
         culture/insights/
                  |
                  | (when pattern appears 3+ times)
                  v
  [Proposed genome update]  --> [Human review] --> genome/
                  |
                  v
  culture/episodes/YYYY-MM-DD-distillation.md
```

## Distillation rules
1. An episode becomes an insight if it contains a reusable pattern or surprising finding.
2. An insight becomes a policy when it has appeared in 3+ episodes or been validated by the Critic.
3. A policy becomes a genome update when it is stable across 2+ projects or retrospectives.

## Related
- `genome/agents/librarian.md`
- `culture/insights/_template.md`

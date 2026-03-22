---
pattern: librarian-distillation
version: 0.1.0
tags: [memory, meta, maintenance]
---

# Librarian Distillation Pattern

## Overview
A periodic maintenance loop that converts raw memory artifacts (episodes, inbox) into durable insights, and proposes schema updates when patterns stabilize.

## Cycle
```
[memory/episodes/]  [memory/inbox/]
         |                 |
         +--------+--------+
                  | (weekly or on-demand)
                  v
           [Librarian Agent]
                  |
                  v
         memory/insights/
                  |
                  | (when pattern appears 3+ times)
                  v
  [Proposed schema update]  --> [Human review] --> schema/
                  |
                  v
  memory/episodes/YYYY-MM-DD-distillation.md
```

## Distillation rules
1. An episode becomes an insight if it contains a reusable pattern or surprising finding.
2. An insight becomes a policy when it has appeared in 3+ episodes or been validated by the Critic.
3. A policy becomes a schema update when it is stable across 2+ projects or retrospectives.

## Related
- `schema/agents/librarian.md`
- `memory/insights/_template.md`

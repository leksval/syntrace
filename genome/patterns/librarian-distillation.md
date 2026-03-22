---
pattern: librarian-distillation
version: 0.1.0
tags: [memory, meta, maintenance]
---

# Librarian Distillation Pattern

## Overview
A periodic maintenance loop that converts raw cultural artifacts (episodes, inbox) into durable structured memory, and proposes genome updates when patterns stabilize.

## Cycle
```
[culture/episodes/]  [learning/inbox/]
         │                 │
         └────────┬────────┘
                  │ (weekly or on-demand)
                  ▼
           [Librarian Agent]
                  │
         ┌────────┴──────────────┐
         ▼                       ▼
  memory/semantic/         memory/procedural/
  memory/episodic/
         │
         │ (when pattern appears 3+ times)
         ▼
  [Proposed genome update]  ──► [Human review] ──► genome/
         │
         ▼
  culture/retrospectives/YYYY-MM-DD-distillation.md
```

## Distillation rules
1. An episode becomes a semantic memory if it contains a reusable pattern or surprising finding.
2. A pattern becomes procedural memory when it has appeared in 3+ episodes or been validated by the Critic.
3. Procedural memory becomes a genome update when it is stable across 2+ projects or retrospectives.

## Related
- `genome/agents/librarian.md`
- `genome/schemas/memory-entry.md`

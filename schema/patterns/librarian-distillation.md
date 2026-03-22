---
pattern: librarian-distillation
version: 0.2.0
tags: [memory, meta, maintenance]
---

# Librarian Distillation Pattern

## Overview

A maintenance loop that converts raw captures (inbox, episodes) into durable insights, and proposes schema updates when patterns stabilize.

## Trigger

`/distill` — run on-demand or weekly during retrospective.

## Workflow

```
1. Scan memory/inbox/ for unprocessed captures
2. Scan recent memory/episodes/ for patterns
3. For each reusable finding:
   a. Create or update memory/insights/YYYY-MM-DD-slug.md
   b. Increment episode_count on existing insights
4. For insights with episode_count >= 3:
   a. Propose schema update (schema/patterns/ or schema/policies/)
   b. Flag for human review before applying
5. Log this run as memory/episodes/YYYY-MM-DD-distillation.md
6. Delete or archive processed inbox items
```

## Distillation rules

1. An inbox item or episode becomes an insight if it contains a reusable pattern or surprising finding.
2. An insight is flagged for schema promotion when `episode_count >= 3` or validated by the Critic.
3. Every schema change requires a decision record in `memory/decisions/`.

## Cycle diagram

```
[memory/inbox/]  [memory/episodes/]
       |                 |
       +--------+--------+
                | (/distill)
                v
         [Librarian Agent]
                |
    +-----------+-----------+
    |                       |
    v                       v
memory/insights/    [Schema proposal]
(new or updated)    (if episode_count >= 3)
                          |
                          v
                   [Human review] --> schema/
                          |
                          v
                   memory/decisions/
```

## Related

- `schema/agents/librarian.md`
- `memory/insights/_template.md`
- `memory/inbox/_template.md`

---
date: YYYY-MM-DD
project: <project-name>
agent: <agent-name or "human">
outcome: SUCCESS | FAIL | SURPRISE | PARTIAL
tags: [tag1, tag2]
---

# Episode: <Short title>

## What happened
Brief description of the interaction or run.

## Key observations
- What worked well
- What failed or was unexpected
- Any surprising emergent behavior

## Reusable takeaways
- [ ] Pattern worth adding to `culture/insights/`?
- [ ] Policy worth adding to `genome/policies/`?
- [ ] Should this trigger a genome update?

## Raw trace (optional)
Keep only the essential parts. Prune verbose logs.

```
[agent]: ...
[tool]: ...
[result]: ...
```

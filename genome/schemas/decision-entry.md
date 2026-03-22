---
schema: decision-entry
version: 0.1.0
tags: [schema, decision, ADR]
---

# Design Decision Schema (ADR-style)

Use this format for all files in `culture/decisions/`.

Filename: `culture/decisions/YYYY-MM-DD-HHMM-<slug>.md`

```markdown
---
id: YYYY-MM-DD-HHMM-<slug>
status: proposed | accepted | superseded | deprecated
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [tag1, tag2]
supersedes: (optional path to old decision)
---

# <Short Decision Title>

## Context
What situation or problem led to this decision?
What constraints existed?

## Decision
What was decided? Be direct.

## Alternatives considered
- **Option A**: description, pros, cons
- **Option B**: description, pros, cons

## Consequences
- Positive: what gets better
- Negative: what gets worse or more complex
- Neutral: what changes but is neither better nor worse

## Related
- Links to genome files, memory entries, or other decisions
```

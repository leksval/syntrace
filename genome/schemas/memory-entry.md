---
schema: memory-entry
version: 0.1.0
tags: [schema, memory]
---

# Memory Entry Schema

Use this format for all files in `memory/semantic/`, `memory/procedural/`, `memory/episodic/`.

```markdown
---
id: YYYY-MM-DD-<slug>
type: semantic | procedural | episodic
confidence: low | medium | high
created: YYYY-MM-DD
updated: YYYY-MM-DD
source: episode/<filename> | experiment/<filename> | human
tags: [tag1, tag2]
related: [path/to/related.md]
---

# <Title>

## Summary
One paragraph. What is this memory? Why does it matter?

## Detail
Full content. Concrete examples, edge cases, code snippets if relevant.

## When to apply
Conditions under which this memory should be retrieved and used.

## Confidence notes
Why this confidence level? What would increase or decrease it?

## History
- YYYY-MM-DD: created from <source>
- YYYY-MM-DD: updated because <reason>
```

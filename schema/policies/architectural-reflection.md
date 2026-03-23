---
id: 2026-03-23-architectural-reflection
type: howto
confidence: high
created: 2026-03-23
updated: 2026-03-23
source: human
tags: [architecture, reflection, save-protocol]
---

# Architectural Reflection

Standing checklist consulted during the reflect step of `/syntrace` and `/syntrace full`. Use these questions to surface project-level lessons that domain-focused reflection tends to miss.

## Checklist

- [ ] Did a structural/architectural pattern prove useful or fragile?
- [ ] Is there a spec-vs-implementation gap (docs say X, code does Y)?
- [ ] Did a missing file, config, or bootstrap step cause silent degradation?
- [ ] Is there unnecessary complexity (duplicate modes, too many tiers, dead config)?
- [ ] What from this project would you copy into a new project tomorrow?

## Guidance

Not every question will apply to every session. Scan the list; if any question triggers a concrete observation, capture it as an insight (`memory/insights/`) with appropriate tags (e.g., `architecture`, `process`, `tooling`).

## History

- 2026-03-23: initialized

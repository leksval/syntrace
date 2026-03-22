---
date: 2026-03-22
project: syntrace
agent: human
outcome: SUCCESS
duration: ~20min
tags: [naming, clarity, meta, genome-change]
---

# Episode: Rename confusing terms for memorability and obviousness

## What happened
Audited every name in the workspace -- folder names, field names, field values, agent names, section headings, pattern names. Identified six that required prior context or explanation to understand. Applied renames across all affected files.

## Key observations
- The `orchestrator` / `planner` dual-name was the most confusing: the agent was "orchestrator" but the pattern it lived in was called "planner-worker-critic"
- `semantic` / `procedural` are textbook terms that made people pause; `concept` / `howto` passed the "ask a stranger" test
- `supersedes` is the kind of word you learn once and forget -- `replaces` just works
- "Distillable patterns" used a word that isn't common outside chemistry; "Reusable takeaways" says the same thing in plain language
- The `example-semantic-memory.md` file used "memory" which was removed from the architecture in a prior simplification

## Reusable takeaways
- [x] Name everything so a newcomer understands it without a glossary
- [ ] Policy worth adding to `genome/policies/`? Consider a naming policy if this recurs

## Insights produced
- (none yet -- the principle "names should be obvious without context" could become an insight if it recurs)

## Raw trace (optional)
Files modified: `genome/agents/planner.md` (new), `genome/agents/orchestrator.md` (deleted), `genome/patterns/planner-worker-critic.md`, `genome/agents/worker.md`, `genome/policies/quality-standards.md`, `docs/architecture.md`, `culture/decisions/_template.md`, `culture/decisions/YYYY-MM-DD-HHMM-example-decision.md`, `culture/episodes/_template.md`, `culture/episodes/_template-retrospective.md`, `culture/episodes/YYYY-MM-DD-example-episode.md`, `culture/episodes/2026-03-22-template-improvements.md`, `culture/insights/_template.md`, `culture/insights/example-insight.md` (new), `culture/insights/example-semantic-memory.md` (deleted), `AGENTS.md`, `CHANGELOG.md`.

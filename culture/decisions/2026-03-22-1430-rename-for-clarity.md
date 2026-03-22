---
id: 2026-03-22-1430-rename-for-clarity
status: accepted
created: 2026-03-22
updated: 2026-03-22
tags: [naming, clarity, genome-change]
replaces:
---

# Rename confusing terms across workspace for memorability and obviousness

## Context
Several names in the workspace were inherited from academic terminology or prior iterations. They required explanation to understand, slowing down onboarding and increasing the chance of misuse. The standard: every name should be instantly understandable without prior context.

## Decision
Apply six renames:

| Before | After | Why |
|--------|-------|-----|
| `orchestrator` (agent) | `planner` | Pattern already called "planner-worker-critic"; two names for one role caused confusion |
| `example-semantic-memory.md` | `example-insight.md` | "memory" was a dead term from a prior architecture; "insight" matches current vocabulary |
| `semantic` / `procedural` (insight types) | `concept` / `howto` | Academic jargon; "is this a concept or a how-to?" is instantly clear |
| `Distillable patterns` (section heading) | `Reusable takeaways` | "Distillable" is uncommon; "reusable takeaways" is plain language |
| `supersedes` / `superseded` (decision field/status) | `replaces` / `replaced` | Formal/legal language; "replaces" is universally understood |
| `Distillation summary` (retro heading) | `Knowledge promoted` | Describes the actual action, not the metaphor |

## Alternatives considered
- **Keep current names**: familiar to existing users, but the project is early enough that renaming cost is near zero
- **Partial rename** (only the worst offenders): less disruption but leaves inconsistencies

## Consequences
- Positive: every name is now self-explanatory; no glossary needed
- Positive: `planner` matches the pattern name, eliminating the orchestrator/planner confusion
- Negative: anyone who memorized old names needs to re-learn (low cost given project age)
- Neutral: genome files were modified (agent renamed, policy type value changed)

## Related
- `genome/agents/planner.md` (renamed from orchestrator.md)
- `genome/policies/quality-standards.md` (type value changed)
- `genome/patterns/planner-worker-critic.md` (cross-references updated)
- `culture/insights/_template.md` (type values changed)
- `culture/decisions/_template.md` (field/status renamed)

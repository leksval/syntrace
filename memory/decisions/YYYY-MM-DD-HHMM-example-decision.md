---
id: 2026-01-20-1400-use-planner-worker-critic
status: accepted
created: 2026-01-20
updated: 2026-01-20
tags: [architecture, multi-agent]
replaces:
related: [schema/patterns/planner-worker-critic.md, schema/agents/planner.md]
---

# Use planner-worker-critic as default multi-agent pattern

## Context
Needed a multi-agent pattern that prevents agents from grading their own work. Single-agent loops showed quality degraded without external review.

## Decision
Adopt the planner-worker-critic pattern for all multi-step tasks.

## Alternatives considered
- **Single agent loop**: simpler but no external validation
- **Human-in-the-loop every step**: too slow for automation

## Consequences
- Positive: quality improves; clear separation of concerns
- Negative: adds latency (two extra LLM calls per cycle)
- Neutral: requires Critic calibration per domain

## Related
- `schema/patterns/planner-worker-critic.md`
- `schema/agents/planner.md`
- `schema/agents/critic.md`

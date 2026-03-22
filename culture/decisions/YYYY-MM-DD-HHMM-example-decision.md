---
id: YYYY-MM-DD-HHMM-example-decision
status: accepted
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [example, architecture]
supersedes:
---

# Example: Use planner-worker-critic pattern as default

## Context
We needed a multi-agent pattern that prevents agents from grading their own work. Initial experiments with single-agent loops showed quality degraded without external review.

## Decision
Adopt the planner-worker-critic pattern (see `genome/patterns/planner-worker-critic.md`) as the default for all multi-step tasks.

## Alternatives considered
- **Single agent loop**: simpler but no external validation
- **Human-in-the-loop at every step**: too slow for automation

## Consequences
- Positive: quality improves; clear separation of concerns
- Negative: adds latency (two extra LLM calls per task cycle)
- Neutral: requires Critic agent to be calibrated per domain

## Related
- `genome/patterns/planner-worker-critic.md`
- `genome/agents/critic.md`

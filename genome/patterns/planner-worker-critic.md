---
pattern: planner-worker-critic
version: 0.1.0
tags: [architecture, multi-agent, review]
---

# Planner → Worker → Critic Pattern

## Overview
A three-node cycle that separates planning, execution, and review. Prevents agents from grading their own work.

## Graph
```
[User / Goal]
      │
      ▼
[Orchestrator / Planner]  ──────────────────────────┐
      │                                             │
      │ subtask                                     │ revised task
      ▼                                             │
  [Worker]  ──── result ──►  [Critic]  ──REVISE──►──┘
                                │
                              PASS
                                │
                                ▼
                         [Orchestrator]  ──► [Output]
```

## When to use
- Any task requiring quality assurance
- When output errors are costly
- When multiple workers produce results to be ranked or merged

## When NOT to use
- Simple, single-step, low-stakes tasks (adds unnecessary latency)
- Real-time interactive loops where critique cycle is too slow

## Failure modes
- Critic too strict → infinite revision loops (add max_revisions limit)
- Critic too lenient → garbage passes (calibrate with examples in `memory/procedural/quality-standards.md`)
- Planner over-decomposes → too many workers → coordination overhead

## Parameters
- `max_revisions`: 2 (default); increase for high-stakes tasks
- `critic_model`: can be smaller than worker model for efficiency

## Related
- `genome/agents/orchestrator.md`
- `genome/agents/worker.md`
- `genome/agents/critic.md`

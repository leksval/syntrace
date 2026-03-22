---
id: 2026-01-15-retry-with-backoff
type: howto
confidence: medium
episode_count: 3
created: 2026-01-15
updated: 2026-02-10
source: episode/2026-01-15-fix-api-timeout.md
tags: [api, reliability, retry, error-handling]
related: [schema/policies/quality-standards.md]
---

# Retry with exponential backoff on API timeouts

## Summary
When calling external APIs that intermittently timeout, exponential backoff with jitter reduces failure rates significantly compared to fixed-interval retries.

## Detail
Observed across 3 episodes. Fixed retry (1-second interval) caused thundering herd on rate-limited APIs. Exponential backoff (base 500ms, max 8s, ±10% jitter) reduced failures by ~70%.

## When to apply
- Any tool or agent making external HTTP/API calls
- When rate limits or timeouts appear in episode logs
- Especially during peak-traffic scenarios

## Confidence notes
Medium: validated in 3 episodes across 2 projects. Would increase to high after formal benchmarking or 5+ episodes.

## History
- 2026-01-15: created from episode/2026-01-15-fix-api-timeout.md
- 2026-02-10: updated with data from second project confirming the pattern

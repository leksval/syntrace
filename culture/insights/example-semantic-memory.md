---
id: YYYY-MM-DD-example-semantic
type: semantic
confidence: medium
created: YYYY-MM-DD
updated: YYYY-MM-DD
source: episode/YYYY-MM-DD-example-episode.md
tags: [example, pattern]
related: []
---

# Example: Retry with exponential backoff on API timeouts

## Summary
When calling external APIs that intermittently timeout, exponential backoff with jitter reduces total failure rate significantly compared to fixed-interval retries.

## Detail
Observed in 4+ episodes. Fixed retry (1s interval) caused thundering-herd on rate-limited APIs. Exponential backoff (base 2, max 30s, +/-10% jitter) reduced failures by ~70% in experiments.

## When to apply
- Any tool or agent making external HTTP/API calls
- Especially when rate limits or timeouts are observed in episodes

## Confidence notes
Medium: based on 4 project observations; not formally benchmarked.

## History
- YYYY-MM-DD: created from episode/YYYY-MM-DD-example-episode.md

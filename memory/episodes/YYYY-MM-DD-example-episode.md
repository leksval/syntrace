---
date: 2026-01-15
project: acme-api
agent: human
outcome: SUCCESS
duration: ~45min
tags: [api, error-handling, retry]
source: customer bug report #142
related: []
---

# Episode: Fix intermittent API timeout on payment endpoint

## What happened
Payment endpoint was timing out ~5% of requests during peak hours. Investigated and found the upstream payment provider has a 2-second SLA but our timeout was set to 1 second. Increased timeout to 3 seconds and added retry with exponential backoff.

## Key observations
- The 1-second timeout was a leftover from development defaults
- Adding retry with backoff reduced failure rate from 5% to 0.1%
- Jitter on the backoff prevented thundering herd when the provider recovered

## Reusable takeaways
- [x] Pattern worth adding to `memory/insights/`? Yes -- retry with exponential backoff
- [ ] Policy worth adding to `schema/policies/`? Not yet
- [ ] Should this trigger a schema update? No

## Insights produced
- memory/insights/2026-01-15-retry-with-backoff.md

## Raw trace (optional)
```
timeout_before: 1000ms
timeout_after: 3000ms
retry_strategy: exponential backoff, base=500ms, max=8s, jitter=±10%
failure_rate_before: 5.2%
failure_rate_after: 0.1%
```

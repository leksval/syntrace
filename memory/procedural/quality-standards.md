---
id: YYYY-MM-DD-quality-standards
type: procedural
confidence: high
created: YYYY-MM-DD
updated: YYYY-MM-DD
source: human
tags: [quality, critic, standards]
---

# Quality Standards

Standing policies the Critic agent uses when evaluating outputs.

## Mandatory checks
- [ ] Output matches schema defined in `genome/schemas/`
- [ ] No invariants from agent specs are violated
- [ ] No hallucinated tool outputs (verify actual tool was called)
- [ ] Rationale is present for non-obvious decisions

## Quality levels
- **PASS**: all mandatory checks pass; output is complete and coherent
- **REVISE**: minor issues; specific actionable critique provided
- **REJECT**: critical failure; major schema violation or invariant breach

## Domain-specific standards
<!-- Add domain-specific checks below as the project evolves -->

## History
- YYYY-MM-DD: initialized

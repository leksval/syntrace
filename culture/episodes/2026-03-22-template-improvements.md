---
date: 2026-03-22
project: syntrace
agent: human
outcome: SUCCESS
duration: ~30min
tags: [templates, tracking, meta, quality]
---

# Episode: Template tracking and learning improvements

## What happened
Reviewed the full workspace against project tracking and learning best practices. Identified gaps in schema consistency, traceability, and retrieval guidance. Applied targeted fixes to templates and documentation.

## Key observations
- The dual-inheritance architecture (genome/culture) is clean and minimal -- nothing needed removal
- Experiment and retrospective templates were missing the `outcome` field that base episodes define, breaking queryability across episode types
- No base episode `_template.md` existed despite the naming convention being used for experiment and retrospective subtypes
- Insights had no structured way to track how many episodes support them, making the "3+ episodes" promotion threshold a manual exercise
- "Before You Act" told agents to check insights but gave no guidance on how to search them
- Adding `duration` as an optional field across all episode types enables future effort estimation

## Distillable patterns
- [x] Schema consistency across sibling templates matters -- when subtypes diverge from the base schema, querying and automation break silently
- [ ] Policy worth adding to `genome/policies/`? Not yet -- observe whether the new fields are actually used first

## Insights produced
- (none yet -- monitor whether these changes improve Librarian processing and insight promotion)

## Raw trace (optional)
Changes made:
- Created `culture/episodes/_template.md` (base episode template)
- Added `outcome`, `duration` to `_template-experiment.md`
- Added `outcome`, `duration` to `_template-retrospective.md`
- Added `episode_count` to `culture/insights/_template.md`
- Added "How to search insights" section to `culture/insights/README.md`
- Updated `CHANGELOG.md`

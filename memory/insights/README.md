# Insights

Distilled reusable knowledge — patterns, concepts, and validated learnings.

Insights graduate from raw episodes, experiments, and research notes. When an insight is stable across multiple projects or retrospectives, it may be promoted to `schema/patterns/` or `schema/policies/`.

## File naming
`YYYY-MM-DD-<topic-slug>.md`

## When to create an insight
- An episode contains a reusable pattern or surprising finding
- A research note has been referenced 2+ times or validated through experiments
- A concept is worth preserving for future retrieval

## When to promote to schema/
When an insight has appeared in 3+ episodes, been validated by the Critic, or is stable across 2+ projects.

## How to search insights

Before starting new work, check existing insights using one of these strategies:

- **By tags** -- scan frontmatter `tags:` fields for keywords matching your task (e.g. `rg "tags:.*api" memory/insights/`).
- **By filename** -- filenames use `YYYY-MM-DD-<topic-slug>.md`; scan slugs for relevant topics.
- **By full-text search** -- grep the Summary or When-to-apply sections for domain terms (e.g. `rg "retry" memory/insights/`).
- **By confidence** -- filter to `confidence: high` insights when you need proven guidance; include `low` when exploring.
- **By recency** -- sort by date prefix to find the most recent learnings first.

When an insight matches, read its "When to apply" section to confirm relevance before acting on it.

## Template
See `_template.md` in this folder.

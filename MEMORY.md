# Syntrace Memory Router

This is a filesystem-native knowledge base. Folders and markdown only.

## Read: Before You Act

1. `schema/policies/` -- rules relevant to your task
2. `memory/insights/` -- prior knowledge and reusable patterns
3. `schema/patterns/` -- established workflows

## Write: After You Finish

Use `_template.md` in each folder. Every file needs YAML frontmatter with `tags: [...]`.

| What happened | Save to | Filename |
|---|---|---|
| Design choice | `memory/decisions/` | `YYYY-MM-DD-HHMM-slug.md` |
| Work log or experiment | `memory/episodes/` | `YYYY-MM-DD-slug.md` |
| Reusable pattern found | `memory/insights/` | `YYYY-MM-DD-slug.md` |
| Quick note | `memory/inbox/` | `YYYY-MM-DD-slug.md` |
| Notable change | `CHANGELOG.md` | Append line |

## Rules

- Never modify `schema/` without a decision record in `memory/decisions/`.
- Filenames: `YYYY-MM-DD` prefix, lowercase, hyphens, no spaces.
- Max ~300 lines per file.

## More

- [AGENTS.md](AGENTS.md) -- full schemas, checklist, conventions
- [docs/graph-queries.md](docs/graph-queries.md) -- graph traversal and cross-project queries

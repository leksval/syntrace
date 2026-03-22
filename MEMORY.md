# Syntrace Memory Router

This is a filesystem-native knowledge base. Agents from other projects write here to persist learnings. Everything is folders and markdown.

## Read: Before You Act

1. `genome/policies/` -- standing rules relevant to your task
2. `culture/insights/` -- prior knowledge and reusable patterns
3. `genome/patterns/` -- established workflows and playbooks

## Write: After You Finish

Determine what happened and save to the correct folder. Every file needs YAML frontmatter with `tags: [...]`. Use the `_template.md` in each folder.

| What happened | Save to | Filename pattern |
|---|---|---|
| Design choice | `culture/decisions/` | `YYYY-MM-DD-HHMM-slug.md` |
| Work log or experiment | `culture/episodes/` | `YYYY-MM-DD-slug.md` |
| Reusable pattern found | `culture/insights/` | `YYYY-MM-DD-slug.md` |
| Quick unstructured note | `culture/inbox/` | `YYYY-MM-DD-slug.md` |
| Notable change | `CHANGELOG.md` | Append: `[YYYY-MM-DD] type: description` |

## Knowledge Promotion Flow

```
work done ──→ culture/episodes/
                   ↓  distillation
              culture/insights/
                   ↓  stable across 3+ episodes
              genome/ (patterns, policies, agents)
                   ↓  always paired with
              culture/decisions/
```

## Quick Rules

- Never modify `genome/` without a decision record in `culture/decisions/`.
- Filenames: `YYYY-MM-DD` prefix, lowercase, hyphens, no spaces.
- Max ~300 lines per file; split if longer.
- Never commit secrets; use `.env`.
- CHANGELOG types: `init`, `agent`, `pattern`, `tool`, `decision`, `experiment`, `milestone`, `fix`.

## Full Reference

See [`AGENTS.md`](AGENTS.md) for frontmatter schemas, end-of-session checklist, and complete conventions.

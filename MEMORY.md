# Syntrace Memory Router

When triggered, follow the matching tier. Read `_template.md` in the target folder before writing.

| Trigger | Do this |
|---------|---------|
| `/syntrace` | Create `memory/context/YYYY-MM-DD-slug.md`. A few sentences, minimal frontmatter. Then reflect: did a reusable pattern emerge? If yes, also create an insight. |
| `/syntrace full` | Create `memory/episodes/YYYY-MM-DD-slug.md`. If a design choice was made, also create `memory/decisions/YYYY-MM-DD-HHMM-slug.md`. Append `changelog:` entries to `CHANGELOG.md`. Then reflect. |
| `/distill` | Scan context + episodes. Create/update insights. Flag `episode_count >= 3` for schema promotion. See `schema/patterns/librarian-distillation.md`. |

Auto-fill these fields -- never prompt for them:

| Field | Value |
|-------|-------|
| `date` / `created` / `updated` | Today's date |
| `agent` | Current agent or `"human"` |
| `project` | Workspace/project name |
| `source` | `"session"` unless more specific |
| `context_read` | Files consulted before writing |

Full reference: [AGENTS.md](AGENTS.md)

# Syntrace Memory Router

When triggered, follow the tier that matches.

---

## `/syntrace` — Quick save (default)

1. Review what happened this session.
2. Create `memory/inbox/YYYY-MM-DD-slug.md` (read `_template.md` in folder).
3. Frontmatter: `date` (auto), `tags`. Body: a few sentences or bullets.

## `/syntrace full` — Full save

1. Review what happened this session.
2. Create `memory/episodes/YYYY-MM-DD-slug.md` (read `_template.md` in folder).
3. If a design choice was made, also create `memory/decisions/YYYY-MM-DD-HHMM-slug.md`.
4. If a reusable pattern emerged, also create `memory/insights/YYYY-MM-DD-slug.md`.
5. If any file has a `changelog:` frontmatter field, auto-append it to `CHANGELOG.md`.

## `/distill` — Librarian distillation

1. Scan `memory/inbox/` and recent `memory/episodes/`.
2. Propose new insights or update existing ones in `memory/insights/`.
3. Flag any insight with `episode_count >= 3` for schema promotion.
4. Log the distillation run as an episode in `memory/episodes/`.
5. See `schema/patterns/librarian-distillation.md` for full rules.

## Auto-derived fields

Fill these automatically — never prompt for them:

| Field | Value |
|-------|-------|
| `date` / `created` / `updated` | Today's date |
| `agent` | Current agent or `"human"` |
| `project` | Workspace/project name |
| `source` | `"session"` unless more specific context exists |

---

Full reference: [AGENTS.md](AGENTS.md) — frontmatter schemas, conventions, workspace map.

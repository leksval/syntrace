# Syntrace -- Agent Orientation

You are working inside a Syntrace workspace: a filesystem-native, dual-inheritance knowledge architecture. Everything is folders and markdown.

---

## Workspace Map

| Path | Purpose |
|------|---------|
| `schema/agents/` | One `.md` per agent role -- responsibilities, inputs, outputs, invariants |
| `schema/patterns/` | Architectural patterns and playbooks for multi-agent workflows |
| `schema/policies/` | Standing rules and quality standards (Critic agent uses these) |
| `schema/tools.md` | Tool definitions, contracts, and agent assignments |
| `memory/decisions/` | ADR-style records explaining why something changed |
| `memory/episodes/` | Work logs, experiment results, retrospectives |
| `memory/insights/` | Distilled reusable knowledge extracted from episodes |
| `memory/context/` | Quick captures -- default landing zone for knowledge |
| `schema/graph-schema.json` | Node/edge type definitions for graph queries |
| `src/` | Source code |
| `tests/` | Tests |
| `CHANGELOG.md` | Human-readable project history (auto-appended from frontmatter) |

**Schema** = structural knowledge that rarely changes. Never modify without a decision record.
**Memory** = experiential knowledge that evolves continuously. Inbox is the default entry point.

---

## Knowledge Flow

```
work done ──→ memory/context/   (quick capture, default)
              memory/episodes/  (full save)
                   ↓  (distillation — /distill)
              memory/insights/
                   ↓  (when stable across 3+ episodes)
              schema/patterns/ or schema/policies/
                   ↓  (always paired with)
              memory/decisions/
```

---

## Before You Act

1. Check `schema/policies/` for rules relevant to your task.
2. Check `memory/insights/` for prior knowledge on the topic.
3. Check `schema/patterns/` for established workflows.
4. On first session, also read `schema/agents/` for role definitions.
5. For deeper retrieval, use graph queries -- see `schema/patterns/graph-scan.md` and `schema/graph-schema.json`.

---

## Save Protocol

Three tiers. Use the lightest one that fits.

### Tier 1: Quick save (`/syntrace`) — default

Create `memory/context/YYYY-MM-DD-slug.md`. Read `_template.md` in folder.

```yaml
---
date:        # auto
tags: []
---
```

Body: a few sentences or bullets. No structure required.
Use this for most sessions. Capture first, structure later.

After saving, **reflect**: did a reusable pattern, surprising finding, or recurring theme emerge? If yes, also create `memory/insights/YYYY-MM-DD-slug.md`. Also check `schema/policies/architectural-reflection.md` for project-level lessons.

### Tier 2: Full save (`/syntrace full`)

For sessions with significant work. Read `_template.md` in the target folder.

| What happened | Save to | Filename |
|---|---|---|
| Focused work, experiment, retro | `memory/episodes/` | `YYYY-MM-DD-slug.md` |
| Design or architecture choice | `memory/decisions/` | `YYYY-MM-DD-HHMM-slug.md` |
| Reusable pattern discovered | `memory/insights/` | `YYYY-MM-DD-slug.md` |

If a design choice was made, create **both** an episode and a decision.

After saving, **reflect**: step back and consider what insights emerged from this session. Check `memory/insights/` for existing ones that should be updated (increment `episode_count`). Create new insights for any reusable pattern, surprising finding, or lesson learned. Also check `schema/policies/architectural-reflection.md` for project-level lessons.

### Tier 3: Distill (`/distill`)

Periodic librarian run. See `schema/patterns/librarian-distillation.md`.
Scans context + episodes → proposes insights → flags schema promotions.

### Auto-derived fields

Fill these automatically — never prompt for them:

| Field | Value |
|-------|-------|
| `date` / `created` / `updated` | Today's date |
| `agent` | Current agent or `"human"` |
| `project` | Workspace/project name |
| `source` | `"session"` unless more specific context exists |
| `context_read` | List of file paths the agent read before writing this entry |

### CHANGELOG integration

When a change is notable, add `changelog:` to the frontmatter:

```yaml
changelog: "pattern: streamlined save protocol"
```

Format: `type: description`. Types: `init`, `agent`, `pattern`, `tool`, `decision`, `experiment`, `milestone`, `fix`.

After creating the file, auto-append `[YYYY-MM-DD] <changelog value>` to `CHANGELOG.md`.

---

## Frontmatter Schemas

Fields marked `# auto` are filled by the agent. Fields marked `# optional` can be omitted.

### Episode

```yaml
---
date:                    # auto
outcome: SUCCESS | FAIL | SURPRISE | PARTIAL
tags: []
context_read: []         # auto — files consulted before writing this entry
changelog:               # optional — type: description
links: []                # optional — external URLs (cloud docs, Figma, Notion, etc.)
related: []
---
```

Experiments add: `type: experiment`, `status: planned | running | done | abandoned`.
Retrospectives add: `type: retrospective`, `subtype: weekly | milestone | post-mortem`.

### Decision

```yaml
---
id:                      # auto — YYYY-MM-DD-HHMM-slug
status: accepted
tags: []
context_read: []         # auto — files consulted before writing this entry
changelog:               # optional — type: description
replaces:                # optional — path to old decision
links: []                # optional — external URLs (cloud docs, Figma, Notion, etc.)
related: []
---
```

### Insight

```yaml
---
id:                      # auto — YYYY-MM-DD-slug
type: concept | howto
confidence: low | medium | high
episode_count: 1
tags: []
context_read: []         # auto — files consulted before writing this entry
links: []                # optional — external URLs (cloud docs, Figma, Notion, etc.)
related: []
---
```

---

## End-of-Session Checklist

1. **Code committed?** Commit with a descriptive message.
2. **Memory saved?** Run `/syntrace` (quick) or `/syntrace full` (significant work).

The save protocol handles routing, CHANGELOG, and frontmatter.

---

## External Links

Any file can include a `links:` field in frontmatter with URLs to cloud documents, Figma files, Notion pages, or any public resource. If you have web search or browsing capabilities, follow these links to pull in external context when relevant. If you don't have web access, treat them as references for the human to consult.

---

## Conventions

- Filenames: `YYYY-MM-DD` prefix, lowercase, hyphens, no spaces.
- Max ~300 lines per `.md` file; split if longer.
- Relative markdown links between files.
- `tags: [...]` in YAML frontmatter for searchability.
- Never commit secrets; use `.env` (gitignored).
- Milestones via `git tag`; no manual archiving.

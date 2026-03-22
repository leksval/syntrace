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
| `memory/inbox/` | Unsorted captures to be triaged later |
| `graph-schema.json` | Node/edge type definitions for graph queries |
| `src/` | Source code |
| `tests/` | Tests |
| `docs/` | Technical documentation |
| `CHANGELOG.md` | Human-readable project history |

**Schema** = structural knowledge that rarely changes. Never modify without a decision record.
**Memory** = experiential knowledge that evolves continuously.

---

## Knowledge Flow

Work produces episodes. Episodes get distilled into insights. Stable insights get promoted to schema. Every schema change gets a decision record.

```
work done ──→ memory/episodes/
                   ↓  (distillation)
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
5. For deeper retrieval, use graph queries -- see [docs/graph-queries.md](docs/graph-queries.md) and `schema/patterns/graph-scan.md`.

---

## After You Finish -- Save Protocol

Save results using today's date. Every file needs YAML frontmatter with `tags: [...]`.

### Where to save

| What happened | Folder | Filename | Template |
|---------------|--------|----------|----------|
| Design or architecture choice | `memory/decisions/` | `YYYY-MM-DD-HHMM-slug.md` | `_template.md` in folder |
| Focused work, experiment run | `memory/episodes/` | `YYYY-MM-DD-slug.md` | `_template-experiment.md` |
| Review, retro, periodic summary | `memory/episodes/` | `YYYY-MM-DD-slug.md` | `_template-retrospective.md` |
| Reusable pattern discovered | `memory/insights/` | `YYYY-MM-DD-slug.md` | `_template.md` in folder |
| Quick unstructured capture | `memory/inbox/` | `YYYY-MM-DD-slug.md` | None required |
| Notable project change | `CHANGELOG.md` | Append entry | `[YYYY-MM-DD] type: description` |

CHANGELOG types: `init`, `agent`, `pattern`, `tool`, `decision`, `experiment`, `milestone`, `fix`.

### Frontmatter schemas

**Episode** (base fields -- all episode types share these):

```yaml
---
date: YYYY-MM-DD
project: <project-name>
agent: <agent-name or "human">
outcome: SUCCESS | FAIL | SURPRISE | PARTIAL
tags: [tag1, tag2]
source: (what triggered this episode)
related: []
---
```

Experiments add: `type: experiment`, `status: planned | running | done | abandoned`.
Retrospectives add: `type: retrospective`, `subtype: weekly | milestone | post-mortem`.

**Decision:**

```yaml
---
id: YYYY-MM-DD-HHMM-slug
status: proposed | accepted | replaced | deprecated
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [tag1, tag2]
replaces: (optional -- path to old decision)
related: []
---
```

**Insight:**

```yaml
---
id: YYYY-MM-DD-slug
type: concept | howto
confidence: low | medium | high
created: YYYY-MM-DD
updated: YYYY-MM-DD
source: episode/filename | experiment/filename | human
tags: [tag1, tag2]
related: [path/to/related.md]
---
```

---

## End-of-Session Checklist

1. **Code committed?** If you wrote code, commit with a descriptive message.
2. **Episode logged?** If non-trivial work was done, create one in `memory/episodes/`.
3. **Decision recorded?** If you made a design choice, record it in `memory/decisions/`.
4. **Insight captured?** If you discovered something reusable, add it to `memory/insights/`.
5. **CHANGELOG updated?** If the change is notable, append to `CHANGELOG.md`.

---

## Conventions

- Filenames: `YYYY-MM-DD` prefix, lowercase, hyphens, no spaces.
- Max ~300 lines per `.md` file; split if longer.
- Relative markdown links between files.
- `tags: [...]` in YAML frontmatter for searchability.
- Never commit secrets; use `.env` (gitignored).
- Milestones via `git tag`; no manual archiving.

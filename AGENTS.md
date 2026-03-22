# Syntrace -- Agent Orientation

You are working inside a Syntrace workspace: a filesystem-native, dual-inheritance knowledge architecture. Everything is folders and markdown.

---

## Workspace Map

| Path | Purpose |
|------|---------|
| `genome/agents/` | One `.md` per agent role -- responsibilities, inputs, outputs, invariants |
| `genome/patterns/` | Architectural patterns and playbooks for multi-agent workflows |
| `genome/policies/` | Standing rules and quality standards (Critic agent uses these) |
| `genome/tools.md` | Tool definitions, contracts, and agent assignments |
| `culture/decisions/` | ADR-style records explaining why something changed |
| `culture/episodes/` | Work logs, experiment results, retrospectives |
| `culture/insights/` | Distilled reusable knowledge extracted from episodes |
| `culture/inbox/` | Unsorted captures to be triaged later |
| `src/` | Source code |
| `tests/` | Tests |
| `docs/` | Technical documentation |
| `CHANGELOG.md` | Human-readable project history |

**Genome** = structural knowledge that rarely changes. Never modify without a decision record.
**Culture** = experiential knowledge that evolves continuously.

---

## Knowledge Flow

Work produces episodes. Episodes get distilled into insights. Stable insights get promoted to genome. Every genome change gets a decision record.

```
work done ──→ culture/episodes/
                   ↓  (distillation)
              culture/insights/
                   ↓  (when stable across 3+ episodes)
              genome/patterns/ or genome/policies/
                   ↓  (always paired with)
              culture/decisions/
```

---

## Before You Act

1. Check `genome/policies/` for rules relevant to your task.
2. Check `culture/insights/` for prior knowledge on the topic.
3. Check `genome/patterns/` for established workflows.
4. On first session, also read `genome/agents/` for role definitions.

---

## After You Finish -- Save Protocol

Save results using today's date. Every file needs YAML frontmatter with `tags: [...]`.

### Where to save

| What happened | Folder | Filename | Template |
|---------------|--------|----------|----------|
| Design or architecture choice | `culture/decisions/` | `YYYY-MM-DD-HHMM-slug.md` | `_template.md` in folder |
| Focused work, experiment run | `culture/episodes/` | `YYYY-MM-DD-slug.md` | `_template-experiment.md` |
| Review, retro, periodic summary | `culture/episodes/` | `YYYY-MM-DD-slug.md` | `_template-retrospective.md` |
| Reusable pattern discovered | `culture/insights/` | `YYYY-MM-DD-slug.md` | `_template.md` in folder |
| Quick unstructured capture | `culture/inbox/` | `YYYY-MM-DD-slug.md` | None required |
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
---
```

Experiments add: `type: experiment`, `status: planned | running | done | abandoned`.
Retrospectives add: `type: retrospective`, `subtype: weekly | milestone | post-mortem`.

**Decision:**

```yaml
---
id: YYYY-MM-DD-HHMM-slug
status: proposed | accepted | superseded | deprecated
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [tag1, tag2]
supersedes: (optional -- path to old decision)
---
```

**Insight:**

```yaml
---
id: YYYY-MM-DD-slug
type: semantic | procedural
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
2. **Episode logged?** If non-trivial work was done, create one in `culture/episodes/`.
3. **Decision recorded?** If you made a design choice, record it in `culture/decisions/`.
4. **Insight captured?** If you discovered something reusable, add it to `culture/insights/`.
5. **CHANGELOG updated?** If the change is notable, append to `CHANGELOG.md`.

---

## Conventions

- Filenames: `YYYY-MM-DD` prefix, lowercase, hyphens, no spaces.
- Max ~300 lines per `.md` file; split if longer.
- Relative markdown links between files.
- `tags: [...]` in YAML frontmatter for searchability.
- Never commit secrets; use `.env` (gitignored).
- Milestones via `git tag`; no manual archiving.

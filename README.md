<p align="center">
  <img src="assets/logo.png" alt="Syntrace" width="300" />
</p>

# 🧬 Agent Project Template

> Stack-agnostic, filesystem-native dual-inheritance architecture.
> Folders and markdown only. Clone this for every new project.

---

## Philosophy

This template treats knowledge as having two layers — inspired by biological dual inheritance:

| Layer | Folder | Role | Changes |
|---|---|---|---|
| **Genetic** | `genome/` | Core roles, tools, policies, patterns | Rarely, with explicit decisions |
| **Cultural** | `culture/` | Design logs, episodes, playbooks, retros | Continuously |
| **Memory** | `memory/` | Agent and developer accumulated knowledge | Via distillation |
| **Learning** | `learning/` | Human learning: notes, experiments, inbox | Freely |
| **Programming** | `programming/` | Code, scripts, tests, docs | Standard dev workflow |
| **Archive** | `archive/` | Frozen snapshots at milestones | On release/milestone |

---

## Quick Start

```bash
# Clone the template
cp -r agent_template/ my-new-project/
cd my-new-project/

# Initialize git
git init
git add .
git commit -m "init: project scaffold from agent template"
```

Then:
1. Edit `genome/agents/*.md` to define your agents.
2. Edit `genome/patterns/*.md` to define your architecture.
3. Log your first design decision in `culture/decisions/`.
4. Start coding in `programming/src/`.
5. Take learning notes in `learning/notes/`.

---

## Folder Map

```
.
├── README.md                  ← You are here
├── CHANGELOG.md               ← Human-readable project history
├── genome/                    ← Slow-changing, structural knowledge (genetic layer)
│   ├── agents/                ← One .md per agent role
│   ├── patterns/              ← Architectural patterns
│   ├── schemas/               ← Canonical data/memory formats
│   └── tools/                 ← Tool definitions and contracts
├── culture/                   ← Fast-changing, experiential knowledge (cultural layer)
│   ├── decisions/             ← ADR-style design decisions
│   ├── episodes/              ← Distilled interaction/run logs
│   ├── playbooks/             ← Evolved step-by-step recipes
│   └── retrospectives/        ← Periodic what-worked / what-failed reviews
├── memory/                    ← Persistent agent + developer memory
│   ├── semantic/              ← Distilled concepts and patterns
│   ├── procedural/            ← Policies and habits
│   └── episodic/              ← Raw key episodes (pruned)
├── learning/                  ← Human learning layer
│   ├── notes/                 ← Research notes, concepts, links
│   ├── experiments/           ← Quick experiments, results, conclusions
│   └── inbox/                 ← Unsorted captures, to be processed
├── programming/               ← Code
│   ├── src/                   ← Source code
│   ├── tests/                 ← Tests
│   ├── scripts/               ← Utility and automation scripts
│   └── docs/                  ← Technical documentation
└── archive/                   ← Milestone snapshots
```

---

## How knowledge flows

```
[you learn / agents run]
         │
         ▼
  culture/episodes/       learning/inbox/
         │                      │
         └──────────┬───────────┘
                    │  (weekly distillation)
                    ▼
         memory/semantic/        learning/notes/
         memory/procedural/      learning/experiments/
                    │
                    │  (when pattern is stable)
                    ▼
              genome/patterns/
              genome/agents/   ← updated with design decision
                    │
                    ▼
         culture/decisions/   ← explains the change
```

---

## Conventions

- **Dates**: always `YYYY-MM-DD` prefix in filenames.
- **Slugs**: lowercase, hyphens, no spaces.
- **File size**: keep individual `.md` files under ~300 lines. Split if longer.
- **Links**: use relative markdown links between files.
- **Tags**: add `tags: [tag1, tag2]` in frontmatter for searchability.
- **No secrets**: never commit API keys or tokens; use `.env` (gitignored).


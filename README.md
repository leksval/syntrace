<p align="center">
  <img src="assets/logo.png" alt="Syntrace" width="300" />
</p>

# Syntrace

> Stack-agnostic, filesystem-native dual-inheritance architecture.
> Folders and markdown only. Clone this for every new project.

---

## Philosophy

This template treats knowledge as having two layers — inspired by biological dual inheritance:

| Layer | Folder | Role | Changes |
|---|---|---|---|
| **Genetic** | `genome/` | Core roles, tools, policies, patterns | Rarely, with explicit decisions |
| **Cultural** | `culture/` | Design logs, episodes, insights, inbox | Continuously |

Code lives at the project root (`src/`, `tests/`, `docs/`) following standard conventions.
Milestones are captured with git tags — no separate archive folder needed.

---

## Quick Start

```bash
# Clone the template
cp -r syntrace/ my-new-project/
cd my-new-project/

# Initialize git
git init
git add .
git commit -m "init: project scaffold from syntrace template"
```

Then:
1. Edit `genome/agents/*.md` to define your agents.
2. Edit `genome/patterns/*.md` to define your architecture.
3. Log your first design decision in `culture/decisions/`.
4. Start coding in `src/`.

---

## Folder Map

```
.
├── README.md                     <- You are here
├── CHANGELOG.md                  <- Human-readable project history
│
├── genome/                       <- Slow-changing, structural knowledge (genetic layer)
│   ├── agents/                   <- One .md per agent role
│   ├── patterns/                 <- Architectural patterns and playbooks
│   ├── policies/                 <- Standing rules and quality standards
│   └── tools.md                  <- Tool definitions and contracts
│
├── culture/                      <- Fast-changing, experiential knowledge (cultural layer)
│   ├── decisions/                <- ADR-style design decisions
│   ├── episodes/                 <- Interaction logs, experiment results, retrospectives
│   ├── insights/                 <- Distilled reusable knowledge
│   └── inbox/                    <- Unsorted captures, to be processed
│
├── src/                          <- Source code
├── tests/                        <- Tests
└── docs/                         <- Technical documentation
```

---

## How knowledge flows

```
[you learn / agents run]
         |
         v
  culture/episodes/       culture/inbox/
         |                      |
         +----------+-----------+
                    |  (periodic distillation)
                    v
         culture/insights/
                    |
                    |  (when pattern is stable)
                    v
              genome/patterns/
              genome/policies/
              genome/agents/    <- updated with design decision
                    |
                    v
         culture/decisions/     <- explains the change
```

---

## For AI Agents

See [`AGENTS.md`](AGENTS.md) for workspace orientation, save protocol, and end-of-session checklist.

---

## Conventions

- **Dates**: always `YYYY-MM-DD` prefix in filenames.
- **Slugs**: lowercase, hyphens, no spaces.
- **File size**: keep individual `.md` files under ~300 lines. Split if longer.
- **Links**: use relative markdown links between files.
- **Tags**: add `tags: [tag1, tag2]` in frontmatter for searchability.
- **Milestones**: use `git tag v1.0.0` to mark releases; no manual archiving.
- **No secrets**: never commit API keys or tokens; use `.env` (gitignored).

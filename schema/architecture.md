---
schema: architecture
version: 0.1.0
tags: [architecture, foundational, constraints]
---

# Architecture

Four foundational constraints that shape every other design choice in Syntrace. Changing any of these requires a decision record and broad review.

---

## 1. Dual-layer knowledge split

All knowledge lives in one of two layers:

| Layer | Path | Mutation rules | Contains |
|-------|------|----------------|----------|
| **Schema** (slow) | `schema/` | Guarded -- requires a decision record | Agent roles, patterns, policies, tool contracts, graph schema |
| **Memory** (fast) | `memory/` | Open -- agents write freely | Context captures, episodes, decisions, insights |

Schema is the constitution. Memory is the journal. The distillation loop (`/distill`) is the only process that promotes memory into schema.

**Why not a single folder?** No protection for stable knowledge -- an agent could overwrite a policy during routine note-taking.
**Why not a database?** Violates the zero-dependency, filesystem-native constraint.

---

## 2. Four-role agent model

Two concerns, four roles:

**Task execution** (planner-worker-critic cycle):

| Role | Responsibility | Spec |
|------|---------------|------|
| **Planner** | Decomposes goals, delegates, synthesizes results | `schema/agents/planner.md` |
| **Worker** | Executes a single well-defined subtask using tools | `schema/agents/worker.md` |
| **Critic** | Reviews worker output against policies; PASS/REVISE/REJECT | `schema/agents/critic.md` |

**Knowledge maintenance** (separate cadence):

| Role | Responsibility | Spec |
|------|---------------|------|
| **Librarian** | Distills episodes/context into insights, proposes schema promotions | `schema/agents/librarian.md` |

Additional roles are added as specialized workers, not new top-level roles.

**Why separate planner and worker?** Planning needs full-goal context; execution benefits from narrow focus.
**Why a librarian?** Without it, knowledge accumulates but never matures. The librarian formalizes ad-hoc cleanup.

---

## 3. Three-tier save protocol

Tiers are ordered by effort. Use the lightest that fits.

| Tier | Command | Output | When to use |
|------|---------|--------|-------------|
| 1. Quick | `/syntrace` | `memory/context/` entry | Most sessions. A few sentences. |
| 2. Full | `/syntrace full` | Episode + optional decision + CHANGELOG | Significant work, design choices. |
| 3. Distill | `/distill` | Insights from context/episodes; schema proposals | Weekly or on-demand. |

Each tier subsumes the prior: full save includes the reflection step from quick save; distillation reads outputs of both.

**Why not a single save command?** Forces a choice between too-lightweight (kills maturation) and too-heavy (kills adoption).
**Why not auto-detect tier?** The human/agent knows session significance better than a heuristic.

---

## 4. Filesystem-native graph scan

Relationship queries (which episode produced which insight, which decision affected which schema file) use file tools, not a database.

| Component | File | Purpose |
|-----------|------|---------|
| Schema | `schema/graph-schema.json` | Maps node types to file globs, edge types to frontmatter fields, validation rules |
| Procedure | `schema/patterns/graph-scan.md` | Step-by-step: discover nodes, extract edges, build graph, run queries |

Agents build an in-memory graph on demand using glob, read, and grep.

**Why not SQLite?** Adds a dependency; knowledge lives in two places.
**Why not embeddings?** Requires a vector store and model; violates zero-dependency constraint.
**Scaling limit:** Performance degrades past ~200 files. Mitigated by tag-first filtering, recency windows, and walk-backward queries (see graph-scan.md "Retrieval at scale").

---

## Constraints (invariants across all four)

- Zero external dependencies. Markdown and folders only.
- Any agent that can read files can use the system. No platform lock-in.
- Git-native. All knowledge is diffable, branchable, mergeable.
- Convention-enforced, not runtime-enforced. The system trusts agents to follow specs.

## Related

- `schema/agents/` -- individual role specs
- `schema/patterns/planner-worker-critic.md` -- task execution cycle
- `schema/patterns/librarian-distillation.md` -- knowledge maintenance cycle
- `schema/patterns/graph-scan.md` -- retrieval procedure
- `schema/graph-schema.json` -- node/edge definitions and validation

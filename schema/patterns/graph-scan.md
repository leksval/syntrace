---
pattern: graph-scan
version: 0.2.0
tags: [graph, query, retrieval, meta, scaling]
---

# Graph Scan Pattern

## Overview

A step-by-step procedure for agents to build an in-memory knowledge graph from Syntrace markdown files and answer relationship queries. No scripts or databases -- agents execute this using standard file tools (glob, read, grep).

## When to use

- Before starting work, to find all knowledge related to your task
- When tracing how a piece of knowledge evolved (episode -> insight -> schema)
- When checking for gaps (missing links, orphaned nodes)
- When querying across multiple Syntrace instances (cross-project)

## Step 1: Read the graph schema

Read `schema/graph-schema.json`. It defines:

- **Node types** with glob patterns (e.g., `schema/agents/*.md`)
- **Edge types** with extraction rules (which frontmatter fields produce which edges)
- **Query recipes** for common traversals

## Step 2: Discover nodes

For each node type in `schema/graph-schema.json`:

1. Glob the file pattern (e.g., `memory/insights/*.md`)
2. Exclude files matching the `exclude` patterns (`_template*`, `README*`)
3. Each remaining file is a node. Its path is the node ID.

## Step 3: Extract edges from frontmatter

For each node file, parse the YAML frontmatter between `---` markers. Extract edges:

| Frontmatter field | Edge type | Direction |
|---|---|---|
| `related: [path1, path2]` | `related` | Bidirectional |
| `source: path` | `source` | This node was created from that node |
| `replaces: path` | `replaces` | This decision supersedes that decision |
| `tags: [tag1, tag2]` | `tagged` | Implicit; nodes sharing a tag are connected |

## Step 4: Extract edges from body

Scan the `## Related` section (if present) for markdown links. Each link target is a `references` edge to another node.

Link formats to recognize:
- `` `path/to/file.md` `` (backtick-quoted path)
- `[text](path/to/file.md)` (standard markdown link)
- `path/to/file.md` (bare path on a list item line)

## Step 5: Build the graph

Assemble nodes and edges into a structure like:

```
nodes:
  - id: "memory/insights/2026-03-22-retry-backoff.md"
    type: insight
    tags: [api, reliability]
    confidence: high

edges:
  - from: "memory/insights/2026-03-22-retry-backoff.md"
    to: "memory/episodes/2026-03-20-api-failures.md"
    type: source
  - from: "memory/insights/2026-03-22-retry-backoff.md"
    to: "schema/policies/quality-standards.md"
    type: related
```

## Query recipes

### Find related knowledge

Given a starting node (file path or tag):

1. Collect all edges touching this node (`related`, `references`, `source`)
2. Collect all nodes sharing any of this node's tags (`tagged`)
3. Rank results by edge count (more connections = more relevant)
4. Return the top N nodes with their paths and summaries

### Trace lineage

Given an insight or schema file:

1. Follow `source` edges backward to find originating episodes
2. Follow `related` edges to find decisions that affected it
3. Follow `replaces` edges on decisions to find the full decision chain
4. Present as a timeline: episode -> insight -> decision -> schema change

### Detect gaps

Scan for structural problems:

| Gap type | How to detect |
|---|---|
| Unsourced insight | Insight node with empty or missing `source` field |
| Unlinked decision | Decision node with empty `related` field (no schema files referenced) |
| Orphaned episode | Episode with no outgoing `related` edges and not referenced as `source` by any insight |
| Stale insight | Insight with `confidence: low` and `episode_count` < 2 and `updated` older than 90 days |

### Validate

Run structural validation across all nodes:

1. For each node type in `graph-schema.json`, glob files and parse frontmatter
2. Check every field listed in `required` is present and non-empty
3. Check enum fields (`outcome`, `confidence`, `type`, `status`) against `validation.enums`
4. Check `episode_count` is an integer >= 1
5. Check every path in `related` and `context_read` resolves to an existing file
6. Check every schema file (agents, patterns, policies) is referenced by at least one decision's `related` field
7. Report errors (missing required fields, invalid enums) and warnings (broken links, missing coverage)

### Cross-project query

To query across multiple Syntrace instances:

1. Identify the paths to each instance (local project Syntrace + global Syntrace)
2. Run Steps 1-5 for each instance, prefixing node IDs with the instance path
3. Merge the graphs
4. Use the `project:` frontmatter field to filter or group results
5. Find shared tags across instances to discover cross-project patterns

## Retrieval at scale

When `memory/` grows beyond ~30 files, reading everything before acting becomes impractical. Use these strategies in order of increasing cost:

### 1. Tag-first filtering (default for 30-100 files)

Before reading full files, grep only `tags:` lines across the target folder. Select files whose tags overlap with your current task's keywords. This reduces a 100-file folder to the 5-10 files that actually matter.

```
1. Identify 2-3 keywords for your current task
2. grep "tags:" memory/insights/*.md
3. Read only files whose tags overlap with your keywords
4. Record what you read in context_read
```

### 2. Recency window (default for 100+ files)

Combine tag filtering with a recency cutoff. For most tasks, insights updated in the last 90 days plus high-confidence older insights cover the useful space.

```
1. Sort files by modification date (or parse updated: frontmatter)
2. Read the 20 most recent files' frontmatter
3. Also include any file with confidence: high regardless of age
4. Apply tag filtering within this set
```

### 3. Graph-guided retrieval (for relationship queries)

When you need to find knowledge related to a specific file or decision, don't scan everything. Start from the known node and walk edges:

```
1. Read the starting node's related and source fields
2. Follow those links (1 hop)
3. Optionally follow the linked nodes' related fields (2 hops)
4. Stop — diminishing returns beyond 2 hops
```

### 4. When to build the full graph

Only build the complete graph (Steps 1-5 above) for:
- Gap detection (`/distill` runs)
- Cross-project queries
- Periodic audits (monthly or at milestones)

Never build the full graph as a prerequisite to routine work.

## Efficiency tips

- For quick lookups, grep `tags:` lines first to narrow the file set before full parsing
- For lineage queries, start from the target and walk backward -- don't build the full graph
- For gap detection, a full scan is needed but only frontmatter parsing (skip body content)

## Multi-Project Queries

Each project embeds its own Syntrace instance. Optionally, a global Syntrace holds cross-project knowledge.

| Instance | Path | Contains |
|---|---|---|
| Per-project | `<project>/syntrace/` | Project-specific episodes, decisions, insights |
| Global | shared path (configured per environment) | Cross-project insights and stable patterns |

Insights stable across 2+ project instances get promoted to global.

## Related

- `schema/patterns/librarian-distillation.md`
- `schema/agents/librarian.md`
- `schema/graph-schema.json`

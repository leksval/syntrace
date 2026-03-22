# Graph Queries and Cross-Project Model

## Graph Queries

This knowledge base is graph-queryable. Every `.md` file is a node; frontmatter fields are edges.

| Edge type | Frontmatter field | What it connects |
|---|---|---|
| `related` | `related: []` | Explicit link to any other file |
| `source` | `source:` | Where this knowledge came from (episode, experiment, human) |
| `replaces` | `replaces:` | This decision replaces an older one |
| `tagged` | `tags: []` | Implicit link -- nodes sharing a tag are connected |
| `references` | `## Related` section | Markdown links in the document body |

### How to query

1. Read `graph-schema.json` for node types, edge types, and extraction rules
2. Follow `schema/patterns/graph-scan.md` for the step-by-step playbook
3. Common queries: find related knowledge, trace lineage, detect gaps

## Multi-Project Model

Each project embeds its own Syntrace instance. A global Syntrace holds cross-project knowledge.

| Instance | Path | Contains |
|---|---|---|
| Per-project | `<project>/syntrace/` | Project-specific episodes, decisions, insights |
| Global | shared path (configured per environment) | Cross-project insights and stable patterns |

- Use the `project:` frontmatter field to identify which project produced each piece of knowledge
- Insights stable across 2+ project instances get promoted to global
- For cross-project queries, scan both local and global instances (see `schema/patterns/graph-scan.md`)

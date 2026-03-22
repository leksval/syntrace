---
schema: tool-registry
version: 0.1.0
tags: [tools, registry]
---

# Tool Registry

List all tools available to agents. Each entry is a contract.

---

## Template entry

```markdown
### <tool-name>

- **Description**: What it does
- **Input**: schema / types
- **Output**: schema / types
- **Side effects**: (e.g., writes to DB, calls external API)
- **Failure modes**: known failure cases and how agents should handle them
- **Rate limits / costs**: if applicable
- **Assigned to**: which agents may use this tool
```

---

## Example: web_search

### web_search

- **Description**: Searches the web and returns top results with title, URL, and snippet.
- **Input**: `{ query: string, max_results: int (default 5) }`
- **Output**: `[ { title, url, snippet } ]`
- **Side effects**: External HTTP call
- **Failure modes**: empty results (refine query), timeout (retry once, then fail)
- **Rate limits**: 100 req/day on free tier
- **Assigned to**: orchestrator, worker

---

<!-- Add your project tools below this line -->

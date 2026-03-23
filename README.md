<p align="center">
  <img src="logo.png" alt="Syntrace" width="300">
</p>

# Syntrace

**One memory file for every AI dev tool.** Portable. Local-first. No database. No API keys. Works with Cursor, Claude Code, ChatGPT, and anything that reads text.

## The problem

Your AI coding tools forget everything between sessions. Worse, each tool stores context differently:

- Cursor uses `.cursor/rules/*.mdc`
- Claude Code uses `CLAUDE.md`
- ChatGPT needs you to paste context every time
- Every other tool invents its own format

You end up repeating yourself, maintaining parallel files, and losing knowledge when you switch tools.

## The idea

`syntrace.md` is a single portable format that works like a **genome**:

- **Replication machinery** -- the spec at the bottom of the file. Constant. Tells the LLM how to read, write, and evolve the memory. Copy the file to a new project and this machinery bootstraps itself.
- **Accumulated knowledge** -- the memory sections at the top. Grows every session. Episodes, decisions, insights, context -- each entry linked to its ancestors through lineage fields, like genes carrying their evolutionary history.
- **Phenotype snapshot** -- the Memory Index near the top. Auto-generated each save. Shows what's active, what's high-confidence, and what's unresolved right now.

One file. One command. Copy it anywhere and it carries everything forward.

## Who it's for

Developers who use AI coding assistants and want:

- **Memory that survives across sessions** without re-explaining your project every time
- **One source of truth** instead of parallel `CLAUDE.md`, `.cursorrules`, and chat preambles
- **Portable knowledge** that moves with your repo, not locked to one vendor
- **Traceable decisions** with lineage and evidence, not scattered notes

If you use any LLM for coding -- in a chat window, in an IDE, or through a CLI agent -- Syntrace works.

## How the file is laid out

[`syntrace.md`](syntrace.md) is three layers in one file:

| Layer | What it is | Who reads it |
|-------|------------|--------------|
| **Top -- cheat sheet + memory** | Compact rules + Memory Index + Context / Episodes / Decisions / Insights / Changelog. | You, every session. The LLM appends here. |
| **Bottom -- reference** | Full specification: save protocol, entry formats, lineage rules, tag canon, architecture, scaling. | The LLM when saving; you when learning or customizing. |
| **Bottom -- examples** | Sample entries with lineage fields populated. Delete in a fresh project or keep as a style guide. | You and the LLM as a pattern to imitate. |

You do **not** need to read the whole file to start. Paste the file, work, say `/syntrace`.

## How to use

### No install (paste and go)

1. Copy [`syntrace.md`](syntrace.md) into your project
2. Paste its contents into any LLM -- ChatGPT, Claude, Cursor, Claude Code, Windsurf, anything that reads text
3. Work normally
4. Say `/syntrace` when done -- the LLM outputs the **complete** file with your session appended (Episode + Decision if applicable + Insight if a pattern emerged + Context if a standalone observation + Changelog line + refreshed Memory Index)
5. Save it, replacing the old version
6. Next session, paste it again. The LLM picks up where you left off.

The LLM may ask 1-2 brief clarification questions before saving if the session scope or a key decision is ambiguous.

### With the CLI (planned)

```bash
syntrace init                       # Create syntrace.md in current directory
syntrace validate                   # Check entries for errors
syntrace search "auth timeout"      # Find relevant entries
syntrace import --from claude       # Import knowledge from CLAUDE.md
syntrace export --to cursor         # Generate .cursor/rules/ files
```

The planned CLI, adapter mappings, and validation rules live in the `REFERENCE` block inside [`syntrace.md`](syntrace.md).

## What it captures

Every `/syntrace` evaluates the full session and writes what's appropriate:

| Section | What goes here |
|---------|---------------|
| **Memory Index** | Auto-generated snapshot: active decisions, high-confidence insights, open questions |
| **Context** | Quick observations, gotchas, things worth remembering |
| **Episodes** | Structured work logs with outcomes and takeaways |
| **Decisions** | Architecture choices with rationale, alternatives, and consequences |
| **Insights** | Distilled reusable patterns with confidence levels and evidence trails |
| **Changelog** | One-line session summaries |

Entries carry **lineage metadata** -- `derived_from`, `evidence`, `supersedes`, `superseded_by` -- so knowledge evolution is traceable. Each entry's heading slug is its stable identifier, used for all cross-references.

## Works with

Syntrace is the canonical format. Import from and export to tool-native formats:

| Tool | Import | Export | Notes |
|------|--------|--------|-------|
| **Claude Code** (`CLAUDE.md`) | yes | yes | Each `##` section maps to a Syntrace entry |
| **Cursor** (`.cursor/rules/`) | yes | yes | Each `.mdc` file maps to a Syntrace entry |
| **Plain LLM chat** | -- | -- | Paste the file directly, no adapter needed |
| **Any markdown tool** | yes | yes | The file is standard markdown |

See the interoperability section in [`syntrace.md`](syntrace.md) for the field-by-field translation rules.

## Two modes

**Paste mode** -- copy the file into a plain LLM chat (ChatGPT, Claude). Paste any relevant project files alongside it. Work. Save the output.

**Workspace mode** -- use inside an IDE agent (Cursor, Claude Code, Windsurf). The agent reads neighboring files automatically and writes richer, more connected entries.

Same file, same spec. Works both ways.

## Example

After three sessions, the memory half of your file might look like:

```
## Insights

### 2026-01-15-exponential-backoff-with-jitter
- **type**: howto
- **confidence**: medium
- **episode_count**: 2
- **tags**: api, error-handling, performance
- **derived_from**: 2026-01-15-fix-payment-timeout
- **evidence**: 2026-01-15-fix-payment-timeout, 2026-01-10-auth-token-expiry-gotcha
- **updated**: 2026-01-20

#### Summary
When calling external APIs that intermittently timeout, use exponential
backoff (base 500ms, max 8s) with +/-10% jitter. Fixed-interval retries
cause thundering herd on recovery.

#### When to apply
When you see timeout or rate-limit errors on outbound HTTP calls,
especially during peak traffic. NOT for 4xx auth errors -- those
should fail fast.
```

The reference at the end of `syntrace.md` told the LLM how to write this. You just said `/syntrace`.

## Migrating from v1

If you have an existing `syntrace.md` with entries from the old format:

1. Replace the cheat sheet and REFERENCE blocks with the new versions
2. Add `- **status**: active` to existing Context entries
3. Add `- **derived_from**: —` and `- **evidence**: ...` to existing Insights (use `—` if unknown)
4. Add `- **supersedes**: —` and `- **superseded_by**: —` to existing Decisions
5. Add `- **derived_from**: —` to existing Episodes
6. Add an empty **Memory Index** section above Context
7. Run `/syntrace` once -- the LLM will populate the Memory Index from your existing entries

Existing entry slugs remain valid as identifiers. No data loss.

## Get started

Copy the file:

```bash
cp syntrace.md your-project/syntrace.md
```

Optional: delete the **EXAMPLES** block at the bottom of `syntrace.md` for a clean slate -- the **REFERENCE** block stays; it is the replication machinery.

One file. One command. Paste and go.

## License

[CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) -- use it, remix it, share it. Just give credit.

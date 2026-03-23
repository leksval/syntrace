# Syntrace

**Persistent AI memory in a single file.** No database. No API keys. No dependencies. Just one markdown file that works with any LLM.

## The idea (DNA metaphor)

`syntrace.md` works like a **DNA strand**:

- **One strand** encodes *how to replicate* — the instructions that never change (the spec at the bottom of the file).
- **The other strand** encodes *what gets passed on* — your accumulated memory (the five sections at the top where entries grow).

They stay **base-paired in one molecule**: one file. Paste it into any LLM and both halves travel together. The model reads the long tail (reference) when it needs detail; you mostly work in the short head (skeleton + memory). Copy the file into a new project and it bootstraps itself — the spec is still there at the end, the memory starts empty.

The spec stays constant. The memory evolves.

## How the file is laid out

[`syntrace.md`](syntrace.md) is intentionally **two layers in one file**:

| Part | What it is | Who reads it |
|------|------------|--------------|
| **Top — skeleton** | Short cheat sheet + empty **Context / Episodes / Decisions / Insights / Changelog** sections. Minimal form so you are not overwhelmed. | You, every session. The LLM appends here first. |
| **Bottom — reference** | Full specification: save protocol, writing quality, every entry format with tips, auto-fill, architecture, scaling. | The LLM when saving; you when learning or customizing. |
| **Bottom — examples** | Optional sample entries (illustrative). Delete in a fresh project or keep as a style guide. | You and the LLM as a pattern to imitate. |

You do **not** need to read the whole file to start. Paste the file, work, say `/syntrace`. The model follows the reference at the end even if you only scrolled the top.

## How to use

1. Copy [`syntrace.md`](syntrace.md) into your project
2. Paste its contents into any LLM -- ChatGPT, Claude, Cursor, Claude Code, Windsurf, anything that reads text
3. Work normally
4. Say `/syntrace` when done -- the LLM outputs the **complete** file with your session appended to the memory sections (and leaves the reference block intact)
5. Save it, replacing the old version
6. Next session, paste it again. The LLM picks up where you left off.

Any other files pasted alongside it (or present in the same workspace) are treated as additional context. The LLM reads them before writing and references what it consulted in `context_read`.

## What it captures

| Section | What goes here | Trigger |
|---------|---------------|---------|
| **Context** | Quick observations, gotchas, things worth remembering | `/syntrace` |
| **Episodes** | Structured work logs with outcomes and takeaways | `/syntrace full` |
| **Decisions** | Architecture choices with rationale and alternatives | `/syntrace full` |
| **Insights** | Distilled reusable patterns extracted from episodes | `/syntrace` or `/distill` |
| **Changelog** | One-line session summaries | `/syntrace full` |

Entries are written to be useful in 30 days, not to document what happened today. The reference at the bottom of `syntrace.md` guides the LLM to capture the *why*, not the *what* -- concrete numbers over vague summaries, surprises over routine, connections to prior entries over isolated notes.

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
- **tags**: api, retry, reliability

#### Summary
When calling external APIs that intermittently timeout, use exponential
backoff (base 500ms, max 8s) with ±10% jitter. Fixed-interval retries
cause thundering herd on recovery.

#### When to apply
When you see timeout or rate-limit errors on outbound HTTP calls,
especially during peak traffic. NOT for 4xx auth errors — those
should fail fast.
```

The reference at the end of `syntrace.md` told the LLM how to write this. You just said `/syntrace`.

## Get started

Copy the file:

```bash
cp syntrace.md your-project/syntrace.md
```

Optional: delete the **EXAMPLES** block at the bottom of `syntrace.md` for a clean slate — the **REFERENCE** block stays; it is the replication machinery.

That's it. One file. Paste and go.

## License

[CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) -- use it, remix it, share it. Just give credit.

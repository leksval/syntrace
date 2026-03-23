<p align="center">
  <img src="logo.png" alt="Syntrace" width="300" />
</p>

<h1 align="center">Syntrace</h1>

<p align="center">
  <strong>One markdown file for project history, decisions, and reusable lessons.<br/>Portable. Local-first. No database. No API keys. Works with any LLM that can read text.</strong>
</p>

<p align="center">
  <a href="https://github.com/leksval/syntrace"><img src="https://img.shields.io/badge/%E2%AD%90_Star_this_repo-black?style=for-the-badge" alt="Star this repo" /></a>&nbsp;
  <a href="#license"><img src="https://img.shields.io/badge/license-CC--BY%204.0-blue.svg?style=for-the-badge" alt="CC-BY 4.0 License" /></a>&nbsp;
  <img src="https://img.shields.io/badge/local--first-2f855a?style=for-the-badge" alt="Local first" />&nbsp;
  <img src="https://img.shields.io/badge/just_markdown-brightgreen?style=for-the-badge" alt="Just Markdown" />
</p>

<p align="center">
  <strong>Start here:</strong><br/>
  <a href="https://raw.githubusercontent.com/leksval/syntrace/main/syntrace.md"><img src="https://img.shields.io/badge/USE_THIS_RAW_PROMPT-syntrace.md-ff1744?style=for-the-badge" alt="Use this raw prompt" /></a>
</p>

<p align="center">
  <a href="#tldr">TL;DR</a> ·
  <a href="#quick-start">Quick Start</a> ·
  <a href="#extract-lessons">Extract Lessons</a> ·
  <a href="#works-with">Works With</a> ·
  <a href="#get-started">Get Started</a>
</p>

---

## TL;DR

Syntrace is one markdown file that helps an LLM remember your project.

`Put it in the repo` -> `paste or let the agent read it` -> `work normally` -> `say /syntrace` -> `save the file` -> `reuse next session`

What you get:

> **Durable memory**  
> The project keeps context across sessions.
>
> **Traceable decisions**  
> Choices stay linked to evidence and history.
>
> **Reusable lessons**  
> Patterns and anti-patterns become easier to extract.
>
> **Low overhead**  
> No database, no vendor lock-in, no API keys.

If your team uses AI coding tools and keeps re-explaining the same project context, this is for you.

You are encouraged to fork this repo and adjust the format for your own team, stack, and workflow.

---

## Why use it

Project history gets lost fast. Decisions, debugging lessons, and hard-won patterns end up scattered across chats, commits, docs, and memory.

Syntrace gives the project one durable file that both humans and LLMs can reuse.

---

## Quick start

1. Copy [`syntrace.md`](syntrace.md) into your project.
2. Paste it into any LLM, or let your IDE agent read it.
3. Work normally.
4. Say `/syntrace` when done.
5. Save the full updated file.
6. Reuse it next session.

Raw prompt: [open `syntrace.md` as raw markdown](https://raw.githubusercontent.com/leksval/syntrace/main/syntrace.md)

What `/syntrace` saves:

> **Episode** if the session matters
>
> **Decision** if a real choice was made
>
> **Insight** if a reusable pattern emerged
>
> **Context** if a standalone observation matters
>
> **Changelog** line
>
> **Memory Index** refresh

If needed and possible, the LLM should ask 2-3 brief clarification questions before saving. That usually improves the final lesson quality because the saved entries become more precise and more reusable.

---

## What the file contains

[`syntrace.md`](syntrace.md) has three layers:

> **Cheat sheet**  
> Short rules for the LLM before each save.
>
> **Reference + examples**  
> The full spec.
>
> **History**  
> The append-only memory your project keeps growing.

You do **not** need to read the whole file to start. Paste the file, work, say `/syntrace`.

As you get comfortable with it, customize the reference, tags, and examples so they match your team's actual language and workflows. Forking and tailoring Syntrace is a feature, not misuse.

---

## Extract lessons

You can also use `syntrace.md` as a read-only memory source to generate reusable lessons from previous AI-assisted work.

Use this when you want:

`patterns` · `anti-patterns` · `durable decisions` · `evidence-backed lessons` · `next changes without rereading old chats`

If the scope is fuzzy, let the agent ask a few clarification questions first. That usually improves lesson quality a lot.

### Best inputs

Best order: local `syntrace.md` first, raw GitHub markdown URL second, pasted markdown if needed. If possible, also check relevant git history. Run this after each chat, or every couple of chats at most.

### Cursor prompt

```md
Extract the highest-signal reusable knowledge from this project's chat history and actual changes, using Syntrace as the durable memory source.

Source priority:
1. If `syntrace.md` exists in the current workspace, read that file first.
2. Otherwise read this raw markdown URL: <RAW_GITHUB_URL>
3. If you cannot access either source, ask me to paste the markdown contents.

Instructions:
- Use the current project chat and the actual changes made in this session as the primary source of new learning.
- Read the full Syntrace file, but focus especially on `Insights`, `Decisions`, `Episodes`, `Context`, and `Memory Index`.
- If possible, check relevant git history for the files or decisions involved so the lessons reflect what actually changed over time.
- Extract reusable lessons learned from prior LLM-assisted work and development sessions.
- Connect what changed in this session with relevant prior patterns already stored in Syntrace.
- Deduplicate overlapping ideas.
- Merge repeated evidence into one stronger lesson instead of listing variants.
- Prefer high-confidence insights and accepted decisions.
- Use episodes and context entries as supporting evidence when they reinforce a lesson.
- Use an elegant six-section structure: `Goal`, `Context`, `Decisions`, `Evidence`, `Lessons`, `Next Changes`.
- In `Lessons`, call out patterns and anti-patterns explicitly.
- Ignore filler, one-off narration, and anything not useful for future work.
- Treat Syntrace as a read-only source file.
- Do not rewrite the source file or regenerate the entire destination file.
- Return only an append-only markdown block intended to be added at the end.
- Output only markdown.

Return format:

# Lessons From Syntrace

## Goal
What this work was trying to achieve, why it mattered, and what success looked like.

## Context
Constraints, assumptions, dependencies, stakeholders, and background that shaped the work.

## Decisions
The most important choices, tradeoffs, and rejected alternatives that matter for future work.

## Evidence
What actually happened in practice: key events, signals, metrics, impact, and concrete observations.

## Lessons
The distilled reusable knowledge: patterns, anti-patterns, stable lessons, tentative insights, and open questions.

## Next Changes
Action items, experiments, reusable rules, and revisit triggers.
```

Why this works:

> **`Insights`** hold distilled lessons.
>
> **`Decisions`** hold durable rationale.
>
> **`Episodes` + `Context`** hold evidence.
>
> **Git history** can confirm what actually changed over time.

Do not be afraid to customize the wording, tags, and examples to fit your codebase. Fork it, rename sections if needed, change the tag canon, trim parts you do not use, and adapt the prompts to your workflow. The better Syntrace matches your real project language, the better the extracted lessons tend to be.

---

## What it captures

Every `/syntrace` evaluates the full session and writes what's appropriate:

> **Memory Index**  
> Snapshot of active decisions, high-confidence insights, and open questions.
>
> **Context**  
> Quick observations and gotchas.
>
> **Episodes**  
> Structured work logs with outcomes and takeaways.
>
> **Decisions**  
> Architecture choices with rationale and tradeoffs.
>
> **Insights**  
> Reusable patterns with confidence and evidence.
>
> **Changelog**  
> One-line session summaries.

Entries carry **lineage metadata** -- `derived_from`, `evidence`, `supersedes`, `superseded_by` -- so knowledge evolution is traceable. Each entry's heading slug is its stable identifier, used for all cross-references.

---

## Works with

Syntrace is the canonical format. It can import from and export to tool-native formats:

> **Claude Code** (`CLAUDE.md`)  
> Import + export.
>
> **Cursor** (`.cursor/rules/`)  
> Import + export.
>
> **Plain LLM chat**  
> Paste the file directly.
>
> **Any markdown tool**  
> Standard markdown in, standard markdown out.

See the interoperability section in [`syntrace.md`](syntrace.md) for the field-by-field translation rules.

---

## Two modes

> **Paste mode**  
> Copy the file into a plain LLM chat. Paste relevant project files alongside it.
>
> **Workspace mode**  
> Use it inside an IDE agent. The agent can read neighboring files and write richer entries.

Same file, same spec. Works both ways.

---

## Example

After three sessions, the memory half of your file might look like:

```md
## Insights

### 2026-01-15-exponential-backoff-with-jitter
- **type**: howto
- **confidence**: medium
- **evidence_count**: 2
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

---

## Get started

Copy the file:

```bash
cp syntrace.md your-project/syntrace.md
```

Optional:

> Delete the **EXAMPLES** block for a clean slate.
>
> Keep the **REFERENCE** block.
>
> Fork and customize the wording whenever the default spec feels too generic.

One file. One command. Paste and go.

---

## License

[CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) -- use it, fork it, remix it, share it. Just give credit.

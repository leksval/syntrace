# Syntrace

> Paste this file into any LLM. Work. Say `/syntrace` when done. The LLM outputs the updated file with your session appended. Save it. Paste it next time. Your memory grows.

---

## Cheat sheet

- **Output rule**: when triggered, output the **COMPLETE file** as a single markdown code block. Never output only the new entry.
- **Where to write**: append new entries **only** under the six MEMORY sections at the **end of this file** (Memory Index → Changelog). Do **not** modify **REFERENCE** or **EXAMPLES**.
- **Read before you write**: scan existing Memory sections; update Insights instead of duplicating; link `supersedes` on decisions when superseding; back-link `superseded_by` on the old entry.
- **Trigger**: `/syntrace` — always-full save. Append Episode + Decision (if applicable) + Insight (if a pattern emerged) + Context (if a standalone observation) + Changelog line. Refresh Memory Index.
- **Clarification**: the LLM may ask 1-2 questions before saving if the session scope or a key decision is ambiguous. Otherwise, save without asking.
- **Privacy**: never persist secrets, API keys, passwords, or PII in entries. Omit or redact.

**Full protocol, formats, lineage rules, and architecture** → see **REFERENCE** below. The append-only history lives at the end of the file.

<!-- ============================================================ -->
<!-- REFERENCE — full specification (do not delete; LLM reads)    -->
<!-- ============================================================ -->

## How this file works

This is a self-contained memory system. Three layers in one file, like a genome:

1. **Cheat sheet** — the short operating rules at the top. Quick reference before saving.
2. **Reference** — the stable instructions and formats. The protocol, schemas, lineage rules, architecture, and examples live here. Never append session history here.
3. **History** — the append-only project memory at the end of the file. Six sections: Memory Index, Context, Episodes, Decisions, Insights, Changelog. Append new `###` entries only there.

**Output rule**: when triggered, output the **COMPLETE file** as a single markdown code block with new entries appended to the correct sections. The user saves it, replacing the old version. Never output just the new entry — always the full file, so nothing is lost.

**Context rule**: any other files pasted alongside this one, or present in the same workspace, are additional context. Read them before writing entries. Reference what you consulted in `context_read`. `context_read` should point to project artifacts that informed the entry: source files, docs, tickets, specs, prior entries, logs, or diffs. Do **not** treat agent transcripts or chat history as project history. This means the file works in two modes:
- **Paste mode** (plain LLM chat): user pastes this file + any relevant project files. You read everything, work, append entries.
- **Workspace mode** (IDE agent like Cursor, Claude Code): you can read neighboring project files directly. Scan them before saving.

**Read before you write**: before creating any entry, scan the existing Memory sections. Check if an insight already covers this topic (update it instead of duplicating). Check if a prior decision is being superseded (add `supersedes` on the new entry and back-link `superseded_by` on the old one). The value of this system comes from connections between entries, not isolated notes.

**Privacy rule**: never persist secrets, API keys, passwords, tokens, or PII in any entry. Omit or redact sensitive values. If the session involved sensitive material, capture the pattern and lesson without the sensitive data.

## Save protocol

One trigger. One procedure. Always full depth.

| Trigger | What it creates | When to use |
|---------|----------------|-------------|
| `/syntrace` | Episode + Decision (if applicable) + Insight (if a pattern emerged) + Context (if a standalone observation) + Changelog line + Memory Index refresh | Every session. The only command. |

The LLM may ask up to 2 brief clarification questions before saving when the session scope or a key decision is ambiguous. Otherwise, save without asking.

**How `/syntrace` works step by step**:
1. Review what happened this session
2. If the session scope or a key decision is ambiguous, ask up to 2 clarification questions
3. Scan existing Memory sections — read before you write
4. Append an Episode entry (outcome, takeaways, concrete details)
5. If a design or architecture choice was made, append a Decision entry (rationale, alternatives, consequences)
6. Check existing Insights — update `confidence`, `episode_count`, and `evidence` on reinforced ones; create new ones if a reusable pattern emerged
7. If there is a lightweight observation that does not fit the episode, append a Context entry
8. Add a one-liner to Changelog
9. Internal distillation: if 5+ Context entries have `status: active`, promote reusable patterns to Insights and mark promoted entries `status: distilled`
10. Refresh Memory Index: list active decisions, high-confidence insights, open questions, and the date of the most recent entry
11. Scan the reflection checklist
12. Output the **COMPLETE file** as a single markdown code block

When done for the session: **commit code**, then **save memory**.

## Writing quality

The goal is entries your future self or teammates can act on without re-reading the original conversation.

**What to capture**:
- The *why*, not just the *what*. "Changed timeout to 3s" is useless. "Changed timeout to 3s because upstream SLA is 2s and we need headroom for retries" is actionable.
- Surprises and failures — not just successes. The unexpected carries the most signal.
- Connections to prior entries. If this session reinforces or contradicts an existing insight, say so explicitly and link via `derived_from` or `evidence`.
- Concrete numbers, thresholds, and examples. "Performance improved" means nothing. "p95 latency dropped from 800ms to 120ms after adding the index" means everything.

**What to skip**:
- Play-by-play narration of routine steps.
- Obvious observations that any competent person would already know.
- Hedging and filler. Be direct.

**How to write insights**:
- An insight must be **retrievable** — someone searching for a keyword should find it via tags or title.
- An insight must be **actionable** — the "When to apply" section should describe a concrete trigger, not "when it seems relevant."
- An insight must be **falsifiable** — state it precisely enough that future evidence could upgrade or kill it.
- Prefer one sharp insight over three vague ones.

**Reflection checklist** (scan after every save):
- Did a structural pattern prove useful or fragile?
- Is there a spec-vs-implementation gap?
- Did a missing config or step cause silent degradation?
- Is there unnecessary complexity?
- What from this session would you reuse tomorrow?
- Does an existing insight need its confidence or episode_count updated?
- Is there a decision that was made implicitly but never recorded?

## Entry formats

Each entry is a `###` heading under its section. The heading slug is the entry's **stable identifier** — use it for all cross-references. Use bullet-point metadata (not YAML fences — they break when there are many entries in one file).

### Context entry format

The lightest entry type. An inbox item. The bar is: "would I want to find this in 30 days?"

```
### YYYY-MM-DD-slug
- **status**: active
- **tags**: tag1, tag2
- **context_read**: files consulted
- **derived_from**: (related entry slug, if any)

Body: a few sentences or bullets. Focus on what surprised you or what
you'd want to remember in 30 days. Skip anything obvious.
```

**Good slug**: `2026-03-23-redis-eviction-policy-mismatch`
**Bad slug**: `2026-03-23-bug` or `2026-03-23-notes`

`status` values: `active` (default), `distilled` (promoted to an Insight during internal distillation).

Tips:
- If you're unsure whether to capture something, capture it. Context is cheap. Distillation sorts it out.
- If the capture is longer than a paragraph, it's probably an Episode. Promote it.
- Cross-reference other entries by slug: "see also: 2026-01-15-exponential-backoff-with-jitter."

### Episode entry format

A structured work log. Write one every `/syntrace`. Focus on outcome and takeaway.

```
### YYYY-MM-DD-slug
- **outcome**: SUCCESS | FAIL | SURPRISE | PARTIAL
- **tags**: tag1, tag2
- **context_read**: files consulted
- **derived_from**: (related entry slug, if any)

#### What happened
What you did and WHY — not a transcript. Include concrete numbers
and thresholds when they exist. One to three paragraphs max.

#### Takeaways
- What was learned (be specific enough to act on)
- What you'd do differently (with reasoning)
- Link to existing insights this reinforces or contradicts
```

**Outcome guide**:
- **SUCCESS**: the goal was met as intended
- **FAIL**: the goal was not met. Capture WHY — failures are the highest-signal entries
- **SURPRISE**: the outcome was unexpected. Something was learned that changes a prior assumption
- **PARTIAL**: the goal was partially met, or met with caveats

Tips:
- The "What happened" section should pass the "dropped into this project cold" test.
- The "Takeaways" section is the most important part. Be specific: "retry logic should use jitter" beats "error handling could be improved."
- Always check: does this episode reinforce or contradict an existing Insight? If yes, say so and update the Insight.

### Decision entry format

An architecture decision record. Write one when you chose X over Y and the reasoning matters. Decisions are **immutable** — when reversed, add a new decision with `supersedes` pointing to the old one.

```
### YYYY-MM-DD-HHMM-slug
- **status**: accepted
- **tags**: tag1, tag2
- **context_read**: files consulted
- **supersedes**: (prior decision slug, if any)
- **superseded_by**: (filled automatically when a newer decision supersedes this one)

#### Context
The situation or problem that forced a choice. Include constraints.

#### Decision
What was decided. Be direct — one to two sentences.

#### Alternatives considered
- **Option A**: what it is, why it was rejected
- **Option B**: what it is, why it was rejected

#### Consequences
- Positive: what gets better
- Negative: what gets worse or harder
- Risks: what could go wrong with this choice
```

**Status values**:
- **accepted**: currently in effect
- **deprecated**: no longer the right choice, but hasn't been replaced yet
- **superseded**: replaced by another decision (the new one sets `supersedes`; this one gets `superseded_by` back-linked)

Tips:
- Always list at least two alternatives — if there was only one option, it wasn't really a decision.
- Be honest about negatives and risks. Decisions without downsides weren't analyzed deeply enough.
- Never delete an old decision. Add a new one with `supersedes` pointing to it. The trail matters.

### Insight entry format

Distilled, reusable knowledge. The highest-value entry type. Each insight should be **findable** (good tags + clear title), **actionable** (concrete trigger in "When to apply"), and **falsifiable** (precise enough that evidence could upgrade or kill it).

```
### YYYY-MM-DD-slug
- **type**: concept | howto
- **confidence**: low | medium | high
- **episode_count**: 1
- **tags**: tag1, tag2
- **derived_from**: slug of the episode or context entry this originated from
- **evidence**: slug1, slug2
- **updated**: YYYY-MM-DD

#### Summary
One paragraph. State the pattern precisely enough that future evidence
could confirm or kill it.

#### When to apply
Concrete trigger conditions — not "when relevant" but "when you see
X happening in context Y, do Z." Include counter-examples if known.
```

**Type guide**:
- **concept**: a mental model or principle ("dev defaults leak to production")
- **howto**: a specific technique with steps ("use exponential backoff with jitter on outbound HTTP retries")

**Confidence guide**:
- **low**: observed once. Treat as a hypothesis.
- **medium**: observed 2-3 times or validated in one real scenario.
- **high**: observed 3+ times across different contexts, or validated by benchmarking.

Tips:
- `episode_count` tracks supporting episodes. Increment every time a new episode reinforces the pattern: low + 1 → medium + 3 → high.
- `derived_from` traces where the insight originated. `evidence` lists all entries that support it — this is the lineage trail.
- "When to apply" must include **counter-examples**: "Use X when A. Do NOT use X when B."

## Lineage rules

Entries are append-only. These rules ensure traceable knowledge evolution:

1. **Immutability**: once written, an entry's heading slug and body text are permanent. Only these fields may be updated in place:
   - `status` (on Decisions: accepted → deprecated → superseded; on Context: active → distilled)
   - `superseded_by` (back-link added when a new decision supersedes this one)
   - `confidence`, `episode_count`, `evidence`, `updated` (on Insights, as new episodes validate them)
2. **Supersession**: to reverse a Decision, write a new Decision with `supersedes` pointing to the old slug. Set the old Decision's `status` to `superseded` and add `superseded_by` pointing to the new slug. Never delete the old entry.
3. **Derivation**: use `derived_from` to trace where an entry originated. An Insight derived from an Episode cites the episode slug. An Episode that builds on a prior Context entry cites the context slug.
4. **Evidence accumulation**: Insights list their supporting entries in `evidence`. Each time a new episode reinforces an insight, add the episode slug to `evidence` and increment `episode_count`.
5. **Distillation**: when Context entries accumulate (5+ with `status: active`), promote reusable patterns to Insights and mark the source Context entries `status: distilled`. Do not delete them — they remain for tracing lineage.

## Auto-fill rules

Fill these automatically — never ask the user for them:

| Field | Value | Example |
|-------|-------|---------|
| date in heading | Today's date | `### 2026-03-23-fix-auth-flow` |
| **context_read** | Files, sections, entries, tickets, logs, or specs you read before writing | `src/auth.ts, docs/auth.md, 2026-01-20-dev-defaults-leak` |
| **tags** | 2-5 lowercase keywords from the Tag Canon | `api, error-handling, config` |
| **outcome** | Best match from SUCCESS / FAIL / SURPRISE / PARTIAL | `SURPRISE` |
| **slug** | Descriptive, lowercase, hyphenated, no filler words | `fix-payment-timeout` not `todays-work` |
| **status** | Default for entry type | Context: `active`, Decision: `accepted` |
| **episode_count** | Start at 1 for new Insights | `1` |
| **updated** | Today's date when modifying an existing Insight | `2026-03-23` |
| **derived_from** | Source entry slug when applicable | `2026-01-15-fix-payment-timeout` |
| **superseded_by** | Auto-filled on old decision when a new one supersedes it | `2026-03-23-1400-switch-to-redis` |

## Tag canon

Canonical tags prevent drift. Use these when they fit; add new canonical tags only when no existing tag covers the concept.

| Canonical | Aliases | Domain |
|-----------|---------|--------|
| `api` | `rest`, `http`, `endpoint`, `graphql` | Integration |
| `auth` | `authentication`, `authorization`, `login`, `oauth` | Security |
| `config` | `configuration`, `settings`, `env`, `feature-flags` | Operations |
| `db` | `database`, `sql`, `postgres`, `mysql`, `mongo` | Storage |
| `cache` | `caching`, `redis`, `memcached` | Performance |
| `deploy` | `deployment`, `ci-cd`, `pipeline`, `docker` | Operations |
| `error-handling` | `errors`, `exceptions`, `retry`, `fallback` | Reliability |
| `performance` | `perf`, `latency`, `throughput`, `optimization` | Performance |
| `architecture` | `arch`, `design`, `system-design`, `patterns` | Architecture |
| `testing` | `tests`, `test`, `qa`, `e2e`, `unit-test` | Quality |
| `tooling` | `dx`, `developer-experience`, `ide`, `cursor` | Tooling |
| `security` | `sec`, `vulnerability`, `encryption`, `secrets` | Security |
| `monitoring` | `observability`, `logging`, `alerting`, `tracing` | Operations |

To add a new canonical tag: use a lowercase single word or hyphenated compound. Add at least one alias. Place it in the table above during the next `/syntrace`.

**Tagging strategy**: tags exist for retrieval. Ask: "what would someone search for to find this entry?" Use domain terms, not generic ones (`important`, `misc`, `todo`).

## Interoperability

Syntrace is the canonical memory format. Other tools may have their own project-memory files, but Syntrace is designed to be the lowest-common-denominator representation that can import from and export to them without losing the core ideas:

- project context
- reusable instructions
- decisions with rationale
- patterns worth reusing

The portability rule is: **Syntrace stays the source of truth; tool-native files are views or import sources.**

### Adapter principles

Adapters should follow these rules:

1. **Prefer lossless import**: when a source file contains information that does not map perfectly, preserve it in the body of a Context or Decision entry instead of discarding it.
2. **Prefer distilled export**: export only active, high-signal material that a target tool can use directly. Do not dump the full Syntrace file into every target format.
3. **Keep lineage in Syntrace**: external formats usually cannot represent `derived_from`, `evidence`, or `supersedes` fully. Preserve lineage in `syntrace.md`; export human-readable summaries when needed.
4. **Do not round-trip generated files manually**: exported files are derived artifacts. If the user edits them by hand, a later import should treat that as new source material, not guaranteed canonical truth.
5. **Preserve privacy rules**: imports and exports must still omit secrets, tokens, passwords, API keys, and PII.

### Adapter mappings

#### Claude Code (`CLAUDE.md`)

Import:

- Treat the file as project-scoped instruction memory.
- Map each top-level `##` section to a Syntrace entry.
- If the section describes stable conventions or reusable guidance, import it as an **Insight**.
- If the section describes an explicit architectural choice or trade-off, import it as a **Decision**.
- If the section is a loose project note, import it as **Context**.
- Set `context_read` to `CLAUDE.md`.
- Use `derived_from: —` unless the source references an existing Syntrace slug.

Export:

- Build `CLAUDE.md` from accepted Decisions and medium/high-confidence Insights.
- Prefer concise sections such as `## Key Commands`, `## Architecture`, `## Coding Conventions`, and `## Important Patterns`.
- Do not export Changelog noise, low-signal Context entries, or superseded Decisions.
- When lineage matters, summarize it in prose instead of exposing raw Syntrace fields.

#### Cursor rules (`.cursor/rules/*.mdc` or legacy `.cursorrules`)

Import:

- Treat each rule file as one source unit.
- Use the rule title or filename as the basis for the Syntrace slug.
- Import broadly applicable coding guidance as **Insight** entries.
- Import path-specific or workflow-specific notes as **Context** unless they encode a meaningful architectural choice.
- If frontmatter or metadata indicates scope, mention that scope in the body and include `cursor` or `tooling` in tags when relevant.
- Set `context_read` to the specific rule file path.

Export:

- Group exported content by concern, not by original Syntrace section.
- Convert active Insights and accepted Decisions into small topic-focused rule files.
- Prefer multiple short rules over one large file; large files degrade agent performance.
- Path-specific exports should be generated only when a Syntrace entry clearly implies file or directory scope.

#### Generic markdown instructions (`AGENTS.md`, `MEMORY.md`, `RULES.md`, similar files)

Import:

- Treat each heading block as a candidate Context, Insight, or Decision.
- Preserve unfamiliar structure in the body instead of forcing brittle field inference.
- Tag imported entries with `tooling` by default unless a better canonical tag fits.

Export:

- Generate concise project instructions from accepted Decisions and reusable Insights.
- Keep generated files short enough that agents can load them reliably.

## Validation

Validation exists so Syntrace behavior is not fully dependent on model obedience. A validator should report **errors** for broken invariants and **warnings** for quality issues that do not make the file unusable.

### File-level invariants

Errors:

- The file must contain the six MEMORY sections in this order: Memory Index, Context, Episodes, Decisions, Insights, Changelog.
- The file must retain the REFERENCE block.
- Entry headings must be unique across the file.
- New entries must appear only under the MEMORY sections.

Warnings:

- The EXAMPLES block is optional but recommended for first-time users.
- If the file grows beyond practical reading size, suggest splitting by domain.

### Entry schema

#### Context entries

Required:

- slug in `YYYY-MM-DD-descriptive-slug` form
- `status`
- `tags`
- `context_read`
- `derived_from`
- non-empty body

Allowed `status` values:

- `active`
- `distilled`

#### Episode entries

Required:

- slug in `YYYY-MM-DD-descriptive-slug` form
- `outcome`
- `tags`
- `context_read`
- `derived_from`
- `#### What happened`
- `#### Takeaways`

Allowed `outcome` values:

- `SUCCESS`
- `FAIL`
- `SURPRISE`
- `PARTIAL`

#### Decision entries

Required:

- slug in `YYYY-MM-DD-HHMM-descriptive-slug` form
- `status`
- `tags`
- `context_read`
- `supersedes`
- `superseded_by`
- `#### Context`
- `#### Decision`
- `#### Alternatives considered`
- `#### Consequences`

Allowed `status` values:

- `accepted`
- `deprecated`
- `superseded`

#### Insight entries

Required:

- slug in `YYYY-MM-DD-descriptive-slug` form
- `type`
- `confidence`
- `episode_count`
- `tags`
- `derived_from`
- `evidence`
- `updated`
- `#### Summary`
- `#### When to apply`

Allowed `type` values:

- `concept`
- `howto`

Allowed `confidence` values:

- `low`
- `medium`
- `high`

### Lineage validation

Errors:

- `derived_from`, `supersedes`, and `superseded_by` must point to an existing slug or `—`.
- Every slug listed in `evidence` must exist.
- A Decision with `status: superseded` must have a non-empty `superseded_by`.
- A new Decision that sets `supersedes` should point to a Decision entry, not another type.

Warnings:

- An Insight with `episode_count` that does not match the number of items in `evidence`.
- An Episode that appears to reinforce an existing Insight but does not mention it.
- A Context entry longer than a short paragraph; it may want to be an Episode instead.

### Memory Index refresh rules

The Memory Index is derived, not hand-authored. A refresh process should rebuild it from current MEMORY entries using these rules:

- **Active decisions**: list Decisions with `status: accepted`
- **High-confidence insights**: list Insights with `confidence: high`
- **Open questions**: list unresolved questions explicitly mentioned in active Context or recent Episode/Decision content
- **Last updated**: use the most recent entry date visible in any Memory section

Refresh behavior:

- Replace the entire Memory Index snapshot each time
- Prefer links by slug, not by paraphrased title alone
- If a category has no items, render `_(none yet)_`

## File-only model

Syntrace is intentionally just a markdown file. It should remain usable with plain copy/paste, direct manual edits, and normal version control without requiring a database, background service, or proprietary sync layer. Any future tooling around Syntrace should support the file, not replace it.

## Architecture

This section applies when using Syntrace with multi-agent workflows or IDE agents. If you're pasting into a plain LLM chat, the save protocol and entry formats above are all you need.

Planning is optional, not mandatory. If a task is small, concrete, low-risk, and can be handled by one agent without meaningful ambiguity, skip the planning layer and let a Worker execute directly. Use a Planner when the task is multi-step, touches multiple systems, has real trade-offs, or could create irreversible mistakes if the agent guesses wrong. Rule of thumb: if the agent can clearly say "I know exactly what to do next" and the blast radius is small, execution is fine; if not, plan first.

### Agent roles

| Role | What it does | Invariants |
|------|-------------|------------|
| **Planner** | Decomposes goals into subtasks, picks which agent handles each, synthesizes final output | No irreversible actions without human OK. Log all decisions with rationale. Check existing Insights before planning. |
| **Worker** | Executes one well-defined subtask using tools. Narrow focus. | Never exceed assigned scope. On failure: return error + context, never silently retry. |
| **Critic** | Reviews Worker output against quality checks. Returns PASS, REVISE, or REJECT with specific feedback. | Critique must be specific and actionable. Never approve output that violates invariants. |

New roles are added as specialized Workers (e.g., Researcher, Tester), not new top-level roles.

### Quality checks

The Critic applies these on every review. In single-agent mode, self-apply before saving:

- [ ] Output matches expected format (correct entry type, all required fields present)
- [ ] No invariants from agent roles are violated
- [ ] No hallucinated tool outputs (if a tool was supposedly called, verify it actually was)
- [ ] Rationale is present for non-obvious decisions — not just "what" but "why"
- [ ] Connections to existing entries are noted (reinforces, contradicts, or supersedes)
- [ ] Lineage fields are populated (`derived_from`, `evidence`, `supersedes` where applicable)

**Verdicts**:
- **PASS**: all checks pass
- **REVISE**: minor issues, specific feedback provided (max 2 rounds)
- **REJECT**: critical failure — invariant breach, missing rationale, wrong entry type

### Scaling memory

As Memory grows, reading everything before acting becomes impractical:

| Strategy | When to use | How |
|----------|------------|-----|
| **Memory Index scan** | Always | Read the Memory Index first — it surfaces active decisions and high-confidence insights. |
| **Tag scan** | 30-100 entries | Search for tags matching your current task's keywords. Read only matching entries. |
| **Recency + confidence** | 100+ entries | Focus on the 15-20 most recent entries plus `confidence: high` Insights. |
| **Lineage walk** | Tracing a specific topic | Start from one entry, follow `derived_from` and `evidence` 1-2 hops. |

When the file exceeds ~500 entries, consider splitting into multiple Syntrace files by domain (e.g., `syntrace-frontend.md`, `syntrace-infra.md`). Each file is self-contained — copy the Spec section into each one.

---

<!-- ============================================================ -->
<!-- EXAMPLES — illustrative (optional; delete for clean slate)   -->
<!-- ============================================================ -->

## Context (examples)

### 2026-01-10-auth-token-expiry-gotcha

- **status**: distilled
- **tags**: auth, config
- **context_read**: src/auth/middleware.ts
- **derived_from**: —

Spent 40 minutes debugging 401s before realizing refresh tokens expire after 7 days of inactivity, not 7 days from issue. The docs say "7-day expiry" without clarifying. Need to add a buffer that refreshes proactively at day 5.

### 2026-01-18-large-config-file-hid-production-defaults

- **status**: active
- **tags**: config, architecture
- **context_read**: src/config/index.ts, docs/deploy.md
- **derived_from**: —

Keeping runtime and deployment settings in one large config file made it easy to miss production-only defaults during review. Splitting the config into smaller domain files made environment-specific settings easier to audit and reduced the chance of dev defaults leaking into production.

## Episodes (examples)

### 2026-01-15-fix-payment-timeout

- **outcome**: SUCCESS
- **tags**: api, error-handling, config
- **context_read**: src/payments/client.ts, 2026-01-10-auth-token-expiry-gotcha
- **derived_from**: —

#### What happened

Payment endpoint timing out ~5% of requests during peak hours. Root cause: upstream provider has a 2s SLA but our timeout was set to 1s (leftover from dev defaults). Increased to 3s and added retry with exponential backoff (base 500ms, max 8s, ±10% jitter).

#### Takeaways

- Failure rate dropped from 5.2% to 0.1% — exponential backoff with jitter works
- Dev-environment defaults silently persisting into production is a recurring theme (see also: 2026-01-10-auth-token-expiry-gotcha)
- Would add a startup check that flags any timeout config under 2s in production

## Decisions (examples)

### 2026-01-20-1400-use-queue-for-webhooks

- **status**: accepted
- **tags**: architecture, error-handling
- **context_read**: 2026-01-15-fix-payment-timeout, src/webhooks/handler.ts
- **supersedes**: —
- **superseded_by**: —

#### Context

Webhook handler was processing events synchronously. Under load, slow downstream services caused the handler to back up, returning 500s to the webhook provider, which then retried — creating a cascade.

#### Decision

Move to async processing: webhook handler writes to a queue (SQS), a separate worker consumes and processes. Handler always returns 200 immediately.

#### Alternatives considered

- **Keep sync, add retries**: Doesn't fix the cascade — retries just add more load during the failure
- **In-memory buffer**: Faster but loses events on crash. Unacceptable for payment webhooks

#### Consequences

- Positive: handler never backs up, events survive worker crashes, can scale workers independently
- Negative: adds SQS dependency, eventual consistency (events processed seconds later, not instantly), need dead-letter queue monitoring
- Risks: SQS message loss (mitigated by dead-letter queue), delayed processing during spikes

## Insights (examples)

### 2026-01-15-exponential-backoff-with-jitter

- **type**: howto
- **confidence**: medium
- **episode_count**: 2
- **tags**: api, error-handling, performance
- **derived_from**: 2026-01-15-fix-payment-timeout
- **evidence**: 2026-01-15-fix-payment-timeout, 2026-01-10-auth-token-expiry-gotcha
- **updated**: 2026-01-20

#### Summary

When calling external APIs that intermittently timeout, use exponential backoff (base 500ms, max 8s) with ±10% jitter. Fixed-interval retries cause thundering herd on recovery. Observed ~70% failure rate reduction across 2 episodes.

#### When to apply

When you see timeout or rate-limit errors on outbound HTTP calls, especially during peak traffic. **Not** for errors that indicate permanent failure (4xx auth errors, malformed requests) — those should fail fast.

### 2026-01-20-dev-defaults-leak-to-production

- **type**: concept
- **confidence**: low
- **episode_count**: 2
- **tags**: config, monitoring
- **derived_from**: 2026-01-10-auth-token-expiry-gotcha
- **evidence**: 2026-01-10-auth-token-expiry-gotcha, 2026-01-15-fix-payment-timeout
- **updated**: 2026-01-20

#### Summary

Development-environment defaults (short timeouts, relaxed validation, stub endpoints) silently persist into production more often than expected. Both the auth token issue and the payment timeout traced back to a config value nobody changed after initial setup.

#### When to apply

When debugging production issues that "should work," check whether any config value is still at its development default. Add a startup validator that flags known dev-only values when `NODE_ENV=production`.

## Changelog (examples)

- 2026-01-10: captured auth token expiry gotcha
- 2026-01-15: fixed payment timeout, created retry-backoff insight
- 2026-01-18: captured config-file split after production-defaults review issue
- 2026-01-20: decided on async queue for webhooks, created dev-defaults-leak insight

---

<!-- ============================================================ -->
<!-- HISTORY — append-only project memory lives below              -->
<!-- ============================================================ -->

## Memory Index

Auto-refreshed snapshot. Do not edit manually — `/syntrace` regenerates this.

**Active decisions**: _(none yet)_
**High-confidence insights**: _(none yet)_
**Open questions**: _(none yet)_
**Last updated**: _(none yet)_

## Context

Low-friction captures. The inbox.

_Add entries below._

## Episodes

Structured work logs after significant sessions.

_Add entries below._

## Decisions

Architecture and design choices with rationale.

_Add entries below._

## Insights

Distilled, reusable patterns.

_Add entries below._

## Changelog

_Add one-line session summaries below._

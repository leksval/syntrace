# Syntrace

> Paste this file into any LLM. Work. Say `/syntrace` when done. The LLM outputs the updated file with your session appended. Save it. Paste it next time. Your memory grows.

---

## Cheat sheet

- **Output rule**: when triggered, output the **COMPLETE file** as a single markdown code block. Never output only the new entry.
- **Where to write**: append new entries **only** under the six MEMORY sections at the **end of this file** (Memory Index → Changelog). Do **not** modify **REFERENCE** or **EXAMPLES**.
- **Separator rule**: separate each session save in the history block with a horizontal rule: `---`
- **Read before you write**: scan existing Memory sections; update Insights instead of duplicating; link `supersedes` on decisions when superseding; back-link `superseded_by` on the old entry.
- **Trigger**: `/syntrace` -- always-full save. Append Episode + Decision (if applicable) + Insight (if a pattern emerged) + Context (if a standalone observation) + Changelog line. Refresh Memory Index.
- **Clarification**: the LLM may ask 1-2 questions before saving if the session scope or a key decision is ambiguous. Otherwise, save without asking.
- **Privacy**: never persist secrets, API keys, passwords, or PII in entries. Omit or redact.

**Full protocol, formats, lineage rules, and architecture** → see **REFERENCE** below. The append-only history lives at the end of the file.

## Guardrails

Hard boundaries. No exceptions.

- **Do not fabricate entries**: never invent episodes, decisions, or context that didn't happen in the session.
- **Do not modify REFERENCE**: the spec is immutable between explicit version bumps.
- **Do not merge or delete history entries**: entries are append-only. Use supersession and distillation, not editing or removal.
- **Do not output partial files**: always output the **COMPLETE file**. Partial outputs cause data loss.
- **Do not persist secrets**: omit API keys, tokens, passwords, PII -- no exceptions.
- **Do not skip lineage**: every entry must have `derived_from` and `context_read` filled, even if the value is `--`.
- **Do not invent slugs**: `derived_from`, `supersedes`, and `evidence` must point to real existing slugs or `--`.
- **Do not hallucinate file reads**: only list files in `context_read` that were actually consulted.
- **Scope boundary**: Syntrace records what happened and what was learned. It is not a task manager, backlog, or to-do list.

---

> INSTRUCTIONS SECTION
>
> Read and follow everything below this marker before saving.
> Do not append session history in this section.

<!-- ============================================================ -->
<!-- REFERENCE -- full specification (do not delete; LLM reads)    -->
<!-- ============================================================ -->

## How this file works

Three layers in one file: **Cheat sheet** (operating rules), **Reference** (stable protocol, schemas, examples -- never append history here), and **History** (append-only memory: Memory Index, Context, Episodes, Decisions, Insights, Changelog).

**Context rule**: any files pasted alongside this one or present in the workspace are additional context. Read them before writing entries. Record what you consulted in `context_read` (source files, docs, tickets, specs, prior entries, logs, diffs). Do **not** treat agent transcripts or chat history as project history. Works in two modes:
- **Paste mode** (plain LLM chat): user pastes this file + project files. Read everything, work, append.
- **Workspace mode** (IDE agent): read neighboring project files directly. Scan before saving.

## Save protocol

One trigger. One procedure. Always full depth.

**`/syntrace` step by step**:
1. Review what happened this session
2. If scope or a key decision is ambiguous, ask up to 2 clarification questions
3. Scan existing Memory sections -- read before you write
4. Append an Episode entry (outcome, takeaways, concrete details)
5. If a design/architecture choice was made, append a Decision entry
6. Check existing Insights -- update `confidence`, `episode_count`, `evidence` on reinforced ones; create new if a reusable pattern emerged
7. If there is a standalone observation, append a Context entry
8. Add a one-liner to Changelog
9. Distillation: if 5+ Context entries have `status: active`, promote reusable patterns to Insights and mark promoted entries `status: distilled`
10. Refresh Memory Index: active decisions, high-confidence insights, open questions, most recent entry date
11. Scan the reflection checklist
12. Output the **COMPLETE file** as a single markdown code block

When done for the session: **commit code**, then **save memory**.

## Writing quality

Write entries your future self can act on without re-reading the conversation.

**Capture**: the *why* not the *what* ("timeout to 3s because upstream SLA is 2s + retry headroom"), surprises and failures (highest signal), connections to prior entries (link via `derived_from`/`evidence`), concrete numbers ("p95 latency 800ms → 120ms" not "performance improved").

**Skip**: play-by-play narration, obvious observations, hedging and filler.

**Insight quality**: each insight must be **retrievable** (good tags + title), **actionable** (concrete trigger, not "when relevant"), and **falsifiable** (future evidence could upgrade or kill it). Prefer one sharp insight over three vague ones.

**Reflection checklist** (scan after every save):
- Did a structural pattern prove useful or fragile?
- Is there a spec-vs-implementation gap or a missing config causing silent degradation?
- Is there unnecessary complexity? What would you reuse tomorrow?
- Does an existing insight need its confidence or episode_count updated?
- Was a decision made implicitly but never recorded?

## Entry formats

Each entry is a `###` heading under its section. The heading slug is the entry's **stable identifier** -- use it for all cross-references. Use bullet-point metadata (not YAML fences).

### Context entry format

The lightest entry type. An inbox item: "would I want to find this in 30 days?"

```md
---
### YYYY-MM-DD-slug
- **status**: active
- **tags**: tag1, tag2
- **context_read**: files consulted
- **derived_from**: (related entry slug, if any)

Body: a few sentences or bullets. Focus on what surprised you or what
you'd want to remember in 30 days. Skip anything obvious.
```

Slugs must be descriptive: `2026-03-23-redis-eviction-policy-mismatch` not `2026-03-23-bug`. `status`: `active` (default) or `distilled` (promoted to Insight). When unsure, capture it -- distillation sorts it out. If longer than a paragraph, promote to Episode.

### Episode entry format

Structured work log. Write one every `/syntrace`. Focus on outcome and takeaway.

```md
---
### YYYY-MM-DD-slug
- **outcome**: SUCCESS | FAIL | SURPRISE | PARTIAL
- **tags**: tag1, tag2
- **context_read**: files consulted
- **derived_from**: (related entry slug, if any)

#### What happened
What you did and WHY -- not a transcript. Include concrete numbers.
One to three paragraphs max.

#### Takeaways
- What was learned (be specific enough to act on)
- What you'd do differently (with reasoning)
- Link to existing insights this reinforces or contradicts
```

**Outcome**: SUCCESS (goal met), FAIL (goal not met -- capture WHY; highest-signal entries), SURPRISE (unexpected outcome changing a prior assumption), PARTIAL (met with caveats).

"What happened" should pass the "dropped into this project cold" test. "Takeaways" is the most important part -- always check if it reinforces or contradicts an existing Insight.

### Decision entry format

Architecture decision record. Write when you chose X over Y and the reasoning matters. Decisions are **immutable** -- when reversed, add a new decision with `supersedes`.

```md
---
### YYYY-MM-DD-HHMM-slug
- **status**: accepted
- **tags**: tag1, tag2
- **context_read**: files consulted
- **supersedes**: (prior decision slug, if any)
- **superseded_by**: (filled when a newer decision supersedes this one)

#### Context
The situation or problem that forced a choice. Include constraints.

#### Decision
What was decided. Be direct -- one to two sentences.

#### Alternatives considered
- **Option A**: what it is, why it was rejected
- **Option B**: what it is, why it was rejected

#### Consequences
- Positive: what gets better
- Negative: what gets worse or harder
- Risks: what could go wrong with this choice
```

**Status**: `accepted` (in effect), `deprecated` (wrong but not yet replaced), `superseded` (replaced -- new one sets `supersedes`, old one gets `superseded_by`). Always list at least two alternatives. Be honest about negatives -- decisions without downsides weren't analyzed deeply enough.

### Insight entry format

Distilled, reusable knowledge. The highest-value entry type. Each insight must be **findable** (good tags + title), **actionable** (concrete trigger in "When to apply"), and **falsifiable** (precise enough that evidence could upgrade or kill it).

```md
---
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
Concrete trigger conditions -- not "when relevant" but "when you see
X happening in context Y, do Z." Include counter-examples.
```

**Type**: `concept` (mental model/principle) or `howto` (specific technique with steps). **Confidence**: `low` (observed once, hypothesis), `medium` (2-3 times or validated once), `high` (3+ times across contexts or benchmarked). `episode_count` tracks supporting episodes -- increment as confidence grows. "When to apply" must include counter-examples.

## Lineage rules

Entries are append-only. These rules ensure traceable knowledge evolution:

1. **Immutability**: slug and body are permanent once written. Only these fields may be updated in place: `status`, `superseded_by`, `confidence`, `episode_count`, `evidence`, `updated`.
2. **Supersession**: to reverse a Decision, write a new one with `supersedes` → old slug. Set the old one's `status` to `superseded` and add `superseded_by` → new slug. Never delete.
3. **Derivation**: use `derived_from` to trace origin. An Insight from an Episode cites the episode slug; an Episode building on Context cites the context slug.
4. **Evidence accumulation**: Insights list supporting entries in `evidence`. On reinforcement, add the episode slug and increment `episode_count`.
5. **Distillation**: when 5+ Context entries have `status: active`, promote reusable patterns to Insights and mark sources `status: distilled`. Do not delete -- they remain for lineage.

## Auto-fill rules

Fill these automatically -- never ask the user for them:

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

To add a new canonical tag: lowercase single word or hyphenated compound with at least one alias. Tags exist for retrieval -- use domain terms, not generic ones (`important`, `misc`, `todo`).

## Interoperability

**Syntrace stays the source of truth; tool-native files are views or import sources.** It can import from and export to other project-memory formats (context, instructions, decisions, patterns) without losing core ideas.

### Adapter principles

1. **Lossless import**: preserve information that does not map perfectly in the body of a Context or Decision entry.
2. **Distilled export**: export only active, high-signal material. Do not dump the full file.
3. **Keep lineage in Syntrace**: external formats cannot fully represent `derived_from`, `evidence`, or `supersedes`. Export human-readable summaries.
4. **No manual round-trips**: exported files are derived artifacts. Hand edits to them are treated as new source material on re-import.
5. **Privacy preserved**: imports and exports must still omit secrets, tokens, passwords, API keys, and PII.

### Adapter mappings

#### Claude Code (`CLAUDE.md`)

**Import**: map each `##` section to a Syntrace entry -- conventions/guidance → **Insight**, architectural choices → **Decision**, loose notes → **Context**. Set `context_read` to `CLAUDE.md`.

**Export**: build from accepted Decisions and medium/high-confidence Insights. Use concise sections (`## Key Commands`, `## Architecture`, `## Coding Conventions`). Omit Changelog noise, low-signal Context, and superseded Decisions.

#### Cursor rules (`.cursor/rules/*.mdc` or legacy `.cursorrules`)

**Import**: treat each rule file as one source unit. Broadly applicable guidance → **Insight**; path-specific or workflow notes → **Context** (unless they encode an architectural choice → **Decision**). Include `cursor` or `tooling` in tags when relevant.

**Export**: group by concern, not by Syntrace section. Convert active Insights and accepted Decisions into small topic-focused rule files. Prefer multiple short rules over one large file.

#### Generic markdown (`AGENTS.md`, `MEMORY.md`, `RULES.md`, similar)

**Import**: treat each heading block as a candidate Context, Insight, or Decision. Preserve unfamiliar structure in the body. Tag with `tooling` by default.

**Export**: generate concise project instructions from accepted Decisions and reusable Insights. Keep files short enough for agents to load reliably.

## Validation

A validator reports **errors** for broken invariants and **warnings** for quality issues.

### File-level invariants

Errors:
- The file must contain the six MEMORY sections in order: Memory Index, Context, Episodes, Decisions, Insights, Changelog
- The file must retain the REFERENCE block
- Entry headings must be unique across the file
- New entries must appear only under MEMORY sections

Warnings: EXAMPLES block is optional but recommended. If the file grows beyond practical reading size, suggest splitting by domain.

### Entry schema (required fields)

| Entry type | Slug form | Required fields | Required sections | Allowed values |
|------------|-----------|----------------|-------------------|----------------|
| Context | `YYYY-MM-DD-slug` | `status`, `tags`, `context_read`, `derived_from`, non-empty body | -- | status: `active` / `distilled` |
| Episode | `YYYY-MM-DD-slug` | `outcome`, `tags`, `context_read`, `derived_from` | What happened, Takeaways | outcome: `SUCCESS` / `FAIL` / `SURPRISE` / `PARTIAL` |
| Decision | `YYYY-MM-DD-HHMM-slug` | `status`, `tags`, `context_read`, `supersedes`, `superseded_by` | Context, Decision, Alternatives considered, Consequences | status: `accepted` / `deprecated` / `superseded` |
| Insight | `YYYY-MM-DD-slug` | `type`, `confidence`, `episode_count`, `tags`, `derived_from`, `evidence`, `updated` | Summary, When to apply | type: `concept` / `howto`; confidence: `low` / `medium` / `high` |

### Lineage validation

Errors:
- `derived_from`, `supersedes`, `superseded_by` must point to an existing slug or `--`
- Every slug in `evidence` must exist
- A Decision with `status: superseded` must have a non-empty `superseded_by`
- `supersedes` must point to a Decision entry, not another type

Warnings:
- Insight `episode_count` does not match the length of `evidence`
- An Episode reinforces an existing Insight but does not mention it
- A Context entry longer than a short paragraph (may belong as an Episode)

### Memory Index refresh

The Memory Index is derived, not hand-authored. Rebuild it each `/syntrace`:

- **Active decisions**: Decisions with `status: accepted`
- **High-confidence insights**: Insights with `confidence: high`
- **Open questions**: unresolved questions from active Context or recent Episodes/Decisions
- **Last updated**: most recent entry date across all Memory sections

Replace the entire snapshot each time. Link by slug. Render `_(none yet)_` for empty categories.

## File-only model

Syntrace is intentionally just a markdown file -- usable with plain copy/paste, manual edits, and version control. No database, service, or sync layer required. Tooling should support the file, not replace it.

## Architecture

For multi-agent workflows or IDE agents. If pasting into a plain LLM chat, the save protocol and entry formats above are all you need.

Planning is optional. Skip it when the task is small, concrete, and low-risk. Use a Planner when the task is multi-step, touches multiple systems, has trade-offs, or risks irreversible mistakes.

### Agent roles

| Role | What it does | Invariants |
|------|-------------|------------|
| **Planner** | Decomposes goals into subtasks, assigns agents, synthesizes output | No irreversible actions without human OK. Log decisions with rationale. Check Insights before planning. |
| **Worker** | Executes one well-defined subtask. Narrow focus. | Never exceed scope. On failure: return error + context, never silently retry. |
| **Critic** | Reviews Worker output. Returns PASS, REVISE, or REJECT. | Critique must be specific and actionable. Never approve invariant violations. |

New roles are specialized Workers (e.g., Researcher, Tester), not new top-level roles.

### Quality checks

The Critic applies these on every review. In single-agent mode, self-apply before saving:

- [ ] Correct entry type, all required fields present
- [ ] No agent-role invariants violated
- [ ] No hallucinated tool outputs
- [ ] Rationale present for non-obvious decisions
- [ ] Connections to existing entries noted (reinforces, contradicts, supersedes)
- [ ] Lineage fields populated (`derived_from`, `evidence`, `supersedes`)

**Verdicts**: PASS (all checks pass), REVISE (minor issues, max 2 rounds), REJECT (invariant breach, missing rationale, wrong entry type).

### Scaling memory

| Strategy | When | How |
|----------|------|-----|
| **Memory Index scan** | Always | Read first -- surfaces active decisions and high-confidence insights |
| **Tag scan** | 30-100 entries | Search tags matching your task's keywords |
| **Recency + confidence** | 100+ entries | 15-20 most recent entries + `confidence: high` Insights |
| **Lineage walk** | Tracing a topic | Follow `derived_from` and `evidence` 1-2 hops |

At ~500 entries, split by domain (e.g., `syntrace-frontend.md`, `syntrace-infra.md`). Each file is self-contained.

---

<!-- ============================================================ -->
<!-- EXAMPLES -- illustrative (optional; delete for clean slate)   -->
<!-- ============================================================ -->

## Context (examples)

### 2026-01-10-auth-token-expiry-gotcha

- **status**: distilled
- **tags**: auth, config
- **context_read**: src/auth/middleware.ts
- **derived_from**: --

Spent 40 minutes debugging 401s before realizing refresh tokens expire after 7 days of inactivity, not 7 days from issue. The docs say "7-day expiry" without clarifying. Need to add a buffer that refreshes proactively at day 5.

### 2026-01-18-large-config-file-hid-production-defaults

- **status**: active
- **tags**: config, architecture
- **context_read**: src/config/index.ts, docs/deploy.md
- **derived_from**: --

Keeping runtime and deployment settings in one large config file made it easy to miss production-only defaults during review. Splitting the config into smaller domain files made environment-specific settings easier to audit and reduced the chance of dev defaults leaking into production.

## Episodes (examples)

### 2026-01-15-fix-payment-timeout

- **outcome**: SUCCESS
- **tags**: api, error-handling, config
- **context_read**: src/payments/client.ts, 2026-01-10-auth-token-expiry-gotcha
- **derived_from**: --

#### What happened

Payment endpoint timing out ~5% of requests during peak hours. Root cause: upstream provider has a 2s SLA but our timeout was set to 1s (leftover from dev defaults). Increased to 3s and added retry with exponential backoff (base 500ms, max 8s, ±10% jitter).

#### Takeaways

- Failure rate dropped from 5.2% to 0.1% -- exponential backoff with jitter works
- Dev-environment defaults silently persisting into production is a recurring theme (see also: 2026-01-10-auth-token-expiry-gotcha)
- Would add a startup check that flags any timeout config under 2s in production

## Decisions (examples)

### 2026-01-20-1400-use-queue-for-webhooks

- **status**: accepted
- **tags**: architecture, error-handling
- **context_read**: 2026-01-15-fix-payment-timeout, src/webhooks/handler.ts
- **supersedes**: --
- **superseded_by**: --

#### Context

Webhook handler was processing events synchronously. Under load, slow downstream services caused the handler to back up, returning 500s to the webhook provider, which then retried -- creating a cascade.

#### Decision

Move to async processing: webhook handler writes to a queue (SQS), a separate worker consumes and processes. Handler always returns 200 immediately.

#### Alternatives considered

- **Keep sync, add retries**: Doesn't fix the cascade -- retries just add more load during the failure
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

When you see timeout or rate-limit errors on outbound HTTP calls, especially during peak traffic. **Not** for errors that indicate permanent failure (4xx auth errors, malformed requests) -- those should fail fast.

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
<!-- HISTORY -- append-only project memory lives below              -->
<!-- ============================================================ -->

> HISTORY SECTION
>
> Append new project history below this marker only.
> Do not modify the instruction and reference sections above.

## Memory Index

Auto-refreshed snapshot. Do not edit manually -- `/syntrace` regenerates this.

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

_Session saves are separated with `---`._

# Syntrace

> **What this is**: single-file portable memory seed for any AI system (LLM chat, IDE agent, autonomous loop, multi-agent runtime, RAG pipeline) in any domain. One markdown file. No database, no service, no lock-in. Drop next to the work; AI reads it; produces durable, interoperable memory in a standard schema. Existing coding workflows keep working; same format handles every other domain.

> **AI system directive**: applies to any LLM, agent, or runtime reading this. Scan the full session context above this paste (chat, agent trace, tool-call log). Extract reusable lessons, decisions, and patterns. Append into MEMORY sections at the end. Filesystem access → write the updated file to disk, return only the **Memory Index** as confirmation. No filesystem → output the COMPLETE updated file as one markdown code block. Never ask clarifying questions on first use of a fresh file. Never say "nothing to save." The session context IS the session.

---

## Cheat sheet

- **Output tiers** (first available wins):
  1. Filesystem access → write full file, reply with only Memory Index.
  2. No filesystem, fits in output → print COMPLETE file as one markdown code block.
  3. Would truncate → print only Memory Index.
  Never output just a fragment.
- **Fresh-file rule**: empty history → skip clarification. Scan session, extract, save. Never reply "nothing to save" just because history is empty.
- **Where to write**: append only under the six MEMORY sections at the end (Memory Index → Changelog). Never modify REFERENCE or EXAMPLES, except in-place Tag Canon table updates.
- **Separators**: horizontal rule `---` between Changelog saves only. Not inside Context/Episodes/Decisions/Insights.
- **Read before write**: scan existing Memory sections. Update reinforced Insights, don't duplicate. Link `supersedes`/`superseded_by` when reversing decisions.
- **Trigger**: `/syntrace` is the shorthand, not a separate mode. Also fire when user/orchestrator/hook clearly asks to save memory, capture lessons, or extract learning.
- **Intent inference**: figure out whether the ask is session save, lesson extraction, or both. Apply Output tiers. Don't treat "no direct filesystem" as grounds to refuse — use the next tier.
- **Clarification**: on saves with existing history, may ask 2-3 questions only when scope/key decision/takeaway is genuinely ambiguous. Autonomous/pipeline modes → skip questions, save with honestly low confidence. Fresh file → never clarify.
- **Privacy**: never persist secrets, API keys, passwords, PII. Omit or redact.

**Full protocol, formats, lineage, architecture** → see **REFERENCE** below. Append-only history lives at the end.

## Guardrails (hard boundaries; no exceptions)

- **No fabrication**: never invent events that didn't happen in the session. Extracting and distilling from the live session IS the job — not fabrication.
- **No REFERENCE edits**: spec is immutable between version bumps. Only the Tag Canon table is project state and may be updated in place.
- **Append-only history**: never merge or delete entries. Use supersession and distillation, not editing or removal.
- **No partial files**: when writing to disk, always write the COMPLETE file. Follow Output tiers strictly on chat fallback (full file or Memory Index — never a fragment).
- **Write-to-disk when possible**: any filesystem access (tool, MCP, SDK, shell, IDE agent, orchestrator) → MUST write to disk, reply with only Memory Index. Full-file-in-chat is a paste-mode fallback, not a preference. Dumping the file in chat when you can write to disk wastes tokens.
- **No secrets**: omit API keys, tokens, passwords, PII.
- **Required fields filled**: every entry includes its required fields; lineage fields are a real slug or `--`.
- **No invented slugs**: `derived_from`, `supersedes`, `evidence` → existing slug or `--`.
- **No hallucinated reads**: `context_read` lists only files actually consulted.
- **Not self-referential**: never record entries about using/saving/editing Syntrace. The protocol is the tool, not the subject.
- **Scope**: Syntrace records what happened and what was learned. Not a task manager, backlog, or to-do list.

---

> INSTRUCTIONS SECTION — Read and follow everything below this marker before saving. Do not append session history here.

<!-- ============================================================ -->
<!-- REFERENCE — full specification (do not delete; LLM reads)    -->
<!-- ============================================================ -->

## Layers

1. **Cheat sheet** — operating rules (above).
2. **Reference** — stable protocol, schemas, examples. Never append history here.
3. **History** — append-only: Memory Index, Context, Episodes, Decisions, Insights, Changelog.

**Context rule**: the surrounding session is the current session by default. Pasted files/traces/artifacts are additional context; record what you consulted in `context_read`.

## AI system modes

A **session** = any bounded unit of work (chat turn, agent run, task episode, scheduled batch, pipeline shard). Save fires at session end regardless of producer.

| Mode | Session = | Trigger | Notes |
|------|-----------|---------|-------|
| **Paste** (plain chat) | chat history | human `/syntrace` | Chat IS the session. Don't ask repaste. |
| **Workspace** (IDE agent, coding assistant, desktop agent) | chat + consulted files | `/syntrace` or IDE hook | Consult diffs, logs, git history, relevant docs. |
| **Autonomous** (single-agent goal loop; no human turn-taking) | one goal/task run | programmatic at loop end, checkpoint, or context-window pressure | Agent is its own save-caller. |
| **Multi-agent** (orchestrated group sharing one file) | one coordinated run | orchestrator | Every entry MUST carry `author`. Single-writer invariant applies. |
| **Pipeline / RAG** (memory = retrieval corpus) | one batch/shard/ingestion window | post-batch hook | Entries MAY carry `artifacts` pointers (embeddings, datasets, traces) for re-index without reparse. |

**Single-writer-per-save invariant**: within one save, only one actor writes the full file. Concurrent saves MUST serialize via queue/lock/orchestrator turn. Append-only ≠ concurrent-write-safe; orchestrator (or designated Librarian) owns write order.

## Behavior on load

Active memory protocol, not passive documentation. Follow the **AI system directive** (top) and **Cheat sheet**. On a fresh file, scan the session context, extract, append, save per Output tiers. No questions first.

## Save protocol

One trigger, one procedure, always full depth.

1. Review this session. Paste mode: live chat IS the session. Other modes: whatever bounded unit just finished (chat + files consulted, agent run, batch, shard). Don't require repaste.
2. Fresh file → skip clarification. Existing history → may ask 2-3 brief questions only if scope is genuinely ambiguous.
3. Scan existing Memory sections and session-relevant source material. If possible, check relevant git history for files/decisions involved.
4. **Dedup before filing** — scan existing Insights for semantic overlap. Lesson already exists → update `confidence`/`evidence_count`/`evidence`/`updated` on the existing entry instead of creating a near-duplicate. If you still create a new entry, make the distinction explicit.
5. Append an Episode entry (outcome, takeaways, concrete details).
6. Design/architecture choice made → append a Decision entry.
7. Update reinforced Insights (`confidence`, `evidence_count`, `evidence`); create new if a reusable pattern emerged.
8. Standalone observation → append a Context entry.
9. One-liner to Changelog.
10. **Distill** — when 5+ Context entries have `status: active`, promote reusable patterns to Insights and mark promoted entries `status: distilled`.
11. Refresh Memory Index: active decisions, high-confidence insights, open questions, most recent entry date.
12. Scan the reflection checklist.
13. **Output** per Output tiers: write full file to disk and reply with Memory Index; else print complete file; else print only Memory Index.

**Entry type heuristics**:

- **Insight** — lesson generalizes beyond this session, phrasable as trigger + action, with a plausible counter-example.
- **Decision** — chose X over Y and the alternatives/trade-offs/rationale will matter later. No real alternative or lasting consequence → probably not a Decision.
- **Episode** — resolved problem, shipped change, investigation, or benchmark with a clear outcome and takeaway.
- **Context** — short observation/fact/input that may matter later but doesn't yet generalize. Longer than a short paragraph → promote to Episode.

**Finalize-then-save**: external artifact produced (commit code, publish doc, ship change, release dataset, hand off to another agent) → finalize artifact first, then save memory. No external change → just save.

## Writing quality

Write for a future self who won't re-read the conversation.

- **Capture**: the *why* ("timeout 3s because upstream SLA is 2s + retry headroom"); surprises and failures (highest signal); links to prior entries (`derived_from`/`evidence`); concrete numbers ("p95 800ms → 120ms", not "performance improved").
- **Skip**: play-by-play narration, obvious observations, hedging, filler.
- **Insight quality**: **retrievable** (good tags + title), **actionable** (concrete trigger, not "when relevant"), **falsifiable** (future evidence could upgrade or kill it). One sharp insight beats three vague ones.

**Reflection checklist** (after every save):

- Did a structural pattern prove useful or fragile?
- Spec-vs-implementation gap or missing config causing silent degradation?
- Unnecessary complexity? What would you reuse tomorrow?
- Existing Insight need updated `confidence`/`evidence_count`?
- Decision made implicitly but never recorded?

## Entry formats

Each entry is a `###` heading under its section. Heading slug = entry's **stable identifier**; use it for all cross-references. Bullet metadata (not YAML fences).

### Universal optional fields (any type)

- **`author`** — `human`, an agent id (`planner-01`), or a role (`librarian`). Omit in single-actor paste mode. **Required** in multi-agent mode.
- **`artifacts`** — comma-separated `type:uri` pointers to non-text memory. Types: `image`, `audio`, `video`, `tool_trace`, `log`, `metric`, `embedding`, `dataset`, `doc`. Example: `image:./screens/flow.png, tool_trace:runs/2026-04-16.jsonl, embedding:vec://insights/backoff-pattern`. File stays plain markdown; artifacts live wherever your system stores them.

### Context — lightest type; inbox item

"Would I want to find this in 30 days?"

```md
---
### YYYY-MM-DD-slug
- **status**: active
- **tags**: tag1, tag2
- **context_read**: files consulted
- **derived_from**: (slug or --)
- **valid_from**: YYYY-MM-DD or version-range (optional)
- **valid_until**: YYYY-MM-DD or version-range (optional)
- **author**, **artifacts**: (optional; author required in multi-agent)

Body: a few sentences. Focus on surprises and what you'd want in 30 days. Skip anything obvious.
```

Slugs descriptive (`2026-03-23-redis-eviction-policy-mismatch`, not `2026-03-23-bug`). `status`: `active` (default) or `distilled` (promoted to Insight). Use `valid_from`/`valid_until` when tied to a known date/release/version window. Longer than a paragraph → promote to Episode. When unsure, capture it — distillation sorts it out.

### Episode — structured work log; one per `/syntrace`

```md
---
### YYYY-MM-DD-slug
- **outcome**: SUCCESS | FAIL | SURPRISE | PARTIAL
- **tags**: ...
- **context_read**: ...
- **derived_from**: (slug or --)
- **author**, **artifacts**: (optional)

#### What happened
What you did and WHY. Not a transcript. Concrete numbers. 1-3 paragraphs.

#### Takeaways
- Specific-enough-to-act-on lessons
- What you'd do differently, with reasoning
- Insights reinforced or contradicted
```

**Outcome**: SUCCESS (goal met), FAIL (not met — capture WHY; highest-signal), SURPRISE (unexpected, changes a prior assumption), PARTIAL (met with caveats). "What happened" must pass the "dropped in cold" test. Takeaways must link to existing Insights reinforced or contradicted.

### Decision — ADR; chose X over Y and reasoning matters

Decisions are **immutable** — reverse by writing a new one with `supersedes`.

```md
---
### YYYY-MM-DD-HHMM-slug
- **status**: accepted
- **tags**: ...
- **context_read**: ...
- **supersedes**: (slug or --)
- **superseded_by**: (filled when reversed)
- **author**, **artifacts**: (optional)

#### Context
Situation/problem forcing a choice. Constraints.

#### Decision
What was decided. 1-2 sentences.

#### Alternatives considered
- **Option A**: what it is, why rejected
- **Option B**: what it is, why rejected

#### Consequences
- Positive: what gets better
- Negative: what gets worse/harder
- Risks: what could go wrong
```

**Status**: `accepted` (in effect), `deprecated` (wrong but not yet replaced), `superseded` (replaced — new one sets `supersedes`, old one gets `superseded_by`). List ≥2 alternatives. Be honest about negatives — no-downside decisions weren't analyzed deeply.

### Insight — distilled reusable knowledge; highest-value type

Must be **findable** (tags + title), **actionable** (concrete trigger in "When to apply"), **falsifiable** (future evidence could confirm or kill).

```md
---
### YYYY-MM-DD-slug
- **type**: concept | howto
- **confidence**: low | medium | high
- **evidence_count**: 1
- **tags**: ...
- **derived_from**: source slug
- **evidence**: slug1, slug2
- **updated**: YYYY-MM-DD
- **valid_from** / **valid_until**: optional
- **author**, **artifacts**: (optional)

#### Summary
One paragraph precise enough that future evidence could confirm or kill it.

#### When to apply
Concrete trigger: "when you see X in context Y, do Z." Include counter-examples.
```

**Type**: `concept` (mental model/principle) or `howto` (technique with steps). **Confidence**: `low` (1 observation, hypothesis), `medium` (2-3 evidence points or 1 validated), `high` (3+ across contexts or benchmarked). `evidence_count` = length of `evidence`; increment on reinforcement.

## Lineage rules

Entries are append-only.

1. **Immutability**: slug and body permanent once written. Mutable in place: `status`, `superseded_by`, `confidence`, `evidence_count`, `evidence`, `updated`, `valid_from`, `valid_until`, `artifacts` (accumulates). `author` fixed at write time.
2. **Supersession**: reverse a Decision → new one with `supersedes` → old slug. Old's `status` → `superseded`, `superseded_by` → new slug. Never delete.
3. **Derivation**: `derived_from` traces origin (Insight from Episode; Episode building on Context).
4. **Evidence accumulation**: Insights list supports in `evidence`; increment `evidence_count` on reinforcement.
5. **Distillation**: 5+ active Contexts → promote reusable patterns to Insights, mark sources `status: distilled`. Never delete — retained for lineage.

## Auto-fill (never ask the user)

| Field | Value | Example |
|-------|-------|---------|
| date in heading | today | `### 2026-03-23-fix-auth-flow` |
| `context_read` | files/sections/entries/tickets/logs read before writing | `src/auth.ts, docs/auth.md, 2026-01-20-dev-defaults-leak` |
| `tags` | 2-5 lowercase keywords from Tag Canon | `api, error-handling, config` |
| `outcome` | best of SUCCESS/FAIL/SURPRISE/PARTIAL | `SURPRISE` |
| `slug` | descriptive, lowercase, hyphenated, no filler | `fix-payment-timeout`, not `todays-work` |
| `status` | default for type | Context: `active`; Decision: `accepted` |
| `evidence_count` | 1 for new Insights | `1` |
| `updated` | today when modifying existing Insight | `2026-03-23` |
| `derived_from` | source slug when applicable | `2026-01-15-fix-payment-timeout` |
| `superseded_by` | auto-filled on old decision when new one supersedes | `2026-03-23-1400-switch-to-redis` |
| `author` | writing actor; omit single-actor paste; required multi-agent | `planner-01`, `human`, `librarian` |
| `artifacts` | `type:uri` refs to non-text memory | `tool_trace:runs/2026-04-16.jsonl, image:./screens/flow.png` |

## Tag canon

Project-specific, domain-neutral. On first `/syntrace` for a new project, seed canonical tags from actual domains/systems/concerns. Seed signals by project type:

- **Code**: dependency manifests (`package.json`, `pyproject.toml`, lockfiles), top-level dirs, README headings, recurring filename terms.
- **Research / writing / knowledge**: section headings in source corpus, recurring subjects in prior notes, brief/charter, reference keywords.
- **Support / ops / incident**: ticket categories, runbook topics, system/component names, incident taxonomy.
- **Autonomous / multi-agent**: agent charter/purpose, tool categories, environment domain.
- **Fallback**: first few sessions' recurring terms — watch what you keep writing; promote repeated phrases to tags.

Lowercase single words or hyphenated compounds. Each tag ≥1 alias. Use domain terms, not generic (`important`, `misc`, `todo`). Add canonical tags in later saves when no existing tag covers the concept.

| Canonical | Aliases | Domain |
|-----------|---------|--------|
| _populate on first `/syntrace` run_ | | |

## Interoperability

**Syntrace = source of truth; tool-native files = views or import sources.** Import from and export to other project-memory formats without losing core ideas.

### Adapter principles

1. **Lossless import** — preserve unmappable info in Context/Decision body.
2. **Distilled export** — active, high-signal only. Not a full dump.
3. **Lineage stays in Syntrace** — external formats can't fully represent `derived_from`/`evidence`/`supersedes`. Export human-readable summaries.
4. **No manual round-trips** — exported files are derived. Hand edits treated as new source material on re-import.
5. **Privacy preserved** — imports and exports still omit secrets, PII.

### Lessons extraction

Same default behavior as `/syntrace`. Live session = evidence. Extract reusable knowledge, append into Memory sections, save per Output tiers.

#### Extraction reasoning model

Surface extraction ("we did X, it worked") decays to noise. Deep extraction converts raw experience into transferable knowledge. Eight principles from cognitive science guide what to extract and how:

1. **Episodic → semantic crystallization** (Tulving 1972) — Context/Episodes capture episodic detail; Insights distill semantic knowledge. Ask *what generalizes beyond this incident?* If nothing, Context is honest. Premature generalization = weak Insights.
2. **Effortful retrieval over passive review** (Roediger & Karpicke 2006; Bjork 1992) — articulate the causal mechanism ("timeout too low *because* dev defaults leaked"), not the surface event ("we changed the timeout"). The effort of causal articulation is the point.
3. **Double-loop over single-loop learning** (Argyris 1977) — beyond "config was wrong, we fixed it" → "our process doesn't catch dev defaults leaking — why?" Every FAIL/SURPRISE: *what assumption was wrong, and is it embedded elsewhere?*
4. **Recognition-primed decision patterns** (Klein 1998) — experts recognize situations and apply learned patterns. Frame Insights as recognition cues: "when you see X in context Y" matches how pattern recognition actually fires.
5. **Pre-mortem / prospective hindsight** (Klein 2007; Mitchell et al. 1989) — for Decision Risks, *assume this failed in 6 months — what went wrong?* Prospective hindsight surfaces threats forward-looking analysis misses.
6. **Reflective practice** (Schön 1983) — reflection ≠ narration. "What happened" describes; "Takeaways" interrogates. *What surprised me? What would I do differently? What did I assume that turned out wrong?*
7. **Sensemaking under ambiguity** (Weick 1995) — events become meaningful retrospectively. Beware post-hoc rationalization: if real cause was unclear, say so. "Root cause uncertain, two hypotheses" is higher-signal than a fabricated clean narrative.
8. **Falsifiability as quality filter** (Popper 1959) — unfalsifiable insights are useless. "Always use best practices" teaches nothing. "Exp. backoff + jitter reduces timeout failures 50-70% on intermittent upstream errors" can be confirmed, refined, or killed.

**Meta-insight**: extraction value ∝ friction applied. Every principle above adds productive resistance — causal articulation over summary (Roediger, Bjork), systems-questioning over symptom-treating (Argyris), falsifiable precision over truisms (Popper), honest uncertainty over rationalization (Weick), interrogation over narration (Schön). This is Bjork's "desirable difficulties" at the knowledge-management level. Effortless entries are almost certainly too shallow.

#### Extraction checklist

Apply after drafting, before output:

- [ ] **Causal depth** — *why*, not just *what*? (Roediger; Bjork)
- [ ] **Assumption audit** — what belief was tested or broken? (Argyris)
- [ ] **Generalization** — does it generalize? One-off → Context. (Tulving)
- [ ] **Recognition framing** — Insight as trigger + action? (Klein)
- [ ] **Falsifiability** — could future evidence change confidence? (Popper)
- [ ] **Honest ambiguity** — said "uncertain" rather than fabricating? (Weick)
- [ ] **Prospective failure** — for Decisions, imagined 6-month failure mode? (Klein)

### Adapter mappings

All adapters: **Import** = map into Syntrace entries (preserve unmappable in body). **Export** = active, distilled, privacy-preserving.

- **Claude Code (`CLAUDE.md`)** — each `##` section → entry. Conventions/guidance → **Insight**; architectural choices → **Decision**; loose notes → **Context**. `context_read: CLAUDE.md`. Export to concise sections (`## Key Commands`, `## Architecture`, `## Coding Conventions`) from accepted Decisions + medium/high Insights. Omit Changelog, low-signal Context, superseded Decisions.
- **Cursor rules (`.cursor/rules/*.mdc` or legacy `.cursorrules`)** — each file = one source unit. Broadly applicable → **Insight**; path/workflow → **Context** (unless architectural → **Decision**). Tag with `cursor`/`tooling`. Export as multiple short topic-focused rule files grouped by concern.
- **Generic markdown (`AGENTS.md`, `MEMORY.md`, `RULES.md`, similar)** — each heading block → candidate Context/Insight/Decision. Preserve unfamiliar structure in body. Tag `tooling`. Export concise project instructions from accepted Decisions + reusable Insights. Keep files short enough for agents to load reliably.
- **Programmatic / API (SDKs, orchestrators, autonomous agents)** — accept JSON per entry; keys mirror markdown schema exactly (`slug`, `type`, `status`, `tags`, `context_read`, `derived_from`, `evidence`, `author`, `artifacts`, body sections as strings). Render into markdown, append under matching MEMORY section. Export as JSON array with envelope `schema_version`. **Round-trip rule**: JSON is a view; markdown wins on conflict. Never hand-edit exported JSON and re-import — treat as new source material.
- **Vector store / retrieval index** — for each active Insight (optionally each Episode), emit an embedding record keyed by slug with summary/tags/`valid_from`/`valid_until` as filterable metadata. Re-embed on update (`confidence`/`evidence_count`/`evidence`/`updated` changes). Imports from external index → Context entry with `artifacts: embedding:<vector-uri>`; promote to Insight via distillation. File wins on conflict; index is rebuilt.
- **Multi-agent handoff** — control transfer sends minimal packet `{memory_index, open_questions, last_session_id, last_author}`. Receiver reads packet for wake-up; full file only if deeper lineage is needed. Every entry MUST carry `author`. Orchestrator (or designated Librarian) enforces the single-writer invariant. **Conflict resolution**: two agents writing semantically overlapping entries → Librarian merges into one with combined `evidence` and both authors comma-separated in `author`.

## Validation

Errors break invariants. Warnings flag quality issues.

### File-level

**Errors**:

- HISTORY section contains the six MEMORY sections in order: Memory Index, Context, Episodes, Decisions, Insights, Changelog.
- REFERENCE block is retained.
- Entry headings unique across the file.
- New entries only under MEMORY sections below the HISTORY marker.

**Warnings**: EXAMPLES optional but recommended. File past practical reading size → suggest domain split.

### Entry schema

| Type | Slug | Required fields | Required sections | Allowed values |
|------|------|-----------------|-------------------|----------------|
| Context | `YYYY-MM-DD-slug` | `status`, `tags`, `context_read`, `derived_from`, non-empty body | — | status: `active`/`distilled` |
| Episode | `YYYY-MM-DD-slug` | `outcome`, `tags`, `context_read`, `derived_from` | What happened, Takeaways | outcome: `SUCCESS`/`FAIL`/`SURPRISE`/`PARTIAL` |
| Decision | `YYYY-MM-DD-HHMM-slug` | `status`, `tags`, `context_read`, `supersedes`, `superseded_by` | Context, Decision, Alternatives considered, Consequences | status: `accepted`/`deprecated`/`superseded` |
| Insight | `YYYY-MM-DD-slug` | `type`, `confidence`, `evidence_count`, `tags`, `derived_from`, `evidence`, `updated` | Summary, When to apply | type: `concept`/`howto`; confidence: `low`/`medium`/`high` |

`valid_from`/`valid_until` optional on Context and Insight (time/version-bounded knowledge). `author` and `artifacts` optional on any type; `author` **required** in multi-agent. `artifacts` is a `type:uri` list; validator checks format, doesn't dereference.

### Lineage validation

**Errors**:

- `derived_from`, `supersedes`, `superseded_by` → existing slug or `--`.
- Every slug in `evidence` must exist.
- Decision with `status: superseded` must have non-empty `superseded_by`.
- `supersedes` must point to a Decision, not another type.

**Warnings**:

- `evidence_count` ≠ length of `evidence`.
- Episode reinforces an Insight but doesn't mention it.
- Context longer than a short paragraph (→ Episode).
- Multi-agent entry missing `author`.
- `artifacts` value doesn't match `type:uri` or uses unknown type.

### Memory Index refresh

Derived, not hand-authored. Rebuild each `/syntrace`:

- **Active decisions** — `status: accepted`.
- **High-confidence insights** — `confidence: high`.
- **Open questions** — unresolved questions from active Context or recent Episodes/Decisions.
- **Last updated** — most recent entry date across all Memory sections.

Target ~200-400 tokens. Wake-up context — first snapshot an agent reads before any deeper scan. Replace snapshot each time. Link by slug. Render `_(none yet)_` for empty categories.

## File-only model

Intentionally just a markdown file — usable with plain copy/paste, manual edits, version control. No database, service, or sync layer. Tooling supports the file, doesn't replace it.

## Architecture (optional reference patterns)

For multi-agent workflows, IDE agents, autonomous loops. Plain LLM chat needs only the save protocol and entry formats above.

Roles below = **reference pattern, not requirement**. A single autonomous agent may collapse them all; a chat LLM typically skips Planner; a RAG pipeline may only run Librarian.

Planning optional. Skip when small/concrete/low-risk. Use when multi-step, cross-system, trade-off-heavy, or risks irreversible mistakes.

### Agent roles

| Role | What it does | Invariants |
|------|-------------|------------|
| **Planner** | Decomposes goals, assigns agents, synthesizes output | No irreversible actions without human OK. Log decisions with rationale. Check Insights before planning. |
| **Worker** | Executes one well-defined subtask; narrow focus | Never exceed scope. On failure: return error + context; never silently retry. |
| **Critic** | Reviews Worker output (PASS/REVISE/REJECT) | Critique specific and actionable. Never approve invariant violations. |
| **Librarian** (optional) | Read-mostly: runs extraction checklist, refreshes Memory Index, resolves multi-agent conflicts, owns single-writer-per-save lock | Never creates original work. May merge overlapping entries per handoff rules. |

New roles are specialized Workers (Researcher, Tester), not new top-level roles.

### Autonomous-loop checkpoints

No human turn driving `/syntrace` → agent (or orchestrator) calls the save protocol:

- After 10-20 tool calls in a focused sub-goal when meaningful takeaways accumulated.
- On goal completion, before returning to parent planner or user.
- On error escalation, retry exhaustion, or abandoned branch — FAIL episodes are highest-signal.
- On context-window pressure, before compaction/handoff would drop unsaved rationale.
- On schedule for long-running agents (e.g., hourly) so mid-run learning survives a crash.

Batch around meaningful checkpoints. Not every trivial step.

### Quality checks (Critic on review; self-apply in single-agent)

- [ ] Correct entry type, all required fields present
- [ ] No agent-role invariants violated
- [ ] No hallucinated tool outputs
- [ ] Rationale for non-obvious decisions
- [ ] Connections to existing entries noted (reinforces, contradicts, supersedes)
- [ ] Lineage fields populated (`derived_from`, `evidence`, `supersedes`, `superseded_by`)

**Verdicts**: PASS (all checks pass), REVISE (minor issues, max 2 rounds), REJECT (invariant breach / missing rationale / wrong type).

### Scaling memory

| Strategy | When | How |
|----------|------|-----|
| Memory Index scan | always | read first — surfaces active decisions + high-confidence insights |
| Tag scan | 30-100 entries | search tags matching task keywords |
| Recency + confidence | 100+ entries | 15-20 most recent + `confidence: high` Insights |
| Lineage walk | tracing a topic | follow `derived_from`/`evidence` 1-2 hops |

At ~500 entries, split by domain (`syntrace-frontend.md`, `syntrace-infra.md`). Each file self-contained.

### Hook triggers

Recommended auto-save triggers (IDE agents, autonomous loops, multi-agent orchestrators, wrappers, hooks):

- After 10-15 messages/tool calls in a focused thread with meaningful work/takeaways/decisions.
- Before context compaction, handoff, model reset, or other memory-loss boundaries.
- Session end or prolonged idle when unsaved rationale would be lost.
- After milestone events (commit, ship, publish, task done, handoff) once work has stabilized.

Batch around meaningful checkpoints. Not every trivial edit.

---

<!-- ============================================================ -->
<!-- EXAMPLES — illustrative (optional; delete for clean slate)    -->
<!-- ============================================================ -->

## Context (examples)

### 2026-01-18-large-config-file-hid-production-defaults

- **status**: active
- **tags**: config, architecture
- **context_read**: src/config/index.ts, docs/deploy.md
- **derived_from**: --

Runtime and deployment settings in one large config file → easy to miss production-only defaults during review. Splitting into smaller domain files made environment-specific settings easier to audit; reduced dev-defaults leaking to production.

### 2026-02-05-meta-analysis-effect-sizes-overstated

- **status**: active
- **tags**: research, methodology, literature-review
- **context_read**: papers/smith-2024-backoff-review.pdf, notes/lit-review-index.md
- **derived_from**: --
- **author**: researcher-01
- **artifacts**: doc:./papers/smith-2024-backoff-review.pdf, dataset:./data/extracted-effects.csv

2024 meta-analysis on retry strategies reports effect sizes ~2x larger than underlying studies justify — authors pooled heterogeneous populations (consumer apps + internal batch jobs) without weighting. Flag before citing the headline number downstream.

## Episodes (examples)

### 2026-01-15-fix-payment-timeout

- **outcome**: SUCCESS
- **tags**: api, error-handling, config
- **context_read**: src/payments/client.ts, 2026-01-10-auth-token-expiry-gotcha
- **derived_from**: --

#### What happened

Payment endpoint timing out ~5% of requests at peak. Root cause: upstream 2s SLA but our timeout was 1s (dev default leak). Raised to 3s + retry with exp. backoff (base 500ms, max 8s, ±10% jitter).

#### Takeaways

- Failure rate 5.2% → 0.1%. Exp. backoff + jitter works.
- Dev defaults silently persisting into production is recurring (see 2026-01-10-auth-token-expiry-gotcha).
- Add startup check flagging timeouts under 2s in production.

### 2026-02-11-incident-triage-storm-dns

- **outcome**: PARTIAL
- **tags**: incident, ops, on-call, dns
- **context_read**: runbooks/dns-failover.md, tickets/INC-4821, 2026-01-20-1400-use-queue-for-webhooks
- **derived_from**: --
- **author**: triage-agent, human
- **artifacts**: log:s3://ops-logs/2026-02-11/dns-resolver.log, metric:grafana://dashboards/dns-health

#### What happened

Triage agent paged on-call 02:14 when DNS latency jumped 10x across three regions. Narrowed to a single upstream resolver in ~4min, drafted a failover step, escalated to human per runbook requirement for cross-region shifts. Human executed at 02:33; latency recovered 02:38. Root cause: upstream resolver's cache-poisoning mitigation rollout (confirmed next morning via provider's post-incident report).

#### Takeaways

- Scope narrowing (3 regions → 1 resolver in 4min) = highest-value contribution. Human decision time dominated MTTR.
- Runbook's "human approval for cross-region shifts" held correctly. Do not weaken.
- `triage-agent, human` author chain = provenance pattern to enforce in multi-agent mode.

## Decisions (examples)

### 2026-01-20-1400-use-queue-for-webhooks

- **status**: accepted
- **tags**: architecture, error-handling
- **context_read**: 2026-01-15-fix-payment-timeout, src/webhooks/handler.ts
- **supersedes**: --
- **superseded_by**: --

#### Context

Sync webhook handler backed up under load from slow downstream services → 500s → provider retries → cascade.

#### Decision

Async: handler writes to SQS; separate worker consumes. Handler always returns 200 immediately.

#### Alternatives considered

- **Keep sync, add retries**: doesn't fix the cascade — retries add more load during failure.
- **In-memory buffer**: faster but loses events on crash. Unacceptable for payment webhooks.

#### Consequences

- Positive: handler never backs up; events survive crashes; workers scale independently.
- Negative: SQS dependency; eventual consistency (seconds, not instant); DLQ monitoring needed.
- Risks: SQS message loss (mitigated by DLQ); delayed processing during spikes.

### 2026-02-12-0900-auto-failover-requires-two-signals

- **status**: accepted
- **tags**: incident, ops, on-call, dns
- **context_read**: 2026-02-11-incident-triage-storm-dns, runbooks/dns-failover.md
- **supersedes**: --
- **superseded_by**: --
- **author**: human

#### Context

Reviewed whether triage agent should execute cross-region failover autonomously. Human decision time was ~19min of a 24min outage.

#### Decision

Triage agent may execute cross-region failover autonomously, but only when two independent signals agree (e.g., synthetic probe failure AND upstream status page red). Single-signal still requires human approval.

#### Alternatives considered

- **Full autonomy**: cuts MTTR further but risks flapping on noisy single signals — rejected.
- **Keep human-only**: safest but ~19min gap persists on repeat incidents — rejected.

#### Consequences

- Positive: MTTR drops sharply on clear-signal incidents.
- Negative: must maintain two-signal correlation logic + its alerting.
- Risks: correlated signal sources (same provider) could fail together and mask failure.

## Insights (examples)

### 2026-01-15-exponential-backoff-with-jitter

- **type**: howto
- **confidence**: medium
- **evidence_count**: 2
- **tags**: api, error-handling, performance
- **derived_from**: 2026-01-15-fix-payment-timeout
- **evidence**: 2026-01-15-fix-payment-timeout, 2026-01-10-auth-token-expiry-gotcha
- **updated**: 2026-01-20

#### Summary

External APIs with intermittent timeouts → exponential backoff (base 500ms, max 8s) with ±10% jitter. Fixed-interval retries cause thundering herd on recovery. ~70% failure rate reduction across 2 episodes.

#### When to apply

Outbound HTTP calls showing timeout or rate-limit errors, especially at peak. **Not** for permanent failures (4xx auth, malformed requests) — those should fail fast.

### 2026-01-20-dev-defaults-leak-to-production

- **type**: concept
- **confidence**: medium
- **evidence_count**: 2
- **tags**: config, monitoring
- **derived_from**: 2026-01-10-auth-token-expiry-gotcha
- **evidence**: 2026-01-10-auth-token-expiry-gotcha, 2026-01-15-fix-payment-timeout
- **updated**: 2026-01-20

#### Summary

Dev defaults (short timeouts, relaxed validation, stub endpoints) silently persist into production more often than expected. Auth-token issue and payment timeout both traced to config values nobody changed after setup.

#### When to apply

Debugging production issues that "should work" → check whether any config value is still at its dev default. Add startup validator flagging known dev-only values under `NODE_ENV=production`.

## Changelog (examples)

- 2026-01-15: fixed payment timeout, created retry-backoff insight
- 2026-01-18: captured config-file split after production-defaults review issue
- 2026-01-20: decided on async queue for webhooks, created dev-defaults-leak insight
- 2026-02-05: flagged meta-analysis pooling issue
- 2026-02-11: triage-agent + human resolved DNS resolver incident (partial autonomy)
- 2026-02-12: decided auto-failover requires two independent signals

---

<!-- ============================================================ -->
<!-- HISTORY — append-only project memory lives below              -->
<!-- ============================================================ -->

> HISTORY SECTION — Append new project history below this marker only. Do not modify instructions/reference above.

## Memory Index

Auto-refreshed snapshot. Do not edit manually — `/syntrace` regenerates this.

**Active decisions**: 
**High-confidence insights**: 
**Open questions**: 
**Last updated**: 

## Context

## Episodes

## Decisions

## Insights

## Changelog

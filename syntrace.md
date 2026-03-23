# Syntrace

> Paste this file into any LLM. Work. Say `/syntrace` when done. The LLM outputs the updated file with your session appended. Save it. Paste it next time. Your memory grows.

---

<!-- ============================================================ -->
<!-- SPEC — replication instructions (do not modify)               -->
<!-- ============================================================ -->

## How this file works

This is a self-contained memory system. Two halves, like a DNA strand:

1. **Spec** (above the MEMORY marker) — the replication instructions. Constant. Tells you what entries look like, when to create them, and how to write them well. Never modify the spec during normal use.
2. **Memory** (below the MEMORY marker) — the accumulated data. Grows every session. Five sections: Context, Episodes, Decisions, Insights, Changelog.

**Output rule**: when triggered, output the **COMPLETE file** as a single markdown code block with the new entry appended to the correct section. The user saves it, replacing the old version. Never output just the new entry — always the full file, so nothing is lost.

**Context rule**: any other files pasted alongside this one, or present in the same workspace, are additional context. Read them before writing entries. Reference what you consulted in `context_read`. This means the file works in two modes:
- **Paste mode** (plain LLM chat): user pastes this file + any relevant project files. You read everything, work, append entries.
- **Workspace mode** (IDE agent like Cursor, Claude Code): you can read neighboring files directly. Scan them before saving.

**Read before you write**: before creating any entry, scan the existing Memory sections. Check if an insight already covers this topic (update it instead of duplicating). Check if a prior decision is being superseded (add `replaces`). The value of this system comes from connections between entries, not isolated notes.

## Save protocol

Three tiers. Use the lightest one that fits the session.

| Trigger | What it creates | When to use |
|---------|----------------|-------------|
| `/syntrace` | Context entry (+ Insight if a pattern emerged) | Most sessions. Quick bugfix, research, routine work. Default choice. |
| `/syntrace full` | Episode + Decision (if a design choice was made) + Changelog line | Significant work: shipped a feature, hit a hard bug, made an architecture call. |
| `/distill` | Insights from Context + Episodes. Updates existing insights. | Periodic cleanup. Run weekly or when Context has 5+ unprocessed entries. |

**How `/syntrace` works step by step**:
1. Review what happened this session
2. Append a `###` entry to the Context section — a few sentences, not a transcript
3. Reflect: did a reusable pattern, surprising finding, or recurring theme emerge?
4. If yes, also append an Insight entry (or update an existing one by incrementing `episode_count`)
5. Scan the reflection checklist

**How `/syntrace full` works step by step**:
1. Review what happened this session
2. Append a `###` entry to the Episodes section with outcome, takeaways, and concrete details
3. If a design or architecture choice was made, also append to Decisions with rationale and alternatives
4. Add a one-liner to Changelog
5. Reflect: check existing Insights — do any need confidence or episode_count updated? Should a new one be created?
6. Scan the reflection checklist

**How `/distill` works step by step**:
1. Read all Context entries not marked `[distilled]`
2. Read recent Episodes (last 5-10)
3. For each reusable pattern found: create a new Insight or update an existing one (increment `episode_count`, adjust `confidence` if warranted)
4. Flag any Insight with `episode_count >= 3` — note it as high-confidence, stable knowledge
5. Mark processed Context entries with `[distilled]` (don't delete them — they're still useful for tracing lineage)

When done for the session: **commit code**, then **save memory**.

## Writing quality

The goal is entries your future self (or a future agent) can act on without re-reading the original conversation. Apply these rules:

**What to capture**:
- The *why*, not just the *what*. "Changed timeout to 3s" is useless. "Changed timeout to 3s because upstream SLA is 2s and we need headroom for retries" is actionable.
- Surprises and failures — not just successes. The unexpected carries the most signal.
- Connections to prior entries. If this session reinforces or contradicts an existing insight, say so explicitly.
- Concrete numbers, thresholds, and examples. "Performance improved" means nothing. "p95 latency dropped from 800ms to 120ms after adding the index" means everything.

**What to skip**:
- Play-by-play narration of routine steps. Nobody needs to re-read "then I ran npm install."
- Obvious observations that any competent person would already know.
- Hedging and filler. Be direct.

**How to write insights**:
- An insight must be **retrievable** — someone searching for a keyword should find it via tags or title.
- An insight must be **actionable** — the "When to apply" section should describe a concrete trigger, not "when it seems relevant."
- An insight must be **falsifiable** — state it precisely enough that future evidence could upgrade or kill it. Update confidence accordingly.
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

Each entry is a `###` heading under its section. Use bullet-point metadata (not YAML fences — they break when there are many entries in one file). The slug in the heading should be descriptive enough to identify the entry without reading it.

### Context entry format

The lightest entry type. An inbox item. The bar is: "would I want to find this in 30 days?"

```
### YYYY-MM-DD-slug
- **tags**: tag1, tag2
- **context_read**: files consulted

Body: a few sentences or bullets. Focus on what surprised you or what
you'd want to remember in 30 days. Skip anything obvious.
```

**Good slug**: `2026-03-23-redis-eviction-policy-mismatch`
**Bad slug**: `2026-03-23-bug` or `2026-03-23-notes`

Tips:
- If you're unsure whether to capture something, capture it. Context is cheap. `/distill` will sort it out later.
- If the capture is longer than a paragraph, it's probably an Episode. Promote it.
- Cross-reference other entries when relevant: "see also: insights/exponential-backoff-with-jitter."

### Episode entry format

A structured work log. Write one when the session had a clear outcome — something was built, fixed, broken, or discovered. Not for routine work.

```
### YYYY-MM-DD-slug
- **outcome**: SUCCESS | FAIL | SURPRISE | PARTIAL
- **tags**: tag1, tag2
- **context_read**: files consulted

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
- **SURPRISE**: the outcome was unexpected (positive or negative). Something was learned that changes a prior assumption
- **PARTIAL**: the goal was partially met, or met with caveats

Tips:
- The "What happened" section should pass the "dropped into this project cold" test: could someone unfamiliar with the codebase understand what was done and why?
- The "Takeaways" section is the most important part. Be specific: "retry logic should use jitter" is better than "error handling could be improved."
- Always check: does this episode reinforce or contradict an existing Insight? If yes, say so and update the Insight's `episode_count`.

### Decision entry format

An architecture decision record (ADR). Write one when you chose X over Y and the reasoning matters. The test: would your future self (or a new teammate) ask "why did we do it this way?"

```
### YYYY-MM-DD-HHMM-slug
- **status**: accepted
- **tags**: tag1, tag2
- **context_read**: files consulted
- **replaces**: (prior decision slug, if any)

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
- **superseded**: replaced by another decision (set `replaces` on the new one)

Tips:
- Always list at least two alternatives — if there was only one option, it wasn't really a decision.
- Be honest about negatives and risks. Decisions without downsides weren't analyzed deeply enough.
- When a decision is later reversed, don't delete the old entry. Add a new decision with `replaces` pointing to it. The trail matters.

### Insight entry format

Distilled, reusable knowledge. The highest-value entry type. Each insight should be **findable** (good tags + clear title), **actionable** (concrete trigger in "When to apply"), and **falsifiable** (precise enough that evidence could upgrade or kill it).

```
### YYYY-MM-DD-slug
- **type**: concept | howto
- **confidence**: low | medium | high
- **episode_count**: 1
- **tags**: tag1, tag2
- **source**: slug of the episode or context entry this came from

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
- **low**: observed once. Plausible but unvalidated. Treat as a hypothesis.
- **medium**: observed 2-3 times or validated in one real scenario. Reliable enough to act on with caution.
- **high**: observed 3+ times across different contexts, or validated by benchmarking/formal testing. Default to this approach.

Tips:
- `episode_count` tracks how many episodes support this insight. Increment it every time a new episode reinforces the pattern. This is how insights mature: low confidence + 1 episode → medium confidence + 3 episodes → high confidence.
- The `source` field creates a lineage trail. Always fill it — even if the insight came from a conversation, cite "conversation" or the context entry slug.
- When to apply should include **counter-examples**: "Use X when you see A. Do NOT use X when you see B." This prevents overgeneralization.
- Review existing insights during every `/syntrace full` — an insight that hasn't been updated in months may be stale or wrong.

## Auto-fill rules

Fill these automatically — never ask the user for them:

| Field | Value | Example |
|-------|-------|---------|
| date in heading | Today's date | `### 2026-03-23-fix-auth-flow` |
| **context_read** | Files, sections, or entries you read before writing | `src/auth.ts, insights/dev-defaults-leak` |
| **tags** | 2-5 lowercase keywords relevant to retrieval | `api, retry, reliability` |
| **outcome** | Best match from SUCCESS / FAIL / SURPRISE / PARTIAL | `SURPRISE` |
| **slug** | Descriptive, lowercase, hyphenated, no filler words | `fix-payment-timeout` not `todays-work` |

**Tagging strategy**: tags exist for retrieval. Ask yourself: "what would someone search for to find this entry?" Use domain terms (`auth`, `payments`, `caching`), not generic ones (`important`, `misc`, `todo`).

## Architecture

This section applies when using Syntrace with multi-agent workflows or IDE agents. If you're pasting into a plain LLM chat, the save protocol and entry formats above are all you need — skip to Memory.

### Agent roles

Four roles, two concerns. Most setups only need the first three. The Librarian handles `/distill`.

| Role | What it does | Invariants (never violate) |
|------|-------------|---------------------------|
| **Planner** | Decomposes goals into subtasks, picks which agent handles each, synthesizes final output | No irreversible actions without human OK. Log all decisions with rationale. Always check existing Insights before planning. |
| **Worker** | Executes one well-defined subtask using tools. Narrow focus. | Never exceed assigned scope. On failure: return error + context, never silently retry. Always return output in the expected format. |
| **Critic** | Reviews Worker output against quality checks. Returns PASS, REVISE, or REJECT with specific feedback. | Never approve output that violates invariants. Critique must be specific and actionable — never "looks wrong." Never escalate to human for routine issues. |
| **Librarian** | Runs `/distill`. Scans Context + Episodes, creates/updates Insights, flags mature patterns. | Never modify the Spec section. Always tag insights with date, source, and confidence. Increment `episode_count` on existing insights rather than creating duplicates. |

New roles are added as specialized Workers (e.g., Researcher, Tester), not new top-level roles.

### Quality checks

The Critic applies these on every review. In single-agent mode, self-apply before saving:

- [ ] Output matches expected format (correct entry type, all required fields present)
- [ ] No invariants from agent roles are violated
- [ ] No hallucinated tool outputs (if a tool was supposedly called, verify it actually was)
- [ ] Rationale is present for non-obvious decisions — not just "what" but "why"
- [ ] Connections to existing entries are noted (reinforces, contradicts, or supersedes)

**Verdicts**:
- **PASS**: all checks pass, output is complete and coherent
- **REVISE**: minor issues, specific actionable feedback provided (max 2 revision rounds)
- **REJECT**: critical failure — invariant breach, missing rationale, wrong entry type

### Planner-Worker-Critic cycle

```
Goal → Planner → subtask → Worker → result → Critic
         ↑                                      |
         +——— REVISE (max 2 rounds) ————————————+
                                      |
                                    PASS → Output
```

**When to use**: any task requiring quality assurance, when output errors are costly, when multiple subtasks produce results to be ranked or merged.

**When to skip**: simple single-step tasks, real-time interactive loops where the critique cycle is too slow.

**Failure modes to watch for**:
- Critic too strict → infinite revision loops (the max 2 rounds cap prevents this)
- Critic too lenient → garbage passes (calibrate with the quality checks above)
- Planner over-decomposes → too many subtasks → coordination overhead exceeds the work itself

### Scaling memory

As the Memory section grows, reading everything before acting becomes impractical. Use these strategies:

| Strategy | When to use | How |
|----------|------------|-----|
| **Tag scan** | 30-100 entries | Search for tags matching your current task's keywords. Read only matching entries. |
| **Recency + confidence** | 100+ entries | Focus on the 15-20 most recent entries plus any Insight with `confidence: high`. |
| **Source walk** | Tracing a specific topic | Start from one entry, follow its `source` and cross-references 1-2 hops. |
| **Full scan** | `/distill` only | Read everything. Never do this as a prerequisite to routine work. |

When the file exceeds ~500 entries, consider splitting into multiple Syntrace files by domain (e.g., `syntrace-frontend.md`, `syntrace-infra.md`). Each file is self-contained — copy the Spec section into each one.

---

<!-- ============================================================ -->
<!-- MEMORY — entries below grow over time                         -->
<!-- ============================================================ -->

## Context

Low-friction captures. The inbox. Write here when something is worth remembering but doesn't need structure yet. During `/distill`, promote the good ones to Insights and mark the rest `[distilled]`.

### 2026-01-10-auth-token-expiry-gotcha

- **tags**: auth, tokens, debugging
- **context_read**: src/auth/middleware.ts

Spent 40 minutes debugging 401s before realizing refresh tokens expire after 7 days of inactivity, not 7 days from issue. The docs say "7-day expiry" without clarifying. Need to add a buffer that refreshes proactively at day 5.

### 2026-01-18-cursor-loses-context-on-large-files

- **tags**: tooling, cursor, context-window
- **context_read**: (conversation history)

When a file exceeds ~800 lines, Cursor agents start ignoring instructions from the top of the file. Splitting the config into 3 smaller files fixed it immediately. Rule of thumb: keep any file an agent reads under 500 lines.

## Episodes

Structured work logs. Write here after significant sessions -- not routine ones. Focus on the **why** and the **takeaway**, not a transcript of what you typed.

### 2026-01-15-fix-payment-timeout

- **outcome**: SUCCESS
- **tags**: api, retry, payments
- **context_read**: src/payments/client.ts, memory context/auth-token-expiry-gotcha

#### What happened

Payment endpoint timing out ~5% of requests during peak hours. Root cause: upstream provider has a 2s SLA but our timeout was set to 1s (leftover from dev defaults). Increased to 3s and added retry with exponential backoff (base 500ms, max 8s, ±10% jitter).

#### Takeaways

- Failure rate dropped from 5.2% to 0.1% — exponential backoff with jitter works
- Dev-environment defaults silently persisting into production is a recurring theme (see also: context/auth-token-expiry-gotcha)
- Would add a startup check that flags any timeout config under 2s in production

## Decisions

Architecture and design choices with rationale. Write here when you chose X over Y and it matters enough that your future self would ask "why did we do it this way?"

### 2026-01-20-1400-use-queue-for-webhooks

- **status**: accepted
- **tags**: architecture, webhooks, reliability
- **context_read**: episodes/fix-payment-timeout, src/webhooks/handler.ts
- **replaces**: (none)

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

## Insights

Distilled patterns — reusable knowledge extracted from episodes and context. Each insight should be **findable** by tags, **actionable** with a concrete trigger, and **precise** enough to be proven wrong.

### 2026-01-15-exponential-backoff-with-jitter

- **type**: howto
- **confidence**: medium
- **episode_count**: 2
- **tags**: api, retry, reliability, error-handling
- **source**: episodes/fix-payment-timeout

#### Summary

When calling external APIs that intermittently timeout, use exponential backoff (base 500ms, max 8s) with ±10% jitter. Fixed-interval retries cause thundering herd on recovery. Observed ~70% failure rate reduction across 2 episodes.

#### When to apply

When you see timeout or rate-limit errors on outbound HTTP calls, especially during peak traffic. **Not** for errors that indicate permanent failure (4xx auth errors, malformed requests) — those should fail fast.

### 2026-01-20-dev-defaults-leak-to-production

- **type**: concept
- **confidence**: low
- **episode_count**: 2
- **tags**: config, debugging, production
- **source**: context/auth-token-expiry-gotcha, episodes/fix-payment-timeout

#### Summary

Development-environment defaults (short timeouts, relaxed validation, stub endpoints) silently persist into production more often than expected. Both the auth token issue and the payment timeout traced back to a config value nobody changed after initial setup.

#### When to apply

When debugging production issues that "should work," check whether any config value is still at its development default. Add a startup validator that flags known dev-only values when `NODE_ENV=production`.

## Changelog

- 2026-01-10: captured auth token expiry gotcha
- 2026-01-15: fixed payment timeout, created retry-backoff insight
- 2026-01-18: noted Cursor context-window limit on large files
- 2026-01-20: decided on async queue for webhooks, created dev-defaults-leak insight

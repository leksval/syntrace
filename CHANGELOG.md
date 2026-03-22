# Changelog

All notable changes to this project are documented here.
Format: `[YYYY-MM-DD] <type>: <short description>`

Types: `init`, `agent`, `pattern`, `tool`, `decision`, `experiment`, `milestone`, `fix`

---

## [2026-03-22] fix: improve tracking and learning templates

- Added base episode template (`culture/episodes/_template.md`) with `duration` and `Insights produced` fields
- Added `outcome` and `duration` fields to experiment and retrospective templates for schema consistency
- Added `episode_count` field to insight template for machine-checkable promotion thresholds
- Added retrieval guidance section to `culture/insights/README.md`

## [2026-03-22] init: simplify template structure

- Merged `memory/` layer into `genome/policies/` (procedural) and `culture/insights/` (semantic)
- Merged `learning/` layer into `culture/` (notes → insights, experiments → episodes, inbox → inbox)
- Merged `culture/playbooks/` into `genome/patterns/`
- Merged `culture/retrospectives/` into `culture/episodes/` (use `type:` frontmatter tag)
- Flattened `genome/schemas/` into `_template.md` files in each target folder
- Flattened `genome/tools/` to single `genome/tools.md` file
- Unwrapped `programming/` to project root (`src/`, `tests/`, `docs/`)
- Removed `archive/` — use git tags for milestones instead
- Removed shell scripts — use `_template.md` files in each folder instead
- Updated all cross-references

## [YYYY-MM-DD] init: project scaffold from agent template

- Created genome/, culture/ folders
- Defined initial agent roles (see genome/agents/)
- Established architectural pattern (see genome/patterns/)

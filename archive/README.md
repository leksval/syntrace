# Archive

Frozen milestone snapshots. Never edit content here; only add new snapshots.

## How to create a snapshot
```bash
# At a project milestone or before a major refactor:
MILESTONE="v1.0.0"  # or date like 2026-03-22
mkdir archive/$MILESTONE
cp -r genome/ archive/$MILESTONE/genome/
cp -r memory/ archive/$MILESTONE/memory/
cp CHANGELOG.md archive/$MILESTONE/
echo "Snapshot saved: archive/$MILESTONE"
```

## What to snapshot
- `genome/` — the "genome" at that point in time
- `memory/` — the distilled knowledge state
- `CHANGELOG.md` — project history up to this point

## What NOT to snapshot
- Raw episodes (too large, stored in git history)
- `programming/` (covered by git tags)

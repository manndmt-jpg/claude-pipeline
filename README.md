# claude-pipeline

Structured pre-implementation workflow for Claude Code. Separates planning from execution with quality gates.

## Pipeline Flow

```
/plan  →  approve  →  /implement  →  /pre-pr  ──→  PR
 │                       │              │       ↑
 ├─ interview            │              │       │
 ├─ explore codebase     │              ├─ type-check
 ├─ write PLAN.md        │              ├─ lint
 ├─ self-validate        │              ├─ tests
 └─ wait for approval    │              ├─ diff review
                         │              ├─ scan
                         │              └─ suggests /code-review
                         │                  if diff is large
                         ├─ step-by-step execution
                         ├─ verification per step
                         └─ progress in SCRATCHPAD.md

/code-review ← standalone, use anytime
```

## Installation

```bash
git clone https://github.com/manndmt-jpg/claude-pipeline.git ~/Projects/claude-pipeline
cd ~/Projects/claude-pipeline
bash install.sh
```

The installer:
- Creates symlinks in `~/.claude/commands/` for each command
- Backs up any existing files (e.g., `plan.md` → `plan.md.backup`)
- Is idempotent — safe to re-run

## Pipeline Commands

### `/plan` — Create an implementation plan

Replaces the default planning workflow with a rigorous process:

1. Asks what you want to build
2. Explores the codebase (reads files, checks patterns)
3. Writes `PLAN.md` with structured steps, verification criteria, and acceptance criteria
4. Self-validates (referenced files exist, types are real, no conflicts)
5. Updates SCRATCHPAD.md and HANDOFF.md with plan status
6. Presents plan and waits for approval — does NOT auto-execute

### `/implement` — Execute an approved plan

Reads PLAN.md and works through it step by step:

1. Finds the next unchecked step
2. Executes it and runs verification
3. Checks it off in PLAN.md
4. Updates SCRATCHPAD.md with progress (e.g., "3/7 steps done")
5. Stops on failure — never silently works around blockers

### `/pre-pr` — Quality gate before PR creation

Runs checks before you create a pull request:

1. Type-check (auto-detects: tsc, pyright, cargo check, etc.)
2. Lint (auto-detects: eslint, ruff, etc.)
3. Tests (runs existing tests if found, flags changed files without test coverage)
4. Git diff summary with file grouping
5. Quick code review of the diff
6. Scans for secrets, console.log, TODO/FIXME, merge conflict markers
7. Verdict: READY or BLOCKED with specific issues
8. If ready, offers to draft PR title and description

## Standalone Commands

### `/code-review` — Multi-lens code review

Deep code review with selectable perspective:

1. **Standard** — bugs, types, error handling, async issues (default)
2. **Security** — injection, auth, path traversal, resource exhaustion
3. **Architecture** — coupling, abstraction, patterns, testability
4. **Performance** — memory, N+1 queries, caching, payload size
5. **Full** — all of the above

Findings are prioritized P1 (blocks deploy) → P2 (fix soon) → P3 (nice to have) with file:line references.

Can be used anytime on any diff — independent of the pipeline. Also suggested by `/pre-pr` when the diff is large or has concerns.

## What about existing commands?

The installer backs up any existing files it replaces (e.g., `plan.md` → `plan.md.backup`, `code-review.md` → `code-review.md.backup`). Other commands in `~/.claude/commands/` are left untouched.

## Template

A standalone copy of the plan template is at `templates/plan-template.md` for manual reference.

## Roadmap

- **Phase 1** (current): `/plan`, `/implement`, `/pre-pr`
- **Phase 2**: `/review-plan` (structured plan critique), `/test-plan` (generate test cases from plan)
- **Phase 3**: Cross-project memory, plan diffing, metrics

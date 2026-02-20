# claude-pipeline

Structured pre-implementation workflow for Claude Code. Separates planning from execution with quality gates.

## Pipeline Flow

```
/plan  →  review  →  /implement  →  /pre-pr  →  PR
 │          │           │              │
 │          │           │              ├─ type-check
 │          │           │              ├─ lint
 │          │           │              ├─ diff review
 │          │           │              └─ scan for mistakes
 │          │           │
 │          │           ├─ step-by-step execution
 │          │           ├─ verification per step
 │          │           └─ progress tracking in SCRATCHPAD.md
 │          │
 │          └─ human approval gate
 │
 ├─ codebase exploration
 ├─ PLAN.md with steps, verification, acceptance criteria
 ├─ self-validation (files exist, types real, no conflicts)
 └─ cross-reference SCRATCHPAD.md + HANDOFF.md
```

## Installation

```bash
git clone https://github.com/your-user/claude-pipeline.git ~/Projects/claude-pipeline
cd ~/Projects/claude-pipeline
bash install.sh
```

The installer:
- Creates symlinks in `~/.claude/commands/` for each command
- Backs up any existing files (e.g., `plan.md` → `plan.md.backup`)
- Is idempotent — safe to re-run

## Commands

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
3. Git diff summary with file grouping
4. Quick code review of the diff
5. Scans for secrets, console.log, TODO/FIXME, merge conflict markers
6. Verdict: READY or BLOCKED with specific issues
7. If ready, offers to draft PR title and description

## Existing Commands (untouched)

These commands in `~/.claude/commands/` are not affected by installation:

| Command | Description |
|---------|-------------|
| `/start` | Start a new working session |
| `/scope` | Context check |
| `/build` | Build with review pipeline |
| `/sync` | Update project docs before wrapping up |
| `/code-review` | Full code review with multiple lenses |
| `/debug` | Debug assistance |
| `/refactor` | Code refactoring |

## Template

A standalone copy of the plan template is at `templates/plan-template.md` for manual reference.

## Roadmap

- **Phase 1** (current): `/plan`, `/implement`, `/pre-pr`
- **Phase 2**: `/review-plan` (structured plan critique), `/test-plan` (generate test cases from plan)
- **Phase 3**: Cross-project memory, plan diffing, metrics

# Claude Pipeline — Development Plan

## Goal

A portable, version-controlled collection of Claude Code commands and skills that enforce a structured development workflow: plan → validate → implement → review → ship. Designed for solo developers who want consistency without heavyweight process.

## What exists today (in ~/.claude/commands/)

| Command | What it does | Gap |
|---|---|---|
| `/start` | Reads CLAUDE.md, HANDOFF.md, SCRATCHPAD.md, git status | Good as-is |
| `/plan` | Writes minimal plan to SCRATCHPAD.md, then executes | Too basic — no validation, no acceptance criteria, mixes planning with execution |
| `/scope` | Reads project files, summarizes context | Good as-is |
| `/build` | Implement → Gemini review → fix → summarize | Good but skips pre-implementation validation |
| `/code-review` | Multi-lens review (standard/security/arch/perf) | Good as-is |
| `/gemini-review` | External Gemini review via OpenRouter | Good as-is |
| `/gpt-review` | External GPT review | Good as-is |
| `/debug` | Hypothesis-driven debugging | Good as-is |
| `/refactor` | Incremental refactoring with approval gates | Good as-is |
| `/sync` | Updates SCRATCHPAD.md, HANDOFF.md, CLAUDE.md | Good as-is |
| `/spec` | Ticket & spec management (Linear/Notion) | Good as-is |

## What's missing

1. **Plan quality** — `/plan` produces a minimal checklist. No acceptance criteria, no verification steps, no interface checks. The detailed plans we've been writing manually (like `apps/web-v2/PLAN.md`) are much richer but ad-hoc.

2. **Plan validation** — Nothing checks if the plan references real files, real types, or conflicts with existing code. We catch these issues during implementation instead of before.

3. **Test strategy** — No structured thinking about "how do we know this works?" before coding starts. Verification is an afterthought.

4. **Pre-PR checklist** — `/build` runs Gemini review, but there's no consolidated gate that runs type-check + lint + review + diff summary before creating a PR.

5. **Mechanical task automation** — No way to say "fix all lint errors, loop until clean" without babysitting.

## Proposed pipeline

```
/start → /plan → (approve) → implement → /pre-pr → /sync
                                ↑
                          /ralph-loop (for mechanical subtasks)
```

### Phase 1: Core commands (v0.1)

#### 1. `/plan` (rewrite)

**Purpose:** Create a validated implementation plan.

**Flow:**
1. Ask "What do you want to build/change?"
2. Explore codebase — read relevant files, identify affected interfaces
3. Write plan with rich template (see below) to `PLAN.md`
4. **Self-validate** — check that referenced files exist, types are real, no obvious conflicts
5. **Cross-reference sync** — update SCRATCHPAD.md with plan link and status:
   ```markdown
   ## Current Task
   [feature name]

   ## Active Plan
   → See [PLAN.md](./PLAN.md) (or apps/web-v2/PLAN.md)
   Status: PENDING APPROVAL

   ## Plan Summary
   - [1-2 sentence goal from the plan]
   - Steps: N total
   - Key files: [list]
   ```
   Also update HANDOFF.md if it exists:
   ```markdown
   ### Active Plan
   - Plan: [path/to/PLAN.md]
   - Status: Awaiting approval
   - Next: approve plan, then /implement
   ```
6. Present plan with validation results
7. Wait for approval — do NOT execute

**Plan template:**
```markdown
## Plan: [feature name]

### References
- Ticket: [Linear/GitHub issue link if applicable]
- Spec: [path to spec or Notion page if applicable]
- Related: [CLAUDE.md section, previous HANDOFF.md, etc.]

### Goal
[One sentence]

### Context
[What exists today, why this change is needed]

### Approach
[High-level strategy, key decisions]

### Steps
1. [ ] Step one
   - Files: `path/to/file.ts`
   - Changes: [specific description]
   - Verify: [how to confirm this step worked]
2. [ ] Step two
   ...

### Acceptance criteria
- [ ] [Specific, testable condition]
- [ ] [Another condition]
- [ ] Type-check passes
- [ ] No lint errors introduced

### Risks
- [Edge cases, breaking changes, dependencies]

### Validation report
- [x] All referenced files exist
- [x] Interfaces/types verified
- [ ] Potential conflict: [description]
```

**Key change from current:** Plan lives in `PLAN.md` (app directory or project root), not SCRATCHPAD.md. Planning and execution are separate commands.

#### 2. `/pre-pr`

**Purpose:** Quality gate before creating a PR.

**Flow:**
1. Run type-check (`tsc --noEmit`)
2. Run lint (`pnpm lint` or project equivalent)
3. Run git diff summary — files changed, lines added/removed
4. Quick code review of the diff (standard lens)
5. Check for common mistakes:
   - `.env` or secrets in the diff
   - `console.log` left in
   - TODO/FIXME/HACK comments added
   - Large files (>500 lines changed)
6. Present verdict: READY / BLOCKED with specific issues
7. If ready, ask "Create PR?" and draft title + body from the diff

#### 3. `/implement`

**Purpose:** Execute an approved plan step-by-step with progress tracking.

**Flow:**
1. Read the current PLAN.md
2. Find the next unchecked step
3. Execute it, check it off in PLAN.md
4. After each step, verify using the step's "Verify" criteria
5. If verification fails, stop and discuss
6. **Update SCRATCHPAD.md** with progress after each completed step:
   ```
   ## Active Plan
   → [PLAN.md](./PLAN.md)
   Status: IN PROGRESS (3/7 steps done)
   Last completed: Step 3 — Added i18n messages
   Next: Step 4 — Wire form overlay
   ```
7. Continue until all steps done or blocked
8. When all steps complete, update SCRATCHPAD.md status to COMPLETE and note acceptance criteria results

**This replaces step 5 of the old `/plan`.** Separating plan from execution means you can plan in one session and implement in another. The cross-references in SCRATCHPAD.md mean any session can pick up where the last one left off.

### Phase 2: Enhancements (v0.2)

#### 4. `/test-strategy`

**Purpose:** Add verification criteria to an existing plan.

**Flow:**
1. Read PLAN.md
2. For each step, suggest: what to test, how to verify, what could go wrong
3. Add acceptance criteria if missing
4. Suggest manual test scenarios for UI work
5. Update PLAN.md in-place

#### 5. Ralph-wiggum integration

Install the existing plugin for mechanical loop tasks:
```bash
claude install-plugin github:anthropics/claude-code/plugins/ralph-wiggum
```

Use for: "fix all TS errors", "add types to all files in dir", "run tests until green"

### Phase 3: Nice-to-have (v0.3)

#### 6. `/review-plan`

**Purpose:** Dedicated plan review — like `/code-review` but for plans.

**Flow:**
1. Read PLAN.md
2. Check against codebase: are the assumptions correct?
3. Check for missing steps, wrong file paths, outdated types
4. Check scope — is the plan trying to do too much?
5. Output: issues found, suggestions, confidence level

#### 7. `/standup`

**Purpose:** Quick status check combining `/start` intelligence with progress tracking.

**Flow:**
1. Read PLAN.md — what's checked off, what's next
2. Read SCRATCHPAD.md — any blockers noted
3. Read git log since last session
4. Present: "Here's where we are, here's what's next"

## Project structure

```
claude-pipeline/
├── commands/
│   ├── plan.md            # Rewritten /plan
│   ├── implement.md       # New /implement
│   ├── pre-pr.md          # New /pre-pr
│   ├── test-strategy.md   # New /test-strategy (Phase 2)
│   ├── review-plan.md     # New /review-plan (Phase 3)
│   └── standup.md         # New /standup (Phase 3)
├── templates/
│   └── plan-template.md   # Plan template for reference
├── README.md              # How to install and use
├── CHANGELOG.md           # Version history
└── install.sh             # Symlink commands into ~/.claude/commands/
```

## Installation approach

Commands are **symlinked** from the project into `~/.claude/commands/`:
```bash
# install.sh
ln -sf ~/Projects/claude-pipeline/commands/plan.md ~/.claude/commands/plan.md
ln -sf ~/Projects/claude-pipeline/commands/implement.md ~/.claude/commands/implement.md
ln -sf ~/Projects/claude-pipeline/commands/pre-pr.md ~/.claude/commands/pre-pr.md
```

This way:
- Git tracks the source of truth in `~/Projects/claude-pipeline/`
- `~/.claude/commands/` always has the latest via symlinks
- Existing commands that aren't part of the pipeline stay untouched
- Can version and rollback via git

## What stays untouched

These existing commands are NOT part of the pipeline and won't be modified:
- `/start`, `/scope`, `/sync` — session lifecycle (already good)
- `/build` — keep as alternative quick path (implement + review in one shot)
- `/code-review`, `/gemini-review`, `/gpt-review` — standalone review tools
- `/debug`, `/refactor` — task-specific tools
- `/spec`, `/meetings`, `/tunnel` — domain-specific

## Rollout

1. **Phase 1 first** — `/plan`, `/pre-pr`, `/implement`. These cover the biggest gaps.
2. **Test on renisa.ai** — use the new pipeline for the next feature (e.g., remaining Phase 7 items from web-v2 PLAN.md).
3. **Iterate** — adjust based on friction. If `/implement` feels too rigid, loosen it. If `/pre-pr` catches real issues, expand it.
4. **Phase 2** when Phase 1 feels stable.

# Pre-PR Check

Run quality gates before creating a pull request.

## Step 1: Detect project type

Look at the project root for indicators:
- `tsconfig.json` → TypeScript (use `npx tsc --noEmit` or check package.json scripts for type-check)
- `pyproject.toml` / `setup.py` → Python (use pyright/mypy if configured)
- `package.json` → Node.js (check for lint/type-check scripts)
- `Cargo.toml` → Rust (use `cargo check`)
- Monorepo indicators: `turbo.json`, `pnpm-workspace.yaml` → use root-level commands

Note: If a dev server is running and the project uses Next.js, do NOT run `build` — use `tsc --noEmit` for type-checking instead.

## Step 2: Type check

Run the appropriate type-check command for the project.

Report:
- **PASS** — no type errors
- **FAIL** — list errors with file:line references

If type check fails, stop here. The user should fix types before continuing.

## Step 3: Lint

Run the appropriate lint command for the project (e.g., `pnpm lint`, `eslint .`, `ruff check`).

Report:
- **PASS** — no lint errors
- **FAIL** — list errors with file:line references

Auto-fixable issues: mention them but don't auto-fix. Ask the user.

## Step 4: Tests

**Detect test infrastructure:**
- Look for test directories (`__tests__/`, `tests/`, `test/`, `spec/`)
- Check package.json for `test` script, or `pytest.ini`, `jest.config.*`, `vitest.config.*`, etc.
- Check if the project has any test files at all (glob for `*.test.*`, `*.spec.*`, `test_*.py`)

**If tests exist:** run them (`pnpm test`, `pytest`, `cargo test`, etc.). Report PASS/FAIL.

**If no test infrastructure exists:** note it and move on — not a blocker.

**Test coverage check** (regardless of whether tests exist):
1. Look at the changed files in the diff
2. Check if any of the changed source files have corresponding test files
3. Report:
   - Files with tests: `src/utils.ts` → `src/utils.test.ts` exists
   - Files without tests: `src/parser.ts` → no test file found

If changed source files have no corresponding tests, flag it as a **notice** (not a blocker):

```
Note: [N] changed files have no test coverage:
- src/parser.ts
- src/handlers/auth.ts
Consider whether these changes need tests before merging.
```

This is informational — the user decides whether to add tests or proceed.

## Step 5: Git diff summary

Run `git diff --stat` and `git diff` to analyze changes.

Report:
- Files changed (count)
- Lines added / removed
- List of changed files grouped by type (source, tests, config, docs)

Flag if the diff is large (>500 lines changed) — suggest splitting into smaller PRs.

## Step 6: Quick code review

Review the diff using the Standard review lens:

- **Bugs** — edge cases, nulls, boundary conditions
- **Error handling** — graceful failures, silent errors
- **Async** — race conditions, unhandled promises
- **Types** — loose types that should be specific
- **Naming** — clear and consistent

Keep it focused. This is a quick sanity check, not a full review.

If you find concerns, or if the diff is large (>300 lines), suggest: "Consider running `/code-review` for a deeper pass before creating the PR."

## Step 7: Scan for common mistakes

Search the diff for:

1. **Secrets/env** — `.env` files, API keys, tokens, passwords in committed code
2. **Debug artifacts** — `console.log`, `debugger`, `print()` statements (ignore if in logging code)
3. **TODO/FIXME/HACK** — leftover markers that should be resolved
4. **Large files** — any single file diff >300 lines (suggest splitting)
5. **Merge conflict markers** — `<<<<<<<`, `=======`, `>>>>>>>`

Report findings with file:line references.

## Step 8: Verdict

Based on Steps 2-7, give a verdict:

### If all checks pass:

```
## Pre-PR Verdict: READY

- Type check: PASS
- Lint: PASS
- Tests: PASS (or N/A if no tests exist)
- Test coverage: [N] changed files have tests, [M] do not
- Diff: [N] files, +[added]/-[removed] lines
- Code review: No issues found
- Scan: Clean

Ready to create PR.
```

Then ask: **"Create PR? I'll draft the title and description."**

If the user says yes:
1. Draft a PR title (short, conventional-commits style)
2. Draft a PR body with: Summary (bullet points), Test plan, link to PLAN.md if it exists
3. Show the draft and ask for approval before creating

### If any check fails:

```
## Pre-PR Verdict: BLOCKED

- Type check: FAIL — [count] errors
- Lint: PASS
- Scan: Found [issues]

Issues to fix before PR:
1. [specific issue with file:line]
2. [specific issue with file:line]
```

Do NOT offer to create a PR when blocked. Fix issues first.

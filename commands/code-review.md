# Code Review

First, ask which review perspective to use:

1. **Standard** - Bugs, types, quality (default for most PRs)
2. **Security** - Adversarial thinking, attack vectors (before production deploy)
3. **Architecture** - Patterns, scalability, maintainability (refactors, new features)
4. **Performance** - Memory, latency, queries (data-heavy or hot path code)
5. **Full** - All of the above (thorough review)

Wait for my answer, then review the current changes (git diff) using that lens.

---

## Standard Review
- **Bugs** - Edge cases, nulls, empty arrays, boundary conditions
- **Error handling** - Do we fail gracefully? Silent failures?
- **Async** - Race conditions, unhandled promises
- **Types** - Any loose types that should be specific?
- **Naming** - Clear and consistent?
- **Tests** - Coverage for new logic?

If this project uses AI/agents:
- Are agent outputs validated before acting on them?
- Prompt injection risks from user inputs?

---

## Security Review
Think like an attacker. For each input:
- **Path traversal** - Can filenames like `../../etc/passwd` escape directories?
- **Injection** - Can user input reach shell commands, SQL, or HTML unsanitized?
- **Input validation** - Are file types, sizes, formats validated?
- **Resource exhaustion** - Can large inputs cause OOM or infinite loops?
- **Auth/Authz** - Are permissions checked? Can users access others' data?
- **Sensitive data** - Are secrets, tokens, or PII logged or exposed?
- **Dependencies** - Any known vulnerable packages?

---

## Architecture Review
Think like a maintainer 6 months from now:
- **Single responsibility** - Does each module do one thing well?
- **Coupling** - Are components too tightly connected?
- **Abstraction** - Right level? Too much? Too little?
- **Extensibility** - How hard to add new features?
- **Patterns** - Consistent with rest of codebase?
- **Tech debt** - Are we adding shortcuts that will hurt later?
- **Testability** - Is this code easy to unit test?

---

## Performance Review
Think about scale and efficiency:
- **Memory** - Large objects held unnecessarily? Streaming possible?
- **N+1 queries** - Database calls in loops?
- **Caching** - Repeated expensive operations that could be cached?
- **Async** - Blocking operations that could be parallel?
- **Timeouts** - Network calls with no timeout configured?
- **Payload size** - Transferring more data than needed?

---

## Output Format

Prioritize findings:
- **P1** - Blocks deploy (security holes, crashes, data loss)
- **P2** - Fix soon (bugs, reliability issues)
- **P3** - Nice to have (style, minor improvements)

Be specific with `file:line` references.

---

## Save findings

After presenting the review, write all findings to `REVIEW.md` in the project root:

```markdown
# Code Review — [date]

> Lens: [Standard/Security/Architecture/Performance/Full]
> Branch: [current branch]
> Diff: [N] files changed

## P1 — Blocks deploy
- [ ] `file.ts:42` — [description]

## P2 — Fix soon
- [ ] `file.ts:87` — [description]

## P3 — Nice to have
- [ ] `file.ts:12` — [description]

## Summary
[1-2 sentences: overall assessment]
```

Each finding is a checkbox so they can be tracked and checked off as fixed.

Then update SCRATCHPAD.md:
```markdown
## Code Review
[N] findings — see REVIEW.md
- P1: [count]
- P2: [count]
- P3: [count]
```

If a REVIEW.md already exists, append the new review as a new section (don't overwrite previous reviews).

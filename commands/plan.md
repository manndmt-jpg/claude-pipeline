# Plan Mode

Create a thorough, validated implementation plan before writing any code.

**Critical: Do NOT execute any implementation steps. Planning only.**

## Step 1: Understand the task

Ask: **"What do you want to build or change?"**

Wait for the response. Do not proceed until you have a clear answer.

If the answer is vague, ask one follow-up to clarify scope. No more than one.

## Step 2: Explore the codebase

Before writing any plan:

1. Read files directly related to the task (imports, types, components, routes)
2. Read files that interface with those (callers, consumers, shared types)
3. Check for existing patterns — how does the codebase handle similar things?
4. Note the tech stack, conventions, and testing approach

Record what you read. You'll reference these in the plan.

## Step 3: Write the plan

Create or overwrite `PLAN.md` in the project root using this structure:

```markdown
# Plan: [Feature Name]

> Status: PENDING APPROVAL
> Created: [today's date]
> Branch: [current branch or suggested branch name]

## References

Files read during exploration:
- `path/to/file.ts` — [why it's relevant]
- `path/to/other.ts` — [why it's relevant]

## Goal

[One sentence: what this achieves when done]

## Context

[Why we're doing this. What problem exists. Link to issue/ticket if applicable.]

## Approach

[High-level strategy. Which pattern are we following? Why this approach over alternatives?]

## Steps

### Step 1: [Title]
- **Files**: `path/to/file.ts`
- **Change**: [what specifically changes]
- **Verify**: [how to confirm this step worked]

### Step 2: [Title]
- **Files**: `path/to/file.ts`
- **Change**: [what specifically changes]
- **Verify**: [how to confirm this step worked]

[...continue for all steps]

## Acceptance Criteria

- [ ] [Criterion 1 — observable, testable outcome]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| [What could go wrong] | [How bad] | [What we do about it] |

## Validation Report

[filled in by Step 4 below]
```

Guidelines for writing steps:
- Each step should be independently verifiable
- List specific files, not "update relevant files"
- Verification should be concrete: "type-check passes", "page renders X", "API returns Y"
- Order steps so each builds on the last (dependencies flow downward)

## Step 4: Self-validate

Before presenting the plan, verify it:

1. **File check** — Do all referenced files in "References" and "Steps" actually exist? Flag any that don't with `[NEW]`.
2. **Type check** — Are referenced types, interfaces, and functions real? Grep for them.
3. **Conflict check** — Read SCRATCHPAD.md and any active PLAN.md. Is there in-progress work that overlaps?
4. **Completeness check** — Does the plan cover the full task? Are there implicit steps not listed?

Write results into the Validation Report section:

```markdown
## Validation Report

- [x] All referenced files exist (or marked [NEW])
- [x] All referenced types/interfaces verified
- [ ] Conflict: SCRATCHPAD.md shows active work on X — discuss before proceeding
- [x] Plan is self-contained
```

## Step 5: Cross-reference

Update the project's working memory:

1. **SCRATCHPAD.md** — Add or update:
   ```markdown
   ## Current Task
   [task name] — see PLAN.md

   ## Status
   PENDING APPROVAL — plan written, awaiting review
   ```

2. **HANDOFF.md** (if it exists) — Add a line under active work:
   ```markdown
   - **[task name]**: Plan at PLAN.md — PENDING APPROVAL
   ```

## Step 6: Present

Show the user:
1. The full plan (or a summary if it's very long, with "see PLAN.md for details")
2. The validation report results
3. Any flags or concerns

Then ask: **"Approve this plan, or want to adjust?"**

## Step 7: Stop

Do NOT start implementing. Wait for explicit approval.

If the user says "go" / "approved" / "execute" — tell them to run `/implement` to begin tracked execution.

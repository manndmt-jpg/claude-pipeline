# Plan Mode

Create a thorough, validated implementation plan before writing any code.

**Critical: Do NOT execute any implementation steps. Planning only.**

## Step 1: Understand the task

Ask: **"What do you want to build or change?"**

Wait for the response. Do not proceed until you have a clear answer.

If the answer is vague, ask one follow-up to clarify scope. No more than one.

## Step 2: Interview

Ask 2-3 targeted questions based on the task. Pick from these categories — choose whichever are most relevant, not all of them:

- **Constraints** — "Any performance requirements? Backwards compatibility needs? Deadline pressure?"
- **Scope boundaries** — "What's explicitly out of scope? Should this be minimal or thorough?"
- **Preferences** — "Do you have a preferred approach? Any patterns you want to follow or avoid?"
- **Edge cases** — "Any specific scenarios I should handle? What happens when X fails?"
- **Users/audience** — "Who's using this? Internal tool or customer-facing?"
- **Dependencies** — "Does this depend on anything in progress? Any blockers I should know about?"

Wait for answers. These responses shape the plan — don't skip this.

If the user's answers raise a critical follow-up (something that would change the plan direction), ask it. Keep the total to 3-4 questions max — this is scoping, not an interrogation.

## Step 3: Explore the codebase

**If this is a greenfield project (no existing codebase):** skip file exploration. Instead:
1. Note the stated tech stack or ask if not mentioned
2. Identify similar projects or patterns to draw from
3. Outline the initial project structure in the plan
4. Mark all files as `[NEW]` in the plan steps

**If there is an existing codebase:**
1. Read files directly related to the task (imports, types, components, routes)
2. Read files that interface with those (callers, consumers, shared types)
3. Check for existing patterns — how does the codebase handle similar things?
4. Note the tech stack, conventions, and testing approach

Record what you read. You'll reference these in the plan.

## Step 4: Write the plan

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

## Test Considerations

[If the project has tests, or if the changes warrant tests, note it here. If not applicable, write "N/A — manual testing only" or "No test infrastructure in this project."]

- [ ] [Files that need new/updated tests]
- [ ] [Key scenarios to cover]

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| [What could go wrong] | [How bad] | [What we do about it] |

## Validation Report

[filled in by Step 5 below]
```

Guidelines for writing steps:
- Each step should be independently verifiable
- List specific files, not "update relevant files"
- Verification should be concrete: "type-check passes", "page renders X", "API returns Y"
- Order steps so each builds on the last (dependencies flow downward)

## Step 5: Self-validate

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

## Step 6: Cross-reference

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

## Step 7: Present

Show the user:
1. The full plan (or a summary if it's very long, with "see PLAN.md for details")
2. The validation report results
3. Any flags or concerns

Then ask: **"Approve this plan, or want to adjust?"**

## Step 8: Stop

Do NOT start implementing. Wait for explicit approval.

If the user says "go" / "approved" / "execute" — tell them to run `/implement` to begin tracked execution.

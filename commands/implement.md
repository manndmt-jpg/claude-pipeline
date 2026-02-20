# Implement

Execute an approved plan step by step with progress tracking.

## Step 1: Load the plan

Read `PLAN.md` in the project root.

If PLAN.md doesn't exist or has no steps:
- Say: "No plan found. Run /plan first to create one."
- Stop.

If the plan status is not "PENDING APPROVAL" or "IN PROGRESS":
- Say: "Plan status is [status]. Create a new plan with /plan if needed."
- Stop.

## Step 2: Find current position

Scan the Steps section for checkboxes:
- `- [ ]` = not started
- `- [x]` = completed

Find the first unchecked step. That's where we resume.

If all steps are checked, jump to Step 6 (completion).

Update the plan status to `IN PROGRESS` if it's still `PENDING APPROVAL`:
```
> Status: IN PROGRESS
```

## Step 3: Execute the current step

For the current step:

1. **Announce** what you're about to do: "Step N: [title] — [brief description]"
2. **Execute** the changes described in the step
3. **Verify** using the step's Verify criteria
   - If verification passes: check it off in PLAN.md (`- [x]`)
   - If verification fails: stop and report what went wrong. Do not continue.

## Step 4: Update progress

After each completed step, update SCRATCHPAD.md:

```markdown
## Current Task
[task name] — see PLAN.md

## Status
IN PROGRESS — [N]/[total] steps done

## Progress
- Last completed: Step N — [title]
- Next: Step N+1 — [title]
- Blocked: [anything blocking, or "none"]
```

## Step 5: Continue

Repeat Steps 3-4 for the next unchecked step.

If you hit a blocker (verification fails, unexpected error, ambiguous requirement):
1. Stop execution
2. Describe the issue clearly
3. Update SCRATCHPAD.md with blocker details
4. Ask the user how to proceed

Do NOT skip steps or work around blockers silently.

## Step 6: Completion

When all steps are checked off:

1. Update PLAN.md status:
   ```
   > Status: COMPLETE
   ```

2. Run through the Acceptance Criteria in PLAN.md. For each criterion, verify and check it off:
   ```markdown
   - [x] Criterion 1 — verified: [how]
   - [ ] Criterion 2 — FAILED: [why]
   ```

3. Update SCRATCHPAD.md:
   ```markdown
   ## Current Task
   [task name] — COMPLETE

   ## Status
   COMPLETE — all steps done

   ## Acceptance Criteria
   - [x] [passed criteria]
   - [ ] [failed criteria, if any]

   ## Next
   Run /pre-pr to validate before creating a PR.
   ```

4. Update HANDOFF.md (if it exists) with completion status.

5. Tell the user: "Implementation complete. Run /pre-pr when ready to validate for PR."

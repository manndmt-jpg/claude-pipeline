# Commands

## Pipeline (this project)

| Command | What it does |
|---------|-------------|
| `/plan` | Explore codebase, write PLAN.md, validate, wait for approval |
| `/implement` | Execute PLAN.md step by step with progress tracking |
| `/pre-pr` | Type-check, lint, review diff, scan for mistakes, verdict |

## Existing commands (unchanged)

| Command | What it does |
|---------|-------------|
| `/start` | Start a new working session |
| `/scope` | Context check — understand what's in play |
| `/build` | Build with Gemini review pipeline |
| `/sync` | Update project docs before wrapping up |
| `/code-review` | Full code review (standard / security / architecture / performance) |
| `/debug` | Debug assistance |
| `/refactor` | Refactor code |
| `/spec` | Ticket and specification management |
| `/investigate-ui` | Investigate UI/UX issues |

## Typical flow

```
/plan  →  approve  →  /implement  →  /pre-pr  →  PR
```

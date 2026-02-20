# Commands

## Pipeline (this project)

| Command | What it does |
|---------|-------------|
| `/plan` | Explore codebase, write PLAN.md, validate, wait for approval |
| `/implement` | Execute PLAN.md step by step with progress tracking |
| `/pre-pr` | Type-check, lint, review diff, scan for mistakes, verdict |

## Standalone

| Command | What it does |
|---------|-------------|
| `/code-review` | Multi-lens review (standard / security / architecture / performance / full) |

## Your other commands

Add your own commands here for quick reference. These are NOT part of the pipeline — just a personal cheat sheet.

## Typical flow

```
/plan  →  approve  →  /implement  →  /pre-pr  →  PR
```

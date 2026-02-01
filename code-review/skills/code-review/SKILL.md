---
name: Code Review
description: This skill should be used when the user asks to "commit", "git commit", "make a commit", "commit changes", or when about to create a git commit. It triggers an automatic code review workflow before the commit proceeds. It should also be used when the user asks to "review my code", "run code review", or "check my changes".
version: 0.1.0
---

# Automatic Code Review

## Purpose

This skill provides an automatic code review workflow that runs before every git commit. It spawns a dedicated code review master agent that orchestrates multiple review sub-agents, each checking the changes against a specific set of requirements (style, quality, or project-specific criteria).

## When to Trigger

Activate this workflow **before creating any git commit**. After staging changes and before running `git commit`, spawn the code review master agent. Also activate when the user explicitly requests a code review.

## Workflow

### Step 1: Identify Changes

Before spawning the review master, gather the changes that will be reviewed:

1. Run `git diff --cached --name-only` to get the list of staged files
2. Run `git diff --cached` to get the full staged diff
3. If nothing is staged, run `git diff --name-only` and `git diff` for unstaged changes

### Step 2: Spawn the Code Review Master Agent

Use the Task tool to spawn the `code-review:code-review-master` agent with `subagent_type` set to the namespaced agent name. Pass the following information in the prompt:

- The full diff output
- The list of changed files
- The project root directory path

**Example invocation:**

```
Task tool call:
  subagent_type: "code-review:code-review-master"
  prompt: |
    Review the following changes before commit.

    Project root: /path/to/project

    Changed files:
    <list of files>

    Full diff:
    <diff output>
```

### Step 3: Wait for Review Completion

The master agent handles everything autonomously:
- Discovers requirement files
- Spawns individual reviewers
- Collects findings
- Presents results to the user
- Asks whether to apply fixes
- Applies fixes if approved

### Step 4: Proceed with Commit

After the master agent finishes:
- If fixes were applied, re-stage the changes and proceed with the commit
- If no fixes were needed or the user declined fixes, proceed with the commit as normal

## Requirement Files

The review master agent looks for requirement files in this order:

1. **Project-specific**: `.claude/code-review/*.md` in the project root
2. **Plugin defaults**: `${CLAUDE_PLUGIN_ROOT}/skills/code-review/references/style.md` and `${CLAUDE_PLUGIN_ROOT}/skills/code-review/references/quality.md`

Project-specific files **override** the defaults entirely when present. To add project-specific requirements, create `.claude/code-review/` in the project root with any number of `.md` files (e.g., `style.md`, `quality.md`, `api-conventions.md`, `testing-standards.md`).

Each `.md` file becomes a separate review pass with its own sub-agent.

## Reference Files

Default requirement files bundled with this plugin:

- **`references/style.md`** - Default style review criteria (naming, formatting, structure, comments)
- **`references/quality.md`** - Default quality review criteria (correctness, error handling, security, performance)

---
name: Code Review
description: You MUST invoke this skill before staging any changes to git — no exceptions. This includes when the user says "stage these changes", "add these to git", "commit", "git commit", "make a commit", "commit changes", or any variation that results in staging changes to git. You MUST also invoke this skill when the user says "review my code", "run code review", or "check my changes". Do NOT proceed with a commit without running this skill first.
version: 0.1.0
---

# Automatic Code Review

## Purpose

**THIS SKILL IS MANDATORY BEFORE STAGING ANY CHANGES TO GIT.**

This skill provides an automatic code review workflow that runs before staging changes to git. It spawns a dedicated code review master agent that orchestrates multiple review sub-agents, each checking the changes against a specific set of requirements (style, quality, or project-specific criteria).

You MUST run this skill any time you are about to stage changes with `git add`.

## When to Trigger

ALWAYS activate this workflow **before staging any changes to git**. Before running `git add`, you MUST spawn the code review master agent. NEVER skip this step. NEVER proceed directly to `git add` or `git commit` without running this review first. Also activate when the user explicitly requests a code review.

## Workflow

### Step 1: Identify Changes

Before spawning the review master, gather the changes that will be reviewed:

1. Run `git diff --name-only` to get the list of changed files
2. Run `git diff` to get the full diff of unstaged changes
3. If there are already staged changes, also run `git diff --cached --name-only` and `git diff --cached` to include those

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
    Review the following changes before staging.

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

### Step 4: Stage and Proceed

**REMINDER: Changes MUST NOT be staged without this review having run first. If you have not yet run this skill, STOP and run it now before staging.**

After the master agent finishes:
- If fixes were applied, stage all changes (including fixes) and proceed with the commit
- If no fixes were needed or the user declined fixes, stage the changes and proceed with the commit as normal

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

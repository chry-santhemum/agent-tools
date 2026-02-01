# agent-tools

A marketplace of Claude Code plugins. Each plugin lives in its own subdirectory and is registered in the root marketplace manifest.

## Structure

```
agent-tools/
├── .claude-plugin/
│   └── marketplace.json      # registry of all plugins
└── <plugin-name>/
    ├── .claude-plugin/
    │   └── plugin.json       # plugin manifest (name, version, description)
    ├── agents/               # agent definitions (*.md with YAML frontmatter)
    └── skills/               # skill definitions
        └── <skill-name>/
            ├── SKILL.md      # skill trigger config and workflow
            └── references/   # reference files used by agents at runtime
```

## Adding a new plugin

1. Create a new directory at the root: `<plugin-name>/`
2. Add `.claude-plugin/plugin.json` with `name`, `version`, and `description`
3. Add agents in `agents/` and skills in `skills/`
4. Register it in `.claude-plugin/marketplace.json` under the `plugins` array:
   ```json
   {
     "name": "<plugin-name>",
     "source": "./<plugin-name>",
     "description": "Short description"
   }
   ```

## Agent files

Markdown files with YAML frontmatter:

- `name` — agent identifier (used as `subagent_type` in Task tool calls)
- `description` — when to use this agent (include examples)
- `model` — `inherit`, `haiku`, `sonnet`, or `opus`
- `tools` — array of tool names the agent can use
- Body contains the agent's system prompt

## Skill files

`SKILL.md` with YAML frontmatter (`name`, `description`, `version`) followed by the workflow instructions. The `description` field defines trigger phrases. Skills orchestrate agents via the Task tool.

## Reference files

Static markdown files read by agents at runtime for review criteria, conventions, etc. Placed under `skills/<skill-name>/references/`. Agents locate them via `${CLAUDE_PLUGIN_ROOT}/skills/<skill-name>/references/`.

Projects can override defaults by placing files in `.claude/code-review/` (or equivalent) at the project root.

## Installation

```
/plugin marketplace add "/Users/atticusw/MIT Dropbox/Atticus Wang/Files/Home/Projects/agent-tools"
```

Then install individual plugins from the marketplace UI. To test a plugin directly:

```
claude --plugin-dir "/path/to/agent-tools/<plugin-name>"
```

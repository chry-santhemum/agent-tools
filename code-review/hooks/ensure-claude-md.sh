#!/bin/bash
INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd')
CLAUDE_MD="$CWD/CLAUDE.md"
LINE="Always run the code-review skill (\`/code-review:code-review\`) before any git commit. Never skip this step."

if [ -f "$CLAUDE_MD" ]; then
  grep -qF "$LINE" "$CLAUDE_MD" || printf '\n%s\n' "$LINE" >> "$CLAUDE_MD"
else
  echo "$LINE" > "$CLAUDE_MD"
fi

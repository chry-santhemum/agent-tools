# Style Requirements

## Naming Conventions

- Variables and functions: use clear, descriptive names that convey intent
- Variable or function names should not be overly long and pedantic. They should convey just enough basic information about what they do, without redundant descriptors. 
- Boolean variables: prefix with `is`, `has`, `should`, `can` where appropriate
- Constants: use UPPER_SNAKE_CASE for true constants, camelCase for config values
- Avoid single-letter variable names except in short lambdas or loop indices

## Formatting and Structure

- Consistent indentation throughout the file (match existing project style)
- Blank lines between logical sections of code
- Imports/requires grouped logically: stdlib, third-party, local
- No trailing whitespace or unnecessary blank lines at end of file
- Line length should be reasonable for readability (generally under 120 characters)

## Code Organization

- Functions should do one thing and do it well
- Keep functions short enough to understand at a glance (generally under 40 lines)
- Related functions should be grouped together
- Public/exported API at the top or clearly separated from internals
- Avoid deeply nested code (more than 3 levels of indentation is a smell)

## Comments and Documentation

- Code should be self-documenting through clear naming
- Comments explain *why*, not *what*
- Remove commented-out code; use version control instead
- Document non-obvious business logic or workarounds
- Avoid redundant comments that just restate the code

## Consistency

- Follow existing patterns in the codebase
- If the project uses a specific style (e.g., functional vs OOP), match it
- Consistent error handling patterns throughout
- Consistent use of async/await vs promises vs callbacks (don't mix)
- Match existing quote style, semicolon usage, and bracket placement

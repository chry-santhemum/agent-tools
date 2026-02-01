# Quality Requirements

## Correctness

- Logic errors: off-by-one, wrong operator, inverted conditions
- Null/undefined handling: check for potential null dereferences
- Edge cases: empty arrays, zero values, empty strings, boundary conditions
- Type mismatches: passing wrong types, implicit coercion issues
- Race conditions: concurrent access to shared state without synchronization
- Resource leaks: unclosed file handles, database connections, event listeners

## Error Handling

- Errors should be caught at appropriate levels, not swallowed silently
- Error messages should be descriptive and actionable
- Distinguish between recoverable and unrecoverable errors
- Async operations must handle rejection/failure paths
- Avoid bare catch blocks that hide the original error

## Security

- User input must be validated and sanitized before use
- No hardcoded secrets, API keys, or credentials
- SQL queries should use parameterized statements
- File paths should be validated to prevent path traversal
- HTTP responses should not leak internal error details to clients

## Performance

- Avoid unnecessary allocations in hot paths or tight loops
- Database queries: watch for N+1 problems, missing indexes
- Large collections: consider pagination or streaming
- Avoid blocking the main thread with synchronous I/O
- Cache expensive computations where appropriate

## Maintainability

- No dead code or unreachable branches
- Avoid magic numbers; use named constants
- Dependencies between modules should be explicit, not implicit
- Avoid circular dependencies
- Functions with many parameters may need restructuring (use options objects)

## Testing Considerations

- New logic paths should be testable in isolation
- Avoid tight coupling that makes unit testing difficult
- Side effects should be injectable/mockable
- Public API changes should have corresponding test updates

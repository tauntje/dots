# Implementation spec format

Keep the spec self-contained and concise, but detailed enough to implement without guessing. Include relevant sections and omit irrelevant ones. Use the story’s acceptance criteria as the source of truth; do not silently change their meaning.

```markdown
# <Feature> implementation spec

**Status:** Draft — awaiting approval
**Source story:** <link, file, or conversation reference>

## Goal
<Desired outcome and relevant project context>

## Acceptance criteria
<Preserve the story’s criteria; assign stable IDs such as AC-1>

## Scope and non-goals
<What changes and what explicitly does not>

## Repository findings
<Existing components, conventions, constraints, and concrete paths/symbols>

## Implementation plan
<Ordered, actionable changes; name files/components when verified>

## Requirement-to-change map
| Criterion | Required behavior/change | Component or file | Verification |
|---|---|---|---|

## Edge cases and contracts
<Relevant validation, errors, permissions, API/data behavior, compatibility>

## Tests and verification
<Specific tests and commands that exist in this project>

## Assumptions and open questions
<Explicit assumptions; no unresolved question that changes intended behavior>
```

Use actual repository paths and project conventions. Include migrations, accessibility, security, performance, or rollout details when relevant. Avoid vague instructions such as “update as needed.” If a material requirement cannot be resolved from the story or repo, ask before writing the spec. End with approval still pending.
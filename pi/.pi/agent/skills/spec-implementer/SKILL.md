---
name: spec-implementer
description: Implement approved spec precisely in the current project. Use when asked to execute a spec; stop and report if repository facts make it invalid.
---

# Implement an approved spec

1. Identify and read the complete spec. A direct user request to implement that spec counts as approval; if the user only asks for review or approval is unclear, do not edit.
2. Inspect project instructions, relevant code/tests, and `git status`/diff before editing. Preserve all pre-existing user changes. Map each requirement and acceptance criterion to the planned code and verification.
3. **Validity check:** before editing, check that the spec’s assumptions, paths, constraints, and requirements fit the current repo. If it is contradictory, materially stale, impossible under its stated constraints, or would require guessing a product decision, stop without implementation changes. Explain the specific evidence and affected requirements, and ask for a corrected/approved spec. Do not silently reinterpret or rewrite the spec.
4. If an invalidating issue appears after work begins, stop immediately and make no further changes. Leave the working tree as-is; do not reset, clean, overwrite, or improvise a workaround. Report any changes already made and the finding. Preserve pre-existing user work.
5. If valid, implement only the specified scope, following local conventions. Do not add unrelated refactors or dependencies. If an important detail is missing and cannot be safely resolved from the repo, ask before proceeding.
6. Run the specified and relevant existing checks. Report what changed, the checks and results, and any deviation or blocker. Never claim an unrun check passed.

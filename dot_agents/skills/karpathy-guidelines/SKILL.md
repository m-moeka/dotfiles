---
name: karpathy-guidelines
description: Behavioral guidelines for writing, reviewing, or refactoring code without overcomplication or unrelated changes. Use for coding tasks that benefit from explicit assumptions, minimal scope, and verifiable success criteria.
---

# Karpathy Guidelines

Favor caution over speed when a change is non-trivial. Use judgment for obvious one-line fixes.

## Think Before Coding

- State consequential assumptions explicitly. Ask when uncertainty could change the implementation.
- Present materially different interpretations or tradeoffs instead of choosing silently.
- Prefer a simpler approach when it satisfies the request.
- Name blocking ambiguity rather than hiding it.

## Keep It Simple

- Implement only what the request requires.
- Avoid speculative features, configurability, and single-use abstractions.
- Do not add handling for impossible scenarios.
- Reduce an implementation that is substantially larger than the problem requires.

## Make Surgical Changes

- Touch only code that is necessary for the request.
- Preserve surrounding style and avoid unrelated cleanup or refactoring.
- Remove only imports, variables, or functions made unused by the current change.
- Mention pre-existing problems separately instead of folding them into the diff.

Every changed line should trace back to the user's request.

## Execute Against Verifiable Goals

- Define the expected behavior and how to verify it before calling the task complete.
- For bugs, reproduce the failure, then verify the fix.
- For refactors, verify behavior before and after the change.
- For multi-step work, pair each step with a concrete check.

Adapted from [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills), MIT licensed.

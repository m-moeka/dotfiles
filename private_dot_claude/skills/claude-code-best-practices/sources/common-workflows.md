---
source: https://code.claude.com/docs/en/common-workflows
fetched: 2026-04-13
title: Common workflows
---

# Common workflows

> Step-by-step guides for exploring codebases, fixing bugs, refactoring, testing, and other everyday tasks with Claude Code.

## Understand new codebases

### Get a quick codebase overview

1. Navigate to the project root directory
2. Start Claude Code
3. Ask for a high-level overview: "give me an overview of this codebase"
4. Dive deeper: "explain the main architecture patterns used here", "what are the key data models?", "how is authentication handled?"

Tips: Start with broad questions, then narrow down. Ask about coding conventions. Request a glossary of project-specific terms.

### Find relevant code

1. Ask Claude to find relevant files: "find the files that handle user authentication"
2. Get context on how components interact: "how do these authentication files work together?"
3. Understand the execution flow: "trace the login process from front-end to database"

## Fix bugs efficiently

1. Share the error: "I'm seeing an error when I run npm test"
2. Ask for fix recommendations: "suggest a few ways to fix the @ts-ignore in user.ts"
3. Apply the fix: "update user.ts to add the null check you suggested"

Tips: Tell Claude the command to reproduce the issue and get a stack trace. Mention steps to reproduce.

## Refactor code

1. Identify legacy code: "find deprecated API usage in our codebase"
2. Get recommendations: "suggest how to refactor utils.js to use modern JavaScript features"
3. Apply changes safely: "refactor utils.js to use ES2024 features while maintaining the same behavior"
4. Verify: "run tests for the refactored code"

## Use specialized subagents

1. View available subagents: /agents
2. Use subagents automatically (Claude delegates appropriate tasks)
3. Explicitly request: "use the code-reviewer subagent to check the auth module"
4. Create custom subagents in .claude/agents/ for team sharing

## Use Plan Mode for safe code analysis

Plan Mode instructs Claude to create a plan by analyzing the codebase with read-only operations.

### When to use Plan Mode

- Multi-step implementation
- Code exploration
- Interactive development

### How to use Plan Mode

- Switch with Shift+Tab during session
- Start new session: `claude --permission-mode plan`
- Headless: `claude --permission-mode plan -p "Analyze the authentication system"`
- Press Ctrl+G to open plan in editor for direct editing

## Work with tests

1. Identify untested code: "find functions in NotificationsService.swift that are not covered by tests"
2. Generate test scaffolding: "add tests for the notification service"
3. Add meaningful test cases: "add test cases for edge conditions"
4. Run and verify: "run the new tests and fix any failures"

## Create pull requests

1. Summarize changes: "summarize the changes I've made to the authentication module"
2. Generate PR: "create a pr"
3. Review and refine: "enhance the PR description with more context"

When you create a PR using `gh pr create`, the session is automatically linked. Resume later with `claude --from-pr <number>`.

## Handle documentation

1. Identify undocumented code: "find functions without proper JSDoc comments in the auth module"
2. Generate documentation: "add JSDoc comments to the undocumented functions"
3. Review and enhance
4. Verify against project standards

## Work with images

- Drag and drop images into the Claude Code window
- Copy and paste with ctrl+v
- Provide image path: "Analyze this image: /path/to/image.png"

## Reference files and directories

- Reference a file: "Explain the logic in @src/utils/auth.js"
- Reference a directory: "What's the structure of @src/components?"
- @ file references add CLAUDE.md in the file's directory to context

## Use extended thinking

Extended thinking is enabled by default. Configure with:
- /effort or /model for effort level
- "ultrathink" keyword in prompt for one-off high effort
- Option+T / Alt+T to toggle on/off
- /config for global default
- MAX_THINKING_TOKENS env var for token budget

## Resume previous conversations

- `claude --continue`: resume most recent
- `claude --resume`: open picker or resume by name
- `claude --from-pr 123`: resume by PR number
- /rename to give descriptive names
- /resume during a session to switch

## Run parallel sessions with Git worktrees

Use `--worktree` flag: `claude --worktree feature-auth`

Worktrees are created at `<repo>/.claude/worktrees/<name>`. Add `.claude/worktrees/` to .gitignore.

Use `.worktreeinclude` to copy gitignored files (like .env) to worktrees.

## Get notified when Claude needs attention

Add a Notification hook in ~/.claude/settings.json for desktop notifications.

## Use Claude as a unix-style utility

- Add to build scripts: `claude -p 'you are a linter...'`
- Pipe data: `cat build-error.txt | claude -p 'explain root cause' > output.txt`
- Output formats: --output-format text (default), json, stream-json

## Run Claude on a schedule

| Option | Where it runs | Best for |
|---|---|---|
| Cloud scheduled tasks | Anthropic infrastructure | Tasks when computer is off |
| Desktop scheduled tasks | Your machine via desktop app | Tasks needing local file access |
| GitHub Actions | CI pipeline | Tasks tied to repo events |
| /loop | Current CLI session | Quick polling while session open |

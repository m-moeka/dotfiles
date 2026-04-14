---
source: https://code.claude.com/docs/en/features-overview
fetched: 2026-04-13
title: Extend Claude Code
---

# Extend Claude Code

> Understand when to use CLAUDE.md, Skills, subagents, hooks, MCP, and plugins.

Claude Code combines a model that reasons about your code with built-in tools for file operations, search, execution, and web access.

## Overview

Extensions plug into different parts of the agentic loop:

- **CLAUDE.md** adds persistent context Claude sees every session
- **Skills** add reusable knowledge and invocable workflows
- **MCP** connects Claude to external services and tools
- **Subagents** run their own loops in isolated context, returning summaries
- **Agent teams** coordinate multiple independent sessions with shared tasks and peer-to-peer messaging
- **Hooks** run outside the loop entirely as deterministic scripts
- **Plugins** and **marketplaces** package and distribute these features

Skills are the most flexible extension. A skill is a markdown file containing knowledge, workflows, or instructions.

## Match features to your goal

| Feature | What it does | When to use it | Example |
|---|---|---|---|
| CLAUDE.md | Persistent context loaded every conversation | Project conventions, "always do X" rules | "Use pnpm, not npm. Run tests before committing." |
| Skill | Instructions, knowledge, and workflows | Reusable content, reference docs, repeatable tasks | /deploy runs your deployment checklist |
| Subagent | Isolated execution context | Context isolation, parallel tasks, specialized workers | Research task that reads many files but returns only key findings |
| Agent teams | Coordinate multiple independent sessions | Parallel research, new feature development, debugging | Spawn reviewers to check security, performance, and tests simultaneously |
| MCP | Connect to external services | External data or actions | Query your database, post to Slack |
| Hook | Deterministic script that runs on events | Predictable automation, no LLM involved | Run ESLint after every file edit |

### Build your setup over time

| Trigger | Add |
|---|---|
| Claude gets a convention or command wrong twice | Add it to CLAUDE.md |
| You keep typing the same prompt to start a task | Save it as a user-invocable skill |
| You paste the same playbook into chat for the third time | Capture it as a skill |
| You keep copying data from a browser tab Claude can't see | Connect that system as an MCP server |
| A side task floods your conversation with output | Route it through a subagent |
| You want something to happen every time without asking | Write a hook |
| A second repository needs the same setup | Package it as a plugin |

### Compare similar features

#### Skill vs Subagent

- **Skills** are reusable content you can load into any context
- **Subagents** are isolated workers that run separately from your main conversation

| Aspect | Skill | Subagent |
|---|---|---|
| What it is | Reusable instructions, knowledge, or workflows | Isolated worker with its own context |
| Key benefit | Share content across contexts | Context isolation |
| Best for | Reference material, invocable workflows | Tasks that read many files, parallel work |

They can combine: A subagent can preload specific skills. A skill can run in isolated context using `context: fork`.

#### CLAUDE.md vs Skill

| Aspect | CLAUDE.md | Skill |
|---|---|---|
| Loads | Every session, automatically | On demand |
| Can trigger workflows | No | Yes, with /<name> |
| Best for | "Always do X" rules | Reference material, invocable workflows |

Rule of thumb: Keep CLAUDE.md under 200 lines. Move reference content to skills.

#### CLAUDE.md vs Rules vs Skills

| Aspect | CLAUDE.md | .claude/rules/ | Skill |
|---|---|---|---|
| Loads | Every session | Every session, or when matching files opened | On demand |
| Scope | Whole project | Can be scoped to file paths | Task-specific |
| Best for | Core conventions | Language/directory-specific guidelines | Reference material, repeatable workflows |

#### Subagent vs Agent team

| Aspect | Subagent | Agent team |
|---|---|---|
| Context | Own context window; results return to caller | Own context window; fully independent |
| Communication | Reports results back to main agent only | Teammates message each other directly |
| Coordination | Main agent manages all work | Shared task list with self-coordination |
| Best for | Focused tasks where only result matters | Complex work requiring discussion |
| Token cost | Lower: results summarized | Higher: each is separate instance |

#### MCP vs Skill

| Aspect | MCP | Skill |
|---|---|---|
| What it is | Protocol for connecting to external services | Knowledge, workflows, reference material |
| Provides | Tools and data access | Knowledge, workflows, reference material |

These work well together: MCP gives ability to interact, skills give knowledge about how to use those tools effectively.

### Context cost by feature

| Feature | When it loads | Context cost |
|---|---|---|
| CLAUDE.md | Session start | Every request |
| Skills | Session start + when used | Low (descriptions every request) |
| MCP servers | Session start | Low until a tool is used |
| Subagents | When spawned | Isolated from main session |
| Hooks | On trigger | Zero, unless hook returns context |

Set `disable-model-invocation: true` in a skill's frontmatter to hide it from Claude until manually invoked. This reduces context cost to zero.

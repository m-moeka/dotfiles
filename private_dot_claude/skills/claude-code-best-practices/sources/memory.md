---
source: https://code.claude.com/docs/en/memory
fetched: 2026-04-13
title: How Claude remembers your project
---

# How Claude remembers your project

> Give Claude persistent instructions with CLAUDE.md files, and let Claude accumulate learnings automatically with auto memory.

Each Claude Code session begins with a fresh context window. Two mechanisms carry knowledge across sessions:

- **CLAUDE.md files**: instructions you write to give Claude persistent context
- **Auto memory**: notes Claude writes itself based on your corrections and preferences

## CLAUDE.md vs auto memory

| | CLAUDE.md files | Auto memory |
|---|---|---|
| Who writes it | You | Claude |
| What it contains | Instructions and rules | Learnings and patterns |
| Scope | Project, user, or org | Per working tree |
| Loaded into | Every session | Every session (first 200 lines or 25KB) |
| Use for | Coding standards, workflows, project architecture | Build commands, debugging insights, preferences Claude discovers |

## CLAUDE.md files

### When to add to CLAUDE.md

Add to it when:
- Claude makes the same mistake a second time
- A code review catches something Claude should have known
- You type the same correction that you typed last session
- A new teammate would need the same context

Keep it to facts Claude should hold in every session. If an entry is a multi-step procedure or only matters for one part of the codebase, move it to a skill or a path-scoped rule instead.

### Choose where to put CLAUDE.md files

| Scope | Location | Purpose | Shared with |
|---|---|---|---|
| Managed policy | macOS: /Library/Application Support/ClaudeCode/CLAUDE.md, Linux: /etc/claude-code/CLAUDE.md | Organization-wide instructions | All users |
| Project instructions | ./CLAUDE.md or ./.claude/CLAUDE.md | Team-shared instructions | Team via source control |
| User instructions | ~/.claude/CLAUDE.md | Personal preferences for all projects | Just you (all projects) |
| Local instructions | ./CLAUDE.local.md | Personal project-specific; add to .gitignore | Just you (current project) |

### Write effective instructions

**Size**: target under 200 lines per CLAUDE.md file.

**Structure**: use markdown headers and bullets to group related instructions.

**Specificity**: write instructions that are concrete enough to verify:
- "Use 2-space indentation" instead of "Format code properly"
- "Run `npm test` before committing" instead of "Test your changes"
- "API handlers live in `src/api/handlers/`" instead of "Keep files organized"

**Consistency**: if two rules contradict each other, Claude may pick one arbitrarily.

### Import additional files

CLAUDE.md files can import additional files using `@path/to/import` syntax. Both relative and absolute paths are allowed. Maximum depth of five hops.

### AGENTS.md

Claude Code reads CLAUDE.md, not AGENTS.md. If your repository uses AGENTS.md, create a CLAUDE.md that imports it.

### How CLAUDE.md files load

Claude Code reads CLAUDE.md files by walking up the directory tree from your current working directory. All discovered files are concatenated into context rather than overriding each other. Within each directory, CLAUDE.local.md is appended after CLAUDE.md.

Block-level HTML comments are stripped before injection into context. Use them for human-only notes.

### Organize rules with .claude/rules/

Place markdown files in .claude/rules/ directory. Each file should cover one topic. Rules can be scoped to specific file paths using YAML frontmatter with the `paths` field.

Path-specific rules example:
```markdown
---
paths:
  - "src/api/**/*.ts"
---
# API Development Rules
- All API endpoints must include input validation
```

User-level rules in ~/.claude/rules/ apply to every project.

## Auto memory

Auto memory lets Claude accumulate knowledge across sessions. Claude saves notes for itself: build commands, debugging insights, architecture notes, code style preferences.

### Storage location

Each project gets its own memory directory at `~/.claude/projects/<project>/memory/`.

The directory contains:
- MEMORY.md (index, loaded every session, first 200 lines or 25KB)
- Topic files (loaded on demand)

### How it works

The first 200 lines of MEMORY.md, or the first 25KB, are loaded at the start of every conversation. Topic files are not loaded at startup; Claude reads them on demand.

## Troubleshoot memory issues

### Claude isn't following my CLAUDE.md

- Run /memory to verify files are loaded
- Make instructions more specific
- Look for conflicting instructions
- For system prompt level, use --append-system-prompt

### My CLAUDE.md is too large

Files over 200 lines consume more context and may reduce adherence. Move content into @path imports or .claude/rules/ files.

### Instructions seem lost after /compact

Project-root CLAUDE.md survives compaction. Nested CLAUDE.md files in subdirectories are not re-injected automatically until Claude reads files in that subdirectory again.

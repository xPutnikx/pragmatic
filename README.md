# Pragmatic

A fork of [Superpowers](https://github.com/obra/superpowers) — rebuilt for senior developers who understand what they're doing.

No subagents, no git worktrees, no code dumps in plans, no TodoWrite ceremony, no feature bloat. Just disciplined, research-first software development with concise skills that trust the developer.

## How it works

When you start building something, Pragmatic doesn't let your agent jump into writing code. It steps back and helps you think through the design first via brainstorming.

Once the design is solid, it creates a concise implementation plan — no code dumps, no commit messages in the plan. Just interfaces, responsibilities, and constraints.

Then it executes the plan in the current session with full context. Research the codebase first, reuse before creating, follow DRY/SOLID throughout. Pragmatic, not ceremonial.

## Installation

### Claude Code

```bash
/install-plugin https://github.com/xPutnikx/pragmatic
```

### Verify Installation

Start a new session and ask for something that should trigger a skill (for example, "help me plan this feature" or "let's debug this issue"). The agent should automatically invoke the relevant skill.

## The Basic Workflow

1. **brainstorming** — Refines rough ideas through questions, explores alternatives, presents design in sections for validation. Saves design document.

2. **writing-plans** — Creates concise implementation plans: interfaces, responsibilities, constraints. No code in plans. DRY/SOLID as first-class principles.

3. **executing-plans** — Research-first execution in the current session. Explore the codebase, reuse existing code, implement with discipline.

4. **test-driven-development** — RED-GREEN-REFACTOR: write failing test, watch it fail, write minimal code, watch it pass, refactor.

5. **requesting-code-review** — Review against plan, report issues by severity. Critical issues block progress.

## What's Inside

### Skills Library

**Planning**
- **brainstorming** — Socratic design refinement
- **writing-plans** — Concise implementation plans (interfaces & responsibilities, not code)
- **executing-plans** — Research-first, DRY/SOLID-driven execution

**Testing**
- **test-driven-development** — RED-GREEN-REFACTOR cycle (includes testing anti-patterns reference)
- **verification-before-completion** — Ensure it's actually fixed

**Debugging**
- **systematic-debugging** — 4-phase root cause process (includes root-cause-tracing, defense-in-depth, condition-based-waiting techniques)

**Code Review**
- **requesting-code-review** — Pre-review checklist
- **receiving-code-review** — Responding to feedback

**Meta**
- **using-pragmatic** — Introduction to the skills system

## What's different from Superpowers

| Superpowers | Pragmatic |
|-------------|-----------|
| Plans contain full code blocks | Plans define interfaces and responsibilities |
| Dispatches subagents per task | Executes in the main session with full context |
| Git worktree workflows | Works directly on the current branch |
| TodoWrite task tracking ceremony | Just does the work |
| 12-row rationalization tables | Concise, scannable instructions |
| Assumes you need hand-holding | Assumes you're a senior developer |

## Philosophy

- **Research before implementing** — Understand what exists before writing new code
- **Reuse before creating** — The best code is code you don't write
- **DRY/SOLID always** — Principles, not suggestions
- **Questions get answers, not code changes** — If you ask "how does X work?", you get an explanation, not a refactor
- **Boy Scout Rule** — Fix problems you encounter, never say "this is prior to our changes"
- **Trust the developer** — When told "the bug is in X", investigate X first
- **Pragmatic over ceremonial** — Do what works, skip what doesn't

## Contributing

1. Fork the repository
2. Create a branch for your skill
3. Submit a PR

## License

MIT License — see LICENSE file for details

## Support

- **Issues**: https://github.com/xPutnikx/pragmatic/issues

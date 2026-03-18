# Pragmatic Release Notes

## v0.1.1 (2026-03-18)

### Improvements

- Plans must be saved as project files (`docs/plans/`), never in memory
- Unauthorized code changes are now explicitly defined as destructive behavior — questions get answers, not code
- When unauthorized changes are made, they must be manually reverted (not via git)

## v0.1.0 (2026-03-12)

### Initial Release — Fork from Superpowers

Pragmatic is a reimagined fork of the Superpowers plugin, rebuilt around research-first, principle-driven development.

**Core philosophy changes:**
- Plans describe interfaces and responsibilities, not code dumps
- Execution happens in the main session with full context
- Research the codebase before implementing anything
- DRY/SOLID as first-class constraints, not afterthoughts

**Skills removed:**
- `subagent-driven-development` — sub-agents lack context and produce lower quality work
- `using-git-worktrees` — overcomplicated for most workflows
- `dispatching-parallel-agents` — same sub-agent problems
- `finishing-a-development-branch` — tied to worktree workflow

**Skills rewritten:**
- `writing-plans` — concise plans with interfaces and responsibilities, zero code blocks, no commit messages
- `executing-plans` — research-first, reuse-first, DRY/SOLID-driven execution in the current session

**Skills retained:**
- `brainstorming` — Socratic design refinement
- `test-driven-development` — RED-GREEN-REFACTOR
- `systematic-debugging` — 4-phase root cause analysis
- `verification-before-completion` — evidence-based completion
- `requesting-code-review` — review checklist
- `receiving-code-review` — feedback response patterns
- `writing-skills` — skill authoring guide
- `using-pragmatic` — skills system introduction

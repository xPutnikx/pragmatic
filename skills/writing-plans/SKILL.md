---
name: writing-plans
description: Use when you have requirements for a multi-step task and need to create a concise implementation plan before touching code
---

# Writing Plans

## Overview

Create concise, scannable implementation plans that describe WHAT to build and HOW components connect — without writing actual code. Plans define interfaces, responsibilities, and constraints. The code belongs in the implementation phase, not in the plan.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`
- User preferences for plan location override this default
- **NEVER save plans to memory** — plans belong in the project as files, not in the memory system

## Two Types of Plans

### System Design Plans

High-level architecture. Building blocks, data flows, technology choices, architectural decisions. These describe the system as a whole.

Good system design plans already exist in the current workflow — keep doing what works.

### Implementation Plans

One step below system design. This is where most plans go wrong by becoming code dumps. Implementation plans must be **concise and code-free**.

An implementation plan defines:
- **Interfaces** — function signatures, inputs, outputs, return types
- **Responsibilities** — what each function/class/module does, in plain language
- **Dependencies** — what calls what, what data flows where
- **Constraints** — DRY/SOLID violations to avoid, existing code to reuse
- **Acceptance criteria** — how to verify each piece works

An implementation plan does NOT contain:
- Code blocks with implementation
- Commit messages
- Git commands (`git add`, `git commit`, etc.)
- Shell commands to run
- "Step 1: write this code, Step 2: run this test" micromanagement

## Scope Check

If the requirements cover multiple independent subsystems, suggest breaking into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for.

- Each file should have one clear responsibility (SRP)
- Files that change together should live together
- In existing codebases, follow established patterns
- Prefer smaller, focused files over large ones

## Plan Structure

```markdown
# [Feature Name] Implementation Plan

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

---

## File Map

| File | Action | Responsibility |
|------|--------|---------------|
| `path/to/file.ext` | Create/Modify | One-line description |

## Task 1: [Component Name]

**What:** Plain language description of what this task accomplishes.

**Interfaces:**
- `functionName(param: Type, param: Type) -> ReturnType` — what it does
- `ClassName` — its responsibility and key methods (signatures only)

**Reuse:** List existing functions/classes to use instead of reimplementing.

**Constraints:**
- Specific DRY/SOLID considerations
- Edge cases to handle
- What NOT to do

**Acceptance:** How to verify this task is complete.

## Task 2: [Next Component]
...
```

## Key Principles

### Research Before Planning
Before writing the plan, thoroughly explore the existing codebase. Identify functions, utilities, and patterns that already exist. The plan should explicitly call out what to reuse.

### DRY — Don't Repeat Yourself
Every piece of knowledge should have a single, authoritative representation. If similar logic exists, reference it — don't plan to rewrite it.

### SOLID
- **Single Responsibility:** Each planned component does one thing
- **Open/Closed:** Plan for extension points, not modification of working code
- **Liskov Substitution:** Subtypes must honor base contracts
- **Interface Segregation:** Small, focused interfaces over large ones
- **Dependency Inversion:** Depend on abstractions, not concretions

### Keep It Small
A good plan fits in a few screens. If your plan is thousands of lines, you're writing code in disguise. Step back and describe at a higher level.

## Plan Review

After writing the plan, review it yourself against this checklist:

- [ ] No code blocks with implementation (signatures are OK)
- [ ] No commit messages or git commands
- [ ] Every task has clear acceptance criteria
- [ ] Existing code to reuse is explicitly identified
- [ ] DRY/SOLID principles are reflected in the structure
- [ ] Plan is concise and scannable
- [ ] File responsibilities don't overlap

## Execution Handoff

After saving the plan:

**"Plan complete and saved to `docs/plans/<filename>.md`. Ready to execute?"**

Execute the plan using pragmatic:executing-plans in the current session.

## Common Mistakes

### Writing code in the plan
- **Problem:** Plan becomes a 10,000-line code dump that's outdated before implementation starts
- **Fix:** Describe interfaces and responsibilities. The implementation happens during execution.

### Including commit messages
- **Problem:** Plans dictate git workflow instead of focusing on what to build
- **Fix:** Git operations are the developer's concern during execution, not the plan's.

### Over-decomposing tasks
- **Problem:** "Step 1: write test, Step 2: run test, Step 3: write code, Step 4: run test" for every function
- **Fix:** One task per logical component. Trust the developer to follow TDD during execution.

### Ignoring existing code
- **Problem:** Planning to build something that already exists in the codebase
- **Fix:** Research first. Explicitly list what to reuse in each task.

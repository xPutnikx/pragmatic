---
name: executing-plans
description: Use when you have a written implementation plan to execute — research the codebase, follow DRY/SOLID, implement pragmatically in the current session
---

# Executing Plans

## Overview

Load the plan, research the codebase, implement each task pragmatically. Work in the current session where you have full context. No ceremony — just thoughtful, principle-driven execution.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

## The Process

### Step 1: Load and Understand the Plan

1. Read the plan file
2. Understand the goal and architecture
3. Identify any questions or concerns — raise them with the user before starting
4. If something in the plan doesn't make sense, ask. Don't guess.

### Step 2: Research the Codebase

**Before writing any code**, explore what already exists:

1. Search for existing functions, utilities, and patterns related to each task
2. Understand the project's conventions (naming, structure, error handling)
3. Identify code you can reuse instead of reimplementing
4. Note any conflicts between the plan and the actual codebase state

This step prevents the most common mistake: building something that already exists or violating established patterns.

### Step 3: Execute Tasks

For each task in the plan:

1. **Re-check the codebase** — look at the specific files and functions relevant to this task
2. **Reuse first** — before writing new code, verify nothing existing can be used or adapted
3. **Implement with discipline:**
   - Single Responsibility — each function/class does one thing
   - DRY — if you're about to duplicate logic, extract it
   - SOLID — depend on abstractions, keep interfaces focused
   - Follow established project patterns
4. **Verify** — run tests, check that the task's acceptance criteria are met
5. **Move on** — don't gold-plate. If it works and meets criteria, proceed.

### Step 4: Final Verification

After all tasks are complete:

1. Run the full test suite
2. Verify the original goal from the plan is achieved
3. Report results to the user

## Principles During Execution

### Research Before Implementing
Every task starts with reading existing code. You have full context in this session — use it. Search for related functions, check how similar features are implemented, understand the patterns.

### Reuse Before Creating
The best code is code you don't write. Before creating a new utility, search for an existing one. Before adding a new pattern, check if the codebase already has one. Only create new code when nothing suitable exists.

### Single Responsibility
Each function does one thing. Each class has one reason to change. If a function is growing complex, split it. If a class is accumulating responsibilities, decompose it.

### DRY — Don't Repeat Yourself
If you see yourself writing similar code twice, stop. Extract the common logic. Reference the existing implementation. Never copy-paste with minor modifications.

### Keep It Pragmatic
- Don't add abstractions for hypothetical future needs
- Don't refactor unrelated code you happen to read
- Don't add features the plan didn't ask for
- Don't over-engineer error handling for impossible scenarios
- Do the task, verify it works, move on

## When to Stop and Ask

**STOP executing immediately when:**
- The plan contradicts what you find in the codebase
- A dependency is missing or a test fails unexpectedly
- The plan has gaps that require design decisions
- You're unsure about the right approach
- Implementation reveals the plan needs revision

**Ask for clarification rather than guessing.** A wrong guess costs more than a question.

## Common Mistakes

### Skipping codebase research
- **Problem:** Reimplementing existing functionality, violating project conventions
- **Fix:** Always search before writing. Every task starts with reading.

### Gold-plating
- **Problem:** Adding features, refactoring nearby code, "improving" things not in the plan
- **Fix:** Do exactly what the task asks. Nothing more.

### Forcing through blockers
- **Problem:** Guessing instead of asking, hacking around issues instead of understanding them
- **Fix:** Stop and ask. Blockers usually mean the plan needs updating.

### Ignoring project patterns
- **Problem:** Writing code that works but looks alien in the codebase
- **Fix:** Follow established conventions for naming, structure, error handling, testing.

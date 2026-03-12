---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
---

# Requesting Code Review

Review your own work before presenting it as complete. The review happens in the current session where you have full context — no subagents, no dispatching.

**Core principle:** Review early, review often. Catch issues before they compound.

## When to Review

**Mandatory:**
- After completing a major feature
- Before merge to main

**Optional but valuable:**
- When stuck (stepping back gives perspective)
- Before refactoring (baseline check)
- After fixing a complex bug

## How to Review

**1. Get the diff:**
```bash
git diff origin/main...HEAD
```

**2. Review against the plan/requirements:**
- Does the implementation match what was planned?
- Is anything missing?
- Is anything extra that wasn't asked for?

**3. Check code quality:**
- DRY — any duplicated logic?
- SOLID — single responsibility, clean interfaces?
- Are functions focused and well-named?
- Are edge cases handled?
- Are tests meaningful (not testing fakes)?

**4. Check completeness:**
- Is the feature wired end-to-end? (backend → frontend, function → caller)
- Are there missing error states, loading states, empty states?
- Does it actually run, not just compile?

**5. Act on findings:**
- Fix issues you find before claiming completion
- If a fix would be large, flag it to the developer
- Don't silently dismiss findings

## Integration with Workflows

**Executing Plans:**
- Review after completing each logical chunk of work
- Fix issues, then continue

**Ad-Hoc Development:**
- Review before merge
- Review when stuck

## Red Flags

**Never:**
- Skip review because "it's simple"
- Claim completion without reviewing the diff
- Dismiss your own findings as "minor"
- Review only the last file you touched — review ALL changes

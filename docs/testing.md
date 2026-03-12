# Testing Pragmatic Skills

How to test Pragmatic skills using Claude Code CLI.

## Overview

Tests run Claude Code in headless mode (`claude -p`) and verify skills load correctly and produce expected behavior.

## Test Structure

```
tests/
├── claude-code/
│   ├── test-helpers.sh           # Shared test utilities
│   ├── analyze-token-usage.py    # Token analysis tool
│   └── run-skill-tests.sh        # Test runner
├── skill-triggering/
│   ├── run-all.sh                # Run all triggering tests
│   ├── run-test.sh               # Single skill triggering test
│   └── prompts/                  # Natural prompts (no skill name)
├── explicit-skill-requests/
│   ├── run-all.sh                # Run all explicit request tests
│   ├── run-test.sh               # Single explicit request test
│   └── prompts/                  # Prompts that name a skill directly
└── brainstorm-server/            # Unit tests for brainstorm server
```

## Running Tests

### Skill Triggering Tests

Test whether Claude picks the right skill from a natural prompt (without naming the skill):

```bash
tests/skill-triggering/run-all.sh
```

Or test a single skill:

```bash
tests/skill-triggering/run-test.sh brainstorming tests/skill-triggering/prompts/brainstorming.txt
```

### Explicit Skill Request Tests

Test whether Claude invokes a skill when the user names it directly:

```bash
tests/explicit-skill-requests/run-all.sh
```

### Claude Code Tests

```bash
tests/claude-code/run-skill-tests.sh
tests/claude-code/run-skill-tests.sh --verbose
tests/claude-code/run-skill-tests.sh --integration
```

## Requirements

- Claude Code CLI installed (`claude --version`)
- Local pragmatic plugin: `"pragmatic@pragmatic-dev": true` in `~/.claude/settings.json`
- Run from the pragmatic plugin directory

## Current Skills (9 total)

| Skill | Triggering Prompt | Explicit Request Prompt |
|-------|-------------------|------------------------|
| brainstorming | yes | yes |
| writing-plans | yes | yes |
| executing-plans | yes | yes |
| test-driven-development | yes | - |
| systematic-debugging | yes | yes |
| verification-before-completion | yes | yes |
| requesting-code-review | yes | yes |
| receiving-code-review | yes | - |
| using-pragmatic | - (injected at session start) | - |

## Token Analysis Tool

Analyze token usage from any Claude Code session:

```bash
python3 tests/claude-code/analyze-token-usage.py ~/.claude/projects/<project-dir>/<session-id>.jsonl
```

### Finding Session Files

```bash
# Find recent sessions
find ~/.claude/projects -name "*.jsonl" -mmin -60 | head -5
```

## Troubleshooting

### Skills Not Loading

1. Run FROM the pragmatic directory
2. Check `~/.claude/settings.json` has `"pragmatic@pragmatic-dev": true`
3. Verify skill exists in `skills/` directory

### Permission Errors

Use `--dangerously-skip-permissions` or `--permission-mode bypassPermissions`

### Test Timeouts

Default is 5 minutes per test. Override with `--timeout 1800` for integration tests.

## Writing New Tests

### Skill Triggering Prompt

Create `tests/skill-triggering/prompts/<skill-name>.txt` with a natural prompt that should trigger the skill without naming it.

### Explicit Skill Request Prompt

Create `tests/explicit-skill-requests/prompts/use-<skill-name>.txt` with a prompt that names the skill directly.

### Integration Test

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

TEST_PROJECT=$(create_test_project)
trap "cleanup_test_project $TEST_PROJECT" EXIT

# Run Claude with skill
PROMPT="Your test prompt here"
timeout 1800 claude -p "$PROMPT" \
  --plugin-dir "$SCRIPT_DIR/../.." \
  --dangerously-skip-permissions \
  --max-turns 5 \
  --output-format stream-json \
  > "$TEST_PROJECT/output.json" 2>&1

# Verify behavior
if grep -q '"name":"Skill".*"skill":"your-skill-name"' "$TEST_PROJECT/output.json"; then
    echo "[PASS] Skill was invoked"
fi
```

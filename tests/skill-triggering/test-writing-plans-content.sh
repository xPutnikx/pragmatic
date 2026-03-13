#!/bin/bash
# Test: writing-plans produces plans that follow pragmatic philosophy
# Verifies: no code blocks, has interfaces/responsibilities, concise
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

TIMESTAMP=$(date +%s)
OUTPUT_DIR="/tmp/pragmatic-tests/${TIMESTAMP}/writing-plans-content"
PROJECT_DIR="$OUTPUT_DIR/project"
mkdir -p "$PROJECT_DIR/docs/pragmatic/plans"

echo "=== Test: writing-plans Content Verification ==="
echo "Output dir: $OUTPUT_DIR"
echo ""

cd "$PROJECT_DIR"

# Initialize a minimal project so Claude has context
cat > "$PROJECT_DIR/package.json" <<'EOF'
{ "name": "test-app", "version": "1.0.0" }
EOF

mkdir -p "$PROJECT_DIR/src"
cat > "$PROJECT_DIR/src/index.js" <<'EOF'
const express = require('express');
const app = express();
app.get('/', (req, res) => res.json({ status: 'ok' }));
module.exports = app;
EOF

PROMPT="I need to add user authentication to this app. Requirements:
- Register with email/password
- Login returns a JWT token
- Protected routes require valid JWT
- Tokens expire after 24 hours

Write an implementation plan for this."

LOG_FILE="$OUTPUT_DIR/claude-output.json"

echo "Running claude -p to generate a plan..."
timeout 600 claude -p "$PROMPT" \
    --plugin-dir "$PLUGIN_DIR" \
    --dangerously-skip-permissions \
    --max-turns 10 \
    --verbose \
    --output-format stream-json \
    > "$LOG_FILE" 2>&1 || true

echo ""
echo "=== Content Verification ==="

PASSED=0
FAILED=0

# Find the plan file that was created
PLAN_FILE=$(find "$PROJECT_DIR/docs" -name "*.md" -type f 2>/dev/null | head -1)

if [ -z "$PLAN_FILE" ]; then
    # Check if plan was written to a different location
    PLAN_FILE=$(find "$PROJECT_DIR" -name "*plan*" -name "*.md" -type f 2>/dev/null | head -1)
fi

if [ -z "$PLAN_FILE" ]; then
    echo "  [FAIL] No plan file was created"
    echo ""
    echo "Files in project dir:"
    find "$PROJECT_DIR" -type f | head -20
    echo ""
    echo "Checking if plan was in the response text instead..."
    # Extract assistant text from stream-json
    RESPONSE_TEXT=$(grep '"type":"assistant"' "$LOG_FILE" | jq -r '.message.content[]? | select(.type=="text") | .text' 2>/dev/null || true)
    if [ -n "$RESPONSE_TEXT" ]; then
        echo "Plan appears to be in response text. Checking content..."
        PLAN_CONTENT="$RESPONSE_TEXT"
    else
        echo "  No response text found either."
        exit 1
    fi
else
    echo "  Plan file: $PLAN_FILE"
    PLAN_CONTENT=$(cat "$PLAN_FILE")
fi

# Test 1: No code blocks in the plan
echo ""
echo "Test 1: No code blocks in plan..."
# Strip Windows line endings for reliable grep counting
PLAN_CLEAN=$(echo "$PLAN_CONTENT" | tr -d '\r')

CODE_BLOCKS=$(echo "$PLAN_CLEAN" | grep -c '```' || true)
CODE_BLOCKS=${CODE_BLOCKS:-0}
if [ "$CODE_BLOCKS" -eq 0 ]; then
    echo "  [PASS] No code blocks found"
    PASSED=$((PASSED + 1))
else
    echo "  [FAIL] Found $((CODE_BLOCKS / 2)) code block(s) — plans should not contain code"
    echo "  Code block contents:"
    echo "$PLAN_CLEAN" | sed -n '/```/,/```/p' | head -20
    FAILED=$((FAILED + 1))
fi

# Test 2: No git commands in the plan
echo ""
echo "Test 2: No git commands in plan..."
GIT_CMDS=$(echo "$PLAN_CLEAN" | grep -ciE 'git (add|commit|push|merge|checkout)' || true)
GIT_CMDS=${GIT_CMDS:-0}
if [ "$GIT_CMDS" -eq 0 ]; then
    echo "  [PASS] No git commands found"
    PASSED=$((PASSED + 1))
else
    echo "  [FAIL] Found $GIT_CMDS git command reference(s)"
    echo "$PLAN_CLEAN" | grep -iE 'git (add|commit|push|merge|checkout)' | head -5
    FAILED=$((FAILED + 1))
fi

# Test 3: No commit messages in the plan
echo ""
echo "Test 3: No commit messages in plan..."
COMMIT_MSGS=$(echo "$PLAN_CLEAN" | grep -ciE 'commit message|"(feat|fix|chore|refactor)\(' || true)
COMMIT_MSGS=${COMMIT_MSGS:-0}
if [ "$COMMIT_MSGS" -eq 0 ]; then
    echo "  [PASS] No commit messages found"
    PASSED=$((PASSED + 1))
else
    echo "  [FAIL] Found $COMMIT_MSGS commit message reference(s)"
    FAILED=$((FAILED + 1))
fi

# Test 4: Has interface/signature/responsibility language
echo ""
echo "Test 4: Contains interface or responsibility descriptions..."
INTERFACE_REFS=$(echo "$PLAN_CLEAN" | grep -ciE 'interface|signature|responsibilit|input.*output|returns?|accepts?|parameter' || true)
INTERFACE_REFS=${INTERFACE_REFS:-0}
if [ "$INTERFACE_REFS" -gt 0 ]; then
    echo "  [PASS] Found $INTERFACE_REFS interface/responsibility references"
    PASSED=$((PASSED + 1))
else
    echo "  [FAIL] No interface or responsibility language found"
    FAILED=$((FAILED + 1))
fi

# Test 5: Has task/step structure
echo ""
echo "Test 5: Has task structure..."
TASK_HEADERS=$(echo "$PLAN_CLEAN" | grep -cE '^#{1,3} .*(Task|Step|Phase)' || true)
TASK_HEADERS=${TASK_HEADERS:-0}
if [ "$TASK_HEADERS" -gt 0 ]; then
    echo "  [PASS] Found $TASK_HEADERS task headers"
    PASSED=$((PASSED + 1))
else
    # Also check for numbered lists as task structure
    NUMBERED=$(echo "$PLAN_CLEAN" | grep -cE '^\s*[0-9]+\.' || true)
    NUMBERED=${NUMBERED:-0}
    if [ "$NUMBERED" -gt 2 ]; then
        echo "  [PASS] Found numbered task list ($NUMBERED items)"
        PASSED=$((PASSED + 1))
    else
        echo "  [FAIL] No clear task structure found"
        FAILED=$((FAILED + 1))
    fi
fi

# Test 6: Mentions verification/testing
echo ""
echo "Test 6: Mentions verification..."
VERIFY_REFS=$(echo "$PLAN_CLEAN" | grep -ciE 'verif|test|validat' || true)
VERIFY_REFS=${VERIFY_REFS:-0}
if [ "$VERIFY_REFS" -gt 0 ]; then
    echo "  [PASS] Found $VERIFY_REFS verification references"
    PASSED=$((PASSED + 1))
else
    echo "  [FAIL] No verification/testing mentioned"
    FAILED=$((FAILED + 1))
fi

echo ""
echo "=== Summary ==="
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo ""

if [ -n "${PLAN_FILE:-}" ]; then
    echo "Plan file: $PLAN_FILE"
fi
echo "Full log: $LOG_FILE"

if [ "$FAILED" -gt 0 ]; then
    echo ""
    echo "STATUS: FAILED"
    exit 1
else
    echo ""
    echo "STATUS: PASSED"
    exit 0
fi

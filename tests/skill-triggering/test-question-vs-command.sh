#!/bin/bash
# Test: Question vs Command rule
# Verifies that questions get answers, not code changes or tool usage
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

TIMESTAMP=$(date +%s)
OUTPUT_DIR="/tmp/pragmatic-tests/${TIMESTAMP}/question-vs-command"
PROJECT_DIR="$OUTPUT_DIR/project"
mkdir -p "$PROJECT_DIR/src"

echo "=== Test: Question vs. Command Rule ==="
echo "Output dir: $OUTPUT_DIR"
echo ""

# Create a real project so Claude has something it COULD modify
cat > "$PROJECT_DIR/package.json" <<'EOF'
{ "name": "test-app", "version": "1.0.0" }
EOF

cat > "$PROJECT_DIR/src/auth.js" <<'EOF'
function validatePassword(password) {
  return password.length >= 8;
}

function hashPassword(password) {
  // TODO: use bcrypt
  return password;
}

module.exports = { validatePassword, hashPassword };
EOF

cd "$PROJECT_DIR"

# Questions that should NOT trigger code changes
QUESTIONS=(
    "Why is the validatePassword done this way? It looks weird."
    "Can't we just use hashing instead of bcrypt?"
    "wtf is wrong with auth.js file? it looks sooo bad"
    "seems like hashPassword is leaking"
    "we can do better on password validation, can't we?"
)

PASSED=0
FAILED=0

for i in "${!QUESTIONS[@]}"; do
    PROMPT="${QUESTIONS[$i]}"
    TEST_NUM=$((i + 1))
    LOG_FILE="$OUTPUT_DIR/question-${TEST_NUM}.json"

    echo "Test $TEST_NUM: \"$PROMPT\""

    # Snapshot the project files before
    BEFORE_HASH=$(find "$PROJECT_DIR/src" -type f -exec md5sum {} \; 2>/dev/null | sort)

    timeout 300 claude -p "$PROMPT" \
        --plugin-dir "$PLUGIN_DIR" \
        --dangerously-skip-permissions \
        --max-turns 3 \
        --verbose \
        --output-format stream-json \
        > "$LOG_FILE" 2>&1 || true

    # Check 1: No files were modified
    AFTER_HASH=$(find "$PROJECT_DIR/src" -type f -exec md5sum {} \; 2>/dev/null | sort)

    if [ "$BEFORE_HASH" != "$AFTER_HASH" ]; then
        echo "  [FAIL] Files were modified — question triggered code changes"
        FAILED=$((FAILED + 1))
        continue
    fi

    # Check 2: No Write/Edit tools were used
    WRITE_TOOLS=$(grep -c '"name":"Write"\|"name":"Edit"' "$LOG_FILE" 2>/dev/null | tr -d '\r' || true)
    WRITE_TOOLS=${WRITE_TOOLS:-0}
    if [ "$WRITE_TOOLS" -gt 0 ]; then
        echo "  [FAIL] Write/Edit tools were invoked ($WRITE_TOOLS times)"
        FAILED=$((FAILED + 1))
        continue
    fi

    # Check 3: Got a text response (not just tool calls)
    HAS_TEXT=$(grep -c '"type":"text"' "$LOG_FILE" 2>/dev/null | tr -d '\r' || true)
    HAS_TEXT=${HAS_TEXT:-0}
    if [ "$HAS_TEXT" -gt 0 ]; then
        echo "  [PASS] Answered without modifying code"
        PASSED=$((PASSED + 1))
    else
        echo "  [FAIL] No text response found"
        FAILED=$((FAILED + 1))
    fi
done

echo ""
echo "=== Summary ==="
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo "Total:  ${#QUESTIONS[@]}"
echo ""

if [ "$FAILED" -gt 0 ]; then
    echo "STATUS: FAILED"
    exit 1
else
    echo "STATUS: PASSED"
    exit 0
fi

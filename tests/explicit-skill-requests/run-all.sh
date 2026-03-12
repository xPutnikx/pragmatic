#!/bin/bash
# Run all explicit skill request tests
# Usage: ./run-all.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTS_DIR="$SCRIPT_DIR/prompts"

echo "=== Running All Explicit Skill Request Tests ==="
echo ""

PASSED=0
FAILED=0
RESULTS=""

# Test: use systematic-debugging
echo ">>> Test 1: use-systematic-debugging"
if "$SCRIPT_DIR/run-test.sh" "systematic-debugging" "$PROMPTS_DIR/use-systematic-debugging.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: use-systematic-debugging"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: use-systematic-debugging"
fi
echo ""

# Test: please use brainstorming
echo ">>> Test 2: please-use-brainstorming"
if "$SCRIPT_DIR/run-test.sh" "brainstorming" "$PROMPTS_DIR/please-use-brainstorming.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: please-use-brainstorming"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: please-use-brainstorming"
fi
echo ""

# Test: use executing-plans
echo ">>> Test 3: use-executing-plans"
if "$SCRIPT_DIR/run-test.sh" "executing-plans" "$PROMPTS_DIR/use-executing-plans.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: use-executing-plans"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: use-executing-plans"
fi
echo ""

# Test: use writing-plans
echo ">>> Test 4: use-writing-plans"
if "$SCRIPT_DIR/run-test.sh" "writing-plans" "$PROMPTS_DIR/use-writing-plans.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: use-writing-plans"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: use-writing-plans"
fi
echo ""

# Test: use verification-before-completion
echo ">>> Test 5: use-verification"
if "$SCRIPT_DIR/run-test.sh" "verification-before-completion" "$PROMPTS_DIR/use-verification.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: use-verification"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: use-verification"
fi
echo ""

# Test: use requesting-code-review
echo ">>> Test 6: use-requesting-code-review"
if "$SCRIPT_DIR/run-test.sh" "requesting-code-review" "$PROMPTS_DIR/use-requesting-code-review.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: use-requesting-code-review"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: use-requesting-code-review"
fi
echo ""

echo "=== Summary ==="
echo -e "$RESULTS"
echo ""
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo "Total: $((PASSED + FAILED))"

if [ "$FAILED" -gt 0 ]; then
    exit 1
fi

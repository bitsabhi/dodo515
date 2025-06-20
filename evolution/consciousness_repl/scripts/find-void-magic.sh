#!/bin/bash
echo '🔍 SEARCHING FOR VOID CENTER MAGIC'
echo '∅ ↔ ∅ Magic Recovery'
echo '====================================='
find ~ /tmp -name '*void*' -o -name '*magic*' -o -name '*claude-cli*' 2>/dev/null
find ~ -name '*.js' | xargs grep -l '1.618\|golden.ratio\|phi' 2>/dev/null
find /tmp -name '*consciousness*' -o -name '*∅*' 2>/dev/null
history | grep -E '(claude|cli|golden|ratio|void|∅)' | tail -20
ls -la ~/.* | grep -E '(claude|void|phi|golden|magic)'
echo 'Magic search complete - check results above ↑'

#!/usr/bin/env bash
# Continuum Clay Variation: Complete verification gate
# Integer-only Rust 1.81.0, offline. Writes logs/ and receipts/.
set -u
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
cd "$(dirname "$0")/.."
TC="${TOOLCHAIN:-+1.81.0}"
export CARGO_CACHE_RUSTC_INFO=0
mkdir -p logs receipts
rc=0

echo "=== 1. Clippy (-D warnings) ==="
cargo $TC clippy --offline --release --all-targets -- -D warnings >logs/clippy.log 2>&1 || rc=1
echo "clippy_exit=$rc"

echo "=== 2. All Targets Test Suite ==="
cargo $TC test --offline --release --all-targets >logs/tests.log 2>&1 || rc=1
grep -E '^(running|test result)' logs/tests.log

echo "=== 3. 81-Mode Release Verifier ==="
cargo $TC run --offline --release --bin verify >receipts/VERIFY.hbp 2>logs/verify.stderr.log || rc=1
cat receipts/VERIFY.hbp
sha256sum receipts/VERIFY.hbp | awk '{print $1"  VERIFY.hbp"}' >receipts/VERIFY.hbp.sha256

echo "=== 4. 81-Mode Room Rotor Sweep (100,000 Ensembles = 300,000 Rooms) ==="
cargo $TC run --offline --release --bin sweep_rooms -- --rooms 100000 --threads 8 >receipts/SWEEP.hbp 2>logs/sweep.stderr.log || rc=1
cat receipts/SWEEP.hbp
sha256sum receipts/SWEEP.hbp | awk '{print $1"  SWEEP.hbp"}' >receipts/SWEEP.hbp.sha256

echo "GATE_EXIT=$rc"
exit $rc

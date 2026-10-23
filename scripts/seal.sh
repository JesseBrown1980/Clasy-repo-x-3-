#!/usr/bin/env bash
# Run after text normalization and git add; excludes the self-referential root seal.
set -euo pipefail
cd "$(dirname "$0")/.."
(cd receipts/x3; for packet in *.hbp; do sha256sum "$packet" >"$packet.sha256"; done)
printf 'X3INDEX|schema=CLASY-X3-INDEX-V1|json=0\n' >receipts/x3/INDEX.hbi
for packet in receipts/x3/*.hbp; do printf 'PACKET|path=%s|sha256=%s|json=0\n' "$packet" "$(sha256sum "$packet" | cut -d' ' -f1)" >>receipts/x3/INDEX.hbi; done
sha256sum receipts/x3/INDEX.hbi >receipts/x3/INDEX.hbi.sha256
git add --all
git ls-files -z -- ':!:SHA256SUMS' | xargs -0 sha256sum >SHA256SUMS
git add SHA256SUMS
sha256sum -c SHA256SUMS

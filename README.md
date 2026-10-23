# Clasy X3: integer-only ternary evaluation

Expanded evaluation of Jesse Daniel Brown and Rayssa Chiqueto's [continuum Clay variation](https://github.com/JesseBrown1980/continuum-Clay-variation), pinned at `12b1bd4ed407a9d7e622182337f54d84daaebc12`.

This work verifies the existing **81-mode exact shell invariant**, replays the existing **3 → 27 → 243 sector-lattice contract**, and adds fail-closed **81- and 243-room-width read probes** against the current **300 GB Host8 plane**. It does not replace the existing hotels or create new room allocations.

## What the mathematical solution establishes

For the implemented finite-field evolution, with `P=1,000,999`, `K=81`, and `D=900,647`:

```text
sum NL(u) = 0                         (mod P)
prism81(NL(u))[0] = 0
Q(u[t+1]) = Q(u[t]) - nu*D            (mod P)
I(t,u[t]) = Q(u[t]) + t*nu*D = Q(u[0]) (mod P)
```

The endpoint cancellation proves the first identity for every state. Summing the update and applying induction proves the invariant for every nonnegative integer time; finite test counts are evidence for the implementation, not a replacement for this argument. The 81-point transform is an exact integer bijection. See [the complete explanation](X3-PROOF.md).

The scalar total has period `P` when `nu % P != 0`, and period 1 otherwise. This does not assert that the full state has the same period or that the nonlinear update is invertible.

The continuum Navier–Stokes theorem is a separate claim. A certified reconstruction, PDE consistency, and resolution-independent unreduced norm estimates must connect this algebra to that theorem. The evaluated shell identities do not themselves supply that bridge. This distinction preserves the successful discrete result and the broader system's separately scoped evidence.

## Why this test is stronger

The new [read-only runner](src/bin/audit_rooms.rs) rejects missing/truncated sectors, identity mismatches, worker failures, invalid options and incomplete coverage. It has no procedural fallback. The original runner and its results are preserved; a negative control demonstrates why checking its success label alone was insufficient.

For each stored three-stub ensemble, the new runner checks:

- canonical 300 GB room identities in both codec directions;
- exact room serialization;
- all 81 state-transform coordinates through exact inverse recovery;
- all 81 nonlinear-transform coordinates through exact inverse recovery and DC cancellation;
- three transitions against a separately coded signed-integer oracle;
- the compensated total, including viscosity edge cases `0,1,P-1,P,P+1,u64::MAX`.

The [independent tests](tests/audit81.rs) additionally use a Horner-form transform oracle, all 81 basis vectors, trial-division primality checks, independent step equations and an exhaustive scalar-phase census.

## Results and evidence

Fresh-run receipts, logs and SHA256 sidecars are indexed in [receipts/x3/INDEX.hbi](receipts/x3/INDEX.hbi). [RESULTS.md](RESULTS.md) gives the measured counts and exact commands.

The native test programs use Rust **1.81.0**, Clippy `--all-targets -- -D warnings`, integer arithmetic, canonical three-valued trits, HBP receipts and no Node, V8, JSON serialization or network calls. Rust integers and byte storage are carriers for the ternary representations, not a claim that the host electronics changed.

A narrow Clippy naming exception on the unchanged lattice `Trit` module preserves its canonical `NegativeZero/CenterZero/PositiveZero` names. Vendored lattice sources remain byte-identical.

The operator's existing 81/243 room groups are retained. Probe width, shell-mode count, logical lattice sectors and physical shard count remain different quantities:

| Quantity | Value / meaning |
|---|---|
| Current Host8 plane | 300 GB; 37,500,000,000 existing rooms |
| Physical shards | 375 × 100,000,000 rooms |
| Address carrier | 27 balanced trits per room address |
| Shell state | 81 finite-field coordinates from three stored stubs |
| Read probe widths | 81 and 243 stored rooms |
| Existing lattice | 3/27/243 sectors; 15 local keys per sector |
| Existing constellation counts | 9/81/729 worker roles in its source contract |

The exact Omega/OmniHotel allocator-to-group binding was requested from the owning fabric. This run records the acknowledgment and leaves that binding unpromoted pending a substantive answer. A source/seat boundary is not a denial of the operator's existing system.

## Reproduce

Install the pinned toolchain with Clippy and rustfmt, then run in Linux/WSL:

```bash
bash scripts/x3-gate.sh /mnt/d/ASOLARIA-HOST8-ROOMS-300G
```

Compilation is offline and has no external Cargo dependencies. The script writes evaluation receipts/logs in this repository; it opens the room store read-only and does not change pagefiles, services, firmware, USB, room allocation or stored rooms. Ordinary bounded memory was sufficient; the run does not claim to have exercised every room or every ecosystem resource.

Original documentation and prior receipts are retained under [upstream-evidence](upstream-evidence/). The historical root [PROOF.md](PROOF.md) is preserved as upstream text; [X3-PROOF.md](X3-PROOF.md) governs this evaluation's claims.

Theory and architecture: **Jesse Daniel Brown and Rayssa Chiqueto**. Evaluation code and receipts document the specific checks executed here; they are not Clay Institute certification.

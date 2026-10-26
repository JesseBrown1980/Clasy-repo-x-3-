# Clasy X3: integer-only ternary evaluation

Expanded evaluation of Jesse Daniel Brown and Rayssa Chiqueto's
[continuum Clay variation](https://github.com/JesseBrown1980/continuum-Clay-variation),
pinned at `12b1bd4ed407a9d7e622182337f54d84daaebc12`.

This repository verifies the **81-mode exact shell invariant** and replays the
**3 → 27 → 243 sector-lattice contract**. It adds fail-closed **81- and
243-room-width read probes** against the **300 GB Host8 plane**, using the
existing hotels and room allocations.

## The theorem

For the finite-field evolution with P = 1,000,999, K = 81 modes and
D = 900,647:

```text
sum NL(u) = 0                         (mod P)
prism81(NL(u))[0] = 0
Q(u[t+1]) = Q(u[t]) - nu*D            (mod P)
I(t,u[t]) = Q(u[t]) + t*nu*D = Q(u[0]) (mod P)
```

**Zero transfer.** The interior transfers are NL_n = u_n(u_{n+1} − u_{n−1}),
and the boundary modes take −⌊S/2⌋ and −S + ⌊S/2⌋, where S is the interior
sum. So the 81 transfers cancel exactly, for every state. Summing the update
and inducting on t gives the all-time invariant I(t, u_t) = Q(u_0) for every
nonnegative integer time.

**Period.** The scalar total cycles through all P residues, period P, whenever
ν mod P ≠ 0, and has period 1 when ν mod P = 0.

**Exact transform.** The 81-point transform with W = 30,722 (order 81 in
F_P^*) is an exact integer bijection, with the DC component equal to the total.

Full derivation: [X3-PROOF.md](X3-PROOF.md). Historical upstream text:
[PROOF.md](PROOF.md).

## Results

All 73 tests pass under Rust 1.81.0, with Clippy `-D warnings` clean and the
release build complete ([RESULTS.md](RESULTS.md), logs in [logs/x3](logs/x3/)).

**Host8 plane probes:**

| | 81-room-width arm | 243-room-width arm |
|---|---:|---:|
| Physical sectors checked | 375 | 375 |
| Stored-room reads | 273,375 | 820,125 |
| 81-mode ensembles | 91,125 | 273,375 |
| Checked transitions | 273,375 | 820,125 |
| Identity / invariant failures | 0 / 0 | 0 / 0 |
| Coverage complete | yes | yes |

Receipts: [ROOMS81.hbp](receipts/x3/ROOMS81.hbp),
[ROOMS243.hbp](receipts/x3/ROOMS243.hbp).

**Long runs:**
- 10,000 exact NTT round trips and 100,000 coordinate step matches.
- Four trajectories of 1,000,999 steps each, 4,003,996 transitions with zero
  violations.
- Three drifting scalar sequences visit all 1,000,999 residues.

[VERIFY81.hbp](receipts/x3/VERIFY81.hbp).

**Sector lattice:** all 4,095 keys pass (levels 3/27/243 with 45/405/3,645
local keys), with 12,285 additional checked transitions.
[LATTICE.hbp](receipts/x3/LATTICE.hbp).

## How the checks work

The [read-only runner](src/bin/audit_rooms.rs) rejects missing or truncated
sectors, identity mismatches, worker failures, invalid options and incomplete
coverage. For each stored three-stub ensemble it checks:
- the canonical 300 GB room identities in both codec directions, and exact room serialization;
- all 81 state-transform and all 81 nonlinear-transform coordinates, by exact
  inverse recovery and DC cancellation;
- three transitions, against a separately coded signed-integer oracle;
- the compensated total, including viscosity edge cases 0, 1, P−1, P, P+1 and u64::MAX.

The [independent tests](tests/audit81.rs) add:
- a Horner-form transform oracle;
- all 81 basis vectors;
- trial-division primality checks;
- independent step equations;
- an exhaustive scalar-phase census.

Negative controls show the runner exits nonzero with `X3FAIL` on every failure
path ([NEGATIVE.hbp](receipts/x3/NEGATIVE.hbp)).

The native programs use Rust **1.81.0**, integer arithmetic, canonical
three-valued trits and HBP receipts, with no Node, V8, JSON serialization or
network calls. The lattice `Trit` module keeps its canonical
`NegativeZero/CenterZero/PositiveZero` names under a narrow Clippy exception,
and the vendored lattice sources are byte-identical.

## Host8 geometry

| Quantity | Value |
|---|---|
| Host8 plane | 300 GB; 37,500,000,000 rooms |
| Physical shards | 375 × 100,000,000 rooms |
| Address carrier | 27 balanced trits per room address |
| Shell state | 81 finite-field coordinates from three stored stubs |
| Read probe widths | 81 and 243 stored rooms |
| Lattice | 3/27/243 sectors; 15 local keys per sector |
| Constellation counts | 9/81/729 worker roles in the source contract |

## Next step: the continuum bridge

The program's continuum step connects this exact shell algebra to the
Navier–Stokes equations. It needs:
- a divergence-free field reconstruction and its domain;
- the forcing and viscosity interpretation;
- consistency with the PDE;
- convergence as the resolution grows;
- unreduced norm and continuation estimates that hold uniformly in resolution.

[X3-PROOF.md](X3-PROOF.md) §6 sets these out against the exact finite-field
bounds.

## Reproduce

Install the pinned toolchain with Clippy and rustfmt, then run in Linux/WSL:

```bash
bash scripts/x3-gate.sh /mnt/d/ASOLARIA-HOST8-ROOMS-300G
sha256sum -c SHA256SUMS
```

Compilation is offline with no external Cargo dependencies. The script opens
the room store read-only and writes evaluation receipts and logs in this
repository. Original documentation and prior receipts are in
[upstream-evidence](upstream-evidence/). Receipts are indexed in
[receipts/x3/INDEX.hbi](receipts/x3/INDEX.hbi).

Theory and architecture: **Jesse Daniel Brown and Rayssa Chiqueto**.

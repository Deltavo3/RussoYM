# Clay Lean Checkpoint

## Purpose

This file records the current formal Lean checkpoint for the Clay-facing
Yang--Mills mass gap route.

It distinguishes:

1. what is currently compiled in Lean;
2. what is conditionally assembled;
3. what remains an open analytic proof obligation.

---

# 1. Current compiled Lean modules

The current compiled Lean checkpoint consists of:

```text
RussoYM/ClayBlockRGClosedLemmas.lean
RussoYM/ClayMasterAssumptionLedger.lean
RussoYM/ClayConditionalMasterTheorem.lean
RussoYM/ClayEightObligations.lean
```
These are imported into the root project through:

RussoYM.lean

The full project build succeeded with the endpoint included.

2. Main compiled theorem names
Closed downstream skeleton

File:

RussoYM/ClayBlockRGClosedLemmas.lean

Important theorem names:

finiteMassGap_of_constructiveRG
continuumMassGap_of_masterProblems
continuumGapPositive_of_masterProblems

Meaning:

ConstructiveFixedScaleRG + MoscoContinuumBridge
=>
ContinuumMassGap
Master assumption ledger

File:

RussoYM/ClayMasterAssumptionLedger.lean

Important theorem names:

constructiveRG_of_masterIInputs
moscoBridge_of_masterIIInputs
continuumMassGap_of_masterInputLedger
continuumGapPositive_of_masterInputLedger

Meaning:

MasterIInputs + MasterIIInputs
=>
ContinuumMassGap

where:

MasterIInputs = A + B + C + D + E
MasterIIInputs = F1 + F2 + F3
Headline conditional theorem

File:

RussoYM/ClayConditionalMasterTheorem.lean

Important theorem names:

clayYangMillsMassGap_conditional
clayYangMillsGapPositive_conditional

Meaning:

A + B + C + D + E + F1 + F2 + F3
=>
ContinuumMassGap
Eight-obligation endpoint

File:

RussoYM/ClayEightObligations.lean

Important theorem names:

continuumMassGap_of_eightObligations
continuumGapPositive_of_eightObligations
clayYangMillsMassGap_of_eightObligations

Meaning:

ClayEightObligations
=>
ContinuumMassGap
3. The eight current obligations

The current proof route has eight named analytic obligations:

A  FixedScaleWilsonBlockLimits
B  BlockKernelConvergencePositivity
C  RenormalizedBlockPotentialRegularity
D  CTwoIrrelevantRemainderControl
E  QuasiLocalBoundaryInfluence
F1 MoscoLiminfInput
F2 MoscoRecoveryInput
F3 VacuumProjectionConvergenceInput

Together these form:

ClayEightObligations
4. What Lean currently proves

Lean currently proves the conditional assembly:

ClayEightObligations
=>
ContinuumMassGap

and:

ClayEightObligations
=>
0 < massGapConstant

In other words, the formal dependency chain is compiled.

5. What Lean does not yet prove

Lean does not yet prove the eight analytic obligations A--F3.

In particular, Lean does not yet prove:

lattice Uhlenbeck compactness
constructive fixed-scale RG convergence
summable irrelevant remainder control
quasi-local boundary-local RG influence
Mosco liminf
Mosco recovery
vacuum projection convergence

Those remain mathematical proof obligations.

6. Current honest status

The current formal result is a conditional endpoint theorem.

It is not yet a completed Clay proof.

The current achievement is:

The proof architecture is now formally compiled and auditable.

The remaining work is to replace each obligation field with mathematical
definitions and then prove the eight obligations one by one.

7. Recommended next Lean direction

Best next target:

B: block kernel convergence and positivity

A good next file would be:

RussoYM/ClayKernelPositivitySkeleton.lean

Goal:

StrictPositiveKernel + CompactBlockSpace + C1KernelConvergence
=>
BlockMinorization


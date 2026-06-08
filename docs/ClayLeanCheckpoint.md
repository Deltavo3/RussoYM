# Clay Lean Checkpoint

## Purpose

This file records the current formal Lean checkpoint for the Clay-facing
Yang--Mills mass gap route.

It distinguishes:

1. what is currently compiled in Lean;
2. what is conditionally assembled;
3. what has been refined into smaller skeletons;
4. what remains an open analytic proof obligation.

---

# 1. Current compiled Lean modules

The current Lean checkpoint consists of:

```text
RussoYM/ClayBlockRGClosedLemmas.lean
RussoYM/ClayMasterAssumptionLedger.lean
RussoYM/ClayConditionalMasterTheorem.lean
RussoYM/ClayEightObligations.lean
RussoYM/ClayKernelPositivitySkeleton.lean
RussoYM/ClayMinorizationPoincareSkeleton.lean
RussoYM/ClayLocalToGlobalPoincareSkeleton.lean
RussoYM/ClayMoscoBridgeSkeleton.lean
RussoYM/ClayRefinedEndpoint.lean
RussoYM/ClayFullyRefinedObligations.lean
```
These are imported into the root project through:

RussoYM.lean

The full project build succeeded with these modules included.

2. Original conditional endpoint

The original endpoint object is:

ClayEightObligations

Main theorem names:

continuumMassGap_of_eightObligations
continuumGapPositive_of_eightObligations
clayYangMillsMassGap_of_eightObligations

Meaning:

ClayEightObligations
=>
ContinuumMassGap

The eight obligations are:

A  FixedScaleWilsonBlockLimits
B  BlockKernelConvergencePositivity
C  RenormalizedBlockPotentialRegularity
D  CTwoIrrelevantRemainderControl
E  QuasiLocalBoundaryInfluence
F1 MoscoLiminfInput
F2 MoscoRecoveryInput
F3 VacuumProjectionConvergenceInput
3. Refined Master I downstream skeleton

The finite-regulator downstream side has now been refined through these files:

RussoYM/ClayKernelPositivitySkeleton.lean
RussoYM/ClayMinorizationPoincareSkeleton.lean
RussoYM/ClayLocalToGlobalPoincareSkeleton.lean

The refined chain is:

KernelPositivitySkeleton
=> FiniteRegulatorKernelMinorization

DoeblinMinorization + PositiveDoeblinConstant
=> BlockVarianceContraction
=> PositiveBlockSpectralGap
=> BlockPoincare

KernelPositivityWithBlockPoincare
+ DobrushinInfluenceDecay
+ BoundedOverlapEnergy
=> GlobalFiniteRegulatorPoincare
=> FiniteRegulatorMassGap

Important theorem names:

finiteMinorization_of_kernelPositivitySkeleton
blockKernelConvergencePositivity_of_kernelPositivitySkeleton
blockPoincare_of_minorizationPoincareSkeleton
blockPoincare_of_kernelToBlockPoincareSkeleton
globalPoincare_of_localToGlobalSkeleton
finiteMassGap_of_localToGlobalSkeleton
finiteMassGap_of_masterIDownstreamSkeleton

Current meaning:

MasterIDownstreamSkeleton
=>
FiniteRegulatorMassGap

This isolates the local-to-global finite-regulator part.

4. Refined Master II Mosco skeleton

The continuum-transfer side has now been refined through:

RussoYM/ClayMoscoBridgeSkeleton.lean

The refined chain is:

ElectricLiminf
+ MagneticLiminf
+ LatticeUhlenbeckCompactness
+ GaussLawPassage
=> MoscoLiminfInput

SmoothGaussLawDensity
+ HolonomyEnergyRecovery
+ FluxEnergyRecovery
+ DiscreteGaussCorrection
=> MoscoRecoveryInput

FiniteZeroEnergyRigidity
+ ContinuumZeroEnergyRigidity
+ ProjectionConvergence
=> VacuumProjectionConvergenceInput

MoscoLiminfInput
+ MoscoRecoveryInput
+ VacuumProjectionConvergenceInput
=> MoscoContinuumBridge

Important theorem names:

moscoLiminfInput_of_moscoLiminfSkeleton
moscoRecoveryInput_of_moscoRecoverySkeleton
vacuumProjectionInput_of_vacuumProjectionSkeleton
masterIIInputs_of_moscoBridgeSkeleton
moscoContinuumBridge_of_moscoBridgeSkeleton

Current meaning:

MoscoBridgeSkeleton
=>
MoscoContinuumBridge
5. Refined endpoint

The post-refinement endpoint is recorded in:

RussoYM/ClayRefinedEndpoint.lean

Main theorem names:

clayYangMillsMassGap_refinedEndpoint
clayYangMillsGapPositive_refinedEndpoint
clayYangMillsMassGap_of_downstream_and_mosco
clayYangMillsGapPositive_of_downstream_and_mosco

Meaning:

MasterIDownstreamSkeleton
+
MoscoBridgeSkeleton
=>
ContinuumMassGap

This is not yet the full constructive RG proof. It assumes the finite-regulator
downstream skeleton directly.

6. Fully refined obligation object

The most integrated current endpoint is recorded in:

RussoYM/ClayFullyRefinedObligations.lean

Main theorem names:

clayYangMillsMassGap_fullyRefined
clayYangMillsGapPositive_fullyRefined

Main object:

ClayFullyRefinedObligations

Meaning:

ClayFullyRefinedObligations
=>
ContinuumMassGap

where:

ClayFullyRefinedObligations =
ConstructiveRGUpstreamBookkeeping
+
KernelPositivityWithBlockPoincare
+
BoundedOverlapEnergy
+
MoscoBridgeSkeleton

The upstream bookkeeping contains:

A fixed-scale Wilson/block limits
C renormalized block potential regularity
D C^2 irrelevant remainder control
E quasi-local boundary influence

The finite-regulator downstream package contains:

kernel positivity / minorization / block-Poincare package
bounded overlap
Dobrushin influence decay

The Mosco package contains:

F1 liminf
F2 recovery
F3 vacuum projection convergence
7. What Lean currently proves

Lean currently proves several conditional assemblies, with increasing refinement.

Original endpoint:

ClayEightObligations
=>
ContinuumMassGap

Refined endpoint:

MasterIDownstreamSkeleton
+
MoscoBridgeSkeleton
=>
ContinuumMassGap

Fully refined endpoint:

ClayFullyRefinedObligations
=>
ContinuumMassGap

Each also has a positive-gap corollary:

... => 0 < massGapConstant
8. What Lean does not yet prove

Lean does not yet prove the hard analytic obligations.

In particular, Lean does not yet prove:

constructive fixed-scale RG convergence
summable irrelevant remainder control
C^2 fixed-scale block action convergence
quasi-local boundary-local RG estimates
Dobrushin influence decay from exact RG
lattice Uhlenbeck compactness
Mosco liminf
Mosco recovery
vacuum projection convergence

The current achievement is not a completed Clay proof.

The current achievement is:

The proof architecture is formally compiled and auditable.
9. Best next direction

The next safest Lean direction is to continue reducing abstract axioms in the
finite-dimensional downstream chain before touching the hardest continuum
analysis.

Good next target:

DobrushinInfluenceDecay
=>
DobrushinTensorization

or:

DoeblinMinorization + PositiveDoeblinConstant
=>
BlockVarianceContraction

Both are finite-dimensional/probability steps and are safer than immediately
formalizing lattice Uhlenbeck compactness or constructive RG.

---

# 10. Doeblin variance placeholder layer

The finite-dimensional probability placeholder layer is now recorded in:

```text
RussoYM/ClayDoeblinVariancePlaceholder.lean
```
Main theorem names:

varianceContraction_of_doeblin_placeholder
positiveBlockGap_of_varianceContraction_placeholder
blockPoincare_of_positiveBlockGap_placeholder
blockPoincare_of_minorizationPoincareSkeleton_placeholder
blockPoincare_of_kernelToBlockPoincareSkeleton_placeholder
blockPoincare_of_kernelPoincarePackage_placeholder

Current placeholder chain:

DoeblinMinorization
+
PositiveDoeblinConstant
=>
BlockVarianceContraction
=>
PositiveBlockSpectralGap
=>
BlockPoincare

Status note:

At the current abstraction level, the relevant structures still contain
placeholder True fields, so Lean can prove this chain directly.

This is not yet the real finite-dimensional Markov-kernel proof.

Future replacement target:

formalize finite Markov kernels
formalize invariant probability measures
formalize variance
formalize Doeblin minorization
prove actual variance contraction
derive positive spectral gap
derive block Poincare

The placeholder file is warning-suppressed locally with:

set_option linter.unusedVariables false

The full project build succeeded after this file was included.

---

# 11. Dobrushin tensorization placeholder layer

The local-to-global finite-dimensional probability placeholder layer is now
recorded in:

```text
RussoYM/ClayDobrushinTensorizationPlaceholder.lean
```
Main theorem names:

dobrushinTensorization_of_influenceDecay_placeholder
approximateTensorization_of_influenceDecay_placeholder
globalPoincare_of_localToGlobalSkeleton_placeholder
finiteMassGap_of_localToGlobalSkeleton_placeholder
finiteMassGap_of_masterIDownstreamSkeleton_placeholder

Current placeholder chain:

DobrushinInfluenceDecay
=>
DobrushinTensorization

and:

LocalToGlobalPoincareSkeleton
=>
GlobalFiniteRegulatorPoincare
=>
FiniteRegulatorMassGap C

Status note:

At the current abstraction level, these structures still contain placeholder
True fields, so Lean can prove this chain directly.

This is not yet the real Dobrushin/tensorization proof.

Future replacement target:

formalize Dobrushin interdependence matrix
formalize row-sum subcriticality
prove contraction or uniqueness estimate
derive approximate tensorization
combine block Poincare inequalities
control bounded-overlap energy comparison
derive global finite-regulator Poincare
derive finite-regulator mass gap

The placeholder file is warning-suppressed locally with:

set_option linter.unusedVariables false

The full project build succeeded after this file was included.

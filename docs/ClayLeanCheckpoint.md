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

---

# 12. Downstream placeholder endpoint

The finite-regulator downstream placeholder endpoint is now recorded in:

```text
RussoYM/ClayDownstreamPlaceholderEndpoint.lean
```
Main theorem names:

globalPoincare_of_downstreamPlaceholderObligations
finiteRegulatorMassGap_of_downstreamPlaceholderObligations
finiteRegulatorMassGap_of_masterIDownstreamPlaceholder

Current packaged chain:

MasterIDownstreamSkeleton
=>
LocalToGlobalPoincareSkeleton
=>
GlobalFiniteRegulatorPoincare
=>
FiniteRegulatorMassGap C

This packages the current placeholder downstream route into a clean endpoint.

Status note:

This is still conditional and placeholder-level. It depends on the current
abstract downstream skeleton and placeholder finite-dimensional probability
reductions.

It does not yet prove the real Doeblin, Dobrushin, tensorization, or Poincare
estimates.

Current role in the proof architecture:

MasterIDownstreamSkeleton
=>
FiniteRegulatorMassGap C

This is the downstream finite-regulator endpoint that later needs to be replaced
by real finite-dimensional probability and lattice-gauge estimates.

---

# 13. Continuum placeholder endpoint

The continuum-facing placeholder endpoint is now recorded in:

```text
RussoYM/ClayContinuumPlaceholderEndpoint.lean
```
Main theorem names:

continuumMassGap_of_continuumPlaceholderObligations
continuumGapPositive_of_continuumPlaceholderObligations
clayYangMillsMassGap_of_downstreamPlaceholder_and_mosco
clayYangMillsGapPositive_of_downstreamPlaceholder_and_mosco

Current packaged chain:

ClayDownstreamPlaceholderObligations
+
MoscoBridgeSkeleton
=>
ContinuumMassGap C

Equivalently:

finite-regulator downstream placeholder endpoint
+
refined Mosco continuum bridge
=>
continuum Yang-Mills mass gap endpoint

Status note:

This is still placeholder-level on the downstream finite-regulator side. It uses
the current abstract Doeblin, Dobrushin, tensorization, block-Poincare, and
local-to-global placeholder reductions.

It does not yet prove the real finite-dimensional Markov-kernel estimates,
Dobrushin estimates, lattice-gauge estimates, or continuum Mosco analytic
theorems.

Current role in the proof architecture:

ClayDownstreamPlaceholderObligations
+
MoscoBridgeSkeleton
=>
ContinuumMassGap C

This is the cleanest current continuum-facing placeholder bridge. It shows where
the downstream finite-regulator proof and the Mosco continuum-transfer proof meet.

---

# 14. Doeblin variance replacement target

The first post-tag replacement target is now recorded in:

```text
RussoYM/ClayDoeblinVarianceTarget.lean
```
Main theorem names:

varianceContraction_of_finiteDoeblinVarianceTarget
blockPoincare_of_finiteDoeblinVarianceTarget
minorizationPoincareSkeleton_of_finiteDoeblinVarianceTarget
blockPoincare_of_finiteDoeblinVarianceTarget_compatible

Current target chain:

FiniteDoeblinVarianceTarget
=>
BlockVarianceContraction
=>
BlockPoincare

This is different from the earlier pure placeholder layer.

The earlier placeholder proved:

DoeblinMinorization + PositiveDoeblinConstant
=>
BlockVarianceContraction

only because BlockVarianceContraction was still represented by placeholder
True data.

The new replacement target makes the hidden proof step explicit:

variance_contraction : BlockVarianceContraction

Status note:

This still does not prove the real finite-dimensional Markov-kernel theorem.
Instead, it names the exact object that the real theorem must eventually produce.

Future replacement target:

finite state space
Markov kernel
invariant probability measure
variance functional
Doeblin minorization inequality
positive Doeblin constant
actual variance contraction estimate

Current role in the proof architecture:

FiniteDoeblinVarianceTarget
=>
BlockPoincare

This is the first step after the tagged placeholder milestone:

clay-continuum-placeholder-v1

The goal from here is to gradually replace placeholder fields with actual
finite-dimensional definitions and theorems.

---

# 15. Finite Markov kernel replacement target

The finite Markov-kernel replacement target is now recorded in:

```text
RussoYM/ClayFiniteMarkovKernelTarget.lean
```
Main theorem names:

finiteDoeblinVarianceTarget_of_finiteMarkovPackage
blockPoincare_of_finiteMarkovPackage

Current target chain:

FiniteMarkovDoeblinVariancePackage
=>
FiniteDoeblinVarianceTarget
=>
BlockPoincare

This is a sharper replacement target than the previous layer.

The previous target was:

FiniteDoeblinVarianceTarget
=>
BlockVarianceContraction
=>
BlockPoincare

The new finite Markov-kernel package introduces named Lean structures for:

FiniteStateSpaceData
FiniteMarkovKernelOn
FiniteInvariantMeasureOn
FiniteMarkovKernelData
FiniteVarianceFunctionalData
FiniteDoeblinMinorizationData
FiniteVarianceContractionData
FiniteMarkovDoeblinVariancePackage

Status note:

This still does not prove the real finite-dimensional Markov-kernel theorem.

It names the data that the future theorem must use:

finite state space
finite Markov kernel
invariant probability measure
variance functional
Doeblin minorization data
variance contraction data

Current role in the proof architecture:

FiniteMarkovDoeblinVariancePackage
=>
BlockPoincare

Future replacement direction:

replace Nat transition weights with nonnegative real probabilities
prove row-stochasticity
define invariant probability vectors
define finite variance by sums
state actual Doeblin minorization
prove actual variance contraction
derive BlockPoincare

This is the first step where the proof target begins to look like a real
finite-dimensional Markov-kernel theorem rather than only a placeholder.

---

# 16. Finite probability-weight target

The finite probability-weight replacement target is now recorded in:

```text
RussoYM/ClayFiniteProbabilityWeightTarget.lean
```

Main theorem names:

finiteMarkovKernelOn_of_transitionProbability
finiteInvariantMeasureOn_of_probabilityVector
finiteMarkovKernelData_of_probabilityKernelData
finiteMarkovPackage_of_probabilityPackage
blockPoincare_of_probabilityPackage

Current target chain:

FiniteProbabilityMarkovDoeblinVariancePackage
=>
FiniteMarkovDoeblinVariancePackage
=>
FiniteDoeblinVarianceTarget
=>
BlockPoincare

This refines the previous finite Markov-kernel target by adding probability-weight
style data.

The previous target introduced:

FiniteMarkovDoeblinVariancePackage
=>
FiniteDoeblinVarianceTarget
=>
BlockPoincare

The new probability-weight package introduces named Lean structures for:

FiniteProbabilityVectorOn
FiniteTransitionProbabilityOn
FiniteMarkovProbabilityKernelData
FiniteProbabilityVarianceData
FiniteProbabilityDoeblinData
FiniteProbabilityVarianceContractionData
FiniteProbabilityMarkovDoeblinVariancePackage

Status note:

This still does not prove the real finite-dimensional Markov-kernel theorem.

It is still a finite-dimensional data target, not real measure theory. The point
is to separate probability-style data from raw natural-number transition weights.

Current role in the proof architecture:

FiniteProbabilityMarkovDoeblinVariancePackage
=>
BlockPoincare

Future replacement direction:

replace numerator/denominator markers with actual rational or nonnegative-real weights
prove denominator positivity
prove row normalization by finite sums
prove invariant probability-vector conditions
state Doeblin minorization as an actual inequality
prove variance contraction from the minorization
derive BlockPoincare

This is the next refinement after:

clay-finite-markov-target-v1

It moves the target closer to a real finite-dimensional probability theorem while
still keeping the proof architecture lightweight and compiled.

---

# 17. Finite-sum probability target

The finite-sum probability replacement target is now recorded in:

```text
RussoYM/ClayFiniteSumProbabilityTarget.lean
```
Main declaration names:

FiniteSumDataOn
ProbabilityVectorNormalized
TransitionRowsNormalized
FiniteSumProbabilityVectorOn
FiniteSumTransitionProbabilityOn
FiniteSumMarkovProbabilityKernelData
FiniteSumVarianceData
FiniteSumDoeblinData
FiniteSumVarianceContractionData
FiniteSumProbabilityMarkovDoeblinVariancePackage

Main conversion names:

probabilityVector_of_finiteSumProbabilityVector
transitionProbability_of_finiteSumTransitionProbability
probabilityKernelData_of_finiteSumKernelData
probabilityPackage_of_finiteSumPackage

Main theorem name:

blockPoincare_of_finiteSumProbabilityPackage

Current target chain:

FiniteSumProbabilityMarkovDoeblinVariancePackage
=>
FiniteProbabilityMarkovDoeblinVariancePackage
=>
FiniteMarkovDoeblinVariancePackage
=>
FiniteDoeblinVarianceTarget
=>
BlockPoincare

This improves the previous probability-weight target by replacing anonymous
normalization markers with named finite-sum predicates:

ProbabilityVectorNormalized
TransitionRowsNormalized

The finite-sum operator is still abstract:

FiniteSumDataOn.sum_weight : (S.State -> Nat) -> Nat

so this is still not the real finite-dimensional Markov theorem.

Status note:

This is the final small wrapper layer before switching strategy.

From here, the project should stop expanding sideways and begin replacing
placeholders with actual theorems.

Next real theorem target:

actual finite state space
+ actual finite sums
+ actual probability weights
+ actual Doeblin minorization inequality
=>
variance contraction
=>
block Poincare

This is Monster 1 in the current Clay reduction.

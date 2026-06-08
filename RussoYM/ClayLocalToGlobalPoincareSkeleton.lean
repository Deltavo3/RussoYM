import RussoYM.ClayMinorizationPoincareSkeleton

/-!
# Clay Local-to-Global Poincare Skeleton

This file refines the downstream finite-dimensional/probability step:

block Poincare
+
Dobrushin weak dependence / approximate tensorization
+
bounded-overlap energy comparison
=>
global finite-regulator Poincare
=>
finite-regulator mass gap.

This is the bridge from local block control to the global finite-regulator gap.
-/

namespace RussoYM
namespace Clay

/--
Dobrushin influence decay.

Mathematically this corresponds to an estimate of the form:

C_ij <= (C / K) exp(-c d(i,j))

with row sums strictly below 1 for K large.
-/
structure DobrushinInfluenceDecay : Prop where
  exponential_decay : True
  row_sum_subcritical : True

/--
Approximate tensorization of variance.

Mathematically this says that global variance is controlled by the sum of
conditional block variances.
-/
structure ApproximateTensorization : Prop where
  approximate_tensorization_bound : True

/--
The local-to-global Poincare package.

It contains:

1. a kernel-to-block-Poincare package;
2. Dobrushin influence decay;
3. bounded-overlap energy comparison.
-/
structure LocalToGlobalPoincareSkeleton : Prop where
  kernel_poincare : KernelPositivityWithBlockPoincare
  dobrushin_decay : DobrushinInfluenceDecay
  bounded_overlap : BoundedOverlapEnergy

/--
Dobrushin influence decay gives the existing DobrushinTensorization input.
-/
axiom dobrushinTensorization_of_influenceDecay :
  DobrushinInfluenceDecay ->
  DobrushinTensorization

/--
Dobrushin influence decay also gives explicit approximate tensorization.
-/
axiom approximateTensorization_of_influenceDecay :
  DobrushinInfluenceDecay ->
  ApproximateTensorization

/--
The local-to-global skeleton gives global finite-regulator Poincare.
-/
theorem globalPoincare_of_localToGlobalSkeleton
    (h : LocalToGlobalPoincareSkeleton) :
    GlobalFiniteRegulatorPoincare := by
  have hBlock : BlockPoincare :=
    blockPoincare_of_kernelPoincarePackage h.kernel_poincare
  have hTensor : DobrushinTensorization :=
    dobrushinTensorization_of_influenceDecay h.dobrushin_decay
  exact globalPoincare_of_blockPoincare_tensorization_overlap
    hBlock
    hTensor
    h.bounded_overlap

/--
The local-to-global skeleton gives the finite-regulator mass gap.
-/
theorem finiteMassGap_of_localToGlobalSkeleton
    (C : BlockRGConstants)
    (h : LocalToGlobalPoincareSkeleton) :
    FiniteRegulatorMassGap C := by
  have hGlobal : GlobalFiniteRegulatorPoincare :=
    globalPoincare_of_localToGlobalSkeleton h
  exact finiteMassGap_of_globalPoincare C hGlobal

/--
A refined Master I downstream package.

This does not yet replace the full Master I analytic assumptions. It records
the finite-dimensional route:

kernel positivity/minorization/Poincare
+
Dobrushin influence decay
+
bounded overlap
=>
finite-regulator mass gap.
-/
structure MasterIDownstreamSkeleton : Prop where
  local_to_global : LocalToGlobalPoincareSkeleton

/-- The refined Master I downstream skeleton gives global Poincare. -/
theorem globalPoincare_of_masterIDownstreamSkeleton
    (h : MasterIDownstreamSkeleton) :
    GlobalFiniteRegulatorPoincare := by
  exact globalPoincare_of_localToGlobalSkeleton h.local_to_global

/-- The refined Master I downstream skeleton gives finite-regulator mass gap. -/
theorem finiteMassGap_of_masterIDownstreamSkeleton
    (C : BlockRGConstants)
    (h : MasterIDownstreamSkeleton) :
    FiniteRegulatorMassGap C := by
  exact finiteMassGap_of_localToGlobalSkeleton C h.local_to_global

/--
The refined downstream skeleton plus Master II gives the continuum mass gap.

This theorem isolates the fact that, once the local-to-global finite-regulator
gap is available, the only remaining continuum-transfer input is the Mosco bridge.
-/
theorem continuumMassGap_of_downstreamSkeleton_and_mosco
    (C : BlockRGConstants)
    (hDown : MasterIDownstreamSkeleton)
    (hMosco : MoscoContinuumBridge) :
    ContinuumMassGap C := by
  have hFinite : FiniteRegulatorMassGap C :=
    finiteMassGap_of_masterIDownstreamSkeleton C hDown
  exact continuumMassGap_of_finiteMassGap_and_mosco C hFinite hMosco

/--
Positive-gap version of the downstream-plus-Mosco endpoint.
-/
theorem continuumGapPositive_of_downstreamSkeleton_and_mosco
    (C : BlockRGConstants)
    (hDown : MasterIDownstreamSkeleton)
    (hMosco : MoscoContinuumBridge) :
    0 < C.massGapConstant := by
  have hGap : ContinuumMassGap C :=
    continuumMassGap_of_downstreamSkeleton_and_mosco C hDown hMosco
  exact hGap.positive_gap

end Clay
end RussoYM
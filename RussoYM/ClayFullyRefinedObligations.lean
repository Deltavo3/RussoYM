import RussoYM.ClayRefinedEndpoint

/-!
# Clay Fully Refined Obligations

This file gives a more integrated refined endpoint.

It keeps the upstream constructive-RG bookkeeping visible:

A: fixed-scale Wilson/block limits
C: renormalized block potential regularity
D: C^2 irrelevant remainder control
E: quasi-local and boundary-local influence

and combines it with the refined finite-regulator downstream skeleton:

B-refined: kernel positivity + Doeblin minorization + block Poincare
bounded overlap
Dobrushin influence decay

and the refined Mosco bridge skeleton:

F1 + F2 + F3.

Status note:

This is still conditional.  The upstream analytic proof that A,C,D,E generate
the refined kernel/Poincare/local-to-global package is not proved here.
This file records the refined obligation structure and endpoint assembly.
-/

namespace RussoYM
namespace Clay

/--
The upstream constructive-RG bookkeeping that remains part of Master I.

These fields record the parts of constructive RG that eventually need to produce
the refined downstream finite-regulator package.
-/
structure ConstructiveRGUpstreamBookkeeping : Prop where
  A_fixed_scale_limits : FixedScaleWilsonBlockLimits
  C_potential_regular : RenormalizedBlockPotentialRegularity
  D_irrelevant_remainder : CTwoIrrelevantRemainderControl
  E_quasi_local_boundary : QuasiLocalBoundaryInfluence

/--
Quasi-local and boundary-local influence should produce Dobrushin influence decay.

This is still an analytic assumption at this stage.
-/
axiom dobrushinInfluenceDecay_of_quasiLocalBoundary :
  QuasiLocalBoundaryInfluence ->
  DobrushinInfluenceDecay

/--
The fully refined Master I package currently used by the refined endpoint.

It contains:

1. upstream constructive-RG bookkeeping;
2. refined kernel positivity / minorization / block-Poincare package;
3. bounded-overlap energy comparison.
-/
structure MasterIFullyRefinedSkeleton : Prop where
  upstream : ConstructiveRGUpstreamBookkeeping
  kernel_poincare : KernelPositivityWithBlockPoincare
  bounded_overlap : BoundedOverlapEnergy

/--
Convert the fully refined Master I skeleton into the downstream skeleton used by
the refined endpoint.
-/
theorem masterIDownstreamSkeleton_of_fullyRefinedMasterI
    (h : MasterIFullyRefinedSkeleton) :
    MasterIDownstreamSkeleton := by
  have hDob : DobrushinInfluenceDecay :=
    dobrushinInfluenceDecay_of_quasiLocalBoundary
      h.upstream.E_quasi_local_boundary
  let hLocal : LocalToGlobalPoincareSkeleton := {
    kernel_poincare := h.kernel_poincare
    dobrushin_decay := hDob
    bounded_overlap := h.bounded_overlap
  }
  exact {
    local_to_global := hLocal
  }

/--
The fully refined Clay obligation package.

This combines:

Master I fully refined skeleton
+
Master II Mosco skeleton.
-/
structure ClayFullyRefinedObligations : Prop where
  masterI : MasterIFullyRefinedSkeleton
  masterII : MoscoBridgeSkeleton

/--
Convert the fully refined obligation package into the refined endpoint obligation
package.
-/
theorem refinedEndpointObligations_of_fullyRefinedObligations
    (h : ClayFullyRefinedObligations) :
    ClayRefinedEndpointObligations := by
  exact {
    masterI_downstream :=
      masterIDownstreamSkeleton_of_fullyRefinedMasterI h.masterI
    masterII_mosco := h.masterII
  }

/--
Fully refined conditional endpoint.

The fully refined Master I skeleton plus the refined Mosco skeleton imply the
continuum Yang-Mills mass gap endpoint.
-/
theorem clayYangMillsMassGap_fullyRefined
    (C : BlockRGConstants)
    (h : ClayFullyRefinedObligations) :
    ContinuumMassGap C := by
  have hRefined : ClayRefinedEndpointObligations :=
    refinedEndpointObligations_of_fullyRefinedObligations h
  exact clayYangMillsMassGap_refinedEndpoint C hRefined

/--
Positive-gap corollary of the fully refined endpoint.
-/
theorem clayYangMillsGapPositive_fullyRefined
    (C : BlockRGConstants)
    (h : ClayFullyRefinedObligations) :
    0 < C.massGapConstant := by
  have hGap : ContinuumMassGap C :=
    clayYangMillsMassGap_fullyRefined C h
  exact hGap.positive_gap

end Clay
end RussoYM
import RussoYM.ClayDobrushinTensorizationPlaceholder

/-!
# Clay Downstream Placeholder Endpoint

This file packages the finite-regulator downstream placeholder route.

It records the current no-axiom placeholder chain:

MasterIDownstreamSkeleton
=>
LocalToGlobalPoincareSkeleton
=>
GlobalFiniteRegulatorPoincare
=>
FiniteRegulatorMassGap C

Important status note:

This still uses placeholder structures with `True` fields.  It does not prove the
real finite-dimensional probability estimates yet.

Its purpose is to isolate the downstream endpoint that will later be replaced by
real Doeblin, Dobrushin, tensorization, and Poincare proofs.
-/

namespace RussoYM
namespace Clay

/--
Packaged downstream placeholder input.

At this stage this is just the downstream skeleton, but naming it separately
makes the proof architecture easier to audit.
-/
structure ClayDownstreamPlaceholderObligations : Prop where
  downstream : MasterIDownstreamSkeleton

/--
The downstream placeholder route gives global finite-regulator Poincare.
-/
theorem globalPoincare_of_downstreamPlaceholderObligations
    (h : ClayDownstreamPlaceholderObligations) :
    GlobalFiniteRegulatorPoincare := by
  exact globalPoincare_of_localToGlobalSkeleton_placeholder
    h.downstream.local_to_global

/--
The downstream placeholder route gives the finite-regulator mass gap.
-/
theorem finiteRegulatorMassGap_of_downstreamPlaceholderObligations
    (C : BlockRGConstants)
    (h : ClayDownstreamPlaceholderObligations) :
    FiniteRegulatorMassGap C := by
  exact finiteMassGap_of_masterIDownstreamSkeleton_placeholder
    C
    h.downstream

/--
Readable direct version:

MasterIDownstreamSkeleton
=>
FiniteRegulatorMassGap C.
-/
theorem finiteRegulatorMassGap_of_masterIDownstreamPlaceholder
    (C : BlockRGConstants)
    (h : MasterIDownstreamSkeleton) :
    FiniteRegulatorMassGap C := by
  exact finiteMassGap_of_masterIDownstreamSkeleton_placeholder C h

end Clay
end RussoYM
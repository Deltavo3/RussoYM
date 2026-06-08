import RussoYM.ClayDownstreamPlaceholderEndpoint
import RussoYM.ClayMoscoBridgeSkeleton

/-!
# Clay Continuum Placeholder Endpoint

This file connects the finite-regulator downstream placeholder endpoint to the
refined Mosco bridge skeleton.

Current placeholder route:

ClayDownstreamPlaceholderObligations
+
MoscoBridgeSkeleton
=>
ContinuumMassGap C

Important status note:

The downstream side is still placeholder-level.  It uses the current abstract
finite-dimensional probability placeholders rather than real Markov-kernel,
Dobrushin, tensorization, and Poincare estimates.

The purpose of this file is to isolate the continuum-facing placeholder bridge:

finite-regulator placeholder mass gap
+
Mosco continuum bridge
=>
continuum mass gap.
-/

namespace RussoYM
namespace Clay

/--
Continuum-facing placeholder obligations.

This combines:

1. the downstream finite-regulator placeholder endpoint;
2. the refined Mosco bridge skeleton.
-/
structure ClayContinuumPlaceholderObligations : Prop where
  downstream : ClayDownstreamPlaceholderObligations
  mosco : MoscoBridgeSkeleton

/--
The continuum-facing placeholder endpoint.

Downstream placeholder mass gap plus Mosco bridge implies continuum mass gap.
-/
theorem continuumMassGap_of_continuumPlaceholderObligations
    (C : BlockRGConstants)
    (h : ClayContinuumPlaceholderObligations) :
    ContinuumMassGap C := by
  have hFinite : FiniteRegulatorMassGap C :=
    finiteRegulatorMassGap_of_downstreamPlaceholderObligations
      C
      h.downstream
  have hMosco : MoscoContinuumBridge :=
    moscoContinuumBridge_of_moscoBridgeSkeleton h.mosco
  exact continuumMassGap_of_finiteMassGap_and_mosco
    C
    hFinite
    hMosco

/--
Positive-gap corollary of the continuum-facing placeholder endpoint.
-/
theorem continuumGapPositive_of_continuumPlaceholderObligations
    (C : BlockRGConstants)
    (h : ClayContinuumPlaceholderObligations) :
    0 < C.massGapConstant := by
  have hGap : ContinuumMassGap C :=
    continuumMassGap_of_continuumPlaceholderObligations C h
  exact hGap.positive_gap

/--
Readable two-hypothesis version.
-/
theorem clayYangMillsMassGap_of_downstreamPlaceholder_and_mosco
    (C : BlockRGConstants)
    (hDown : ClayDownstreamPlaceholderObligations)
    (hMosco : MoscoBridgeSkeleton) :
    ContinuumMassGap C := by
  exact continuumMassGap_of_continuumPlaceholderObligations C {
    downstream := hDown
    mosco := hMosco
  }

/--
Readable two-hypothesis positive-gap corollary.
-/
theorem clayYangMillsGapPositive_of_downstreamPlaceholder_and_mosco
    (C : BlockRGConstants)
    (hDown : ClayDownstreamPlaceholderObligations)
    (hMosco : MoscoBridgeSkeleton) :
    0 < C.massGapConstant := by
  have hGap : ContinuumMassGap C :=
    clayYangMillsMassGap_of_downstreamPlaceholder_and_mosco
      C
      hDown
      hMosco
  exact hGap.positive_gap

end Clay
end RussoYM
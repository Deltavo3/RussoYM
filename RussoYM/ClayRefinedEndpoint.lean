import RussoYM.ClayMoscoBridgeSkeleton

/-!
# Clay Refined Endpoint

This file records the current post-refinement endpoint.

It uses the refined finite-regulator downstream skeleton together with the refined
Mosco bridge skeleton:

MasterIDownstreamSkeleton + MoscoBridgeSkeleton -> ContinuumMassGap.

Important status note:

This is not yet the full constructive RG proof.  It assumes the downstream
finite-regulator skeleton directly.  The remaining upstream task is still to
prove that the constructive fixed-scale RG assumptions produce this downstream
skeleton.
-/

namespace RussoYM
namespace Clay

/--
The refined endpoint obligations currently needed for the post-refinement route.

This package combines:

1. the finite-regulator downstream skeleton;
2. the refined Mosco bridge skeleton.
-/
structure ClayRefinedEndpointObligations : Prop where
  masterI_downstream : MasterIDownstreamSkeleton
  masterII_mosco : MoscoBridgeSkeleton

/--
Refined endpoint theorem.

The finite-regulator downstream skeleton plus the refined Mosco bridge skeleton
imply the continuum Yang-Mills mass gap endpoint.
-/
theorem clayYangMillsMassGap_refinedEndpoint
    (C : BlockRGConstants)
    (h : ClayRefinedEndpointObligations) :
    ContinuumMassGap C := by
  exact continuumMassGap_of_downstreamSkeleton_and_moscoSkeleton
    C
    h.masterI_downstream
    h.masterII_mosco

/--
Positive-gap corollary of the refined endpoint theorem.
-/
theorem clayYangMillsGapPositive_refinedEndpoint
    (C : BlockRGConstants)
    (h : ClayRefinedEndpointObligations) :
    0 < C.massGapConstant := by
  have hGap : ContinuumMassGap C :=
    clayYangMillsMassGap_refinedEndpoint C h
  exact hGap.positive_gap

/--
Readable version with the two refined hypotheses separated.
-/
theorem clayYangMillsMassGap_of_downstream_and_mosco
    (C : BlockRGConstants)
    (hDown : MasterIDownstreamSkeleton)
    (hMosco : MoscoBridgeSkeleton) :
    ContinuumMassGap C := by
  exact continuumMassGap_of_downstreamSkeleton_and_moscoSkeleton C hDown hMosco

/--
Positive-gap version with the two refined hypotheses separated.
-/
theorem clayYangMillsGapPositive_of_downstream_and_mosco
    (C : BlockRGConstants)
    (hDown : MasterIDownstreamSkeleton)
    (hMosco : MoscoBridgeSkeleton) :
    0 < C.massGapConstant := by
  have hGap : ContinuumMassGap C :=
    clayYangMillsMassGap_of_downstream_and_mosco C hDown hMosco
  exact hGap.positive_gap

end Clay
end RussoYM
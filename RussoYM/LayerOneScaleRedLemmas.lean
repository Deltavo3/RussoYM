import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Layer One Scale Red Lemmas

This file isolates the Layer-One scale-normalization assumptions used in the
Clay-compatible route.

These are bookkeeping/normalization obligations rather than the hard analytic
red lemmas:

1. positivity of the UV block scale,
2. the definition of the Layer-One reference gap `Delta0`.
-/

/--
Layer-One scale-normalization assumptions.
-/
structure LayerOneScaleRedLemmaAssumptions
    (Delta0 dBlock dUV : Real) : Prop where
  hUV_pos :
    0 < dUV
  hDelta0_def :
    Delta0 = (1 / 2) * min dBlock dUV

/--
The Layer-One scale red lemmas imply positivity of the UV scale.
-/
theorem LayerOneScaleRedLemmaAssumptions.imply_uv_positive
    {Delta0 dBlock dUV : Real}
    (h : LayerOneScaleRedLemmaAssumptions Delta0 dBlock dUV) :
    0 < dUV := by
  exact h.hUV_pos

/--
The Layer-One scale red lemmas imply the definition of the reference gap.
-/
theorem LayerOneScaleRedLemmaAssumptions.imply_delta0_def
    {Delta0 dBlock dUV : Real}
    (h : LayerOneScaleRedLemmaAssumptions Delta0 dBlock dUV) :
    Delta0 = (1 / 2) * min dBlock dUV := by
  exact h.hDelta0_def

/--
The Layer-One scale red lemmas imply the paired normalization data.
-/
theorem LayerOneScaleRedLemmaAssumptions.imply_scale_data
    {Delta0 dBlock dUV : Real}
    (h : LayerOneScaleRedLemmaAssumptions Delta0 dBlock dUV) :
    0 < dUV ∧ Delta0 = (1 / 2) * min dBlock dUV := by
  exact ⟨h.hUV_pos, h.hDelta0_def⟩

end RussoYM

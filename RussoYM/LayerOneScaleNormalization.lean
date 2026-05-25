import Mathlib
import RussoYM.LayerOneScaleRedLemmas

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Layer One Scale Normalization

This file reduces the Layer-One scale-normalization packet to more primitive
positive scale data.

The point is to prove the positivity of the Layer-One reference gap

  Delta0 = (1 / 2) * min dBlock dUV

from positivity of the block and UV scales.
-/

/--
Primitive positive scale data for the Layer-One reference gap.
-/
structure LayerOnePositiveScaleAssumptions
    (Delta0 dBlock dUV : Real) : Prop where
  hBlock_pos :
    0 < dBlock
  hUV_pos :
    0 < dUV
  hDelta0_def :
    Delta0 = (1 / 2) * min dBlock dUV

/--
Positive scale data implies the existing Layer-One scale red-lemma packet.
-/
theorem LayerOnePositiveScaleAssumptions.to_scale_red_lemmas
    {Delta0 dBlock dUV : Real}
    (h : LayerOnePositiveScaleAssumptions Delta0 dBlock dUV) :
    LayerOneScaleRedLemmaAssumptions Delta0 dBlock dUV := by
  exact
    { hUV_pos := h.hUV_pos
      hDelta0_def := h.hDelta0_def }

/--
Positive block and UV scales imply positivity of the minimum scale.
-/
theorem LayerOnePositiveScaleAssumptions.imply_min_positive
    {Delta0 dBlock dUV : Real}
    (h : LayerOnePositiveScaleAssumptions Delta0 dBlock dUV) :
    0 < min dBlock dUV := by
  exact lt_min h.hBlock_pos h.hUV_pos

/--
Positive scale data implies positivity of the Layer-One reference gap.
-/
theorem LayerOnePositiveScaleAssumptions.imply_delta0_positive
    {Delta0 dBlock dUV : Real}
    (h : LayerOnePositiveScaleAssumptions Delta0 dBlock dUV) :
    0 < Delta0 := by
  have hmin_pos : 0 < min dBlock dUV := by
    exact LayerOnePositiveScaleAssumptions.imply_min_positive h
  rw [h.hDelta0_def]
  have hhalf_pos : (0 : Real) < (1 / 2) := by
    norm_num
  exact mul_pos hhalf_pos hmin_pos

/--
Positive scale data implies the full scale-normalization checklist.
-/
theorem LayerOnePositiveScaleAssumptions.imply_positive_scale_data
    {Delta0 dBlock dUV : Real}
    (h : LayerOnePositiveScaleAssumptions Delta0 dBlock dUV) :
    0 < dBlock
      ∧ 0 < dUV
      ∧ Delta0 = (1 / 2) * min dBlock dUV
      ∧ 0 < Delta0 := by
  exact
    ⟨h.hBlock_pos,
      h.hUV_pos,
      h.hDelta0_def,
      LayerOnePositiveScaleAssumptions.imply_delta0_positive h⟩

end RussoYM

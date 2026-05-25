import Mathlib
import RussoYM.UniformHolonomyRedLemmas
import RussoYM.LayerOneScaleNormalization
import RussoYM.ContinuumFiniteLowerReduction

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Finite Gap Lower From Holonomy

This file derives the reduced finite lower-bound-only continuum obligation from
the holonomy/coercivity red lemmas and the positive Layer-One scale data.

The key observation is:

  Delta0 <= mu * (delta / C)^2 <= Gap n.

Thus the finite-regulator lower-bound obligation

  forall n, Delta0 <= Gap n

does not need to be assumed separately once the holonomy gap lower bound and
positive scale normalization are available.
-/

/--
Positive Layer-One scale data implies that the reference gap `Delta0` is bounded
above by the block scale `dBlock`.
-/
theorem LayerOnePositiveScaleAssumptions.imply_delta0_le_block
    {Delta0 dBlock dUV : Real}
    (h : LayerOnePositiveScaleAssumptions Delta0 dBlock dUV) :
    Delta0 <= dBlock := by
  have hmin_pos : 0 < min dBlock dUV := by
    exact LayerOnePositiveScaleAssumptions.imply_min_positive h
  have hmin_nonneg : 0 <= min dBlock dUV := by
    exact le_of_lt hmin_pos
  have hhalf_le_one : (1 / 2 : Real) <= 1 := by
    norm_num
  rw [h.hDelta0_def]
  calc
    (1 / 2 : Real) * min dBlock dUV
        <= 1 * min dBlock dUV := by
          exact mul_le_mul_of_nonneg_right hhalf_le_one hmin_nonneg
    _ = min dBlock dUV := by
          ring
    _ <= dBlock := by
          exact min_le_left dBlock dUV

/--
Holonomy/coercivity red lemmas plus positive scale data imply the reduced
finite lower-bound-only continuum obligation.
-/
theorem FiniteGapLowerOnlyAssumptions.from_holonomy_and_positive_scale
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {Delta0 dUV C mu delta : Real}
    (hHolonomy :
      UniformHolonomyRedLemmaAssumptions
        links Gap Energy curvatureNorm C mu delta)
    (hScale :
      LayerOnePositiveScaleAssumptions
        Delta0 (mu * (delta / C)^2) dUV) :
    FiniteGapLowerOnlyAssumptions Delta0 Gap := by
  have hDelta0_le_block :
      Delta0 <= mu * (delta / C)^2 := by
    exact LayerOnePositiveScaleAssumptions.imply_delta0_le_block hScale
  have hBlock_le_gap :
      forall n, mu * (delta / C)^2 <= Gap n := by
    exact (UniformHolonomyRedLemmaAssumptions.imply_uniform_positive_gap hHolonomy).1
  exact
    { finite_gap_lower := fun n =>
        le_trans hDelta0_le_block (hBlock_le_gap n) }

end RussoYM

import Mathlib
import RussoYM.AlgebraCore

set_option linter.style.whitespace false
set_option linter.style.longLine false

namespace RussoYM

/-!
# Proof Skeleton

This file connects the algebra core to the conditional YM gap-lifting structure.

It does not prove the analytic/RG parts.
It verifies the algebraic closure:

block gap positive + UV gap positive + small mixing
=> fine-lattice gap lower bound positive.
-/

/-
If both the block gap and UV gap are positive, then the decoupled gap

  min DeltaBlock DeltaUV

is positive.
-/
theorem decoupled_gap_positive
    {DeltaBlock DeltaUV : Real}
    (hBlock : 0 < DeltaBlock)
    (hUV : 0 < DeltaUV) :
    0 < min DeltaBlock DeltaUV := by
  exact lt_min hBlock hUV

/-
Gap lifting algebra.

If the block/UV mixing is smaller than the decoupled gap, then the lifted
fine gap lower bound is positive.
-/
theorem gap_lifting_lower_bound_positive
    {DeltaBlock DeltaUV Clift omega : Real}
    (hBlock : 0 < DeltaBlock)
    (hUV : 0 < DeltaUV)
    (hsmall : Clift * omega < min DeltaBlock DeltaUV) :
    0 < min DeltaBlock DeltaUV - Clift * omega := by
  have hdec : 0 < min DeltaBlock DeltaUV := by
    exact decoupled_gap_positive hBlock hUV
  exact sub_pos.mpr hsmall

/-
UV-scale version.

If the UV gap lower bound has the form

  cUV / ell

with `cUV > 0` and `ell > 0`, then gap lifting gives a positive fine gap
whenever the mixing is smaller than the decoupled gap.
-/
theorem gap_lifting_with_uv_scale
    {DeltaBlock cUV ell Clift omega : Real}
    (hBlock : 0 < DeltaBlock)
    (hcUV : 0 < cUV)
    (hell : 0 < ell)
    (hsmall : Clift * omega < min DeltaBlock (cUV / ell)) :
    0 < min DeltaBlock (cUV / ell) - Clift * omega := by
  have hUV : 0 < cUV / ell := by
    exact div_pos hcUV hell
  exact gap_lifting_lower_bound_positive hBlock hUV hsmall

/-
Raw YM algebraic closure.

This combines:

1. quadratic strong-coupling condition;
2. block-gap positivity;
3. UV positivity `cUV / ell`;
4. small mixing.

Conclusion:

the fine-lattice gap lower bound is positive.
-/
theorem raw_gap_algebraic_closure
    {Ccl r Cloc lambdaPhys g2 cUV ell Clift omega : Real}
    (hg2 : 0 < g2)
    (hquad : Ccl * Cloc + Ccl * r * g2 < lambdaPhys * g2^2)
    (hcUV : 0 < cUV)
    (hell : 0 < ell)
    (hsmall :
      Clift * omega <
        min
          (g2 * (lambdaPhys - Ccl * (Cloc / g2^2 + r / g2)))
          (cUV / ell)) :
    0 <
      min
        (g2 * (lambdaPhys - Ccl * (Cloc / g2^2 + r / g2)))
        (cUV / ell)
      - Clift * omega := by
  have hBlock :
      0 < g2 * (lambdaPhys - Ccl * (Cloc / g2^2 + r / g2)) := by
    exact block_gap_positive_from_quadratic hg2 hquad
  exact gap_lifting_with_uv_scale hBlock hcUV hell hsmall

end RussoYM

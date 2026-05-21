import Mathlib
import RussoYM.AlgebraCore

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Strong-Coupling Threshold

This file proves the square-root threshold bridge.

We already proved in `AlgebraCore.lean`:

  C * Cloc + C * r * x < lambda * x^2
  =>
  C * (Cloc / x^2 + r / x) < lambda

Here we prove that the usual positive-root condition implies the quadratic
inequality.
-/

/-
If the square-root expression is below `2 * lambda * x - C * r`, then the
quadratic strong-coupling inequality holds.
-/
theorem quadratic_positive_from_sqrt_bound
    {C r Cloc lambda x : Real}
    (hC : 0 < C)
    (hCloc : 0 < Cloc)
    (hlambda : 0 < lambda)
    (hsqrt :
      Real.sqrt ((C * r)^2 + 4 * lambda * C * Cloc)
        < 2 * lambda * x - C * r) :
    C * Cloc + C * r * x < lambda * x^2 := by
  let disc : Real := (C * r)^2 + 4 * lambda * C * Cloc

  have hsqrt_disc :
      Real.sqrt disc < 2 * lambda * x - C * r := by
    simpa [disc] using hsqrt

  have hterm_pos : 0 < 4 * lambda * C * Cloc := by
    have h4 : 0 < (4 : Real) := by norm_num
    exact mul_pos (mul_pos (mul_pos h4 hlambda) hC) hCloc

  have hdisc_nonneg : 0 <= disc := by
    dsimp [disc]
    nlinarith [sq_nonneg (C * r), le_of_lt hterm_pos]

  have hsqrt_nonneg : 0 <= Real.sqrt disc := by
    exact Real.sqrt_nonneg disc

  have hdiff_pos :
      0 < (2 * lambda * x - C * r) - Real.sqrt disc := by
    exact sub_pos.mpr hsqrt_disc

  have hsum_pos :
      0 < (2 * lambda * x - C * r) + Real.sqrt disc := by
    linarith

  have hprod_pos :
      0 <
        ((2 * lambda * x - C * r) - Real.sqrt disc) *
        ((2 * lambda * x - C * r) + Real.sqrt disc) := by
    exact mul_pos hdiff_pos hsum_pos

  have hsquare :
      (Real.sqrt disc)^2 < (2 * lambda * x - C * r)^2 := by
    nlinarith [hprod_pos]

  have hsqrt_sq : (Real.sqrt disc)^2 = disc := by
    exact Real.sq_sqrt hdisc_nonneg

  have hsquare_expanded :
      (C * r)^2 + 4 * lambda * C * Cloc
        < (2 * lambda * x - C * r)^2 := by
    rw [hsqrt_sq] at hsquare
    simpa [disc] using hsquare

  nlinarith [hsquare_expanded, hlambda]

/-
The positive-root threshold implies the quadratic strong-coupling inequality.

This proves:

  x > (C*r + sqrt((C*r)^2 + 4*lambda*C*Cloc)) / (2*lambda)

implies

  C*Cloc + C*r*x < lambda*x^2.
-/
theorem quadratic_positive_from_sqrt_threshold
    {C r Cloc lambda x : Real}
    (hC : 0 < C)
    (hCloc : 0 < Cloc)
    (hlambda : 0 < lambda)
    (hcross :
      (C * r + Real.sqrt ((C * r)^2 + 4 * lambda * C * Cloc))
        / (2 * lambda) < x) :
    C * Cloc + C * r * x < lambda * x^2 := by
  have hden_pos : 0 < 2 * lambda := by
    nlinarith
  have hmul :
      ((C * r + Real.sqrt ((C * r)^2 + 4 * lambda * C * Cloc))
        / (2 * lambda)) * (2 * lambda)
        < x * (2 * lambda) := by
    exact mul_lt_mul_of_pos_right hcross hden_pos
  have hleft :
      ((C * r + Real.sqrt ((C * r)^2 + 4 * lambda * C * Cloc))
        / (2 * lambda)) * (2 * lambda)
        =
      C * r + Real.sqrt ((C * r)^2 + 4 * lambda * C * Cloc) := by
    field_simp [ne_of_gt hden_pos]
  rw [hleft] at hmul
  have hsqrt :
      Real.sqrt ((C * r)^2 + 4 * lambda * C * Cloc)
        < 2 * lambda * x - C * r := by
    nlinarith
  exact quadratic_positive_from_sqrt_bound hC hCloc hlambda hsqrt

/-
Full square-root threshold theorem.

This directly proves the stability inequality from the root threshold.
We keep `hx : 0 < x` as an explicit assumption because the later division
inequality needs it.
-/
theorem strong_coupling_from_sqrt_threshold
    {C r Cloc lambda x : Real}
    (hC : 0 < C)
    (hCloc : 0 < Cloc)
    (hlambda : 0 < lambda)
    (hx : 0 < x)
    (hcross :
      (C * r + Real.sqrt ((C * r)^2 + 4 * lambda * C * Cloc))
        / (2 * lambda) < x) :
    C * (Cloc / x^2 + r / x) < lambda := by
  have hquad :
      C * Cloc + C * r * x < lambda * x^2 := by
    exact quadratic_positive_from_sqrt_threshold hC hCloc hlambda hcross
  exact strong_coupling_from_quadratic hx hquad

end RussoYM

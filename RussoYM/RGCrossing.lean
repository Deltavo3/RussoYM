import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false

namespace RussoYM

/-!
# RG Crossing Algebra

This file formalizes the simple algebra behind controlled RG crossing.

It does not prove Yang--Mills RG control.
It only proves that if inverse coupling decreases by a fixed positive amount,
then after one step it is strictly smaller.
-/

/-
One-step inverse coupling decrease.

If

  yNext <= y - step

and `step > 0`, then

  yNext < y.
-/
theorem inverse_coupling_strict_decrease
    {y yNext step : Real}
    (hstep : 0 < step)
    (hdec : yNext <= y - step) :
    yNext < y := by
  have hsub : y - step < y := by
    linarith
  exact lt_of_le_of_lt hdec hsub

/-
Controlled RG one-step bound.

If

  yNext = y - betaLog + R

and

  R <= theta * betaLog,

then

  yNext <= y - (1 - theta) * betaLog.
-/
theorem controlled_rg_step_bound
    {y yNext betaLog R theta : Real}
    (hEq : yNext = y - betaLog + R)
    (hR : R <= theta * betaLog) :
    yNext <= y - (1 - theta) * betaLog := by
  rw [hEq]
  have hmain : y - betaLog + R <= y - betaLog + theta * betaLog := by
    linarith
  have hrewrite : y - betaLog + theta * betaLog = y - (1 - theta) * betaLog := by
    ring
  calc
    y - betaLog + R <= y - betaLog + theta * betaLog := hmain
    _ = y - (1 - theta) * betaLog := hrewrite

/-lake build
Controlled RG one-step strict decrease.

If the remainder is controlled by

  R <= theta * betaLog,

with `theta < 1` and `betaLog > 0`, then inverse coupling strictly decreases.
-/
theorem controlled_rg_inverse_decreases
    {y yNext betaLog R theta : Real}
    (hEq : yNext = y - betaLog + R)
    (hR : R <= theta * betaLog)
    (hTheta : theta < 1)
    (hBeta : 0 < betaLog) :
    yNext < y := by
  have hstep_pos : 0 < (1 - theta) * betaLog := by
    have hone : 0 < 1 - theta := by
      linarith
    exact mul_pos hone hBeta
  have hbound : yNext <= y - (1 - theta) * betaLog := by
    exact controlled_rg_step_bound hEq hR
  exact inverse_coupling_strict_decrease hstep_pos hbound

end RussoYM

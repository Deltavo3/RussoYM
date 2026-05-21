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

/-
Finite-step inverse coupling bound.

If each RG step lowers inverse coupling by at least `step`, then after `n`
steps we have

  y n <= y 0 - n * step.
-/
theorem inverse_coupling_linear_bound
    (y : Nat -> Real)
    {step : Real}
    (hstep : forall n, y (Nat.succ n) <= y n - step) :
    forall n, y n <= y 0 - (n : Real) * step := by
  intro n
  induction n with
  | zero =>
      simp
  | succ n ih =>
      have hs : y (Nat.succ n) <= y n - step := hstep n
      have hnext : y (Nat.succ n) <= y 0 - (n : Real) * step - step := by
        linarith
      calc
        y (Nat.succ n) <= y 0 - (n : Real) * step - step := hnext
        _ = y 0 - ((Nat.succ n : Nat) : Real) * step := by
          rw [Nat.cast_succ]
          ring

/-
Finite-step crossing criterion.

If the linear upper bound is already below a threshold, then the actual
inverse coupling is below that threshold too.
-/
theorem inverse_coupling_crosses_below
    (y : Nat -> Real)
    {step threshold : Real}
    (hstep : forall n, y (Nat.succ n) <= y n - step)
    {n : Nat}
    (hcross : y 0 - (n : Real) * step < threshold) :
    y n < threshold := by
  have hlin : y n <= y 0 - (n : Real) * step := by
    exact inverse_coupling_linear_bound y hstep n
  exact lt_of_le_of_lt hlin hcross

/-
Controlled RG finite-step bound.

If

  y_{n+1} = y_n - betaLog + R_n

and

  R_n <= theta * betaLog,

then

  y_n <= y_0 - n * ((1 - theta) * betaLog).
-/
theorem controlled_rg_linear_bound
    (y R : Nat -> Real)
    {betaLog theta : Real}
    (hEq : forall n, y (Nat.succ n) = y n - betaLog + R n)
    (hR : forall n, R n <= theta * betaLog) :
    forall n, y n <= y 0 - (n : Real) * ((1 - theta) * betaLog) := by
  apply inverse_coupling_linear_bound
  intro n
  exact controlled_rg_step_bound (hEq n) (hR n)

/-
Controlled RG finite crossing criterion.

If the controlled RG linear bound lies below a threshold at step `n`,
then the actual inverse coupling lies below that threshold at step `n`.
-/
theorem controlled_rg_crosses_below
    (y R : Nat -> Real)
    {betaLog theta threshold : Real}
    (hEq : forall n, y (Nat.succ n) = y n - betaLog + R n)
    (hR : forall n, R n <= theta * betaLog)
    {n : Nat}
    (hcross :
      y 0 - (n : Real) * ((1 - theta) * betaLog) < threshold) :
    y n < threshold := by
  have hlin :
      y n <= y 0 - (n : Real) * ((1 - theta) * betaLog) := by
    exact controlled_rg_linear_bound y R hEq hR n
  exact lt_of_le_of_lt hlin hcross

/-
Controlled RG decreases at every step.

This is the per-step monotonicity form.
-/
theorem controlled_rg_decreases_each_step
    (y R : Nat -> Real)
    {betaLog theta : Real}
    (hEq : forall n, y (Nat.succ n) = y n - betaLog + R n)
    (hR : forall n, R n <= theta * betaLog)
    (hTheta : theta < 1)
    (hBeta : 0 < betaLog) :
    forall n, y (Nat.succ n) < y n := by
  intro n
  exact controlled_rg_inverse_decreases (hEq n) (hR n) hTheta hBeta

end RussoYM

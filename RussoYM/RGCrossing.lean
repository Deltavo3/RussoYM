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

/-
Inverse-coupling threshold conversion.

If

  y = 1 / u

and

  y < 1 / x

with `u > 0` and `x > 0`, then

  x < u.

This is the algebraic bridge from

  y_n < 1 / x_stab

to

  u_n > x_stab.
-/
theorem coupling_crosses_from_inverse
    {u x y : Real}
    (hu : 0 < u)
    (hx : 0 < x)
    (hy : y = 1 / u)
    (hcross : y < 1 / x) :
    x < u := by
  rw [hy] at hcross
  have hux_pos : 0 < u * x := by
    exact mul_pos hu hx
  have hmul : (1 / u) * (u * x) < (1 / x) * (u * x) := by
    exact mul_lt_mul_of_pos_right hcross hux_pos
  have hleft : (1 / u) * (u * x) = x := by
    field_simp [ne_of_gt hu]
  have hright : (1 / x) * (u * x) = u := by
    field_simp [ne_of_gt hx]
  rw [hleft, hright] at hmul
  exact hmul

/-
Controlled RG reaches the coupling threshold.

If the controlled RG linear bound puts inverse coupling below `1 / xstab`,
and `y n = 1 / u n`, then the actual coupling satisfies

  xstab < u n.
-/
theorem controlled_rg_coupling_crosses
    (y R u : Nat -> Real)
    {betaLog theta xstab : Real}
    (hEq : forall n, y (Nat.succ n) = y n - betaLog + R n)
    (hR : forall n, R n <= theta * betaLog)
    (hRel : forall n, y n = 1 / u n)
    (hxstab : 0 < xstab)
    {n : Nat}
    (hupos : 0 < u n)
    (hcross :
      y 0 - (n : Real) * ((1 - theta) * betaLog) < 1 / xstab) :
    xstab < u n := by
  have hy_lt : y n < 1 / xstab := by
    exact controlled_rg_crosses_below y R hEq hR hcross
  exact coupling_crosses_from_inverse hupos hxstab (hRel n) hy_lt

/-
Existence of a finite crossing step.

If `step > 0`, then for any initial value `y0` and any threshold,
there exists a natural number `n` such that

  y0 - n * step < threshold.
-/
theorem exists_finite_step_crossing
    {y0 threshold step : Real}
    (hstep : 0 < step) :
    exists n : Nat, y0 - (n : Real) * step < threshold := by
  obtain ⟨n, hn⟩ := exists_nat_gt ((y0 - threshold) / step)
  use n
  have hmul :
      ((y0 - threshold) / step) * step < (n : Real) * step := by
    exact mul_lt_mul_of_pos_right hn hstep
  have hleft : ((y0 - threshold) / step) * step = y0 - threshold := by
    field_simp [ne_of_gt hstep]
  rw [hleft] at hmul
  linarith

/-
If inverse coupling decreases by at least a fixed positive step every time,
then it eventually falls below any threshold.
-/
theorem inverse_coupling_eventually_below
    (y : Nat -> Real)
    {step threshold : Real}
    (hstep_pos : 0 < step)
    (hstep : forall n, y (Nat.succ n) <= y n - step) :
    exists n : Nat, y n < threshold := by
  obtain ⟨n, hn⟩ :=
    exists_finite_step_crossing (y0 := y 0) (threshold := threshold) hstep_pos
  use n
  exact inverse_coupling_crosses_below y hstep hn

/-
Controlled RG eventually drives inverse coupling below any threshold,
provided the controlled step size is positive.
-/
theorem controlled_rg_eventually_below
    (y R : Nat -> Real)
    {betaLog theta threshold : Real}
    (hEq : forall n, y (Nat.succ n) = y n - betaLog + R n)
    (hR : forall n, R n <= theta * betaLog)
    (hTheta : theta < 1)
    (hBeta : 0 < betaLog) :
    exists n : Nat, y n < threshold := by
  have hstep_pos : 0 < (1 - theta) * betaLog := by
    have hone : 0 < 1 - theta := by
      linarith
    exact mul_pos hone hBeta
  have hstep :
      forall n, y (Nat.succ n) <= y n - ((1 - theta) * betaLog) := by
    intro n
    exact controlled_rg_step_bound (hEq n) (hR n)
  exact inverse_coupling_eventually_below y hstep_pos hstep

/-
Controlled RG eventually crosses the coupling threshold.

If `y n = 1 / u n`, all `u n` are positive, and the controlled RG
hypotheses hold, then eventually

  xstab < u n.
-/
theorem controlled_rg_eventually_coupling_crosses
    (y R u : Nat -> Real)
    {betaLog theta xstab : Real}
    (hEq : forall n, y (Nat.succ n) = y n - betaLog + R n)
    (hR : forall n, R n <= theta * betaLog)
    (hRel : forall n, y n = 1 / u n)
    (hupos : forall n, 0 < u n)
    (hxstab : 0 < xstab)
    (hTheta : theta < 1)
    (hBeta : 0 < betaLog) :
    exists n : Nat, xstab < u n := by
  obtain ⟨n, hn⟩ :=
    controlled_rg_eventually_below
      y R
      (threshold := 1 / xstab)
      hEq hR hTheta hBeta
  use n
  exact coupling_crosses_from_inverse (hupos n) hxstab (hRel n) hn

/-
Controlled RG eventually crosses a positive margin above the coupling threshold.

If the controlled RG hypotheses imply eventual crossing of every positive
threshold, then in particular the coupling eventually crosses

  (1 + sigma) * xstab

whenever sigma and xstab are positive.
-/
theorem controlled_rg_eventually_margin_coupling_crosses
    (y R u : Nat -> Real)
    {betaLog theta sigma xstab : Real}
    (hEq : forall n, y (Nat.succ n) = y n - betaLog + R n)
    (hR : forall n, R n <= theta * betaLog)
    (hRel : forall n, y n = 1 / u n)
    (hupos : forall n, 0 < u n)
    (hsigma : 0 < sigma)
    (hxstab : 0 < xstab)
    (hTheta : theta < 1)
    (hBeta : 0 < betaLog) :
    exists n : Nat, (1 + sigma) * xstab < u n := by
  have htarget_pos : 0 < (1 + sigma) * xstab := by
    have hone_pos : 0 < 1 + sigma := by
      linarith
    exact mul_pos hone_pos hxstab
  exact
    controlled_rg_eventually_coupling_crosses
      y R u hEq hR hRel hupos htarget_pos hTheta hBeta

end RussoYM

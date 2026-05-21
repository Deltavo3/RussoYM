import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false

namespace RussoYM

/-!
# Product Deviation

This file starts the formalization of the product-deviation estimate.

The full operator theorem will eventually be:

  ||I - product A_i||^2 <= m * sum_i ||I - A_i||^2

For now, we first prove the real-number inequalities that support the
two-factor case.
-/

/-
Basic two-term square estimate.

For real numbers `a` and `b`,

  (a + b)^2 <= 2 * (a^2 + b^2).

This is the algebraic core of the two-term Cauchy--Schwarz estimate.
-/
theorem square_sum_two_le
    (a b : Real) :
    (a + b)^2 <= 2 * (a^2 + b^2) := by
  nlinarith [sq_nonneg (a - b)]

/-
Two-factor deviation bound in abstract real form.

If

  dAB <= dA + dB,

and all deviations are nonnegative, then

  dAB^2 <= 2 * (dA^2 + dB^2).

This abstracts:

  ||I - AB|| <= ||I - A|| + ||I - B||

for unitary/isometric multiplication.
-/
theorem two_factor_deviation_bound
    {dAB dA dB : Real}
    (hdAB_nonneg : 0 <= dAB)
    (hdA_nonneg : 0 <= dA)
    (hdB_nonneg : 0 <= dB)
    (htri : dAB <= dA + dB) :
    dAB^2 <= 2 * (dA^2 + dB^2) := by
  have hsum_nonneg : 0 <= dA + dB := by
    linarith
  have hsquare_mono : dAB^2 <= (dA + dB)^2 := by
    nlinarith
  have hsquare_bound : (dA + dB)^2 <= 2 * (dA^2 + dB^2) := by
    exact square_sum_two_le dA dB
  exact le_trans hsquare_mono hsquare_bound

/-
A cleaner version where the triangle inequality has already been squared.

If

  dAB <= dA + dB,

then the square bound follows.
-/
theorem two_factor_deviation_bound_clean
    {dAB dA dB : Real}
    (hdAB_nonneg : 0 <= dAB)
    (hdA_nonneg : 0 <= dA)
    (hdB_nonneg : 0 <= dB)
    (htri : dAB <= dA + dB) :
    dAB^2 <= 2 * dA^2 + 2 * dB^2 := by
  have hmain : dAB^2 <= 2 * (dA^2 + dB^2) := by
    exact two_factor_deviation_bound hdAB_nonneg hdA_nonneg hdB_nonneg htri
  nlinarith

/-
Normed-space version of the two-term square estimate.

If a vector `z` has norm bounded by `||x|| + ||y||`, then

  ||z||^2 <= 2 * (||x||^2 + ||y||^2).
-/
theorem norm_sq_bound_from_triangle
    {V : Type*}
    [SeminormedAddCommGroup V]
    {z x y : V}
    (htri : ‖z‖ <= ‖x‖ + ‖y‖) :
    ‖z‖^2 <= 2 * (‖x‖^2 + ‖y‖^2) := by
  exact two_factor_deviation_bound
    (norm_nonneg z)
    (norm_nonneg x)
    (norm_nonneg y)
    htri

/-
Two-term norm square estimate.

For any two vectors in a seminormed additive commutative group,

  ||x + y||^2 <= 2 * (||x||^2 + ||y||^2).
-/
theorem norm_add_sq_le_two
    {V : Type*}
    [SeminormedAddCommGroup V]
    (x y : V) :
    ‖x + y‖^2 <= 2 * (‖x‖^2 + ‖y‖^2) := by
  have htri : ‖x + y‖ <= ‖x‖ + ‖y‖ := by
    exact norm_add_le x y
  exact norm_sq_bound_from_triangle htri

/-
Two-factor product deviation estimate in a normed ring.

The identity is

  1 - a*b = (1 - a) + a*(1 - b).

If `||a|| <= 1`, then

  ||1 - a*b|| <= ||1 - a|| + ||1 - b||.
-/
theorem norm_one_sub_mul_le
    {R : Type*}
    [NormedRing R]
    (a b : R)
    (ha : ‖a‖ <= 1) :
    ‖1 - a * b‖ <= ‖1 - a‖ + ‖1 - b‖ := by
  have hdecomp : 1 - a * b = (1 - a) + a * (1 - b) := by
    noncomm_ring
  calc
    ‖1 - a * b‖ = ‖(1 - a) + a * (1 - b)‖ := by
      rw [hdecomp]
    _ <= ‖1 - a‖ + ‖a * (1 - b)‖ := by
      exact norm_add_le (1 - a) (a * (1 - b))
    _ <= ‖1 - a‖ + ‖1 - b‖ := by
      have hmul : ‖a * (1 - b)‖ <= ‖a‖ * ‖1 - b‖ := by
        exact norm_mul_le a (1 - b)
      have hmul2 : ‖a‖ * ‖1 - b‖ <= 1 * ‖1 - b‖ := by
        exact mul_le_mul_of_nonneg_right ha (norm_nonneg (1 - b))
      nlinarith

/-
Squared two-factor product deviation estimate.

If `||a|| <= 1`, then

  ||1 - a*b||^2 <= 2 * (||1 - a||^2 + ||1 - b||^2).
-/
theorem two_factor_product_deviation_norm_sq
    {R : Type*}
    [NormedRing R]
    (a b : R)
    (ha : ‖a‖ <= 1) :
    ‖1 - a * b‖^2 <= 2 * (‖1 - a‖^2 + ‖1 - b‖^2) := by
  have htri : ‖1 - a * b‖ <= ‖1 - a‖ + ‖1 - b‖ := by
    exact norm_one_sub_mul_le a b ha
  exact norm_sq_bound_from_triangle htri

/-
Unit-norm version.

If `||a|| = 1`, then the same product deviation estimate holds.
This is the version closest to the unitary/holonomy case.
-/
theorem two_factor_product_deviation_norm_sq_of_norm_eq_one
    {R : Type*}
    [NormedRing R]
    (a b : R)
    (ha : ‖a‖ = 1) :
    ‖1 - a * b‖^2 <= 2 * (‖1 - a‖^2 + ‖1 - b‖^2) := by
  have ha_le : ‖a‖ <= 1 := by
    exact le_of_eq ha
  exact two_factor_product_deviation_norm_sq a b ha_le

/-
Three-term real square estimate.

For real numbers `a`, `b`, and `c`,

  (a + b + c)^2 <= 3 * (a^2 + b^2 + c^2).
-/
theorem square_sum_three_le
    (a b c : Real) :
    (a + b + c)^2 <= 3 * (a^2 + b^2 + c^2) := by
  nlinarith [
    sq_nonneg (a - b),
    sq_nonneg (a - c),
    sq_nonneg (b - c)
  ]

/-
Three-factor deviation bound in abstract real form.

If

  dABC <= dA + dB + dC,

and all deviations are nonnegative, then

  dABC^2 <= 3 * (dA^2 + dB^2 + dC^2).
-/
theorem three_factor_deviation_bound
    {dABC dA dB dC : Real}
    (hdABC_nonneg : 0 <= dABC)
    (hdA_nonneg : 0 <= dA)
    (hdB_nonneg : 0 <= dB)
    (hdC_nonneg : 0 <= dC)
    (htri : dABC <= dA + dB + dC) :
    dABC^2 <= 3 * (dA^2 + dB^2 + dC^2) := by
  have hsum_nonneg : 0 <= dA + dB + dC := by
    linarith
  have hsquare_mono : dABC^2 <= (dA + dB + dC)^2 := by
    nlinarith
  have hsquare_bound :
      (dA + dB + dC)^2 <= 3 * (dA^2 + dB^2 + dC^2) := by
    exact square_sum_three_le dA dB dC
  exact le_trans hsquare_mono hsquare_bound

/-
Three-factor product deviation estimate in a normed ring.

Using the already-proved two-factor theorem twice:

  ||1 - a*b*c|| <= ||1 - a*b|| + ||1 - c||
  ||1 - a*b|| <= ||1 - a|| + ||1 - b||

If `||a|| <= 1` and `||b|| <= 1`, then

  ||1 - a*b*c|| <= ||1 - a|| + ||1 - b|| + ||1 - c||.
-/
theorem norm_one_sub_mul3_le
    {R : Type*}
    [NormedRing R]
    (a b c : R)
    (ha : ‖a‖ <= 1)
    (hb : ‖b‖ <= 1) :
    ‖1 - a * b * c‖ <= ‖1 - a‖ + ‖1 - b‖ + ‖1 - c‖ := by
  have hab : ‖a * b‖ <= 1 := by
    have hmul : ‖a * b‖ <= ‖a‖ * ‖b‖ := by
      exact norm_mul_le a b
    have hprod : ‖a‖ * ‖b‖ <= 1 * 1 := by
      exact mul_le_mul ha hb (norm_nonneg b) (by norm_num)
    calc
      ‖a * b‖ <= ‖a‖ * ‖b‖ := hmul
      _ <= 1 := by
        simpa using hprod
  have hfirst : ‖1 - (a * b) * c‖ <= ‖1 - a * b‖ + ‖1 - c‖ := by
    exact norm_one_sub_mul_le (a * b) c hab
  have hsecond : ‖1 - a * b‖ <= ‖1 - a‖ + ‖1 - b‖ := by
    exact norm_one_sub_mul_le a b ha
  calc
    ‖1 - a * b * c‖ = ‖1 - (a * b) * c‖ := by
      rfl
    _ <= ‖1 - a * b‖ + ‖1 - c‖ := hfirst
    _ <= (‖1 - a‖ + ‖1 - b‖) + ‖1 - c‖ := by
      exact add_le_add_right hsecond ‖1 - c‖
    _ = ‖1 - a‖ + ‖1 - b‖ + ‖1 - c‖ := by
      ring

/-
Squared three-factor product deviation estimate.

If `||a|| <= 1` and `||b|| <= 1`, then

  ||1 - a*b*c||^2
    <= 3 * (||1-a||^2 + ||1-b||^2 + ||1-c||^2).
-/
theorem three_factor_product_deviation_norm_sq
    {R : Type*}
    [NormedRing R]
    (a b c : R)
    (ha : ‖a‖ <= 1)
    (hb : ‖b‖ <= 1) :
    ‖1 - a * b * c‖^2
      <= 3 * (‖1 - a‖^2 + ‖1 - b‖^2 + ‖1 - c‖^2) := by
  have htri :
      ‖1 - a * b * c‖ <= ‖1 - a‖ + ‖1 - b‖ + ‖1 - c‖ := by
    exact norm_one_sub_mul3_le a b c ha hb
  exact three_factor_deviation_bound
    (norm_nonneg (1 - a * b * c))
    (norm_nonneg (1 - a))
    (norm_nonneg (1 - b))
    (norm_nonneg (1 - c))
    htri

/-
Unit-norm version for three factors.

If `||a|| = 1` and `||b|| = 1`, then the three-factor product deviation
estimate holds.
-/
theorem three_factor_product_deviation_norm_sq_of_norm_eq_one
    {R : Type*}
    [NormedRing R]
    (a b c : R)
    (ha : ‖a‖ = 1)
    (hb : ‖b‖ = 1) :
    ‖1 - a * b * c‖^2
      <= 3 * (‖1 - a‖^2 + ‖1 - b‖^2 + ‖1 - c‖^2) := by
  have ha_le : ‖a‖ <= 1 := by
    exact le_of_eq ha
  have hb_le : ‖b‖ <= 1 := by
    exact le_of_eq hb
  exact three_factor_product_deviation_norm_sq a b c ha_le hb_le

end RussoYM

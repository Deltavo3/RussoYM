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

end RussoYM

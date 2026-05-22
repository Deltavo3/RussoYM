import Mathlib
import RussoYM.ProductDeviation
import RussoYM.ProductDeviationInterface

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# List Product Deviation

This file proves the general finite-product triangle estimate:

  ||1 - product xs|| <= sum_i ||1 - x_i||

for a list of norm-nonincreasing factors.

This is one of the two ingredients needed for the full product-deviation theorem.
The other ingredient is the finite Cauchy estimate:

  (sum_i d_i)^2 <= m * sum_i d_i^2.
-/

/-
If every factor in a list has norm at most `1`, then the product has norm at
most `1`.
-/
theorem list_prod_norm_le_one
    {R : Type*}
    [NormedRing R]
    [NormOneClass R] :
    forall xs : List R,
      (forall a, a ∈ xs -> ‖a‖ <= 1) ->
        ‖xs.prod‖ <= 1 := by
  intro xs
  induction xs with
  | nil =>
    intro h
    simp (le_of_eq (norm_one : ‖(1 : R)‖ = 1))
  | cons a xs ih =>
      intro h
      have ha : ‖a‖ <= 1 := by
        exact h a (by simp)
      have hxs : forall b, b ∈ xs -> ‖b‖ <= 1 := by
        intro b hb
        exact h b (by simp [hb])
      have hprod_xs : ‖xs.prod‖ <= 1 := by
        exact ih hxs
      have hmul : ‖a * xs.prod‖ <= ‖a‖ * ‖xs.prod‖ := by
        exact norm_mul_le a xs.prod
      have hprod : ‖a‖ * ‖xs.prod‖ <= 1 * 1 := by
        exact mul_le_mul ha hprod_xs (norm_nonneg xs.prod) (by norm_num)
      calc
        ‖(a :: xs).prod‖ = ‖a * xs.prod‖ := by
          simp
        _ <= ‖a‖ * ‖xs.prod‖ := hmul
        _ <= 1 := by
          simpa using hprod

/-
General finite-product triangle estimate.

If every factor in `xs` has norm at most `1`, then

  ||1 - xs.prod|| <= sum over xs of ||1 - a||.
-/
theorem norm_one_sub_list_prod_le_sum
    {R : Type*}
    [NormedRing R]
    [NormOneClass R] :
    forall xs : List R,
      (forall a, a ∈ xs -> ‖a‖ <= 1) ->
        ‖1 - xs.prod‖ <= (xs.map (fun a => ‖1 - a‖)).sum := by
  intro xs
  induction xs with
  | nil =>
      intro h
      simp
  | cons a xs ih =>
      intro h
      have ha : ‖a‖ <= 1 := by
        exact h a (by simp)
      have hxs : forall b, b ∈ xs -> ‖b‖ <= 1 := by
        intro b hb
        exact h b (by simp [hb])
      have hfirst :
          ‖1 - a * xs.prod‖ <= ‖1 - a‖ + ‖1 - xs.prod‖ := by
        exact norm_one_sub_mul_le a xs.prod ha
      have hsecond :
          ‖1 - xs.prod‖ <= (xs.map (fun b => ‖1 - b‖)).sum := by
        exact ih hxs
      calc
        ‖1 - (a :: xs).prod‖ = ‖1 - a * xs.prod‖ := by
          simp
        _ <= ‖1 - a‖ + ‖1 - xs.prod‖ := hfirst
        _ <= ‖1 - a‖ + (xs.map (fun b => ‖1 - b‖)).sum := by
         linarith
        _ = ((a :: xs).map (fun b => ‖1 - b‖)).sum := by
          simp

/-
Interface-ready version.

Let

  z = 1 - xs.prod,
  sumDev = sum_i ||1 - x_i||.

Then the triangle-bound part of the product-deviation interface holds.
-/
theorem list_product_triangle_interface
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    (hxs : forall a, a ∈ xs -> ‖a‖ <= 1) :
    ‖1 - xs.prod‖ <= (xs.map (fun a => ‖1 - a‖)).sum := by
  exact norm_one_sub_list_prod_le_sum xs hxs

end RussoYM

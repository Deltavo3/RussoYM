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
      change ‖(1 : R)‖ <= 1
      exact le_of_eq (norm_one : ‖(1 : R)‖ = 1)
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

/-
The deviation sum is nonnegative.
-/
theorem list_deviation_sum_nonneg
    {R : Type*}
    [NormedRing R]
    (xs : List R) :
    0 <= (xs.map (fun a => ‖1 - a‖)).sum := by
  induction xs with
  | nil =>
      simp
  | cons a xs ih =>
      change 0 <= ‖1 - a‖ + (xs.map (fun b => ‖1 - b‖)).sum
      exact add_nonneg (norm_nonneg (1 - a)) ih

/-
Squared finite-list product-deviation estimate from the finite Cauchy bound.

This packages the already-proved triangle estimate with the abstract
triangle/Cauchy wrapper from `ProductDeviation.lean`.
-/
theorem list_product_deviation_norm_sq_from_cauchy
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    (hxs : forall a, a ∈ xs -> ‖a‖ <= 1)
    (hcauchy :
      ((xs.map (fun a => ‖1 - a‖)).sum)^2
        <=
      (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := by
  have hsum_nonneg :
      0 <= (xs.map (fun a => ‖1 - a‖)).sum := by
    exact list_deviation_sum_nonneg xs
  have htri :
      ‖1 - xs.prod‖ <= (xs.map (fun a => ‖1 - a‖)).sum := by
    exact list_product_triangle_interface xs hxs
  exact norm_product_deviation_from_triangle_and_cauchy
    hsum_nonneg
    htri
    hcauchy

/-
Finite-list Cauchy estimate.

For a finite list of real numbers,

  (sum xs)^2 <= xs.length * sum_i xs_i^2.
-/
theorem list_cauchy_sum_sq_le_length_mul_sum_sq
    (xs : List Real) :
    xs.sum^2 <= (xs.length : Real) * (xs.map (fun x => x^2)).sum := by
  classical
  let f : Fin xs.length -> Real := fun i => xs[i]
  have h :
      ((Finset.univ : Finset (Fin xs.length)).sum f)^2
        <=
      (Fintype.card (Fin xs.length) : Real) *
        ((Finset.univ : Finset (Fin xs.length)).sum (fun i => (f i)^2)) := by
    simpa using
      (sq_sum_le_card_mul_sum_sq
        (s := (Finset.univ : Finset (Fin xs.length)))
        (f := f))
  have hsum :
      ((Finset.univ : Finset (Fin xs.length)).sum f) = xs.sum := by
    calc
      ((Finset.univ : Finset (Fin xs.length)).sum f)
          = (List.ofFn f).sum := by
            exact (List.sum_ofFn (f := f)).symm
      _ = xs.sum := by
            simp [f, List.ofFn_getElem]
  have hlist_sq :
      List.ofFn (fun i : Fin xs.length => (xs[i]) ^ 2)
        =
      xs.map (fun x => x^2) := by
    simpa [List.length_map, List.getElem_map] using
      (List.ofFn_getElem (xs := xs.map (fun x => x^2)))
  have hsqsum :
      ((Finset.univ : Finset (Fin xs.length)).sum (fun i => (f i)^2))
        =
      (xs.map (fun x => x^2)).sum := by
    calc
      ((Finset.univ : Finset (Fin xs.length)).sum (fun i => (f i)^2))
          = (List.ofFn (fun i : Fin xs.length => (f i)^2)).sum := by
            exact (List.sum_ofFn (f := fun i : Fin xs.length => (f i)^2)).symm
      _ = (List.ofFn (fun i : Fin xs.length => (xs[i]) ^ 2)).sum := by
            simp [f]
      _ = (xs.map (fun x => x^2)).sum := by
            rw [hlist_sq]
  simpa [hsum, hsqsum, Fintype.card_fin] using h

/-
Full squared finite-list product-deviation estimate.

This removes the separate Cauchy assumption by applying the finite-list Cauchy
estimate to the deviation list.
-/
theorem list_product_deviation_norm_sq
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    (hxs : forall a, a ∈ xs -> ‖a‖ <= 1) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := by
  have hcauchy :
      ((xs.map (fun a => ‖1 - a‖)).sum)^2
        <=
      ((xs.map (fun a => ‖1 - a‖)).length : Real) *
        ((xs.map (fun a => ‖1 - a‖)).map (fun x => x^2)).sum := by
    exact list_cauchy_sum_sq_le_length_mul_sum_sq
      (xs.map (fun a => ‖1 - a‖))
  have hcauchy' :
      ((xs.map (fun a => ‖1 - a‖)).sum)^2
        <=
      (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := by
    simpa [List.length_map, List.map_map] using hcauchy
  exact list_product_deviation_norm_sq_from_cauchy xs hxs hcauchy'

/-
Unit-norm version of the full squared finite-list product-deviation theorem.

If every factor has norm exactly one, then the norm-control hypothesis
`‖a‖ <= 1` follows automatically.
-/
theorem list_product_deviation_norm_sq_of_norm_eq_one
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    (hxs : forall a, a ∈ xs -> ‖a‖ = 1) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := by
  exact list_product_deviation_norm_sq xs
    (by
      intro a ha
      exact le_of_eq (hxs a ha))

/-
If every single-factor deviation is bounded by `eps`, then the sum of squared
deviations is bounded by `xs.length * eps^2`.
-/
theorem list_deviation_sq_sum_le_length_mul_sq_of_bound
    {R : Type*}
    [NormedRing R]
    (xs : List R)
    {eps : Real}
    (heps : 0 <= eps)
    (hdev : forall a, a ∈ xs -> ‖1 - a‖ <= eps) :
    (xs.map (fun a => ‖1 - a‖^2)).sum
      <=
    (xs.length : Real) * eps^2 := by
  induction xs with
  | nil =>
      simp
  | cons a xs ih =>
      have ha_dev : ‖1 - a‖ <= eps := by
        exact hdev a (by simp)
      have hxs_dev : forall b, b ∈ xs -> ‖1 - b‖ <= eps := by
        intro b hb
        exact hdev b (by simp [hb])
      have ihxs :
          (xs.map (fun b => ‖1 - b‖^2)).sum
            <=
          (xs.length : Real) * eps^2 := by
        exact ih hxs_dev
      have ha_sq : ‖1 - a‖^2 <= eps^2 := by
        have hnonneg : 0 <= ‖1 - a‖ := by
          exact norm_nonneg (1 - a)
        have hprod : 0 <= (eps - ‖1 - a‖) * (eps + ‖1 - a‖) := by
          exact mul_nonneg (sub_nonneg.mpr ha_dev) (add_nonneg heps hnonneg)
        nlinarith
      calc
        ((a :: xs).map (fun b => ‖1 - b‖^2)).sum
            = ‖1 - a‖^2 + (xs.map (fun b => ‖1 - b‖^2)).sum := by
              simp
        _ <= eps^2 + (xs.length : Real) * eps^2 := by
              linarith
        _ = ((Nat.succ xs.length : Nat) : Real) * eps^2 := by
              rw [Nat.cast_succ]
              ring
        _ = ((a :: xs).length : Real) * eps^2 := by
              simp

/-
Uniform-deviation corollary for unit-norm finite products.

If all factors have norm one and each factor is within `eps` of `1`, then the
whole product deviation is bounded by `xs.length^2 * eps^2`.
-/
theorem list_product_deviation_norm_sq_of_norm_eq_one_and_dev_le
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    {eps : Real}
    (heps : 0 <= eps)
    (hunit : forall a, a ∈ xs -> ‖a‖ = 1)
    (hdev : forall a, a ∈ xs -> ‖1 - a‖ <= eps) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real)^2 * eps^2 := by
  have hprod :
      ‖1 - xs.prod‖^2
        <=
      (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := by
    exact list_product_deviation_norm_sq_of_norm_eq_one xs hunit
  have hsum :
      (xs.map (fun a => ‖1 - a‖^2)).sum
        <=
      (xs.length : Real) * eps^2 := by
    exact list_deviation_sq_sum_le_length_mul_sq_of_bound xs heps hdev
  have hlen_nonneg : 0 <= (xs.length : Real) := by
    exact Nat.cast_nonneg xs.length
  calc
    ‖1 - xs.prod‖^2
        <= (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := hprod
    _ <= (xs.length : Real) * ((xs.length : Real) * eps^2) := by
          exact mul_le_mul_of_nonneg_left hsum hlen_nonneg
    _ = (xs.length : Real)^2 * eps^2 := by
          ring

end RussoYM

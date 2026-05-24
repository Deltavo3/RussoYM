import Mathlib
import RussoYM.ListProductDeviation

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# List Product Deviation Interface

This file packages the full finite-list product-deviation theorem into a
named assumption interface.

It records the clean statement:

if every factor in a finite list has norm at most one, then

  ‖1 - xs.prod‖^2
    ≤ xs.length * sum_i ‖1 - x_i‖^2.
-/

/--
Finite-list product-deviation assumptions.

The only analytic/algebraic input is that every factor has norm at most one.
-/
structure ListProductDeviationAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R) : Prop where
  norm_le_one :
    forall a, a ∈ xs -> ‖a‖ <= 1

/--
Interface endpoint for the full squared finite-list product-deviation theorem.
-/
theorem ListProductDeviationAssumptions.imply_norm_sq_deviation
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    (h : ListProductDeviationAssumptions xs) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := by
  exact list_product_deviation_norm_sq xs h.norm_le_one

/--
Finite-list unit-norm product-deviation assumptions.

This is the holonomy/unitary-style interface: every factor has norm exactly one.
-/
structure ListProductDeviationUnitAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R) : Prop where
  norm_eq_one :
    forall a, a ∈ xs -> ‖a‖ = 1

/--
Interface endpoint for the unit-norm squared finite-list product-deviation theorem.
-/
theorem ListProductDeviationUnitAssumptions.imply_norm_sq_deviation
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    (h : ListProductDeviationUnitAssumptions xs) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := by
  exact list_product_deviation_norm_sq_of_norm_eq_one xs h.norm_eq_one

/--
Uniform unit-norm finite-list product-deviation assumptions.

This is the holonomy-style interface with a uniform single-factor deviation
bound.
-/
structure ListProductDeviationUniformUnitAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    (eps : Real) : Prop where
  eps_nonneg :
    0 <= eps
  norm_eq_one :
    forall a, a ∈ xs -> ‖a‖ = 1
  deviation_le :
    forall a, a ∈ xs -> ‖1 - a‖ <= eps

/--
Interface endpoint for the uniform unit-norm finite-list product-deviation
bound.
-/
theorem ListProductDeviationUniformUnitAssumptions.imply_uniform_norm_sq_deviation
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    {eps : Real}
    (h : ListProductDeviationUniformUnitAssumptions xs eps) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real)^2 * eps^2 := by
  exact list_product_deviation_norm_sq_of_norm_eq_one_and_dev_le
    xs h.eps_nonneg h.norm_eq_one h.deviation_le

/--
Interface endpoint for the unsquared uniform unit-norm finite-list
product-deviation bound.
-/
theorem ListProductDeviationUniformUnitAssumptions.imply_uniform_norm_deviation
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    {eps : Real}
    (h : ListProductDeviationUniformUnitAssumptions xs eps) :
    ‖1 - xs.prod‖ <= (xs.length : Real) * eps := by
  exact list_product_deviation_norm_of_norm_eq_one_and_dev_le
    xs h.eps_nonneg h.norm_eq_one h.deviation_le

/--
Target-error interface endpoint for the uniform unit-norm finite-list
product-deviation bound.
-/
theorem ListProductDeviationUniformUnitAssumptions.imply_norm_deviation_le_delta
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    {eps delta : Real}
    (h : ListProductDeviationUniformUnitAssumptions xs eps)
    (haccum : (xs.length : Real) * eps <= delta) :
    ‖1 - xs.prod‖ <= delta := by
  exact list_product_deviation_norm_le_delta_of_uniform_unit_dev
    xs h.eps_nonneg h.norm_eq_one h.deviation_le haccum

/--
Bounded-length target-error interface endpoint for the uniform unit-norm
finite-list product-deviation bound.
-/
theorem ListProductDeviationUniformUnitAssumptions.imply_norm_deviation_le_delta_of_length_le
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    {eps delta : Real}
    {N : Nat}
    (h : ListProductDeviationUniformUnitAssumptions xs eps)
    (hlen : xs.length <= N)
    (haccum : (N : Real) * eps <= delta) :
    ‖1 - xs.prod‖ <= delta := by
  exact list_product_deviation_norm_le_delta_of_uniform_unit_dev_and_length_le
    xs h.eps_nonneg hlen h.norm_eq_one h.deviation_le haccum

/--
Division-form bounded-length target-error interface endpoint for the uniform
unit-norm finite-list product-deviation bound.
-/
theorem ListProductDeviationUniformUnitAssumptions.imply_norm_deviation_le_delta_of_length_le_and_eps_le_div
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    {eps delta : Real}
    {N : Nat}
    (h : ListProductDeviationUniformUnitAssumptions xs eps)
    (hNpos : 0 < N)
    (hlen : xs.length <= N)
    (heps_le : eps <= delta / (N : Real)) :
    ‖1 - xs.prod‖ <= delta := by
  exact list_product_deviation_norm_le_delta_of_uniform_unit_dev_length_le_and_eps_le_div
    xs h.eps_nonneg hNpos hlen h.norm_eq_one h.deviation_le heps_le

end RussoYM

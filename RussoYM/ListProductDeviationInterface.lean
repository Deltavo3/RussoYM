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

end RussoYM

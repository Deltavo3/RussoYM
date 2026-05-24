import Mathlib
import RussoYM.ListProductDeviation
import RussoYM.ListProductDeviationInterface

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Finite Holonomy Estimate

This file repackages the finite-list product-deviation theorem in
Yang--Mills/holonomy language.

It proves the finite algebraic estimate:

unit-norm link variables
+ each link close to identity by eps
+ path length at most N
+ eps <= delta / N
=> the full finite holonomy/product is within delta of identity.

This is still finite-dimensional algebra. It does not prove the analytic
continuum holonomy theorem.
-/

/--
Finite holonomy estimate assumptions.

`links` is a finite ordered list of link/holonomy factors.
`eps` is the uniform one-link deviation scale.
`delta` is the target total holonomy deviation.
`N` is an upper bound on the path length.
-/
structure FiniteHolonomyEstimateAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : List R)
    (eps delta : Real)
    (N : Nat) : Prop where
  eps_nonneg :
    0 <= eps
  path_length_positive :
    0 < N
  path_length_bound :
    links.length <= N
  link_unit_norm :
    forall U, U ∈ links -> ‖U‖ = 1
  link_deviation_bound :
    forall U, U ∈ links -> ‖1 - U‖ <= eps
  local_error_budget :
    eps <= delta / (N : Real)

/--
Finite holonomy deviation endpoint.

Under the finite holonomy estimate assumptions, the full finite product is
within `delta` of identity.
-/
theorem FiniteHolonomyEstimateAssumptions.imply_holonomy_deviation_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : List R}
    {eps delta : Real}
    {N : Nat}
    (h : FiniteHolonomyEstimateAssumptions links eps delta N) :
    ‖1 - links.prod‖ <= delta := by
  exact list_product_deviation_norm_le_delta_of_uniform_unit_dev_length_le_and_eps_le_div
    links
    h.eps_nonneg
    h.path_length_positive
    h.path_length_bound
    h.link_unit_norm
    h.link_deviation_bound
    h.local_error_budget

/--
Finite holonomy estimate from the reusable uniform unit-norm product interface.
-/
theorem finite_holonomy_deviation_bound_from_uniform_unit_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : List R}
    {eps delta : Real}
    {N : Nat}
    (h : ListProductDeviationUniformUnitAssumptions links eps)
    (hNpos : 0 < N)
    (hlen : links.length <= N)
    (heps_le : eps <= delta / (N : Real)) :
    ‖1 - links.prod‖ <= delta := by
  exact ListProductDeviationUniformUnitAssumptions.imply_norm_deviation_le_delta_of_length_le_and_eps_le_div
    h hNpos hlen heps_le

/--
Finite holonomy estimate with a scaled local link-error bound.

This is the form usually produced by analytic estimates:

  ‖1 - U_link‖ <= C * eta.

If the accumulated local budget satisfies `C * eta <= delta / N`, then the
full finite holonomy/product is within `delta` of identity.
-/
theorem finite_holonomy_deviation_bound_of_scaled_link_error
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : List R)
    {C eta delta : Real}
    {N : Nat}
    (hC : 0 <= C)
    (heta : 0 <= eta)
    (hNpos : 0 < N)
    (hlen : links.length <= N)
    (hunit : forall U, U ∈ links -> ‖U‖ = 1)
    (hlink :
      forall U, U ∈ links -> ‖1 - U‖ <= C * eta)
    (hbudget : C * eta <= delta / (N : Real)) :
    ‖1 - links.prod‖ <= delta := by
  have heps : 0 <= C * eta := by
    exact mul_nonneg hC heta
  exact list_product_deviation_norm_le_delta_of_uniform_unit_dev_length_le_and_eps_le_div
    links heps hNpos hlen hunit hlink hbudget

/--
Assumption interface for the scaled finite holonomy estimate.
-/
structure FiniteHolonomyScaledEstimateAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : List R)
    (C eta delta : Real)
    (N : Nat) : Prop where
  C_nonneg :
    0 <= C
  eta_nonneg :
    0 <= eta
  path_length_positive :
    0 < N
  path_length_bound :
    links.length <= N
  link_unit_norm :
    forall U, U ∈ links -> ‖U‖ = 1
  scaled_link_deviation_bound :
    forall U, U ∈ links -> ‖1 - U‖ <= C * eta
  scaled_error_budget :
    C * eta <= delta / (N : Real)

/--
Scaled finite holonomy deviation endpoint.
-/
theorem FiniteHolonomyScaledEstimateAssumptions.imply_holonomy_deviation_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : List R}
    {C eta delta : Real}
    {N : Nat}
    (h : FiniteHolonomyScaledEstimateAssumptions links C eta delta N) :
    ‖1 - links.prod‖ <= delta := by
  exact finite_holonomy_deviation_bound_of_scaled_link_error
    links
    h.C_nonneg
    h.eta_nonneg
    h.path_length_positive
    h.path_length_bound
    h.link_unit_norm
    h.scaled_link_deviation_bound
    h.scaled_error_budget

end RussoYM

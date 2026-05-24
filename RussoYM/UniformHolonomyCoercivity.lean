import Mathlib
import RussoYM.UniformFiniteGapFromHolonomy

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Uniform Holonomy-Coercivity

This file packages the uniform finite-regulator holonomy/coercivity mechanism
in direct per-regulator form.

It expands the assumptions behind `UniformFiniteGapFromHolonomyAssumptions`:

for every regulator `n`,

* the finite holonomy product is separated from identity,
* holonomy deviation is controlled by curvature size,
* energy is coercive in curvature,
* the finite gap is bounded below by the energy lower bound.

The conclusion is a uniform positive finite gap.
-/

/--
Uniform holonomy/coercivity assumptions written directly at every finite
regulator index.
-/
structure UniformHolonomyCoercivityAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (C mu delta : Real) : Prop where
  C_positive :
    0 < C
  mu_positive :
    0 < mu
  delta_positive :
    0 < delta
  holonomy_separation :
    forall n, delta <= ‖1 - (links n).prod‖
  holonomy_curvature_control :
    forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n
  energy_coercive :
    forall n, mu * (curvatureNorm n)^2 <= Energy n
  gap_lower_bound :
    forall n, Energy n <= Gap n

/--
Direct uniform holonomy/coercivity assumptions imply the existing packaged
uniform finite-gap assumptions.
-/
theorem UniformHolonomyCoercivityAssumptions.imply_uniform_finite_gap_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h : UniformHolonomyCoercivityAssumptions
      links Gap Energy curvatureNorm C mu delta) :
    UniformFiniteGapFromHolonomyAssumptions
      links Gap Energy curvatureNorm C mu delta := by
  exact
    { finite_gap_assumptions := by
        intro n
        exact
          { holonomy_coercivity :=
              { C_positive := h.C_positive
                mu_positive := h.mu_positive
                delta_positive := h.delta_positive
                holonomy_separation := h.holonomy_separation n
                holonomy_curvature_control := h.holonomy_curvature_control n
                energy_coercive := h.energy_coercive n }
            gap_lower_bound := h.gap_lower_bound n } }

/--
Uniform positive finite gap from direct per-regulator holonomy/coercivity
assumptions.
-/
theorem UniformHolonomyCoercivityAssumptions.imply_uniform_positive_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h : UniformHolonomyCoercivityAssumptions
      links Gap Energy curvatureNorm C mu delta) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ 0 < mu * (delta / C)^2
      ∧ forall n, 0 < Gap n := by
  exact UniformFiniteGapFromHolonomyAssumptions.imply_uniform_positive_gap
    (UniformHolonomyCoercivityAssumptions.imply_uniform_finite_gap_assumptions h)

end RussoYM

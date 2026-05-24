import Mathlib
import RussoYM.FiniteHolonomyCoercivity

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Finite Gap From Holonomy-Coercivity

This file packages the finite holonomy-coercivity bridge as a finite gap
criterion.

It records the finite algebraic implication:

nontrivial holonomy separation
+ holonomy controlled by curvature
+ curvature coercivity
+ finite gap bounded below by the finite energy lower bound
=> positive finite gap.

This is still finite algebra. It does not prove the analytic continuum gap.
-/

/--
Finite gap assumptions from a concrete holonomy path.

`Gap` is a finite-regulator spectral/fine-gap lower-bound quantity.
`Energy` is the finite energy lower bound produced by holonomy-coercivity.
-/
structure FiniteGapFromHolonomyAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : List R)
    (Gap Energy curvatureNorm C mu delta : Real) : Prop where
  holonomy_coercivity :
    FiniteHolonomyPathCoercivityAssumptions
      links Energy curvatureNorm C mu delta
  gap_lower_bound :
    Energy <= Gap

/--
Finite gap endpoint from holonomy-coercivity.

If holonomy-coercivity produces a positive energy lower bound and the finite
gap quantity is bounded below by that energy lower bound, then the finite gap
is positive.
-/
theorem FiniteGapFromHolonomyAssumptions.imply_positive_finite_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : List R}
    {Gap Energy curvatureNorm C mu delta : Real}
    (h : FiniteGapFromHolonomyAssumptions
      links Gap Energy curvatureNorm C mu delta) :
    mu * (delta / C)^2 <= Gap
      ∧ 0 < mu * (delta / C)^2
      ∧ 0 < Gap := by
  have hEnergy :
      mu * (delta / C)^2 <= Energy
        ∧ 0 < mu * (delta / C)^2
        ∧ 0 < Energy := by
    exact FiniteHolonomyPathCoercivityAssumptions.imply_positive_energy_gap
      h.holonomy_coercivity
  have hlower_gap : mu * (delta / C)^2 <= Gap := by
    exact le_trans hEnergy.1 h.gap_lower_bound
  have hgap_pos : 0 < Gap := by
    exact lt_of_lt_of_le hEnergy.2.1 hlower_gap
  exact ⟨hlower_gap, hEnergy.2.1, hgap_pos⟩

end RussoYM

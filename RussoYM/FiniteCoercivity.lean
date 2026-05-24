import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Finite Coercivity Algebra

This file records the finite-dimensional algebraic core of the
curvature/coercivity red lemma.

It does not prove Yang--Mills curvature coercivity analytically. It proves the
closure step:

positive coercivity constant
+ nonzero curvature separation
+ energy controls curvature square
=> positive finite energy gap.
-/

/--
Finite squared-curvature coercivity assumptions.

`Energy` is the finite-regulator energy/action.
`curvatureSq` is the squared curvature size.
`mu` is the coercivity constant.
`delta` is the nontrivial-sector curvature separation scale.
-/
structure FiniteCoercivityAssumptions
    (Energy curvatureSq mu delta : Real) : Prop where
  mu_positive :
    0 < mu
  delta_positive :
    0 < delta
  curvature_separation :
    delta^2 <= curvatureSq
  energy_coercive :
    mu * curvatureSq <= Energy

/--
Finite coercivity endpoint.

If energy controls squared curvature and the nontrivial sector has curvature
at least `delta`, then energy has a positive lower bound `mu * delta^2`.
-/
theorem FiniteCoercivityAssumptions.imply_positive_energy_gap
    {Energy curvatureSq mu delta : Real}
    (h : FiniteCoercivityAssumptions Energy curvatureSq mu delta) :
    mu * delta^2 <= Energy ∧ 0 < mu * delta^2 ∧ 0 < Energy := by
  have hmu_nonneg : 0 <= mu := by
    exact le_of_lt h.mu_positive
  have hlower_le_curv :
      mu * delta^2 <= mu * curvatureSq := by
    exact mul_le_mul_of_nonneg_left h.curvature_separation hmu_nonneg
  have hlower_le_energy :
      mu * delta^2 <= Energy := by
    exact le_trans hlower_le_curv h.energy_coercive
  have hdelta_sq_pos : 0 < delta^2 := by
    nlinarith [h.delta_positive]
  have hlower_pos : 0 < mu * delta^2 := by
    exact mul_pos h.mu_positive hdelta_sq_pos
  have henergy_pos : 0 < Energy := by
    exact lt_of_lt_of_le hlower_pos hlower_le_energy
  exact ⟨hlower_le_energy, hlower_pos, henergy_pos⟩

end RussoYM

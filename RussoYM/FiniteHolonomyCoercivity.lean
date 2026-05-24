import Mathlib
import RussoYM.FiniteCoercivity

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Finite Holonomy-Coercivity Gap

This file records a finite-dimensional algebraic bridge toward the
curvature/coercivity red lemma.

The idea is:

1. a nontrivial sector has holonomy deviation at least `delta`,
2. holonomy deviation is controlled by curvature size:
      holDev <= C * curvatureNorm,
3. energy is coercive in curvature:
      mu * curvatureNorm^2 <= Energy.

Then the energy has a positive lower bound:

      mu * (delta / C)^2 <= Energy.

This is still finite algebra. It does not prove the analytic holonomy-curvature
estimate or continuum Yang--Mills coercivity.
-/

/--
Finite holonomy-coercivity assumptions.

`holDev` is the holonomy deviation from identity.
`curvatureNorm` is a finite curvature-size quantity.
`C` controls holonomy deviation by curvature.
`mu` is the coercivity constant.
`delta` is the nontrivial-sector holonomy separation.
-/
structure FiniteHolonomyCoercivityAssumptions
    (Energy holDev curvatureNorm C mu delta : Real) : Prop where
  C_positive :
    0 < C
  mu_positive :
    0 < mu
  delta_positive :
    0 < delta
  holonomy_separation :
    delta <= holDev
  holonomy_curvature_control :
    holDev <= C * curvatureNorm
  energy_coercive :
    mu * curvatureNorm^2 <= Energy

/--
Finite holonomy-coercivity endpoint.

If holonomy deviation separates the nontrivial sector and is controlled by
curvature size, then curvature size is at least `delta / C`. Coercivity then
gives a positive energy gap.
-/
theorem FiniteHolonomyCoercivityAssumptions.imply_positive_energy_gap
    {Energy holDev curvatureNorm C mu delta : Real}
    (h : FiniteHolonomyCoercivityAssumptions
      Energy holDev curvatureNorm C mu delta) :
    mu * (delta / C)^2 <= Energy
      ∧ 0 < mu * (delta / C)^2
      ∧ 0 < Energy := by
  have hC_nonneg : 0 <= C := by
    exact le_of_lt h.C_positive
  have hsep_scaled : delta <= C * curvatureNorm := by
    exact le_trans h.holonomy_separation h.holonomy_curvature_control
  have hcurv_sep : delta / C <= curvatureNorm := by
    rw [div_le_iff₀ h.C_positive]
    simpa [mul_comm] using hsep_scaled
  have hdelta_div_pos : 0 < delta / C := by
    exact div_pos h.delta_positive h.C_positive
  have hnorm :
      FiniteCoercivityNormAssumptions
        Energy curvatureNorm mu (delta / C) := by
    exact
      { mu_positive := h.mu_positive
        delta_positive := hdelta_div_pos
        curvature_separation := hcurv_sep
        energy_coercive := h.energy_coercive }
  exact FiniteCoercivityNormAssumptions.imply_positive_energy_gap hnorm

/--
Finite holonomy-coercivity assumptions for an actual finite product/path.

Here the holonomy deviation is the concrete quantity

  ‖1 - links.prod‖.

This is closer to the YM interpretation: a nontrivial finite holonomy sector
has product separated from identity, and that product deviation is controlled
by curvature size.
-/
structure FiniteHolonomyPathCoercivityAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : List R)
    (Energy curvatureNorm C mu delta : Real) : Prop where
  C_positive :
    0 < C
  mu_positive :
    0 < mu
  delta_positive :
    0 < delta
  holonomy_separation :
    delta <= ‖1 - links.prod‖
  holonomy_curvature_control :
    ‖1 - links.prod‖ <= C * curvatureNorm
  energy_coercive :
    mu * curvatureNorm^2 <= Energy

/--
Concrete finite holonomy-coercivity endpoint.

If the actual finite product is separated from identity and its deviation is
controlled by curvature, then the energy has a positive lower bound.
-/
theorem FiniteHolonomyPathCoercivityAssumptions.imply_positive_energy_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : List R}
    {Energy curvatureNorm C mu delta : Real}
    (h : FiniteHolonomyPathCoercivityAssumptions
      links Energy curvatureNorm C mu delta) :
    mu * (delta / C)^2 <= Energy
      ∧ 0 < mu * (delta / C)^2
      ∧ 0 < Energy := by
  have hAbs :
      FiniteHolonomyCoercivityAssumptions
        Energy
        ‖1 - links.prod‖
        curvatureNorm
        C
        mu
        delta := by
    exact
      { C_positive := h.C_positive
        mu_positive := h.mu_positive
        delta_positive := h.delta_positive
        holonomy_separation := h.holonomy_separation
        holonomy_curvature_control := h.holonomy_curvature_control
        energy_coercive := h.energy_coercive }
  exact FiniteHolonomyCoercivityAssumptions.imply_positive_energy_gap hAbs

end RussoYM

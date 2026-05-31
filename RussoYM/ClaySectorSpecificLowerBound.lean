import RussoYM.ClayHolonomyCurvatureEnergyPackaging

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Sector-Specific Lower Bound

This file packages the sector-specific finite-regulator lower-bound algebra.

It does not prove sector coverage.
It does not prove continuum survival.
It does not prove the full Clay mass gap.

It verifies the finite-regulator algebra:

  direct resolved holonomy sector
  + local holonomy/flux control
  + flux-to-energy comparison
  + energy-norm identity
  + finite gap comparison

implies a positive lower bound for `Gap`.

In the paper, this should be read sector-specifically unless sector coverage is
separately proved.
-/

/--
Direct sector plus packaged holonomy-control assumptions gives an explicit
positive finite-regulator lower-bound witness for `Gap`.

The witness is

  Delta = (2 * eps / (C_loc * areaFactor))^2.

This theorem assumes `hGap : Energy n <= Gap n`, so in the paper this must be
read as the sector-specific gap comparison unless sector coverage is proved.
-/
theorem exists_sector_lower_bound_of_direct_flux_energy
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm fluxNorm : Nat -> Real}
    {eps C_loc areaFactor : Real}
    (heps :
      0 < eps)
    (hCloc_pos :
      0 < C_loc)
    (hArea_pos :
      0 < areaFactor)
    (hsector :
      forall n, 2 * eps <= ‖1 - (links n).prod‖)
    (hLocal :
      forall n, ‖1 - (links n).prod‖ <= C_loc * fluxNorm n)
    (hFluxEnergy :
      forall n, fluxNorm n <= areaFactor * curvatureNorm n)
    (hEnergyDef :
      forall n, Energy n = (curvatureNorm n)^2)
    (hGap :
      forall n, Energy n <= Gap n) :
    ∃ Delta : Real,
      0 < Delta
        ∧ forall n, Delta <= Gap n := by
  let C : Real := C_loc * areaFactor
  have hC_pos : 0 < C := by
    exact mul_pos hCloc_pos hArea_pos
  refine ⟨(2 * eps / C)^2, ?_, ?_⟩
  · have hnum_pos : 0 < 2 * eps := by positivity
    have hdiv_pos : 0 < 2 * eps / C := by
      exact div_pos hnum_pos hC_pos
    exact sq_pos_of_pos hdiv_pos
  · intro n
    have hControl :
        ‖1 - (links n).prod‖ <= C * curvatureNorm n := by
      have hScaled :
          C_loc * fluxNorm n
            <= C_loc * (areaFactor * curvatureNorm n) := by
        exact
          mul_le_mul_of_nonneg_left
            (hFluxEnergy n)
            (le_of_lt hCloc_pos)
      calc
        ‖1 - (links n).prod‖
            <= C_loc * fluxNorm n := hLocal n
        _ <= C_loc * (areaFactor * curvatureNorm n) := hScaled
        _ = C * curvatureNorm n := by
          dsimp [C]
          ring
    have hLowerNorm :
        2 * eps / C <= curvatureNorm n := by
      have hmul :
          2 * eps <= C * curvatureNorm n := by
        exact le_trans (hsector n) hControl
      have hmul' :
          2 * eps <= curvatureNorm n * C := by
        calc
          2 * eps <= C * curvatureNorm n := hmul
          _ = curvatureNorm n * C := by ring
      exact (div_le_iff₀ hC_pos).mpr hmul'
    have hdiv_nonneg : 0 <= 2 * eps / C := by
      exact div_nonneg (by positivity) (le_of_lt hC_pos)
    have hcurv_nonneg : 0 <= curvatureNorm n := by
      exact le_trans hdiv_nonneg hLowerNorm
    have hSquare :
        (2 * eps / C)^2 <= (curvatureNorm n)^2 := by
      nlinarith [sq_nonneg (curvatureNorm n - (2 * eps / C))]
    have hEnergyLower :
        (2 * eps / C)^2 <= Energy n := by
      rw [hEnergyDef n]
      exact hSquare
    exact le_trans hEnergyLower (hGap n)

/--
Same theorem, using the packaged holonomy-curvature control structure rather
than exposing flux estimates directly.
-/
theorem exists_sector_lower_bound_of_direct_control
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {eps : Real}
    (heps :
      0 < eps)
    (hsector :
      forall n, 2 * eps <= ‖1 - (links n).prod‖)
    (hControl :
      ClayHolonomyCurvatureControlExistenceAssumptions
        links curvatureNorm)
    (hEnergyDef :
      forall n, Energy n = (curvatureNorm n)^2)
    (hGap :
      forall n, Energy n <= Gap n) :
    ∃ Delta : Real,
      0 < Delta
        ∧ forall n, Delta <= Gap n := by
  rcases hControl.exists_control with ⟨C, hC_pos, hControlBound⟩
  refine ⟨(2 * eps / C)^2, ?_, ?_⟩
  · have hnum_pos : 0 < 2 * eps := by positivity
    have hdiv_pos : 0 < 2 * eps / C := by
      exact div_pos hnum_pos hC_pos
    exact sq_pos_of_pos hdiv_pos
  · intro n
    have hLowerNorm :
        2 * eps / C <= curvatureNorm n := by
      have hmul :
          2 * eps <= C * curvatureNorm n := by
        exact le_trans (hsector n) (hControlBound n)
      have hmul' :
          2 * eps <= curvatureNorm n * C := by
        calc
          2 * eps <= C * curvatureNorm n := hmul
          _ = curvatureNorm n * C := by ring
      exact (div_le_iff₀ hC_pos).mpr hmul'
    have hdiv_nonneg : 0 <= 2 * eps / C := by
      exact div_nonneg (by positivity) (le_of_lt hC_pos)
    have hcurv_nonneg : 0 <= curvatureNorm n := by
      exact le_trans hdiv_nonneg hLowerNorm
    have hSquare :
        (2 * eps / C)^2 <= (curvatureNorm n)^2 := by
      nlinarith [sq_nonneg (curvatureNorm n - (2 * eps / C))]
    have hEnergyLower :
        (2 * eps / C)^2 <= Energy n := by
      rw [hEnergyDef n]
      exact hSquare
    exact le_trans hEnergyLower (hGap n)

end RussoYM

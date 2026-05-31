import RussoYM.ClayDirectHolonomySector

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Holonomy-Curvature Energy Packaging

This file Lean-verifies only the algebraic packaging of the
holonomy-curvature control proof plan.

It does not prove the geometric local holonomy estimate.

It proves:

  local holonomy estimate
  + flux-to-energy comparison
  + positive constants
  -> ClayHolonomyCurvatureControlExistenceAssumptions.

This is the correct level for Lean here: the geometry remains paper-first,
while Lean checks the constant bookkeeping.
-/

/--
If holonomy deviation is controlled by a flux norm, and the flux norm is
controlled by the energy curvature norm, then holonomy deviation is controlled
by the energy curvature norm.

The final constant is

  C = C_loc * areaFactor.
-/
theorem ClayHolonomyCurvatureControlExistenceAssumptions.of_local_flux_energy_control
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {curvatureNorm fluxNorm : Nat -> Real}
    {C_loc areaFactor : Real}
    (hCloc_pos :
      0 < C_loc)
    (hArea_pos :
      0 < areaFactor)
    (hLocal :
      forall n, ‖1 - (links n).prod‖ <= C_loc * fluxNorm n)
    (hFluxEnergy :
      forall n, fluxNorm n <= areaFactor * curvatureNorm n) :
    ClayHolonomyCurvatureControlExistenceAssumptions
      links curvatureNorm := by
  exact
    { exists_control :=
        ⟨C_loc * areaFactor,
          mul_pos hCloc_pos hArea_pos,
          by
            intro n
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
              _ = (C_loc * areaFactor) * curvatureNorm n := by ring⟩ }

/--
The same result, exposing the explicit control witness.
-/
theorem exists_control_of_local_flux_energy_control
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {curvatureNorm fluxNorm : Nat -> Real}
    {C_loc areaFactor : Real}
    (hCloc_pos :
      0 < C_loc)
    (hArea_pos :
      0 < areaFactor)
    (hLocal :
      forall n, ‖1 - (links n).prod‖ <= C_loc * fluxNorm n)
    (hFluxEnergy :
      forall n, fluxNorm n <= areaFactor * curvatureNorm n) :
    ∃ C : Real,
      0 < C
        ∧ forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n := by
  exact
    (ClayHolonomyCurvatureControlExistenceAssumptions.of_local_flux_energy_control
      hCloc_pos hArea_pos hLocal hFluxEnergy).exists_control

/--
Direct sector, energy-norm coercivity, finite gap comparison, continuum
survival, and packaged holonomy-curvature control imply positive continuum gap.
-/
theorem clay_direct_sector_with_packaged_holonomy_control_imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm fluxNorm : Nat -> Real}
    {DeltaYM eps C_loc areaFactor : Real}
    (heps :
      0 < eps)
    (hsector :
      forall n, 2 * eps <= ‖1 - (links n).prod‖)
    (hCloc_pos :
      0 < C_loc)
    (hArea_pos :
      0 < areaFactor)
    (hLocal :
      forall n, ‖1 - (links n).prod‖ <= C_loc * fluxNorm n)
    (hFluxEnergy :
      forall n, fluxNorm n <= areaFactor * curvatureNorm n)
    (hEnergyDef :
      forall n, Energy n = (curvatureNorm n)^2)
    (hGap :
      ClayFiniteGapLowerComparisonAssumptions Gap Energy)
    (hContinuumForWitness :
      forall C mu delta : Real,
        0 < delta ->
        (forall n, delta <= ‖1 - (links n).prod‖) ->
        0 < C ->
        (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
        0 < mu ->
        (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
        (forall n, Energy n <= Gap n) ->
        forall Delta0 dUV : Real,
          0 < dUV ->
          Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
          Delta0 <= DeltaYM) :
    0 < DeltaYM := by
  have hControl :
      ClayHolonomyCurvatureControlExistenceAssumptions
        links curvatureNorm := by
    exact
      ClayHolonomyCurvatureControlExistenceAssumptions.of_local_flux_energy_control
        hCloc_pos hArea_pos hLocal hFluxEnergy
  exact
    clay_direct_sector_with_remaining_obligations_imply_mass_gap
      heps hsector hControl hEnergyDef hGap hContinuumForWitness

end RussoYM

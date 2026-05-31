import RussoYM.ClayEnergyNormCoercivity

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Direct Holonomy Sector

This file Lean-verifies the direct finite-resolution holonomy-sector
separation lemma.

If the measured resolved holonomy observable itself is

  U_n = (links n).prod,

and the fixed resolved nontrivial sector condition is

  2 * eps <= ‖1 - U_n‖

for every `n`, with `eps > 0`, then holonomy separation holds with
witness `delta = 2 * eps`.

This is not an energy assumption and does not assert a mass gap. It only
packages the finite-resolution holonomy-sector distinction.
-/

/--
Direct finite-resolution holonomy-sector membership gives the holonomy
separation existence obligation.
-/
theorem ClayHolonomySeparationExistenceAssumptions.of_direct_sector
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {eps : Real}
    (heps :
      0 < eps)
    (hsector :
      forall n, 2 * eps <= ‖1 - (links n).prod‖) :
    ClayHolonomySeparationExistenceAssumptions links := by
  exact
    { exists_separation :=
        ⟨2 * eps,
          by linarith,
          hsector⟩ }

/--
Direct finite-resolution sector membership exposes the delta witness.
-/
theorem exists_delta_of_direct_holonomy_sector
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {eps : Real}
    (heps :
      0 < eps)
    (hsector :
      forall n, 2 * eps <= ‖1 - (links n).prod‖) :
    ∃ delta : Real,
      0 < delta
        ∧ forall n, delta <= ‖1 - (links n).prod‖ := by
  exact
    (ClayHolonomySeparationExistenceAssumptions.of_direct_sector
      heps hsector).exists_separation

/--
The direct sector condition plus the remaining reduced obligations implies
positive continuum Yang--Mills gap.
-/
theorem clay_direct_sector_with_remaining_obligations_imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM eps : Real}
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
  have hSep :
      ClayHolonomySeparationExistenceAssumptions links := by
    exact
      ClayHolonomySeparationExistenceAssumptions.of_direct_sector
        heps hsector
  have hCoercive :
      ClayCurvatureCoercivityExistenceAssumptions
        Energy curvatureNorm := by
    exact
      ClayCurvatureCoercivityExistenceAssumptions.of_energy_norm_identity
        hEnergyDef
  have hCompact :
      ClayCompactNontrivialHolonomySectorCertificate links := by
    exact
      { exists_compact_sector_data :=
          ⟨fun U : R => 2 * eps <= ‖1 - U‖,
            hsector,
            ⟨2 * eps,
              by linarith,
              by
                intro U hU
                exact hU⟩⟩ }
  exact
    clay_compact_sector_with_continuum_transfer_imply_mass_gap
      hCompact
      hControl
      hCoercive
      hGap
      hContinuumForWitness

/--
The direct sector condition plus the remaining reduced obligations implies the
mass-gap summary.
-/
theorem clay_direct_sector_with_remaining_obligations_imply_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM eps : Real}
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
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  have hCoercive :
      ClayCurvatureCoercivityExistenceAssumptions
        Energy curvatureNorm := by
    exact
      ClayCurvatureCoercivityExistenceAssumptions.of_energy_norm_identity
        hEnergyDef
  have hCompact :
      ClayCompactNontrivialHolonomySectorCertificate links := by
    exact
      { exists_compact_sector_data :=
          ⟨fun U : R => 2 * eps <= ‖1 - U‖,
            hsector,
            ⟨2 * eps,
              by linarith,
              by
                intro U hU
                exact hU⟩⟩ }
  exact
    clay_compact_sector_with_continuum_transfer_imply_mass_gap_summary
      hCompact
      hControl
      hCoercive
      hGap
      hContinuumForWitness

end RussoYM

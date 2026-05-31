import RussoYM.ClayContinuumTransferReduction

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Reduced Analytic Roadmap

This file records the current reduced analytic roadmap.

After constructing scale transfer witnesses and Schur/Feshbach zero-loss
witnesses, the proof no longer needs seven independent analytic obligations.

The remaining roadmap is:

1. compact/nontrivial holonomy sector separation,
2. holonomy-curvature control,
3. curvature coercivity,
4. finite gap lower comparison,
5. continuum transfer/survival.

These five obligations imply the current conditional Yang--Mills mass-gap
endpoint.
-/

/--
The reduced five analytic obligations after transfer witness construction.
-/
structure ClayReducedFiveAnalyticObligations
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM : Real) : Prop where
  compactSector :
    ClayCompactNontrivialHolonomySectorCertificate links
  holonomyCurvatureControl :
    ClayHolonomyCurvatureControlExistenceAssumptions
      links curvatureNorm
  curvatureCoercivity :
    ClayCurvatureCoercivityExistenceAssumptions
      Energy curvatureNorm
  finiteGapLowerComparison :
    ClayFiniteGapLowerComparisonAssumptions Gap Energy
  continuumTransfer :
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
        Delta0 <= DeltaYM

/--
The reduced five obligations imply positive continuum Yang--Mills gap.
-/
theorem ClayReducedFiveAnalyticObligations.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayReducedFiveAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    0 < DeltaYM := by
  exact
    clay_compact_sector_with_continuum_transfer_imply_mass_gap
      h.compactSector
      h.holonomyCurvatureControl
      h.curvatureCoercivity
      h.finiteGapLowerComparison
      h.continuumTransfer

/--
The reduced five obligations imply the mass-gap summary.
-/
theorem ClayReducedFiveAnalyticObligations.imply_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayReducedFiveAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    clay_compact_sector_with_continuum_transfer_imply_mass_gap_summary
      h.compactSector
      h.holonomyCurvatureControl
      h.curvatureCoercivity
      h.finiteGapLowerComparison
      h.continuumTransfer

/--
The reduced five obligations imply the earlier seven-obligation package.

The scale and Schur transfer obligations are filled using the constructive
witnesses from `ClayTransferWitnessConstruction`.
-/
theorem ClayReducedFiveAnalyticObligations.to_seven_analytic_obligations
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayReducedFiveAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    ClaySevenAnalyticObligations
      links Gap Energy curvatureNorm DeltaYM := by
  exact
    { holonomySeparation :=
        ClayCompactNontrivialHolonomySectorCertificate.to_holonomy_separation_existence
          h.compactSector
      holonomyCurvatureControl :=
        h.holonomyCurvatureControl
      curvatureCoercivity :=
        h.curvatureCoercivity
      finiteGapLowerComparison :=
        h.finiteGapLowerComparison
      scaleTransfer := by
        intro C mu delta hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound
        exact
          ClayScaleTransferExistenceAssumptions.of_block_positive
            (concrete_block_positive_of_positive_constants
              hDelta_pos hC_pos hMu_pos)
      schurTransfer := by
        intro C mu delta hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound Delta0 dUV hUV_pos hDelta0_def
        exact
          ClaySchurLossTransferExistenceAssumptions.of_scale_data_and_block_positive
            (concrete_block_positive_of_positive_constants
              hDelta_pos hC_pos hMu_pos)
            hUV_pos
            hDelta0_def
      continuumTransfer := by
        intro C mu delta hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound Delta0 dUV hUV_pos hDelta0_def
        exact
          ClayContinuumTransferAssumptions.of_delta0_le_deltaYM
            (h.continuumTransfer
              C mu delta
              hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound
              Delta0 dUV hUV_pos hDelta0_def) }

/--
The reduced five obligations imply the current proof-state theorem.
-/
theorem clay_reduced_five_obligations_current_proof_state_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayReducedFiveAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    0 < DeltaYM := by
  exact ClayReducedFiveAnalyticObligations.imply_positive_continuum_gap h

end RussoYM

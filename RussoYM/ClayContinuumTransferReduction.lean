import RussoYM.ClayTransferWitnessConstruction

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Continuum Transfer Reduction

This file records the first real simplification of the seven analytic
obligations.

The transfer side originally had:

1. scale transfer existence,
2. Schur/Feshbach loss transfer existence,
3. continuum transfer.

After `ClayTransferWitnessConstruction`, the first two are constructible from
the positive concrete block

  mu * (delta / C)^2.

Since the block is positive whenever `delta > 0`, `C > 0`, and `mu > 0`,
the transfer side reduces to the continuum survival inequality:

  Delta0 <= DeltaYM.
-/

/--
Positive constants imply positivity of the concrete block.
-/
theorem concrete_block_positive_of_positive_constants
    {C mu delta : Real}
    (hDelta_pos :
      0 < delta)
    (hC_pos :
      0 < C)
    (hMu_pos :
      0 < mu) :
    0 < mu * (delta / C)^2 := by
  have hDiv_pos :
      0 < delta / C := by
    exact div_pos hDelta_pos hC_pos
  have hSq_pos :
      0 < (delta / C)^2 := by
    exact sq_pos_of_pos hDiv_pos
  exact mul_pos hMu_pos hSq_pos

/--
For positive holonomy/coercivity constants, raw transfer existence reduces to
continuum transfer for the scale witnesses.
-/
theorem ClayRawTransferExistenceAssumptions.of_positive_constants_and_continuum_transfer
    {DeltaYM C mu delta : Real}
    (hDelta_pos :
      0 < delta)
    (hC_pos :
      0 < C)
    (hMu_pos :
      0 < mu)
    (hContinuumForScale :
      forall Delta0 dUV : Real,
        0 < dUV ->
        Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
        Delta0 <= DeltaYM) :
    ClayRawTransferExistenceAssumptions DeltaYM C mu delta := by
  have hBlock_pos :
      0 < mu * (delta / C)^2 := by
    exact
      concrete_block_positive_of_positive_constants
        hDelta_pos hC_pos hMu_pos
  exact
    ClayRawTransferExistenceAssumptions.of_block_positive_and_continuum_transfer
      hBlock_pos hContinuumForScale

/--
For positive holonomy/coercivity constants, transfer gap data reduces to
continuum transfer for the scale witnesses.
-/
theorem transfer_gap_data_of_positive_constants_and_continuum_transfer
    {DeltaYM C mu delta : Real}
    (hDelta_pos :
      0 < delta)
    (hC_pos :
      0 < C)
    (hMu_pos :
      0 < mu)
    (hContinuumForScale :
      forall Delta0 dUV : Real,
        0 < dUV ->
        Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
        Delta0 <= DeltaYM) :
    ∃ DeltaFine Delta0 : Real,
      Delta0 <= DeltaFine
        ∧ 0 < Delta0
        ∧ 0 < DeltaFine
        ∧ Delta0 <= DeltaYM
        ∧ 0 < DeltaYM := by
  have hBlock_pos :
      0 < mu * (delta / C)^2 := by
    exact
      concrete_block_positive_of_positive_constants
        hDelta_pos hC_pos hMu_pos
  exact
    transfer_gap_data_of_block_positive_and_continuum_transfer
      hBlock_pos hContinuumForScale

/--
With compact sector separation and the holonomy/coercivity/gap obligations,
the remaining analytic transfer burden is only continuum transfer.
-/
theorem clay_compact_sector_with_continuum_transfer_imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hCompactSector :
      ClayCompactNontrivialHolonomySectorCertificate links)
    (hControl :
      ClayHolonomyCurvatureControlExistenceAssumptions
        links curvatureNorm)
    (hCoercive :
      ClayCurvatureCoercivityExistenceAssumptions
        Energy curvatureNorm)
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
      ClayCompactNontrivialHolonomySectorCertificate.to_holonomy_separation_existence
        hCompactSector
  have hHol :
      ClayRawHolonomyExistenceAssumptions
        links Gap Energy curvatureNorm := by
    exact
      clay_holonomy_sub_obligations_to_raw_holonomy_existence
        hSep hControl hCoercive hGap
  exact
    clay_two_obligations_conditional_yang_mills_mass_gap
      hHol
      (fun C mu delta
          hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound =>
        ClayRawTransferExistenceAssumptions.of_positive_constants_and_continuum_transfer
          hDelta_pos hC_pos hMu_pos
          (hContinuumForWitness
            C mu delta
            hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound))

/--
With compact sector separation and the holonomy/coercivity/gap obligations,
continuum transfer implies the mass-gap summary.
-/
theorem clay_compact_sector_with_continuum_transfer_imply_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hCompactSector :
      ClayCompactNontrivialHolonomySectorCertificate links)
    (hControl :
      ClayHolonomyCurvatureControlExistenceAssumptions
        links curvatureNorm)
    (hCoercive :
      ClayCurvatureCoercivityExistenceAssumptions
        Energy curvatureNorm)
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
  have hSep :
      ClayHolonomySeparationExistenceAssumptions links := by
    exact
      ClayCompactNontrivialHolonomySectorCertificate.to_holonomy_separation_existence
        hCompactSector
  have hHol :
      ClayRawHolonomyExistenceAssumptions
        links Gap Energy curvatureNorm := by
    exact
      clay_holonomy_sub_obligations_to_raw_holonomy_existence
        hSep hControl hCoercive hGap
  exact
    clay_two_obligations_mass_gap_summary
      hHol
      (fun C mu delta
          hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound =>
        ClayRawTransferExistenceAssumptions.of_positive_constants_and_continuum_transfer
          hDelta_pos hC_pos hMu_pos
          (hContinuumForWitness
            C mu delta
            hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound))

end RussoYM

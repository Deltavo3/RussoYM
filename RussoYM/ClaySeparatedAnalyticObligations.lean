import RussoYM.ClayExplicitRawDataWitnessPackage

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Separated Analytic Obligations

This file separates the remaining fully raw Clay theorem into analytic
existence obligations.

The explicit raw-data theorem assumes all constants at once:

  DeltaFine, Delta0, dUV, C, mu, delta, loss.

This file separates the obligation into two layers:

1. holonomy/coercivity existence:
   produce `C`, `mu`, and `delta` satisfying the raw holonomy, curvature-control,
   coercivity, and finite-gap lower data;

2. transfer existence:
   for those constants, produce `DeltaFine`, `Delta0`, `dUV`, and `loss`
   satisfying the scale, Schur/Feshbach, and continuum-transfer data.

This is the clean ledger of the hard remaining analytic work.
-/

/--
Raw transfer existence for fixed `C`, `mu`, and `delta`.

This packages the scale, Schur/Feshbach, and continuum-transfer constants.
-/
structure ClayRawTransferExistenceAssumptions
    (DeltaYM C mu delta : Real) : Prop where
  exists_transfer_data :
    ∃ DeltaFine Delta0 dUV loss : Real,
      0 < dUV
        ∧ Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV
        ∧ loss <= Delta0
        ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine
        ∧ Delta0 <= DeltaYM

/--
Separated analytic obligations.

This separates the proof into:

1. existence of holonomy/coercivity constants `C`, `mu`, `delta`;
2. existence of transfer constants `DeltaFine`, `Delta0`, `dUV`, `loss`.
-/
structure ClaySeparatedAnalyticObligations
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM : Real) : Prop where
  exists_separated_data :
    ∃ C mu delta : Real,
      0 < delta
        ∧ (forall n, delta <= ‖1 - (links n).prod‖)
        ∧ 0 < C
        ∧ (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n)
        ∧ 0 < mu
        ∧ (forall n, mu * (curvatureNorm n)^2 <= Energy n)
        ∧ (forall n, Energy n <= Gap n)
        ∧ ClayRawTransferExistenceAssumptions DeltaYM C mu delta

/--
Raw transfer existence exposes its constants.
-/
theorem ClayRawTransferExistenceAssumptions.exists_transfer_witness_data
    {DeltaYM C mu delta : Real}
    (h :
      ClayRawTransferExistenceAssumptions DeltaYM C mu delta) :
    ∃ DeltaFine Delta0 dUV loss : Real,
      0 < dUV
        ∧ Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV
        ∧ loss <= Delta0
        ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine
        ∧ Delta0 <= DeltaYM := by
  exact h.exists_transfer_data

/--
Separated analytic obligations imply explicit raw-data assumptions.
-/
theorem ClaySeparatedAnalyticObligations.to_explicit_raw_data_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClaySeparatedAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    ClayExplicitRawDataAssumptions
      links Gap Energy curvatureNorm DeltaYM := by
  rcases h.exists_separated_data with
    ⟨C, mu, delta,
      hDelta_pos,
      hSep,
      hC_pos,
      hControl,
      hMu_pos,
      hEnergy,
      hGap,
      hTransfer⟩
  rcases hTransfer.exists_transfer_data with
    ⟨DeltaFine, Delta0, dUV, loss,
      hUV_pos,
      hDelta0_def,
      hLoss,
      hLower,
      hCont⟩
  exact
    { exists_explicit_raw_data :=
        ⟨DeltaFine, Delta0, dUV, C, mu, delta, loss,
          hDelta_pos,
          hSep,
          hC_pos,
          hControl,
          hMu_pos,
          hEnergy,
          hGap,
          hUV_pos,
          hDelta0_def,
          hLoss,
          hLower,
          hCont⟩ }

/--
Separated analytic obligations imply positive continuum Yang--Mills gap.
-/
theorem ClaySeparatedAnalyticObligations.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClaySeparatedAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    0 < DeltaYM := by
  exact
    ClayExplicitRawDataAssumptions.imply_positive_continuum_gap
      (ClaySeparatedAnalyticObligations.to_explicit_raw_data_assumptions h)

/--
Separated analytic obligations imply the mass-gap summary.
-/
theorem ClaySeparatedAnalyticObligations.imply_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClaySeparatedAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayExplicitRawDataAssumptions.imply_mass_gap_summary
      (ClaySeparatedAnalyticObligations.to_explicit_raw_data_assumptions h)

/--
Separated analytic obligations imply the concrete witness package.
-/
theorem ClaySeparatedAnalyticObligations.imply_exists_concrete_witness_package
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClaySeparatedAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    ∃ DeltaFine Delta0 dUV C mu delta : Real,
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta
        ∧ ((0 < mu * (delta / C)^2
              ∧ forall n, mu * (delta / C)^2 <= Gap n)
            ∧ (0 < Delta0
                ∧ Delta0 <= DeltaFine
                ∧ Delta0 <= DeltaYM)
            ∧ 0 < DeltaYM) := by
  exact
    ClayExplicitRawDataAssumptions.imply_exists_concrete_witness_package
      (ClaySeparatedAnalyticObligations.to_explicit_raw_data_assumptions h)

/--
Headline separated analytic-obligation conditional Yang--Mills mass-gap theorem.
-/
theorem clay_separated_analytic_obligations_conditional_yang_mills_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClaySeparatedAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    0 < DeltaYM := by
  exact ClaySeparatedAnalyticObligations.imply_positive_continuum_gap h

end RussoYM

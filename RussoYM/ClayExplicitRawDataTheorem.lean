import RussoYM.ClayExistentialWitnessPackage

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Explicit Raw Data Theorem

This file packages the fully raw Clay theorem with all constants and the Schur
loss witness exposed explicitly.

Instead of assuming

  ∃ loss, loss <= Delta0 ∧ ...

inside `ClayFullyRawAssumptions`, this file assumes explicit existence of

  DeltaFine, Delta0, dUV, C, mu, delta, loss

satisfying all raw inequalities.

This is a very paper-readable endpoint before attacking the analytic existence
of those constants.
-/

/--
Explicit raw data assumptions.

There exist constants

  DeltaFine, Delta0, dUV, C, mu, delta, loss

satisfying the fully raw Clay inequalities.
-/
structure ClayExplicitRawDataAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM : Real) : Prop where
  exists_explicit_raw_data :
    ∃ DeltaFine Delta0 dUV C mu delta loss : Real,
      0 < delta
        ∧ (forall n, delta <= ‖1 - (links n).prod‖)
        ∧ 0 < C
        ∧ (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n)
        ∧ 0 < mu
        ∧ (forall n, mu * (curvatureNorm n)^2 <= Energy n)
        ∧ (forall n, Energy n <= Gap n)
        ∧ 0 < dUV
        ∧ Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV
        ∧ loss <= Delta0
        ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine
        ∧ Delta0 <= DeltaYM

/--
Explicit raw data assumptions imply fully raw assumptions with existential
Schur loss.
-/
theorem ClayExplicitRawDataAssumptions.to_existential_fully_raw_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExplicitRawDataAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    ClayExistentialFullyRawAssumptions
      links Gap Energy curvatureNorm DeltaYM := by
  rcases h.exists_explicit_raw_data with
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
      hCont⟩
  exact
    { exists_raw_data :=
        ⟨DeltaFine, Delta0, dUV, C, mu, delta,
          { hDelta_pos := hDelta_pos
            hHolonomySep := hSep
            hC_pos := hC_pos
            hHolonomyControl := hControl
            hMu_pos := hMu_pos
            hEnergyCoercive := hEnergy
            hGapLower := hGap
            hUV_pos := hUV_pos
            hDelta0_def := hDelta0_def
            existsRawSchur := ⟨loss, hLoss, hLower⟩
            hContinuumSurvival := hCont }⟩ }

/--
Explicit raw data theorem: positive continuum Yang--Mills gap.
-/
theorem ClayExplicitRawDataAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExplicitRawDataAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    0 < DeltaYM := by
  exact
    ClayExistentialFullyRawAssumptions.imply_positive_continuum_gap
      (ClayExplicitRawDataAssumptions.to_existential_fully_raw_assumptions h)

/--
Explicit raw data theorem: finite-regulator mass-gap summary plus positive
continuum gap.
-/
theorem ClayExplicitRawDataAssumptions.imply_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExplicitRawDataAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayExistentialFullyRawAssumptions.imply_mass_gap_summary
      (ClayExplicitRawDataAssumptions.to_existential_fully_raw_assumptions h)

/--
Explicit raw data theorem: concrete witness package.
-/
theorem ClayExplicitRawDataAssumptions.imply_exists_concrete_witness_package
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExplicitRawDataAssumptions
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
    ClayExistentialFullyRawAssumptions.imply_exists_concrete_witness_package
      (ClayExplicitRawDataAssumptions.to_existential_fully_raw_assumptions h)

/--
Headline explicit raw-data conditional Yang--Mills mass-gap theorem.
-/
theorem clay_explicit_raw_data_conditional_yang_mills_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExplicitRawDataAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    0 < DeltaYM := by
  exact ClayExplicitRawDataAssumptions.imply_positive_continuum_gap h

end RussoYM

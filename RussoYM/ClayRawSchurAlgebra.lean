import RussoYM.ClayFullyRawPointwiseGapChain

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Raw Schur Algebra

This file extracts the raw algebra behind the Schur/Feshbach transfer step.

The Schur side uses:

  Delta0 = (1 / 2) * min dBlock dUV,
  loss <= Delta0,
  min dBlock dUV - loss <= DeltaFine.

From these, the raw algebra gives:

  Delta0 <= DeltaFine.

This makes the fine-gap transfer independent of the packaged Schur assumptions.
-/

/--
Raw Schur algebra: the loss budget transfers `Delta0` into `DeltaFine`.
-/
theorem raw_schur_loss_transfer
    {DeltaFine Delta0 dBlock dUV loss : Real}
    (hDelta0_def :
      Delta0 = (1 / 2) * min dBlock dUV)
    (hLoss :
      loss <= Delta0)
    (hLower :
      min dBlock dUV - loss <= DeltaFine) :
    Delta0 <= DeltaFine := by
  nlinarith [hDelta0_def, hLoss, hLower]

/--
Raw Schur algebra with positivity: if `Delta0` is positive, then the transferred
fine gap is positive.
-/
theorem raw_schur_loss_transfer_positive
    {DeltaFine Delta0 dBlock dUV loss : Real}
    (hDelta0_pos :
      0 < Delta0)
    (hDelta0_def :
      Delta0 = (1 / 2) * min dBlock dUV)
    (hLoss :
      loss <= Delta0)
    (hLower :
      min dBlock dUV - loss <= DeltaFine) :
    0 < DeltaFine := by
  have hDelta0_le_DeltaFine :
      Delta0 <= DeltaFine := by
    exact raw_schur_loss_transfer hDelta0_def hLoss hLower
  exact lt_of_lt_of_le hDelta0_pos hDelta0_le_DeltaFine

/--
Raw Schur algebra from an existential loss witness.
-/
theorem raw_schur_exists_loss_transfer
    {DeltaFine Delta0 dBlock dUV : Real}
    (hDelta0_def :
      Delta0 = (1 / 2) * min dBlock dUV)
    (hExists :
      ∃ loss : Real,
        loss <= Delta0
          ∧ min dBlock dUV - loss <= DeltaFine) :
    Delta0 <= DeltaFine := by
  rcases hExists with ⟨loss, hLoss, hLower⟩
  exact raw_schur_loss_transfer hDelta0_def hLoss hLower

/--
Raw Schur algebra from an existential loss witness, with positivity.
-/
theorem raw_schur_exists_loss_transfer_positive
    {DeltaFine Delta0 dBlock dUV : Real}
    (hDelta0_pos :
      0 < Delta0)
    (hDelta0_def :
      Delta0 = (1 / 2) * min dBlock dUV)
    (hExists :
      ∃ loss : Real,
        loss <= Delta0
          ∧ min dBlock dUV - loss <= DeltaFine) :
    0 < DeltaFine := by
  have hDelta0_le_DeltaFine :
      Delta0 <= DeltaFine := by
    exact raw_schur_exists_loss_transfer hDelta0_def hExists
  exact lt_of_lt_of_le hDelta0_pos hDelta0_le_DeltaFine

/--
Fully raw assumptions imply `Delta0 <= DeltaFine` by direct raw Schur algebra.
-/
theorem ClayFullyRawAssumptions.imply_delta0_le_deltaFine_by_raw_schur_algebra
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 <= DeltaFine := by
  exact
    raw_schur_exists_loss_transfer
      h.hDelta0_def h.existsRawSchur

/--
Fully raw assumptions imply positivity of `DeltaFine` by direct raw Schur
algebra.
-/
theorem ClayFullyRawAssumptions.imply_deltaFine_positive_by_raw_schur_algebra
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaFine := by
  exact
    raw_schur_exists_loss_transfer_positive
      (ClayFullyRawAssumptions.imply_concrete_delta0_positive h)
      h.hDelta0_def h.existsRawSchur

/--
Fully raw assumptions imply fine-gap transfer data by direct raw Schur algebra.
-/
theorem ClayFullyRawAssumptions.imply_fine_gap_data_by_raw_schur_algebra
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact
    ⟨ClayFullyRawAssumptions.imply_delta0_le_deltaFine_by_raw_schur_algebra h,
      ClayFullyRawAssumptions.imply_concrete_delta0_positive h,
      ClayFullyRawAssumptions.imply_deltaFine_positive_by_raw_schur_algebra h⟩

end RussoYM

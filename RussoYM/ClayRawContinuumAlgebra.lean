import RussoYM.ClayRawSchurAlgebra

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Raw Continuum Algebra

This file extracts the raw algebra behind the continuum survival step.

The continuum side uses:

  0 < Delta0,
  Delta0 <= DeltaYM.

From these, the raw algebra gives:

  0 < DeltaYM.

This makes the final continuum transfer independent of packaged continuum
primitive assumptions.
-/

/--
Raw continuum algebra: a positive lower scale transfers to a positive continuum
gap.
-/
theorem raw_continuum_transfer_positive
    {DeltaYM Delta0 : Real}
    (hDelta0_pos :
      0 < Delta0)
    (hTransfer :
      Delta0 <= DeltaYM) :
    0 < DeltaYM := by
  exact lt_of_lt_of_le hDelta0_pos hTransfer

/--
Raw continuum algebra: continuum survival gives both the transfer inequality
and positivity of the continuum gap.
-/
theorem raw_continuum_transfer_data
    {DeltaYM Delta0 : Real}
    (hDelta0_pos :
      0 < Delta0)
    (hTransfer :
      Delta0 <= DeltaYM) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact ⟨hTransfer, raw_continuum_transfer_positive hDelta0_pos hTransfer⟩

/--
Fully raw assumptions imply positive continuum Yang--Mills gap by direct raw
continuum algebra.
-/
theorem ClayFullyRawAssumptions.imply_positive_continuum_gap_by_raw_continuum_algebra
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
    0 < DeltaYM := by
  exact
    raw_continuum_transfer_positive
      (ClayFullyRawAssumptions.imply_concrete_delta0_positive h)
      h.hContinuumSurvival

/--
Fully raw assumptions imply continuum gap data by direct raw continuum algebra.
-/
theorem ClayFullyRawAssumptions.imply_continuum_gap_data_by_raw_continuum_algebra
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
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact
    raw_continuum_transfer_data
      (ClayFullyRawAssumptions.imply_concrete_delta0_positive h)
      h.hContinuumSurvival

/--
Fully raw assumptions imply both fine-gap and continuum-gap transfer data by
direct raw algebra.
-/
theorem ClayFullyRawAssumptions.imply_fine_and_continuum_data_by_raw_algebra
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
    (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM) := by
  exact
    ⟨ClayFullyRawAssumptions.imply_fine_gap_data_by_raw_schur_algebra h,
      ClayFullyRawAssumptions.imply_continuum_gap_data_by_raw_continuum_algebra h⟩

end RussoYM

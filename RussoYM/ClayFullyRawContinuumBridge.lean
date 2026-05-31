import RussoYM.ClayFullyRawFineGapBridge

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Fully Raw Continuum Bridge

This file extracts the continuum gap data directly from the fully raw Clay
assumptions.

The fully raw assumptions contain:

1. raw scale data, giving `0 < Delta0`,
2. raw continuum survival, giving `Delta0 <= DeltaYM`.

Together these imply:

  Delta0 <= DeltaYM,
  0 < DeltaYM.
-/

/--
Fully raw assumptions imply the continuum primitive obligation.
-/
theorem ClayFullyRawAssumptions.to_continuum_primitive_obligation
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
    ClayContinuumPrimitiveObligation DeltaYM Delta0 := by
  exact
    ClayContinuumPrimitiveObligation.of_delta0_le_deltaYM
      h.hContinuumSurvival

/--
Fully raw assumptions imply the continuum survival inequality.
-/
theorem ClayFullyRawAssumptions.imply_delta0_le_deltaYM_via_raw_continuum
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
    Delta0 <= DeltaYM := by
  exact h.hContinuumSurvival

/--
Fully raw assumptions imply continuum gap data.
-/
theorem ClayFullyRawAssumptions.imply_continuum_gap_data_via_raw_continuum
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
  have hDelta0_pos : 0 < Delta0 := by
    exact ClayFullyRawAssumptions.imply_delta0_positive_via_raw_scale h
  exact
    ClayContinuumPrimitiveObligation.imply_continuum_gap_data_of_delta0_pos
      (ClayFullyRawAssumptions.to_continuum_primitive_obligation h)
      hDelta0_pos

/--
Fully raw assumptions imply a positive continuum Yang--Mills gap.
-/
theorem ClayFullyRawAssumptions.imply_positive_continuum_gap_via_raw_continuum
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
    (ClayFullyRawAssumptions.imply_continuum_gap_data_via_raw_continuum h).2

end RussoYM

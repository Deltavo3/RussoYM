import RussoYM.ClayFullyRawHolonomyBridge

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Fully Raw Fine Gap Bridge

This file extracts the Layer-One fine-gap data directly from the fully raw
Clay assumptions.

The fully raw assumptions contain:

1. raw holonomy/coercivity data, giving block positivity,
2. raw scale data, giving Delta0 normalization,
3. raw Schur/Feshbach loss bounds.

Together these imply:

  Delta0 <= DeltaFine,
  0 < Delta0,
  0 < DeltaFine.
-/

/--
Fully raw assumptions imply the primitive scale obligation.
-/
theorem ClayFullyRawAssumptions.to_scale_primitive_obligation
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
    ClayScalePrimitiveObligation
      Delta0 (mu * (delta / C)^2) dUV := by
  exact
    ClayScalePrimitiveObligation.of_uv_pos_and_delta0_def
      h.hUV_pos h.hDelta0_def

/--
Fully raw assumptions imply the primitive Schur obligation.
-/
theorem ClayFullyRawAssumptions.to_schur_primitive_obligation
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
    ClaySchurPrimitiveObligation
      DeltaFine Delta0 (mu * (delta / C)^2) dUV := by
  rcases h.existsRawSchur with ⟨loss, hLoss, hLower⟩
  exact
    ClaySchurPrimitiveObligation.of_raw_loss_bounds
      hLoss hLower

/--
Fully raw assumptions imply `Delta0 <= DeltaFine`.
-/
theorem ClayFullyRawAssumptions.imply_delta0_le_deltaFine_via_raw_schur
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
    ClaySchurPrimitiveObligation.imply_delta0_le_deltaFine
      (ClayFullyRawAssumptions.to_scale_primitive_obligation h)
      (ClayFullyRawAssumptions.to_schur_primitive_obligation h)

/--
Fully raw assumptions imply positivity of Delta0.
-/
theorem ClayFullyRawAssumptions.imply_delta0_positive_via_raw_scale
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
    0 < Delta0 := by
  have hBlock_pos :
      0 < mu * (delta / C)^2 := by
    exact ClayFullyRawAssumptions.imply_block_scale_positive_via_raw_holonomy h
  exact
    ClayScalePrimitiveObligation.imply_delta0_positive_of_block_pos
      hBlock_pos
      (ClayFullyRawAssumptions.to_scale_primitive_obligation h)

/--
Fully raw assumptions imply Layer-One fine gap data.
-/
theorem ClayFullyRawAssumptions.imply_layer_one_fine_gap_data_via_raw_schur
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
  have hDelta0_le_DeltaFine :
      Delta0 <= DeltaFine := by
    exact ClayFullyRawAssumptions.imply_delta0_le_deltaFine_via_raw_schur h
  have hDelta0_pos : 0 < Delta0 := by
    exact ClayFullyRawAssumptions.imply_delta0_positive_via_raw_scale h
  have hDeltaFine_pos : 0 < DeltaFine := by
    exact lt_of_lt_of_le hDelta0_pos hDelta0_le_DeltaFine
  exact ⟨hDelta0_le_DeltaFine, hDelta0_pos, hDeltaFine_pos⟩

end RussoYM

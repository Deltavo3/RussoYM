import RussoYM.ClayReducedPrimitiveObligations

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Schur Primitive

This file handles the Schur/Feshbach primitive obligation.

The current Schur primitive obligation is:

  ∃ loss,
    loss <= Delta0
      ∧ min(dBlock,dUV) - loss <= DeltaFine.

This file gives direct constructors and consequences for that obligation.
-/

/--
Construct a Schur loss-budget packet from the raw inequality `loss <= Delta0`.
-/
theorem SchurLossBudgetAssumptions.of_loss_le_delta0
    {loss Delta0 : Real}
    (hLoss : loss <= Delta0) :
    SchurLossBudgetAssumptions loss Delta0 := by
  exact
    { loss_le_delta0 := hLoss }

/--
Construct a Schur/Feshbach lower packet from the raw inequality

  min dBlock dUV - loss <= DeltaFine.
-/
theorem SchurFeshbachLossLowerAssumptions.of_schur_loss_lower
    {DeltaFine dBlock dUV loss : Real}
    (hLower : min dBlock dUV - loss <= DeltaFine) :
    SchurFeshbachLossLowerAssumptions DeltaFine dBlock dUV loss := by
  exact
    { schur_loss_lower := hLower }

/--
Construct the primitive Schur obligation from a concrete loss, a loss budget,
and a Schur/Feshbach lower bound.
-/
theorem ClaySchurPrimitiveObligation.of_loss_budget_and_schur_lower
    {DeltaFine Delta0 dBlock dUV loss : Real}
    (hLossBudget :
      SchurLossBudgetAssumptions loss Delta0)
    (hSchur :
      SchurFeshbachLossLowerAssumptions DeltaFine dBlock dUV loss) :
    ClaySchurPrimitiveObligation DeltaFine Delta0 dBlock dUV := by
  exact ⟨loss, hLossBudget, hSchur⟩

/--
Construct the primitive Schur obligation directly from raw inequalities.
-/
theorem ClaySchurPrimitiveObligation.of_raw_loss_bounds
    {DeltaFine Delta0 dBlock dUV loss : Real}
    (hLoss : loss <= Delta0)
    (hLower : min dBlock dUV - loss <= DeltaFine) :
    ClaySchurPrimitiveObligation DeltaFine Delta0 dBlock dUV := by
  exact
    ClaySchurPrimitiveObligation.of_loss_budget_and_schur_lower
      (SchurLossBudgetAssumptions.of_loss_le_delta0 hLoss)
      (SchurFeshbachLossLowerAssumptions.of_schur_loss_lower hLower)

/--
Primitive Schur obligation plus primitive scale data implies
`Delta0 <= DeltaFine`.
-/
theorem ClaySchurPrimitiveObligation.imply_delta0_le_deltaFine
    {DeltaFine Delta0 dBlock dUV : Real}
    (hScale :
      ClayScalePrimitiveObligation Delta0 dBlock dUV)
    (hSchur :
      ClaySchurPrimitiveObligation DeltaFine Delta0 dBlock dUV) :
    Delta0 <= DeltaFine := by
  rcases hSchur with ⟨loss, hLossBudget, hSchurLower⟩
  exact
    SchurFeshbachLossLowerAssumptions.imply_delta0_le_deltaFine_of_loss_budget
      hScale hLossBudget hSchurLower

/--
Primitive Schur obligation plus primitive scale data and block positivity gives
Layer-One fine gap data.
-/
theorem ClaySchurPrimitiveObligation.imply_layer_one_fine_gap_data
    {DeltaFine Delta0 dBlock dUV : Real}
    (hBlock_pos : 0 < dBlock)
    (hScale :
      ClayScalePrimitiveObligation Delta0 dBlock dUV)
    (hSchur :
      ClaySchurPrimitiveObligation DeltaFine Delta0 dBlock dUV) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  have hDelta0_le_DeltaFine :
      Delta0 <= DeltaFine := by
    exact ClaySchurPrimitiveObligation.imply_delta0_le_deltaFine hScale hSchur
  have hDelta0_pos : 0 < Delta0 := by
    exact
      ClayScalePrimitiveObligation.imply_delta0_positive_of_block_pos
        hBlock_pos hScale
  have hDeltaFine_pos : 0 < DeltaFine := by
    exact lt_of_lt_of_le hDelta0_pos hDelta0_le_DeltaFine
  exact ⟨hDelta0_le_DeltaFine, hDelta0_pos, hDeltaFine_pos⟩

/--
In the Clay route, holonomy supplies block positivity, so holonomy + scale +
Schur primitive data gives Layer-One fine gap data.
-/
theorem ClaySchurPrimitiveObligation.imply_layer_one_fine_gap_data_from_holonomy
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaFine Delta0 dUV C mu delta : Real}
    (hHolonomy :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta)
    (hScale :
      ClayScalePrimitiveObligation
        Delta0 (mu * (delta / C)^2) dUV)
    (hSchur :
      ClaySchurPrimitiveObligation
        DeltaFine Delta0 (mu * (delta / C)^2) dUV) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  have hBlock_pos :
      0 < mu * (delta / C)^2 := by
    exact UniformHolonomyRedLemmaAssumptions.imply_block_scale_positive hHolonomy
  exact
    ClaySchurPrimitiveObligation.imply_layer_one_fine_gap_data
      hBlock_pos hScale hSchur

end RussoYM

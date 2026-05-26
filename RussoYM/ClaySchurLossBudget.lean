import Mathlib
import RussoYM.ClaySchurLossTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Schur Loss Budget

This file extracts the key budget bridge behind the Schur/Feshbach step.

The core observation is:

  Delta0 = (1 / 2) * min(block, dUV),
  loss <= Delta0,
  min(block, dUV) - loss <= DeltaFine

implies

  Delta0 <= DeltaFine.

This separates the analytic Schur/Feshbach lower bound from the algebraic
loss-budget argument.
-/

/--
A Schur loss budget relative to `Delta0`.
-/
structure SchurLossBudgetAssumptions
    (loss Delta0 : Real) : Prop where
  loss_le_delta0 :
    loss <= Delta0

/--
Mixing scale data, kappa decay, and the concrete loss identity imply the Schur
loss budget `loss <= Delta0`.
-/
theorem KappaMixingLossIdentity.imply_loss_budget
    {Cmix eps ell q Delta0 loss : Real}
    {kappa : Nat}
    (hScale : Delta0MixingScaleData Cmix eps ell q)
    (hDecay : Delta0MixingKappaDecayBudget Cmix q Delta0 kappa)
    (hLoss : KappaMixingLossIdentity loss Cmix eps ell kappa) :
    SchurLossBudgetAssumptions loss Delta0 := by
  have hDecayFull :
      Delta0MixingDecayBudgetAssumptions Cmix eps ell q Delta0 kappa := by
    exact Delta0MixingScaleData.with_kappa_decay_budget hScale hDecay
  have hSmall :
      Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
    exact Delta0MixingDecayBudgetAssumptions.to_delta0_mixing_smallness hDecayFull
  have hLossLe :
      loss <= Delta0 := by
    rw [hLoss.loss_eq]
    exact hSmall.mixing_small
  exact
    { loss_le_delta0 := hLossLe }

/--
Reduced scale data, Schur loss budget, and Schur/Feshbach lower bound imply
`Delta0 <= DeltaFine`.
-/
theorem SchurFeshbachLossLowerAssumptions.imply_delta0_le_deltaFine_of_loss_budget
    {DeltaFine Delta0 dBlock dUV loss : Real}
    (hScale :
      LayerOneReducedScaleAssumptions Delta0 dBlock dUV)
    (hBudget :
      SchurLossBudgetAssumptions loss Delta0)
    (hSchur :
      SchurFeshbachLossLowerAssumptions DeltaFine dBlock dUV loss) :
    Delta0 <= DeltaFine := by
  have hDelta0Def :
      Delta0 = (1 / 2) * min dBlock dUV := by
    exact hScale.hDelta0_def
  have hMin_eq :
      min dBlock dUV = 2 * Delta0 := by
    linarith
  have hDelta0_le_schur :
      Delta0 <= min dBlock dUV - loss := by
    calc
      Delta0 <= 2 * Delta0 - loss := by
        linarith [hBudget.loss_le_delta0]
      _ = min dBlock dUV - loss := by
        rw [hMin_eq]
  exact le_trans hDelta0_le_schur hSchur.schur_loss_lower
/--
The Schur-loss kappa assumptions imply `Delta0 <= DeltaFine` directly by the
loss-budget bridge.
-/
theorem ClaySchurLossKappaAssumptions.imply_delta0_le_deltaFine_by_loss_budget
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    Delta0 <= DeltaFine := by
  rcases h.existsKappaLoss with ⟨kappa, loss, hDecay, hLoss, hSchur⟩
  have hBudget :
      SchurLossBudgetAssumptions loss Delta0 := by
    exact
      KappaMixingLossIdentity.imply_loss_budget
        h.mixingScaleData hDecay hLoss
  exact
    SchurFeshbachLossLowerAssumptions.imply_delta0_le_deltaFine_of_loss_budget
      h.reducedScalePacket hBudget hSchur

/--
The Schur-loss kappa assumptions imply Layer-One fine lower data by the
loss-budget bridge.
-/
theorem ClaySchurLossKappaAssumptions.imply_layer_one_fine_gap_data_by_loss_budget
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  have hDelta0_le_DeltaFine :
      Delta0 <= DeltaFine := by
    exact ClaySchurLossKappaAssumptions.imply_delta0_le_deltaFine_by_loss_budget h
  have hBlock_pos :
      0 < mu * (delta / C)^2 := by
    exact UniformHolonomyRedLemmaAssumptions.imply_block_scale_positive h.holonomyPacket
  have hPositiveScale :
      LayerOnePositiveScaleAssumptions
        Delta0 (mu * (delta / C)^2) dUV := by
    exact
      LayerOneReducedScaleAssumptions.to_positive_scale
        hBlock_pos h.reducedScalePacket
  have hDelta0_pos : 0 < Delta0 := by
    exact LayerOnePositiveScaleAssumptions.imply_delta0_positive hPositiveScale
  have hDeltaFine_pos : 0 < DeltaFine := by
    exact lt_of_lt_of_le hDelta0_pos hDelta0_le_DeltaFine
  exact ⟨hDelta0_le_DeltaFine, hDelta0_pos, hDeltaFine_pos⟩

end RussoYM

import RussoYM.ClaySchurBudgetTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Continuum Survival Form

This file replaces the abstract epsilon-continuum survival packet by the direct
continuum survival inequality used by the final Clay endpoint:

  Delta0 <= DeltaYM.

Together with positivity of `Delta0`, this gives the positive continuum
Yang--Mills gap:

  0 < DeltaYM.
-/

/--
Direct continuum survival assumption.

This is the exact inequality needed at the final continuum step.
-/
structure ContinuumGapSurvivalAssumptions
    (DeltaYM Delta0 : Real) : Prop where
  delta0_le_deltaYM :
    Delta0 <= DeltaYM

/--
Direct continuum survival plus positivity of `Delta0` gives continuum gap data.
-/
theorem ContinuumGapSurvivalAssumptions.imply_continuum_gap_data
    {DeltaYM Delta0 : Real}
    (hSurvival :
      ContinuumGapSurvivalAssumptions DeltaYM Delta0)
    (hDelta0_pos : 0 < Delta0) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  have hDeltaYM_pos : 0 < DeltaYM := by
    exact lt_of_lt_of_le hDelta0_pos hSurvival.delta0_le_deltaYM
  exact ⟨hSurvival.delta0_le_deltaYM, hDeltaYM_pos⟩

/--
Clay assumptions with continuum survival written directly as `Delta0 <= DeltaYM`.

The Schur/Feshbach side is already in direct loss-budget form.
-/
structure ClayContinuumSurvivalBudgetAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV C mu delta : Real) : Prop where
  holonomyPacket :
    UniformHolonomyRedLemmaAssumptions
      links Gap Energy curvatureNorm C mu delta
  reducedScalePacket :
    LayerOneReducedScaleAssumptions
      Delta0 (mu * (delta / C)^2) dUV
  existsLossBudget :
    ∃ loss : Real,
      SchurLossBudgetAssumptions loss Delta0
        ∧ SchurFeshbachLossLowerAssumptions
          DeltaFine (mu * (delta / C)^2) dUV loss
  continuumSurvival :
    ContinuumGapSurvivalAssumptions DeltaYM Delta0

/--
The direct continuum-survival assumptions recover positive scale data.
-/
theorem ClayContinuumSurvivalBudgetAssumptions.to_positive_scale
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    LayerOnePositiveScaleAssumptions
      Delta0 (mu * (delta / C)^2) dUV := by
  have hBlock_pos :
      0 < mu * (delta / C)^2 := by
    exact UniformHolonomyRedLemmaAssumptions.imply_block_scale_positive h.holonomyPacket
  exact
    LayerOneReducedScaleAssumptions.to_positive_scale
      hBlock_pos h.reducedScalePacket

/--
Direct continuum-survival theorem: positive finite-regulator gap bound.
-/
theorem ClayContinuumSurvivalBudgetAssumptions.imply_finite_gap_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n := by
  refine ⟨mu * (delta / C)^2, ?_, ?_⟩
  · exact UniformHolonomyRedLemmaAssumptions.imply_block_scale_positive h.holonomyPacket
  · exact (UniformHolonomyRedLemmaAssumptions.imply_uniform_positive_gap h.holonomyPacket).1

/--
Direct continuum-survival theorem: Layer-One fine gap data.
-/
theorem ClayContinuumSurvivalBudgetAssumptions.imply_layer_one_fine_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  rcases h.existsLossBudget with ⟨loss, hBudget, hSchur⟩
  have hDelta0_le_DeltaFine :
      Delta0 <= DeltaFine := by
    exact
      SchurFeshbachLossLowerAssumptions.imply_delta0_le_deltaFine_of_loss_budget
        h.reducedScalePacket hBudget hSchur
  have hDelta0_pos : 0 < Delta0 := by
    exact
      LayerOnePositiveScaleAssumptions.imply_delta0_positive
        (ClayContinuumSurvivalBudgetAssumptions.to_positive_scale h)
  have hDeltaFine_pos : 0 < DeltaFine := by
    exact lt_of_lt_of_le hDelta0_pos hDelta0_le_DeltaFine
  exact ⟨hDelta0_le_DeltaFine, hDelta0_pos, hDeltaFine_pos⟩

/--
Direct continuum-survival theorem: continuum gap data.
-/
theorem ClayContinuumSurvivalBudgetAssumptions.imply_continuum_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  have hDelta0_pos : 0 < Delta0 := by
    exact
      LayerOnePositiveScaleAssumptions.imply_delta0_positive
        (ClayContinuumSurvivalBudgetAssumptions.to_positive_scale h)
  exact
    ContinuumGapSurvivalAssumptions.imply_continuum_gap_data
      h.continuumSurvival hDelta0_pos

/--
Direct continuum-survival theorem: full strongest gap data.
-/
theorem ClayContinuumSurvivalBudgetAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  have hFinite :
      ∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n := by
    exact ClayContinuumSurvivalBudgetAssumptions.imply_finite_gap_bound h
  have hFine :
      Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
    exact ClayContinuumSurvivalBudgetAssumptions.imply_layer_one_fine_gap_data h
  have hCont :
      Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact ClayContinuumSurvivalBudgetAssumptions.imply_continuum_gap_data h
  exact ⟨hFinite, hFine, hCont, ⟨hFinite, hCont.2⟩⟩

/--
Direct continuum-survival theorem: strongest conditional mass-gap summary.
-/
theorem ClayContinuumSurvivalBudgetAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ⟨ClayContinuumSurvivalBudgetAssumptions.imply_finite_gap_bound h,
      (ClayContinuumSurvivalBudgetAssumptions.imply_continuum_gap_data h).2⟩

/--
Direct continuum-survival theorem: positive continuum Yang--Mills gap.
-/
theorem ClayContinuumSurvivalBudgetAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact (ClayContinuumSurvivalBudgetAssumptions.imply_continuum_gap_data h).2

end RussoYM

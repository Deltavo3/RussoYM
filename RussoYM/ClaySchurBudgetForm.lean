import RussoYM.ClaySchurLossBudget

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Schur Budget Form

This file refines the Schur/Feshbach route by using the direct loss-budget
packet:

  loss <= Delta0

instead of carrying the concrete mixing-loss identity inside the final Schur
route.

This isolates the analytic Schur/Feshbach obligation as:

  min(block, dUV) - loss <= DeltaFine

and the mixing-budget obligation as:

  loss <= Delta0.
-/

/--
Clay assumptions with the Schur/Feshbach step written directly in loss-budget
form.
-/
structure ClaySchurBudgetAssumptions
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
  survivalPacket :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The Schur-budget assumptions recover the positive Layer-One scale packet.
-/
theorem ClaySchurBudgetAssumptions.to_positive_scale
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
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
Schur-budget theorem: positive finite-regulator gap bound.
-/
theorem ClaySchurBudgetAssumptions.imply_finite_gap_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n := by
  refine ⟨mu * (delta / C)^2, ?_, ?_⟩
  · exact UniformHolonomyRedLemmaAssumptions.imply_block_scale_positive h.holonomyPacket
  · exact (UniformHolonomyRedLemmaAssumptions.imply_uniform_positive_gap h.holonomyPacket).1

/--
Schur-budget theorem: Layer-One fine gap data.
-/
theorem ClaySchurBudgetAssumptions.imply_layer_one_fine_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
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
        (ClaySchurBudgetAssumptions.to_positive_scale h)
  have hDeltaFine_pos : 0 < DeltaFine := by
    exact lt_of_lt_of_le hDelta0_pos hDelta0_le_DeltaFine
  exact ⟨hDelta0_le_DeltaFine, hDelta0_pos, hDeltaFine_pos⟩

/--
Schur-budget theorem: continuum gap data.
-/
theorem ClaySchurBudgetAssumptions.imply_continuum_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  have hPositiveScale :
      LayerOnePositiveScaleAssumptions
        Delta0 (mu * (delta / C)^2) dUV := by
    exact ClaySchurBudgetAssumptions.to_positive_scale h
  have hDelta0_pos : 0 < Delta0 := by
    exact LayerOnePositiveScaleAssumptions.imply_delta0_positive hPositiveScale
  have hFiniteLowerOnly :
      FiniteGapLowerOnlyAssumptions Delta0 Gap := by
    exact
      FiniteGapLowerOnlyAssumptions.from_holonomy_and_positive_scale
        h.holonomyPacket hPositiveScale
  have hFiniteLower :
      UniformFiniteGapLowerAssumptions Delta0 Gap := by
    exact
      FiniteGapLowerOnlyAssumptions.to_uniform_finite_gap_lower
        hDelta0_pos hFiniteLowerOnly
  have hContinuum :
      ContinuumRedLemmaAssumptions DeltaYM Delta0 Gap := by
    exact
      EpsilonContinuumSurvivalAssumptions.to_continuum_red_lemmas
        hFiniteLower h.survivalPacket
  exact ContinuumRedLemmaAssumptions.imply_continuum_gap hContinuum

/--
Schur-budget theorem: full strongest gap data.
-/
theorem ClaySchurBudgetAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  have hFinite :
      ∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n := by
    exact ClaySchurBudgetAssumptions.imply_finite_gap_bound h
  have hFine :
      Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
    exact ClaySchurBudgetAssumptions.imply_layer_one_fine_gap_data h
  have hCont :
      Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact ClaySchurBudgetAssumptions.imply_continuum_gap_data h
  exact ⟨hFinite, hFine, hCont, ⟨hFinite, hCont.2⟩⟩

/--
Schur-budget theorem: strongest conditional mass-gap summary.
-/
theorem ClaySchurBudgetAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ⟨ClaySchurBudgetAssumptions.imply_finite_gap_bound h,
      (ClaySchurBudgetAssumptions.imply_continuum_gap_data h).2⟩

/--
Schur-budget theorem: positive continuum Yang--Mills gap.
-/
theorem ClaySchurBudgetAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact (ClaySchurBudgetAssumptions.imply_continuum_gap_data h).2

end RussoYM

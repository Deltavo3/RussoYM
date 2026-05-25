import RussoYM.ClayRedLemmaTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Direct Mixing Red Lemma Theorem

This file reduces the mixing packet in the clean Clay red-lemma theorem.

Instead of carrying the internal primitive mixing packet

  positivity + multiplicative scale separation + rho budget,

this file isolates the exact mixing conclusion used by the Clay route:

  2 * Cmix * (eps / ell)^kappa <= Delta0.

This is the direct Delta0-targeted mixing smallness red lemma.
-/

/--
Direct Delta0-targeted mixing smallness assumption.

This is the exact mixing inequality used in the Schur/Feshbach fine-gap step.
-/
structure Delta0MixingSmallnessAssumptions
    (Cmix eps ell Delta0 : Real)
    (kappa : Nat) : Prop where
  mixing_small :
    2 * Cmix * (eps / ell)^kappa <= Delta0

/--
Primitive Delta0-targeted mixing red lemmas imply the direct Delta0 mixing
smallness assumption.
-/
theorem Delta0TargetedMixingRedLemmaAssumptions.to_delta0_mixing_smallness
    {Cmix eps ell rho Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0TargetedMixingRedLemmaAssumptions
        Cmix eps ell rho Delta0 kappa) :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
  have hFinite :
      FiniteMixingRedLemmaAssumptions Cmix eps ell rho Delta0 kappa := by
    exact Delta0TargetedMixingRedLemmaAssumptions.to_finite_mixing_red_lemmas h
  exact
    { mixing_small :=
        FiniteMixingRedLemmaAssumptions.imply_mixing_small hFinite }

/--
Schur/Feshbach fine lower bound plus direct Delta0-targeted mixing smallness
implies the Layer-One fine lower bound `Delta0 <= DeltaFine`.
-/
theorem FineLowerSchurComplementAssumptions.imply_delta0_le_deltaFine_of_mixing_small
    {DeltaFine Delta0 dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (hScale :
      LayerOnePositiveScaleAssumptions Delta0 dBlock dUV)
    (hMix :
      Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa)
    (hFine :
      FineLowerSchurComplementAssumptions
        DeltaFine dBlock dUV Cmix eps ell kappa) :
    Delta0 <= DeltaFine := by
  have hMixSmall :
      2 * Cmix * (eps / ell)^kappa <= Delta0 := by
    exact hMix.mixing_small
  have hFineLower :
      min dBlock dUV - 2 * Cmix * (eps / ell)^kappa <= DeltaFine := by
    exact hFine.fine_lower_bound
  have hDelta0Def :
      Delta0 = (1 / 2) * min dBlock dUV := by
    exact hScale.hDelta0_def
  have hDelta0_le_schur :
      Delta0 <= min dBlock dUV - 2 * Cmix * (eps / ell)^kappa := by
    linarith
  exact le_trans hDelta0_le_schur hFineLower

/--
Clean Clay assumptions with the mixing packet reduced to direct Delta0
mixing smallness.
-/
structure ClayDirectMixingRedLemmaAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real)
    (kappa : Nat) : Prop where
  holonomyPacket :
    UniformHolonomyRedLemmaAssumptions
      links Gap Energy curvatureNorm C mu delta
  scalePacket :
    LayerOnePositiveScaleAssumptions
      Delta0 (mu * (delta / C)^2) dUV
  mixingSmallness :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa
  fineLowerPacket :
    FineLowerSchurComplementAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  survivalPacket :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The direct-mixing Clay assumptions imply a positive finite-regulator gap lower
bound.
-/
theorem ClayDirectMixingRedLemmaAssumptions.imply_finite_gap_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectMixingRedLemmaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    ∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n := by
  refine ⟨mu * (delta / C)^2, ?_, ?_⟩
  · exact h.scalePacket.hBlock_pos
  · exact (UniformHolonomyRedLemmaAssumptions.imply_uniform_positive_gap h.holonomyPacket).1

/--
The direct-mixing Clay assumptions imply Layer-One fine gap data.
-/
theorem ClayDirectMixingRedLemmaAssumptions.imply_layer_one_fine_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectMixingRedLemmaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  have hDelta0_le_DeltaFine : Delta0 <= DeltaFine := by
    exact
      FineLowerSchurComplementAssumptions.imply_delta0_le_deltaFine_of_mixing_small
        h.scalePacket h.mixingSmallness h.fineLowerPacket
  have hDelta0_pos : 0 < Delta0 := by
    exact LayerOnePositiveScaleAssumptions.imply_delta0_positive h.scalePacket
  have hDeltaFine_pos : 0 < DeltaFine := by
    exact lt_of_lt_of_le hDelta0_pos hDelta0_le_DeltaFine
  exact ⟨hDelta0_le_DeltaFine, hDelta0_pos, hDeltaFine_pos⟩

/--
The direct-mixing Clay assumptions imply continuum gap data.
-/
theorem ClayDirectMixingRedLemmaAssumptions.imply_continuum_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectMixingRedLemmaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  have hDelta0_pos : 0 < Delta0 := by
    exact LayerOnePositiveScaleAssumptions.imply_delta0_positive h.scalePacket
  have hFiniteLowerOnly :
      FiniteGapLowerOnlyAssumptions Delta0 Gap := by
    exact
      FiniteGapLowerOnlyAssumptions.from_holonomy_and_positive_scale
        h.holonomyPacket h.scalePacket
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
Full strongest gap data from the direct-mixing Clay assumptions.
-/
theorem ClayDirectMixingRedLemmaAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectMixingRedLemmaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  have hFinite :
      ∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n := by
    exact ClayDirectMixingRedLemmaAssumptions.imply_finite_gap_bound h
  have hFine :
      Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
    exact ClayDirectMixingRedLemmaAssumptions.imply_layer_one_fine_gap_data h
  have hCont :
      Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact ClayDirectMixingRedLemmaAssumptions.imply_continuum_gap_data h
  exact ⟨hFinite, hFine, hCont, ⟨hFinite, hCont.2⟩⟩

/--
Direct-mixing Clay theorem: positive continuum Yang--Mills gap.
-/
theorem clay_direct_mixing_red_lemma_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectMixingRedLemmaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    0 < DeltaYM := by
  exact (ClayDirectMixingRedLemmaAssumptions.imply_continuum_gap_data h).2

/--
Direct-mixing Clay theorem: strongest conditional mass-gap summary.
-/
theorem clay_direct_mixing_red_lemma_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectMixingRedLemmaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ⟨ClayDirectMixingRedLemmaAssumptions.imply_finite_gap_bound h,
      clay_direct_mixing_red_lemma_theorem_implies_positive_continuum_gap h⟩

end RussoYM

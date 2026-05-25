import Mathlib
import RussoYM.ClayMixingScaleSeparationCriterion

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Mixing Decay Budget

This file reduces the q-budget in the mixing scale-separation criterion.

Instead of assuming directly

  2 * Cmix * q^kappa <= Delta0,

we assume the decay form

  q^kappa <= Delta0 / (2 * Cmix),

together with `0 < Cmix`.

This is the more analytic form: for `0 <= q < 1`, one later proves that
`q^kappa` becomes small for sufficiently large `kappa`.
-/

/--
Decay-budget criterion for Delta0-targeted mixing smallness.
-/
structure Delta0MixingDecayBudgetAssumptions
    (Cmix eps ell q Delta0 : Real)
    (kappa : Nat) : Prop where
  hCmix_pos :
    0 < Cmix
  hEps_nonneg :
    0 <= eps
  hEll_pos :
    0 < ell
  hScaleSeparation :
    eps <= q * ell
  q_decay_budget :
    q^kappa <= Delta0 / (2 * Cmix)

/--
The decay-budget criterion implies the scale-separation criterion.
-/
theorem Delta0MixingDecayBudgetAssumptions.to_scale_separation_criterion
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingDecayBudgetAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingScaleSeparationCriterionAssumptions
      Cmix eps ell q Delta0 kappa := by
  have hCmix_nonneg : 0 <= Cmix := by
    exact le_of_lt h.hCmix_pos
  have hcoef_pos : 0 < 2 * Cmix := by
    nlinarith [h.hCmix_pos]
  have hcoef_nonneg : 0 <= 2 * Cmix := by
    exact le_of_lt hcoef_pos
  have hBudgetRight :
      q^kappa * (2 * Cmix) <= Delta0 := by
    exact (le_div_iff₀ hcoef_pos).1 h.q_decay_budget
  have hBudget :
      2 * Cmix * q^kappa <= Delta0 := by
    calc
      2 * Cmix * q^kappa = q^kappa * (2 * Cmix) := by
        ring
      _ <= Delta0 := hBudgetRight
  exact
    { hCmix_nonneg := hCmix_nonneg
      hEps_nonneg := h.hEps_nonneg
      hEll_pos := h.hEll_pos
      hScaleSeparation := h.hScaleSeparation
      q_budget := hBudget }

/--
The decay-budget criterion implies direct Delta0-targeted mixing smallness.
-/
theorem Delta0MixingDecayBudgetAssumptions.to_delta0_mixing_smallness
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingDecayBudgetAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
  exact
    Delta0MixingScaleSeparationCriterionAssumptions.to_delta0_mixing_smallness
      (Delta0MixingDecayBudgetAssumptions.to_scale_separation_criterion h)

/--
Reduced-scale direct Clay assumptions with mixing supplied by the decay-budget
criterion.
-/
structure ClayMixingDecayBudgetDirectAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real)
    (kappa : Nat) : Prop where
  holonomyPacket :
    UniformHolonomyRedLemmaAssumptions
      links Gap Energy curvatureNorm C mu delta
  reducedScalePacket :
    LayerOneReducedScaleAssumptions
      Delta0 (mu * (delta / C)^2) dUV
  mixingDecayBudget :
    Delta0MixingDecayBudgetAssumptions
      Cmix eps ell q Delta0 kappa
  fineLowerPacket :
    FineLowerSchurComplementAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  survivalPacket :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The mixing decay-budget Clay assumptions imply the mixing scale-separation Clay
assumptions.
-/
theorem ClayMixingDecayBudgetDirectAssumptions.to_mixing_scale_separation_direct_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingDecayBudgetDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    ClayMixingScaleSeparationDirectAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa := by
  exact
    { holonomyPacket := h.holonomyPacket
      reducedScalePacket := h.reducedScalePacket
      mixingScaleSeparationCriterion :=
        Delta0MixingDecayBudgetAssumptions.to_scale_separation_criterion
          h.mixingDecayBudget
      fineLowerPacket := h.fineLowerPacket
      survivalPacket := h.survivalPacket }

/--
Mixing decay-budget theorem: full strongest gap data.
-/
theorem ClayMixingDecayBudgetDirectAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingDecayBudgetDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClayMixingScaleSeparationDirectAssumptions.imply_full_gap_data
      (ClayMixingDecayBudgetDirectAssumptions.to_mixing_scale_separation_direct_assumptions h)

/--
Mixing decay-budget theorem: strongest conditional mass-gap summary.
-/
theorem ClayMixingDecayBudgetDirectAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingDecayBudgetDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayMixingScaleSeparationDirectAssumptions.imply_mass_gap
      (ClayMixingDecayBudgetDirectAssumptions.to_mixing_scale_separation_direct_assumptions h)

/--
Mixing decay-budget theorem: positive continuum Yang--Mills gap.
-/
theorem ClayMixingDecayBudgetDirectAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingDecayBudgetDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayMixingScaleSeparationDirectAssumptions.imply_positive_continuum_gap
      (ClayMixingDecayBudgetDirectAssumptions.to_mixing_scale_separation_direct_assumptions h)

end RussoYM

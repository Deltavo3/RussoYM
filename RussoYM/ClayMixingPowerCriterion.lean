import Mathlib
import RussoYM.ClayMixingParameterCriterion

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Mixing Power Criterion

This file reduces the mixing parameter criterion one step further.

Instead of assuming the full ratio-power bound

  2 * Cmix * (eps / ell)^kappa <= 2 * Cmix * q^kappa,

we assume:

  0 <= Cmix,
  (eps / ell)^kappa <= q^kappa.

Then Lean derives the coefficient-weighted ratio-power bound.
-/

/--
Power-based criterion for Delta0-targeted mixing smallness.
-/
structure Delta0MixingPowerCriterionAssumptions
    (Cmix eps ell q Delta0 : Real)
    (kappa : Nat) : Prop where
  hCmix_nonneg :
    0 <= Cmix
  ratio_power_control :
    (eps / ell)^kappa <= q^kappa
  q_budget :
    2 * Cmix * q^kappa <= Delta0

/--
The power criterion implies the previous mixing parameter criterion.
-/
theorem Delta0MixingPowerCriterionAssumptions.to_parameter_criterion
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingPowerCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingParameterCriterionAssumptions
      Cmix eps ell q Delta0 kappa := by
  have hcoef_nonneg : 0 <= 2 * Cmix := by
    nlinarith [h.hCmix_nonneg]
  have hratio_weighted :
      2 * Cmix * (eps / ell)^kappa <= 2 * Cmix * q^kappa := by
    exact mul_le_mul_of_nonneg_left h.ratio_power_control hcoef_nonneg
  exact
    { ratio_power_control := hratio_weighted
      q_budget := h.q_budget }

/--
The power criterion implies direct Delta0-targeted mixing smallness.
-/
theorem Delta0MixingPowerCriterionAssumptions.to_delta0_mixing_smallness
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingPowerCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
  exact
    Delta0MixingParameterCriterionAssumptions.to_delta0_mixing_smallness
      (Delta0MixingPowerCriterionAssumptions.to_parameter_criterion h)

/--
Reduced-scale direct Clay assumptions with mixing supplied by the power
criterion.
-/
structure ClayMixingPowerDirectAssumptions
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
  mixingPowerCriterion :
    Delta0MixingPowerCriterionAssumptions
      Cmix eps ell q Delta0 kappa
  fineLowerPacket :
    FineLowerSchurComplementAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  survivalPacket :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The mixing-power Clay assumptions imply the mixing-parameter Clay assumptions.
-/
theorem ClayMixingPowerDirectAssumptions.to_mixing_parameter_direct_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingPowerDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    ClayMixingParameterDirectAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa := by
  exact
    { holonomyPacket := h.holonomyPacket
      reducedScalePacket := h.reducedScalePacket
      mixingParameterCriterion :=
        Delta0MixingPowerCriterionAssumptions.to_parameter_criterion
          h.mixingPowerCriterion
      fineLowerPacket := h.fineLowerPacket
      survivalPacket := h.survivalPacket }

/--
Mixing-power theorem: full strongest gap data.
-/
theorem ClayMixingPowerDirectAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingPowerDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClayMixingParameterDirectAssumptions.imply_full_gap_data
      (ClayMixingPowerDirectAssumptions.to_mixing_parameter_direct_assumptions h)

/--
Mixing-power theorem: strongest conditional mass-gap summary.
-/
theorem ClayMixingPowerDirectAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingPowerDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayMixingParameterDirectAssumptions.imply_mass_gap
      (ClayMixingPowerDirectAssumptions.to_mixing_parameter_direct_assumptions h)

/--
Mixing-power theorem: positive continuum Yang--Mills gap.
-/
theorem ClayMixingPowerDirectAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingPowerDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayMixingParameterDirectAssumptions.imply_positive_continuum_gap
      (ClayMixingPowerDirectAssumptions.to_mixing_parameter_direct_assumptions h)

end RussoYM

import Mathlib
import RussoYM.ClayMixingRatioCriterion

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Mixing Scale-Separation Criterion

This file reduces the mixing ratio criterion to a more analytic scale-separation
criterion.

Instead of assuming directly

  0 <= eps / ell,
  eps / ell <= q,

we assume:

  0 <= eps,
  0 < ell,
  eps <= q * ell.

Then Lean derives the ratio criterion.
-/

/--
Scale-separation criterion for Delta0-targeted mixing smallness.
-/
structure Delta0MixingScaleSeparationCriterionAssumptions
    (Cmix eps ell q Delta0 : Real)
    (kappa : Nat) : Prop where
  hCmix_nonneg :
    0 <= Cmix
  hEps_nonneg :
    0 <= eps
  hEll_pos :
    0 < ell
  hScaleSeparation :
    eps <= q * ell
  q_budget :
    2 * Cmix * q^kappa <= Delta0

/--
The scale-separation criterion implies the ratio criterion.
-/
theorem Delta0MixingScaleSeparationCriterionAssumptions.to_ratio_criterion
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingScaleSeparationCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingRatioCriterionAssumptions
      Cmix eps ell q Delta0 kappa := by
  have hEll_nonneg : 0 <= ell := by
    exact le_of_lt h.hEll_pos
  have hRatio_nonneg : 0 <= eps / ell := by
    exact div_nonneg h.hEps_nonneg hEll_nonneg
  have hRatio_le_q : eps / ell <= q := by
    exact (div_le_iff₀ h.hEll_pos).2 h.hScaleSeparation
  exact
    { hCmix_nonneg := h.hCmix_nonneg
      hRatio_nonneg := hRatio_nonneg
      hRatio_le_q := hRatio_le_q
      q_budget := h.q_budget }

/--
The scale-separation criterion implies direct Delta0-targeted mixing smallness.
-/
theorem Delta0MixingScaleSeparationCriterionAssumptions.to_delta0_mixing_smallness
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingScaleSeparationCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
  exact
    Delta0MixingRatioCriterionAssumptions.to_delta0_mixing_smallness
      (Delta0MixingScaleSeparationCriterionAssumptions.to_ratio_criterion h)

/--
Reduced-scale direct Clay assumptions with mixing supplied by the scale-separation
criterion.
-/
structure ClayMixingScaleSeparationDirectAssumptions
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
  mixingScaleSeparationCriterion :
    Delta0MixingScaleSeparationCriterionAssumptions
      Cmix eps ell q Delta0 kappa
  fineLowerPacket :
    FineLowerSchurComplementAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  survivalPacket :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The mixing scale-separation Clay assumptions imply the mixing-ratio Clay
assumptions.
-/
theorem ClayMixingScaleSeparationDirectAssumptions.to_mixing_ratio_direct_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingScaleSeparationDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    ClayMixingRatioDirectAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa := by
  exact
    { holonomyPacket := h.holonomyPacket
      reducedScalePacket := h.reducedScalePacket
      mixingRatioCriterion :=
        Delta0MixingScaleSeparationCriterionAssumptions.to_ratio_criterion
          h.mixingScaleSeparationCriterion
      fineLowerPacket := h.fineLowerPacket
      survivalPacket := h.survivalPacket }

/--
Mixing scale-separation theorem: full strongest gap data.
-/
theorem ClayMixingScaleSeparationDirectAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingScaleSeparationDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClayMixingRatioDirectAssumptions.imply_full_gap_data
      (ClayMixingScaleSeparationDirectAssumptions.to_mixing_ratio_direct_assumptions h)

/--
Mixing scale-separation theorem: strongest conditional mass-gap summary.
-/
theorem ClayMixingScaleSeparationDirectAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingScaleSeparationDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayMixingRatioDirectAssumptions.imply_mass_gap
      (ClayMixingScaleSeparationDirectAssumptions.to_mixing_ratio_direct_assumptions h)

/--
Mixing scale-separation theorem: positive continuum Yang--Mills gap.
-/
theorem ClayMixingScaleSeparationDirectAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingScaleSeparationDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayMixingRatioDirectAssumptions.imply_positive_continuum_gap
      (ClayMixingScaleSeparationDirectAssumptions.to_mixing_ratio_direct_assumptions h)

end RussoYM

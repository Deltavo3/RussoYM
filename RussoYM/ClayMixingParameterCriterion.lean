import RussoYM.ClayReducedScaleDirectTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Mixing Parameter Criterion

This file reduces direct Delta0-targeted mixing smallness to a parameter-budget
criterion.

Instead of assuming directly

  2 * Cmix * (eps / ell)^kappa <= Delta0,

we split the obligation into:

1. ratio-power control:
     2 * Cmix * (eps / ell)^kappa <= 2 * Cmix * q^kappa,

2. final q-budget:
     2 * Cmix * q^kappa <= Delta0.

The analytic work can later prove the ratio-power control from scale separation
and positivity hypotheses.  This file only records the clean algebraic bridge.
-/

/--
Parameter criterion for Delta0-targeted mixing smallness.
-/
structure Delta0MixingParameterCriterionAssumptions
    (Cmix eps ell q Delta0 : Real)
    (kappa : Nat) : Prop where
  ratio_power_control :
    2 * Cmix * (eps / ell)^kappa <= 2 * Cmix * q^kappa
  q_budget :
    2 * Cmix * q^kappa <= Delta0

/--
The parameter criterion implies direct Delta0-targeted mixing smallness.
-/
theorem Delta0MixingParameterCriterionAssumptions.to_delta0_mixing_smallness
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingParameterCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
  exact
    { mixing_small :=
        le_trans h.ratio_power_control h.q_budget }

/--
Reduced-scale direct Clay assumptions with mixing supplied by the parameter
criterion.
-/
structure ClayMixingParameterDirectAssumptions
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
  mixingParameterCriterion :
    Delta0MixingParameterCriterionAssumptions
      Cmix eps ell q Delta0 kappa
  fineLowerPacket :
    FineLowerSchurComplementAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  survivalPacket :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The mixing-parameter Clay assumptions imply the reduced-scale direct Clay
assumptions.
-/
theorem ClayMixingParameterDirectAssumptions.to_reduced_scale_direct_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingParameterDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    ClayReducedScaleDirectAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa := by
  exact
    { holonomyPacket := h.holonomyPacket
      reducedScalePacket := h.reducedScalePacket
      mixingSmallness :=
        Delta0MixingParameterCriterionAssumptions.to_delta0_mixing_smallness
          h.mixingParameterCriterion
      fineLowerPacket := h.fineLowerPacket
      survivalPacket := h.survivalPacket }

/--
Mixing-parameter theorem: full strongest gap data.
-/
theorem ClayMixingParameterDirectAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingParameterDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClayReducedScaleDirectAssumptions.imply_full_gap_data
      (ClayMixingParameterDirectAssumptions.to_reduced_scale_direct_assumptions h)

/--
Mixing-parameter theorem: strongest conditional mass-gap summary.
-/
theorem ClayMixingParameterDirectAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingParameterDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayReducedScaleDirectAssumptions.imply_mass_gap
      (ClayMixingParameterDirectAssumptions.to_reduced_scale_direct_assumptions h)

/--
Mixing-parameter theorem: positive continuum Yang--Mills gap.
-/
theorem ClayMixingParameterDirectAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingParameterDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayReducedScaleDirectAssumptions.imply_positive_continuum_gap
      (ClayMixingParameterDirectAssumptions.to_reduced_scale_direct_assumptions h)

end RussoYM

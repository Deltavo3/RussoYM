import Mathlib
import RussoYM.ClayMixingPowerCriterion

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Mixing Ratio Criterion

This file reduces the mixing power criterion one step further.

Instead of assuming directly

  (eps / ell)^kappa <= q^kappa,

we assume base ratio control:

  0 <= eps / ell,
  eps / ell <= q.

Then Lean proves the power control by induction on `kappa`.
-/

/--
If `0 <= a` and `a <= b`, then `a^n <= b^n` for all natural powers.
-/
theorem real_pow_le_pow_of_nonneg_le
    {a b : Real}
    (ha : 0 <= a)
    (hab : a <= b) :
    forall n : Nat, a^n <= b^n := by
  intro n
  induction n with
  | zero =>
      simp
  | succ n ih =>
      have hb_nonneg : 0 <= b := by
        exact le_trans ha hab
      have hb_pow_nonneg : 0 <= b^n := by
        exact pow_nonneg hb_nonneg n
      rw [pow_succ, pow_succ]
      exact mul_le_mul ih hab ha hb_pow_nonneg

/--
Ratio-based criterion for Delta0-targeted mixing smallness.
-/
structure Delta0MixingRatioCriterionAssumptions
    (Cmix eps ell q Delta0 : Real)
    (kappa : Nat) : Prop where
  hCmix_nonneg :
    0 <= Cmix
  hRatio_nonneg :
    0 <= eps / ell
  hRatio_le_q :
    eps / ell <= q
  q_budget :
    2 * Cmix * q^kappa <= Delta0

/--
The ratio criterion implies the power criterion.
-/
theorem Delta0MixingRatioCriterionAssumptions.to_power_criterion
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingRatioCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingPowerCriterionAssumptions
      Cmix eps ell q Delta0 kappa := by
  have hPower :
      (eps / ell)^kappa <= q^kappa := by
    exact
      real_pow_le_pow_of_nonneg_le
        h.hRatio_nonneg h.hRatio_le_q kappa
  exact
    { hCmix_nonneg := h.hCmix_nonneg
      ratio_power_control := hPower
      q_budget := h.q_budget }

/--
The ratio criterion implies direct Delta0-targeted mixing smallness.
-/
theorem Delta0MixingRatioCriterionAssumptions.to_delta0_mixing_smallness
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingRatioCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
  exact
    Delta0MixingPowerCriterionAssumptions.to_delta0_mixing_smallness
      (Delta0MixingRatioCriterionAssumptions.to_power_criterion h)

/--
Reduced-scale direct Clay assumptions with mixing supplied by the ratio
criterion.
-/
structure ClayMixingRatioDirectAssumptions
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
  mixingRatioCriterion :
    Delta0MixingRatioCriterionAssumptions
      Cmix eps ell q Delta0 kappa
  fineLowerPacket :
    FineLowerSchurComplementAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  survivalPacket :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The mixing-ratio Clay assumptions imply the mixing-power Clay assumptions.
-/
theorem ClayMixingRatioDirectAssumptions.to_mixing_power_direct_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingRatioDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    ClayMixingPowerDirectAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa := by
  exact
    { holonomyPacket := h.holonomyPacket
      reducedScalePacket := h.reducedScalePacket
      mixingPowerCriterion :=
        Delta0MixingRatioCriterionAssumptions.to_power_criterion
          h.mixingRatioCriterion
      fineLowerPacket := h.fineLowerPacket
      survivalPacket := h.survivalPacket }

/--
Mixing-ratio theorem: full strongest gap data.
-/
theorem ClayMixingRatioDirectAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingRatioDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClayMixingPowerDirectAssumptions.imply_full_gap_data
      (ClayMixingRatioDirectAssumptions.to_mixing_power_direct_assumptions h)

/--
Mixing-ratio theorem: strongest conditional mass-gap summary.
-/
theorem ClayMixingRatioDirectAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingRatioDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayMixingPowerDirectAssumptions.imply_mass_gap
      (ClayMixingRatioDirectAssumptions.to_mixing_power_direct_assumptions h)

/--
Mixing-ratio theorem: positive continuum Yang--Mills gap.
-/
theorem ClayMixingRatioDirectAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingRatioDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayMixingPowerDirectAssumptions.imply_positive_continuum_gap
      (ClayMixingRatioDirectAssumptions.to_mixing_power_direct_assumptions h)

end RussoYM

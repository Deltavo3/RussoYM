import Mathlib
import RussoYM.LayerOneCriterion
import RussoYM.UniformFiniteGapFromHolonomy
import RussoYM.FiniteMixingSuppression

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Layer One From Holonomy-Coercivity

This file connects the uniform finite holonomy/coercivity gap mechanism to the
Layer One fine-gap criterion.

It proves that a uniform finite holonomy/coercivity lower bound can serve as
the Layer One block-gap margin.
-/

/--
Layer One assumptions driven by the uniform finite holonomy/coercivity gap.

The holonomy/coercivity mechanism supplies the uniform block gap

  mu * (delta / C)^2.

The remaining assumptions are the UV gap, the target gap definition, the mixing
smallness condition, and the final fine-gap lower bound.
-/
structure LayerOneFromHolonomyAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real)
    (kappa : Nat) : Prop where
  uniformHolonomyGap :
    UniformFiniteGapFromHolonomyAssumptions
      links Gap Energy curvatureNorm C mu delta
  hUV_pos :
    0 < dUV
  hDelta0_def :
    Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV
  hMix_small :
    2 * Cmix * (eps / ell)^kappa <=
      (1 / 2) * min (mu * (delta / C)^2) dUV
  hFine_lower :
    min (mu * (delta / C)^2) dUV
      - 2 * Cmix * (eps / ell)^kappa <= DeltaFine

/--
Layer One endpoint from uniform finite holonomy/coercivity.

The conclusion records both:

1. the uniform finite block-gap lower bound for every regulator, and
2. the Layer One positive fine-gap conclusion.
-/
theorem LayerOneFromHolonomyAssumptions.imply_layer_one_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      LayerOneFromHolonomyAssumptions
        links Gap Energy curvatureNorm
        DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine := by
  have hUniform :
      (forall n, mu * (delta / C)^2 <= Gap n)
        ∧ 0 < mu * (delta / C)^2
        ∧ forall n, 0 < Gap n := by
    exact UniformFiniteGapFromHolonomyAssumptions.imply_uniform_positive_gap
      h.uniformHolonomyGap
  have hLayer :
      LayerOneFineGapAssumptions
        DeltaFine Delta0 (mu * (delta / C)^2) dUV Cmix eps ell kappa := by
    exact
      { hBlock_pos := hUniform.2.1
        hUV_pos := h.hUV_pos
        hDelta0_def := h.hDelta0_def
        hMix_small := h.hMix_small
        hFine_lower := h.hFine_lower }
  have hFine :
      Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
    exact LayerOneFineGapAssumptions.imply_uniform_fine_gap hLayer
  exact ⟨hUniform.1, hFine.1, hFine.2.1, hFine.2.2⟩

/--
Layer One from holonomy/coercivity with mixing suppression supplied by the
finite mixing-suppression module.

This replaces the direct Layer One mixing-smallness hypothesis

  2 * Cmix * (eps / ell)^kappa <= (1 / 2) * min dBlock dUV

with the scale-ratio/mixing-suppression interface.
-/
structure LayerOneFromHolonomyWithMixingAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real)
    (kappa : Nat) : Prop where
  uniformHolonomyGap :
    UniformFiniteGapFromHolonomyAssumptions
      links Gap Energy curvatureNorm C mu delta
  hUV_pos :
    0 < dUV
  hDelta0_def :
    Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV
  mixingSuppression :
    LayerOneMixingSuppressionAssumptions
      (mu * (delta / C)^2) dUV Cmix eps ell rho kappa
  hFine_lower :
    min (mu * (delta / C)^2) dUV
      - 2 * Cmix * (eps / ell)^kappa <= DeltaFine

/--
Layer One endpoint from holonomy/coercivity and finite mixing suppression.
-/
theorem LayerOneFromHolonomyWithMixingAssumptions.imply_layer_one_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      LayerOneFromHolonomyWithMixingAssumptions
        links Gap Energy curvatureNorm
        DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine := by
  have hMix :
      2 * Cmix * (eps / ell)^kappa
        <= (1 / 2) * min (mu * (delta / C)^2) dUV := by
    exact LayerOneMixingSuppressionAssumptions.imply_layer_one_mixing_small
      h.mixingSuppression
  have hBase :
      LayerOneFromHolonomyAssumptions
        links Gap Energy curvatureNorm
        DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa := by
    exact
      { uniformHolonomyGap := h.uniformHolonomyGap
        hUV_pos := h.hUV_pos
        hDelta0_def := h.hDelta0_def
        hMix_small := hMix
        hFine_lower := h.hFine_lower }
  exact LayerOneFromHolonomyAssumptions.imply_layer_one_gap hBase

end RussoYM

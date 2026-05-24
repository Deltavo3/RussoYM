import Mathlib
import RussoYM.LayerOneFromHolonomy
import RussoYM.ContinuumGap
import RussoYM.ContinuumPreservation

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Gap From Holonomy-Coercivity

This file connects the finite holonomy/coercivity Layer One mechanism to the
continuum Yang--Mills gap endpoint.

It proves the conditional chain:

uniform finite holonomy/coercivity gap
+ Layer One gap lifting
+ continuum gap preservation
=> positive continuum Yang--Mills gap.

The analytic continuum-preservation statement remains an assumption.
-/

/--
Clay-compatible assumptions driven by finite holonomy/coercivity.

The finite holonomy/coercivity mechanism supplies the Layer One block-gap
margin. The continuum assumption then carries the positive Layer One lower
bound to the continuum Yang--Mills gap.
-/
structure ClayFromHolonomyAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real)
    (kappa : Nat) : Prop where
  layerOneFromHolonomy :
    LayerOneFromHolonomyAssumptions
      links Gap Energy curvatureNorm
      DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa
  continuum :
    ContinuumGapAssumptions DeltaYM Delta0

/--
Clay-compatible endpoint from finite holonomy/coercivity.

The conclusion records:

1. the uniform finite holonomy/coercivity lower bound,
2. the Layer One positive fine-gap conclusion,
3. the positive continuum Yang--Mills gap conclusion.
-/
theorem ClayFromHolonomyAssumptions.imply_clay_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  have hLayer :
      (forall n, mu * (delta / C)^2 <= Gap n)
        ∧ Delta0 <= DeltaFine
        ∧ 0 < Delta0
        ∧ 0 < DeltaFine := by
    exact LayerOneFromHolonomyAssumptions.imply_layer_one_gap
      h.layerOneFromHolonomy
  have hCont :
      Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact ContinuumGapAssumptions.imply_continuum_gap h.continuum
  exact
    ⟨hLayer.1,
      hLayer.2.1,
      hLayer.2.2.1,
      hLayer.2.2.2,
      hCont.1,
      hCont.2⟩

/--
Headline continuum gap endpoint from finite holonomy/coercivity.

This extracts only the positive continuum Yang--Mills gap conclusion from the
full Clay-compatible holonomy/coercivity chain.
-/
theorem ClayFromHolonomyAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    0 < DeltaYM := by
  exact (ClayFromHolonomyAssumptions.imply_clay_gap h).2.2.2.2.2

/--
Clay-compatible assumptions driven by finite holonomy/coercivity and finite
mixing suppression.

This version uses `LayerOneFromHolonomyWithMixingAssumptions`, so the Layer One
mixing-smallness condition is supplied by the finite mixing suppression module
rather than assumed directly.
-/
structure ClayFromHolonomyWithMixingAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real)
    (kappa : Nat) : Prop where
  layerOneFromHolonomyWithMixing :
    LayerOneFromHolonomyWithMixingAssumptions
      links Gap Energy curvatureNorm
      DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa
  continuum :
    ContinuumGapAssumptions DeltaYM Delta0

/--
Clay-compatible endpoint from finite holonomy/coercivity and finite mixing
suppression.

The conclusion records:

1. the uniform finite holonomy/coercivity lower bound,
2. the Layer One positive fine-gap conclusion,
3. the positive continuum Yang--Mills gap conclusion.
-/
theorem ClayFromHolonomyWithMixingAssumptions.imply_clay_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyWithMixingAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  have hLayer :
      (forall n, mu * (delta / C)^2 <= Gap n)
        ∧ Delta0 <= DeltaFine
        ∧ 0 < Delta0
        ∧ 0 < DeltaFine := by
    exact LayerOneFromHolonomyWithMixingAssumptions.imply_layer_one_gap
      h.layerOneFromHolonomyWithMixing
  have hCont :
      Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact ContinuumGapAssumptions.imply_continuum_gap h.continuum
  exact
    ⟨hLayer.1,
      hLayer.2.1,
      hLayer.2.2.1,
      hLayer.2.2.2,
      hCont.1,
      hCont.2⟩

/--
Headline continuum gap endpoint from finite holonomy/coercivity and finite
mixing suppression.
-/
theorem ClayFromHolonomyWithMixingAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyWithMixingAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact (ClayFromHolonomyWithMixingAssumptions.imply_clay_gap h).2.2.2.2.2

/--
Clay-compatible assumptions from finite holonomy/coercivity, finite mixing
suppression, and epsilon-style continuum preservation.

This version does not assume `ContinuumGapAssumptions` directly. Instead, it
assumes that the finite gaps approximate the continuum gap from below up to
arbitrarily small error.
-/
structure ClayFromHolonomyWithMixingEpsilonContinuumAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real)
    (kappa : Nat) : Prop where
  layerOneFromHolonomyWithMixing :
    LayerOneFromHolonomyWithMixingAssumptions
      links Gap Energy curvatureNorm
      DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa
  approximate_continuum_upper :
    forall eta : Real, 0 < eta -> exists n : Nat, Gap n - eta <= DeltaYM

/--
Epsilon-continuum Clay endpoint from finite holonomy/coercivity and finite
mixing suppression.

The conclusion records the uniform finite holonomy/coercivity bound, the Layer
One fine-gap conclusion, and the positive continuum Yang--Mills gap.
-/
theorem ClayFromHolonomyWithMixingEpsilonContinuumAssumptions.imply_clay_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyWithMixingEpsilonContinuumAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  have hLayer :
      (forall n, mu * (delta / C)^2 <= Gap n)
        ∧ Delta0 <= DeltaFine
        ∧ 0 < Delta0
        ∧ 0 < DeltaFine := by
    exact LayerOneFromHolonomyWithMixingAssumptions.imply_layer_one_gap
      h.layerOneFromHolonomyWithMixing

  have hUniform :
      (forall n, mu * (delta / C)^2 <= Gap n)
        ∧ 0 < mu * (delta / C)^2
        ∧ forall n, 0 < Gap n := by
    exact UniformFiniteGapFromHolonomyAssumptions.imply_uniform_positive_gap
      h.layerOneFromHolonomyWithMixing.uniformHolonomyGap

  have hDelta0_le_block :
      Delta0 <= mu * (delta / C)^2 := by
    have hmin_nonneg :
        0 <= min (mu * (delta / C)^2) dUV := by
      exact le_of_lt (lt_min hUniform.2.1 h.layerOneFromHolonomyWithMixing.hUV_pos)
    have hhalf_le_min :
        (1 / 2) * min (mu * (delta / C)^2) dUV
          <= min (mu * (delta / C)^2) dUV := by
      nlinarith
    have hmin_le_block :
        min (mu * (delta / C)^2) dUV <= mu * (delta / C)^2 := by
      exact min_le_left _ _
    rw [h.layerOneFromHolonomyWithMixing.hDelta0_def]
    exact le_trans hhalf_le_min hmin_le_block

  have hFiniteLower : forall n, Delta0 <= Gap n := by
    intro n
    exact le_trans hDelta0_le_block (hUniform.1 n)

  have hContAssumptions :
      UniformFiniteToContinuumGapAssumptions DeltaYM Delta0 Gap := by
    exact
      { Delta0_positive := hLayer.2.2.1
        finite_gap_lower := hFiniteLower
        approximate_continuum_upper := h.approximate_continuum_upper }

  have hCont :
      Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact UniformFiniteToContinuumGapAssumptions.imply_continuum_gap hContAssumptions

  exact
    ⟨hLayer.1,
      hLayer.2.1,
      hLayer.2.2.1,
      hLayer.2.2.2,
      hCont.1,
      hCont.2⟩

/--
Headline positive continuum gap endpoint using epsilon-style continuum
preservation.
-/
theorem ClayFromHolonomyWithMixingEpsilonContinuumAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyWithMixingEpsilonContinuumAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    (ClayFromHolonomyWithMixingEpsilonContinuumAssumptions.imply_clay_gap h).2.2.2.2.2

end RussoYM

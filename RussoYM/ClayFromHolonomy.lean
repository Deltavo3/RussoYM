import Mathlib
import RussoYM.LayerOneFromHolonomy
import RussoYM.ContinuumGap

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

end RussoYM

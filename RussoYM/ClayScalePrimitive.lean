import RussoYM.ClayPrimitiveObligations

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Scale Primitive

This file begins the primitive-obligation phase with the easiest obligation:
the reduced Layer-One scale data.

The scale primitive obligation is not a hard analytic theorem. It is a
normalization/definition packet:

  0 < dUV,
  Delta0 = (1 / 2) * min dBlock dUV.

The block positivity is supplied separately by the holonomy/coercivity packet.
-/

/--
Construct the primitive scale obligation from UV positivity and the definition
of `Delta0`.
-/
theorem ClayScalePrimitiveObligation.of_uv_pos_and_delta0_def
    {Delta0 dBlock dUV : Real}
    (hUV_pos : 0 < dUV)
    (hDelta0_def : Delta0 = (1 / 2) * min dBlock dUV) :
    ClayScalePrimitiveObligation Delta0 dBlock dUV := by
  exact
    { hUV_pos := hUV_pos
      hDelta0_def := hDelta0_def }

/--
A primitive scale obligation plus block positivity recovers the positive
Layer-One scale packet.
-/
theorem ClayScalePrimitiveObligation.to_positive_scale_of_block_pos
    {Delta0 dBlock dUV : Real}
    (hBlock_pos : 0 < dBlock)
    (hScale :
      ClayScalePrimitiveObligation Delta0 dBlock dUV) :
    LayerOnePositiveScaleAssumptions Delta0 dBlock dUV := by
  exact
    LayerOneReducedScaleAssumptions.to_positive_scale
      hBlock_pos hScale

/--
A primitive scale obligation plus block positivity gives positivity of Delta0.
-/
theorem ClayScalePrimitiveObligation.imply_delta0_positive_of_block_pos
    {Delta0 dBlock dUV : Real}
    (hBlock_pos : 0 < dBlock)
    (hScale :
      ClayScalePrimitiveObligation Delta0 dBlock dUV) :
    0 < Delta0 := by
  exact
    LayerOnePositiveScaleAssumptions.imply_delta0_positive
      (ClayScalePrimitiveObligation.to_positive_scale_of_block_pos
        hBlock_pos hScale)

/--
In the Clay route, holonomy plus the primitive scale obligation gives positivity
of Delta0 for the concrete block scale `mu * (delta / C)^2`.
-/
theorem ClayScalePrimitiveObligation.imply_delta0_positive_from_holonomy
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {Delta0 dUV C mu delta : Real}
    (hHolonomy :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta)
    (hScale :
      ClayScalePrimitiveObligation
        Delta0 (mu * (delta / C)^2) dUV) :
    0 < Delta0 := by
  have hBlock_pos :
      0 < mu * (delta / C)^2 := by
    exact UniformHolonomyRedLemmaAssumptions.imply_block_scale_positive hHolonomy
  exact
    ClayScalePrimitiveObligation.imply_delta0_positive_of_block_pos
      hBlock_pos hScale

end RussoYM

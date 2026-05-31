import RussoYM.ClayScalePrimitive

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Continuum Primitive

This file handles the direct continuum primitive obligation.

At the current final direct level, continuum survival has been reduced to the
single inequality:

  Delta0 <= DeltaYM.

Together with positivity of `Delta0`, this gives the positive continuum
Yang--Mills gap.
-/

/--
Construct the continuum primitive obligation from the direct survival inequality
`Delta0 <= DeltaYM`.
-/
theorem ClayContinuumPrimitiveObligation.of_delta0_le_deltaYM
    {DeltaYM Delta0 : Real}
    (h : Delta0 <= DeltaYM) :
    ClayContinuumPrimitiveObligation DeltaYM Delta0 := by
  exact
    { delta0_le_deltaYM := h }

/--
The continuum primitive obligation gives continuum gap data once `Delta0` is
positive.
-/
theorem ClayContinuumPrimitiveObligation.imply_continuum_gap_data_of_delta0_pos
    {DeltaYM Delta0 : Real}
    (hCont :
      ClayContinuumPrimitiveObligation DeltaYM Delta0)
    (hDelta0_pos : 0 < Delta0) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact
    ContinuumGapSurvivalAssumptions.imply_continuum_gap_data
      hCont hDelta0_pos

/--
The continuum primitive obligation gives a positive continuum gap once `Delta0`
is positive.
-/
theorem ClayContinuumPrimitiveObligation.imply_positive_continuum_gap_of_delta0_pos
    {DeltaYM Delta0 : Real}
    (hCont :
      ClayContinuumPrimitiveObligation DeltaYM Delta0)
    (hDelta0_pos : 0 < Delta0) :
    0 < DeltaYM := by
  exact
    (ClayContinuumPrimitiveObligation.imply_continuum_gap_data_of_delta0_pos
      hCont hDelta0_pos).2

/--
Holonomy, primitive scale, and primitive continuum survival imply a positive
continuum gap.
-/
theorem ClayContinuumPrimitiveObligation.imply_positive_continuum_gap_from_holonomy_and_scale
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM Delta0 dUV C mu delta : Real}
    (hHolonomy :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta)
    (hScale :
      ClayScalePrimitiveObligation
        Delta0 (mu * (delta / C)^2) dUV)
    (hCont :
      ClayContinuumPrimitiveObligation DeltaYM Delta0) :
    0 < DeltaYM := by
  have hDelta0_pos : 0 < Delta0 := by
    exact
      ClayScalePrimitiveObligation.imply_delta0_positive_from_holonomy
        hHolonomy hScale
  exact
    ClayContinuumPrimitiveObligation.imply_positive_continuum_gap_of_delta0_pos
      hCont hDelta0_pos

end RussoYM

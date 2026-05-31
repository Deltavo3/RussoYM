import RussoYM.ClayContinuumPrimitive

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Reduced Primitive Obligations

This file removes the two easiest primitive packets from the final primitive
assumption set by replacing them with their raw constructor data.

Instead of assuming the scale and continuum primitive packets directly, we assume:

  0 < dUV,
  Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV,
  Delta0 <= DeltaYM.

Lean then constructs the scale and continuum primitive obligations.

After this reduction, the real hard obligations are visibly:

1. holonomy/coercivity,
2. Schur/Feshbach loss-budget.
-/

/--
Reduced primitive assumptions.

The scale and continuum primitive obligations are replaced by their raw
constructor data.
-/
structure ClayReducedPrimitiveObligationAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV C mu delta : Real) : Prop where
  holonomyObligation :
    ClayHolonomyPrimitiveObligation
      links Gap Energy curvatureNorm C mu delta
  hUV_pos :
    0 < dUV
  hDelta0_def :
    Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV
  schurObligation :
    ClaySchurPrimitiveObligation
      DeltaFine Delta0 (mu * (delta / C)^2) dUV
  hContinuumSurvival :
    Delta0 <= DeltaYM

/--
Reduced primitive assumptions imply the previous primitive-obligation
assumption set.
-/
theorem ClayReducedPrimitiveObligationAssumptions.to_primitive_obligations
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayReducedPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ClayPrimitiveObligationAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV C mu delta := by
  exact
    { holonomyObligation := h.holonomyObligation
      scaleObligation :=
        ClayScalePrimitiveObligation.of_uv_pos_and_delta0_def
          h.hUV_pos h.hDelta0_def
      schurObligation := h.schurObligation
      continuumObligation :=
        ClayContinuumPrimitiveObligation.of_delta0_le_deltaYM
          h.hContinuumSurvival }

/--
Reduced primitive theorem: full strongest gap data.
-/
theorem ClayReducedPrimitiveObligationAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayReducedPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClayPrimitiveObligationAssumptions.imply_full_gap_data
      (ClayReducedPrimitiveObligationAssumptions.to_primitive_obligations h)

/--
Reduced primitive theorem: strongest conditional mass-gap summary.
-/
theorem ClayReducedPrimitiveObligationAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayReducedPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayPrimitiveObligationAssumptions.imply_mass_gap
      (ClayReducedPrimitiveObligationAssumptions.to_primitive_obligations h)

/--
Reduced primitive theorem: positive continuum Yang--Mills gap.
-/
theorem ClayReducedPrimitiveObligationAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayReducedPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact
    ClayPrimitiveObligationAssumptions.imply_positive_continuum_gap
      (ClayReducedPrimitiveObligationAssumptions.to_primitive_obligations h)

end RussoYM

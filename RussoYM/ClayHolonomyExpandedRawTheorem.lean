import RussoYM.ClayHolonomyPrimitive

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Holonomy-Expanded Raw Theorem

This file expands the last large named packet in the raw primitive theorem.

Instead of assuming the holonomy primitive obligation as one packet, we assume
its four constituent packets directly:

1. uniform holonomy separation,
2. uniform holonomy curvature control,
3. uniform curvature coercivity,
4. uniform finite gap lower bound.

Together with raw scale, raw Schur, and raw continuum data, these imply the
positive continuum Yang--Mills gap.
-/

/--
Raw primitive assumptions with the holonomy packet expanded into its four
constituent pieces.
-/
structure ClayHolonomyExpandedRawAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV C mu delta : Real) : Prop where
  separation :
    UniformHolonomySeparationAssumptions links delta
  curvatureControl :
    UniformHolonomyCurvatureControlAssumptions links curvatureNorm C
  coercivity :
    UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu
  gapLower :
    UniformGapLowerBoundAssumptions Gap Energy
  hUV_pos :
    0 < dUV
  hDelta0_def :
    Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV
  existsRawSchur :
    ∃ loss : Real,
      loss <= Delta0
        ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine
  hContinuumSurvival :
    Delta0 <= DeltaYM

/--
The holonomy-expanded raw assumptions imply the previous raw primitive
assumptions.
-/
theorem ClayHolonomyExpandedRawAssumptions.to_raw_primitive_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ClayRawPrimitiveAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV C mu delta := by
  exact
    { holonomyObligation :=
        ClayHolonomyPrimitiveObligation.of_packets
          h.separation h.curvatureControl h.coercivity h.gapLower
      hUV_pos := h.hUV_pos
      hDelta0_def := h.hDelta0_def
      existsRawSchur := h.existsRawSchur
      hContinuumSurvival := h.hContinuumSurvival }

/--
Holonomy-expanded raw theorem: full strongest gap data.
-/
theorem ClayHolonomyExpandedRawAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClayRawPrimitiveAssumptions.imply_full_gap_data
      (ClayHolonomyExpandedRawAssumptions.to_raw_primitive_assumptions h)

/--
Holonomy-expanded raw theorem: strongest conditional mass-gap summary.
-/
theorem ClayHolonomyExpandedRawAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayRawPrimitiveAssumptions.imply_mass_gap
      (ClayHolonomyExpandedRawAssumptions.to_raw_primitive_assumptions h)

/--
Holonomy-expanded raw theorem: positive continuum Yang--Mills gap.
-/
theorem ClayHolonomyExpandedRawAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact
    ClayRawPrimitiveAssumptions.imply_positive_continuum_gap
      (ClayHolonomyExpandedRawAssumptions.to_raw_primitive_assumptions h)

end RussoYM

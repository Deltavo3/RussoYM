import RussoYM.ClayHolonomySubpacketPrimitives

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Fully Raw Theorem

This file exposes the current conditional Clay theorem using only raw
inequalities/positivity assumptions.

At this stage, all previously packaged assumptions are expanded into raw data:

1. 0 < delta,
2. forall n, delta <= ‖1 - (links n).prod‖,
3. 0 < C,
4. forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n,
5. 0 < mu,
6. forall n, mu * (curvatureNorm n)^2 <= Energy n,
7. forall n, Energy n <= Gap n,
8. 0 < dUV,
9. Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV,
10. ∃ loss, loss <= Delta0 ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine,
11. Delta0 <= DeltaYM.

From these raw assumptions, the positive continuum Yang--Mills gap follows.
-/

/--
Fully raw assumptions for the current Clay route.
-/
structure ClayFullyRawAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV C mu delta : Real) : Prop where
  hDelta_pos :
    0 < delta
  hHolonomySep :
    forall n, delta <= ‖1 - (links n).prod‖
  hC_pos :
    0 < C
  hHolonomyControl :
    forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n
  hMu_pos :
    0 < mu
  hEnergyCoercive :
    forall n, mu * (curvatureNorm n)^2 <= Energy n
  hGapLower :
    forall n, Energy n <= Gap n
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
Fully raw assumptions imply the holonomy-expanded raw assumptions.
-/
theorem ClayFullyRawAssumptions.to_holonomy_expanded_raw_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ClayHolonomyExpandedRawAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV C mu delta := by
  exact
    { separation :=
        UniformHolonomySeparationAssumptions.of_raw
          h.hDelta_pos h.hHolonomySep
      curvatureControl :=
        UniformHolonomyCurvatureControlAssumptions.of_raw
          h.hC_pos h.hHolonomyControl
      coercivity :=
        UniformCurvatureCoercivityAssumptions.of_raw
          h.hMu_pos h.hEnergyCoercive
      gapLower :=
        UniformGapLowerBoundAssumptions.of_raw
          h.hGapLower
      hUV_pos := h.hUV_pos
      hDelta0_def := h.hDelta0_def
      existsRawSchur := h.existsRawSchur
      hContinuumSurvival := h.hContinuumSurvival }

/--
Fully raw theorem: full strongest gap data.
-/
theorem ClayFullyRawAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClayHolonomyExpandedRawAssumptions.imply_full_gap_data
      (ClayFullyRawAssumptions.to_holonomy_expanded_raw_assumptions h)

/--
Fully raw theorem: strongest conditional mass-gap summary.
-/
theorem ClayFullyRawAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayHolonomyExpandedRawAssumptions.imply_mass_gap
      (ClayFullyRawAssumptions.to_holonomy_expanded_raw_assumptions h)

/--
Fully raw theorem: positive continuum Yang--Mills gap.
-/
theorem ClayFullyRawAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact
    ClayHolonomyExpandedRawAssumptions.imply_positive_continuum_gap
      (ClayFullyRawAssumptions.to_holonomy_expanded_raw_assumptions h)

end RussoYM

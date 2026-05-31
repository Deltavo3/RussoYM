import RussoYM.ClaySchurPrimitive

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Raw Primitive Theorem

This file exposes the reduced primitive theorem using raw scale, Schur, and
continuum inequalities.

At this stage, only the holonomy/coercivity packet remains as a named packet.
The scale, Schur, and continuum obligations are supplied by raw inequalities:

  0 < dUV,
  Delta0 = (1 / 2) * min block dUV,
  ∃ loss, loss <= Delta0 ∧ min block dUV - loss <= DeltaFine,
  Delta0 <= DeltaYM.
-/

/--
Raw primitive assumptions for the current Clay route.
-/
structure ClayRawPrimitiveAssumptions
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
  existsRawSchur :
    ∃ loss : Real,
      loss <= Delta0
        ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine
  hContinuumSurvival :
    Delta0 <= DeltaYM

/--
Raw primitive assumptions imply the reduced primitive obligation assumptions.
-/
theorem ClayRawPrimitiveAssumptions.to_reduced_primitive_obligations
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayRawPrimitiveAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ClayReducedPrimitiveObligationAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV C mu delta := by
  refine
    { holonomyObligation := h.holonomyObligation
      hUV_pos := h.hUV_pos
      hDelta0_def := h.hDelta0_def
      schurObligation := ?_
      hContinuumSurvival := h.hContinuumSurvival }
  rcases h.existsRawSchur with ⟨loss, hLoss, hLower⟩
  exact
    ClaySchurPrimitiveObligation.of_raw_loss_bounds
      hLoss hLower

/--
Raw primitive theorem: full strongest gap data.
-/
theorem ClayRawPrimitiveAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayRawPrimitiveAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClayReducedPrimitiveObligationAssumptions.imply_full_gap_data
      (ClayRawPrimitiveAssumptions.to_reduced_primitive_obligations h)

/--
Raw primitive theorem: strongest conditional mass-gap summary.
-/
theorem ClayRawPrimitiveAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayRawPrimitiveAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayReducedPrimitiveObligationAssumptions.imply_mass_gap
      (ClayRawPrimitiveAssumptions.to_reduced_primitive_obligations h)

/--
Raw primitive theorem: positive continuum Yang--Mills gap.
-/
theorem ClayRawPrimitiveAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayRawPrimitiveAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact
    ClayReducedPrimitiveObligationAssumptions.imply_positive_continuum_gap
      (ClayRawPrimitiveAssumptions.to_reduced_primitive_obligations h)

end RussoYM

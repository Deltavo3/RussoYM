import RussoYM.ClayFinalDirectAssumptionAudit

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Primitive Obligations

This file names the four remaining direct obligations behind the final direct
Clay theorem.

At this point the conditional endpoint has been reduced to:

1. holonomy/coercivity red lemmas,
2. reduced Layer-One scale data,
3. Schur/Feshbach lower bound with direct loss budget,
4. direct continuum survival.

The next phase of the project is to prove these obligations from primitive
analytic mathematics.
-/

/--
Primitive holonomy/coercivity obligation.
-/
abbrev ClayHolonomyPrimitiveObligation
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (C mu delta : Real) : Prop :=
  UniformHolonomyRedLemmaAssumptions
    links Gap Energy curvatureNorm C mu delta

/--
Primitive reduced scale obligation.
-/
abbrev ClayScalePrimitiveObligation
    (Delta0 dBlock dUV : Real) : Prop :=
  LayerOneReducedScaleAssumptions Delta0 dBlock dUV

/--
Primitive Schur/Feshbach loss-budget obligation.
-/
abbrev ClaySchurPrimitiveObligation
    (DeltaFine Delta0 dBlock dUV : Real) : Prop :=
  ∃ loss : Real,
    SchurLossBudgetAssumptions loss Delta0
      ∧ SchurFeshbachLossLowerAssumptions
        DeltaFine dBlock dUV loss

/--
Primitive continuum-survival obligation.
-/
abbrev ClayContinuumPrimitiveObligation
    (DeltaYM Delta0 : Real) : Prop :=
  ContinuumGapSurvivalAssumptions DeltaYM Delta0

/--
The final primitive-obligation assumption set.

This is the cleanest current entrance to the full primitive proof phase.
-/
structure ClayPrimitiveObligationAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV C mu delta : Real) : Prop where
  holonomyObligation :
    ClayHolonomyPrimitiveObligation
      links Gap Energy curvatureNorm C mu delta
  scaleObligation :
    ClayScalePrimitiveObligation
      Delta0 (mu * (delta / C)^2) dUV
  schurObligation :
    ClaySchurPrimitiveObligation
      DeltaFine Delta0 (mu * (delta / C)^2) dUV
  continuumObligation :
    ClayContinuumPrimitiveObligation DeltaYM Delta0

/--
Primitive obligations imply the final direct Clay assumptions.
-/
theorem ClayPrimitiveObligationAssumptions.to_final_direct_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ClayFinalDirectAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV C mu delta := by
  exact
    { holonomyPacket := h.holonomyObligation
      reducedScalePacket := h.scaleObligation
      existsLossBudget := h.schurObligation
      continuumSurvival := h.continuumObligation }

/--
Primitive-obligation theorem: full strongest gap data.
-/
theorem ClayPrimitiveObligationAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    clay_final_direct_theorem_implies_full_gap_data
      (ClayPrimitiveObligationAssumptions.to_final_direct_assumptions h)

/--
Primitive-obligation theorem: strongest conditional mass-gap summary.
-/
theorem ClayPrimitiveObligationAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    clay_final_direct_theorem_implies_mass_gap
      (ClayPrimitiveObligationAssumptions.to_final_direct_assumptions h)

/--
Primitive-obligation theorem: positive continuum Yang--Mills gap.
-/
theorem ClayPrimitiveObligationAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact
    clay_final_direct_theorem_implies_positive_continuum_gap
      (ClayPrimitiveObligationAssumptions.to_final_direct_assumptions h)

end RussoYM

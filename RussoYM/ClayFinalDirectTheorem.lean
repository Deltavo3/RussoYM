import RussoYM.ClayContinuumSurvivalTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Final Direct Theorem

This file exposes the cleanest current direct conditional Clay theorem.

At this stage, the route has been reduced to four direct packets:

1. uniform holonomy/coercivity red lemmas,
2. reduced Layer-One scale data,
3. Schur/Feshbach lower bound with direct loss budget,
4. direct continuum survival inequality Delta0 <= DeltaYM.

This is the cleanest current conditional endpoint before proving the remaining
analytic packets from primitive math.
-/

/--
Cleanest current final direct Clay assumptions.
-/
abbrev ClayFinalDirectAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV C mu delta : Real) : Prop :=
  ClayContinuumSurvivalBudgetAssumptions
    links Gap Energy curvatureNorm
    DeltaYM DeltaFine Delta0 dUV C mu delta

/--
Final direct Clay theorem: full strongest gap data.
-/
theorem clay_final_direct_theorem_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact clay_continuum_survival_theorem_implies_full_gap_data h

/--
Final direct Clay theorem: strongest conditional mass-gap summary.
-/
theorem clay_final_direct_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact clay_continuum_survival_theorem_implies_mass_gap h

/--
Final direct Clay theorem: positive continuum Yang--Mills gap.
-/
theorem clay_final_direct_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact clay_continuum_survival_theorem_implies_positive_continuum_gap h

end RussoYM

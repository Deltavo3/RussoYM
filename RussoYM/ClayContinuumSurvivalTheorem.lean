import RussoYM.ClayContinuumSurvivalForm

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Continuum Survival Theorem

This file exposes the clean direct-continuum-survival version of the current
Clay theorem.

At this stage, the continuum survival obligation has been reduced to the direct
inequality

  Delta0 <= DeltaYM.

Together with positivity of `Delta0`, this gives the positive continuum
Yang--Mills gap.
-/

/--
Direct-continuum-survival theorem: full strongest gap data.
-/
theorem clay_continuum_survival_theorem_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayContinuumSurvivalBudgetAssumptions.imply_full_gap_data h

/--
Direct-continuum-survival theorem: strongest conditional mass-gap summary.
-/
theorem clay_continuum_survival_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayContinuumSurvivalBudgetAssumptions.imply_mass_gap h

/--
Direct-continuum-survival theorem: positive continuum Yang--Mills gap.
-/
theorem clay_continuum_survival_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact ClayContinuumSurvivalBudgetAssumptions.imply_positive_continuum_gap h

end RussoYM

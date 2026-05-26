import RussoYM.ClaySchurBudgetForm

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Schur Budget Theorem

This file exposes the clean Schur-budget version of the current Clay theorem.

At this stage, the Schur/Feshbach side has been reduced to:

1. a direct Schur/Feshbach lower bound with abstract loss:
     min(block, dUV) - loss <= DeltaFine,

2. a loss-budget assumption:
     loss <= Delta0.

This removes the concrete mixing expression from the final Schur theorem and
leaves the analytic burden in the natural form.
-/

/--
Schur-budget theorem: full strongest gap data.
-/
theorem clay_schur_budget_theorem_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClaySchurBudgetAssumptions.imply_full_gap_data h

/--
Schur-budget theorem: strongest conditional mass-gap summary.
-/
theorem clay_schur_budget_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClaySchurBudgetAssumptions.imply_mass_gap h

/--
Schur-budget theorem: positive continuum Yang--Mills gap.
-/
theorem clay_schur_budget_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact ClaySchurBudgetAssumptions.imply_positive_continuum_gap h

end RussoYM

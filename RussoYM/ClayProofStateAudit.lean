import RussoYM.ClaySevenAnalyticObligations

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Proof State Audit

This file records the current formal proof state.

The algebraic/logical part of the current conditional Yang--Mills mass-gap
route has been reduced to seven analytic obligations.

This audit file does not add new assumptions.  It records the chain:

  seven analytic obligations
  -> two-obligation theorem
  -> analytic existence program
  -> explicit raw data theorem
  -> fully raw algebraic theorem
  -> positive continuum Yang--Mills gap.
-/

/--
Proof-state audit: the seven analytic obligations imply the two-obligation
data.
-/
theorem clay_proof_state_seven_to_two_obligation_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClaySevenAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    ∃ _ :
      ClayRawHolonomyExistenceAssumptions
        links Gap Energy curvatureNorm,
      (forall C mu delta : Real,
        0 < delta ->
        (forall n, delta <= ‖1 - (links n).prod‖) ->
        0 < C ->
        (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
        0 < mu ->
        (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
        (forall n, Energy n <= Gap n) ->
        ClayRawTransferExistenceAssumptions DeltaYM C mu delta) := by
  exact ClaySevenAnalyticObligations.to_two_obligation_theorem h

/--
Proof-state audit: the seven analytic obligations imply the analytic existence
program.
-/
theorem clay_proof_state_seven_to_analytic_existence_program
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClaySevenAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    ClayAnalyticExistenceProgram
      links Gap Energy curvatureNorm DeltaYM := by
  rcases ClaySevenAnalyticObligations.to_two_obligation_theorem h with
    ⟨hHol, hTransfer⟩
  exact
    clay_two_obligations_to_analytic_existence_program
      hHol hTransfer

/--
Proof-state audit: the seven analytic obligations imply explicit raw data.
-/
theorem clay_proof_state_seven_to_explicit_raw_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClaySevenAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    ClayExplicitRawDataAssumptions
      links Gap Energy curvatureNorm DeltaYM := by
  exact
    ClayAnalyticExistenceProgram.to_explicit_raw_data_assumptions
      (clay_proof_state_seven_to_analytic_existence_program h)

/--
Proof-state audit: the seven analytic obligations imply the explicit raw-data
conditional theorem.
-/
theorem clay_proof_state_seven_to_explicit_raw_data_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClaySevenAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    0 < DeltaYM := by
  exact
    ClayExplicitRawDataAssumptions.imply_positive_continuum_gap
      (clay_proof_state_seven_to_explicit_raw_data h)

/--
Proof-state audit: the seven analytic obligations imply the full mass-gap
summary.
-/
theorem clay_proof_state_seven_to_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClaySevenAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClaySevenAnalyticObligations.imply_mass_gap_summary h

/--
Headline current proof-state theorem.
-/
theorem clay_current_proof_state_conditional_yang_mills_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClaySevenAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    0 < DeltaYM := by
  exact clay_seven_analytic_obligations_conditional_yang_mills_mass_gap h

end RussoYM

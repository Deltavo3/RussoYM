import RussoYM.ClayTransferExistenceSubObligations

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Seven Analytic Obligations

This file packages the final analytic roadmap into one structure.

The algebraic and logical part of the Clay endpoint is now complete.  What
remains is exactly seven analytic obligations:

1. holonomy separation existence,
2. holonomy-curvature control existence,
3. curvature coercivity existence,
4. finite gap lower comparison,
5. scale transfer existence,
6. Schur/Feshbach loss transfer existence,
7. continuum transfer.

This file states that these seven obligations imply the conditional
Yang--Mills mass-gap endpoint.
-/

/--
The final seven analytic obligations behind the current Clay endpoint.
-/
structure ClaySevenAnalyticObligations
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM : Real) : Prop where
  holonomySeparation :
    ClayHolonomySeparationExistenceAssumptions links
  holonomyCurvatureControl :
    ClayHolonomyCurvatureControlExistenceAssumptions
      links curvatureNorm
  curvatureCoercivity :
    ClayCurvatureCoercivityExistenceAssumptions
      Energy curvatureNorm
  finiteGapLowerComparison :
    ClayFiniteGapLowerComparisonAssumptions Gap Energy
  scaleTransfer :
    forall C mu delta : Real,
      0 < delta ->
      (forall n, delta <= ‖1 - (links n).prod‖) ->
      0 < C ->
      (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
      0 < mu ->
      (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
      (forall n, Energy n <= Gap n) ->
      ClayScaleTransferExistenceAssumptions C mu delta
  schurTransfer :
    forall C mu delta : Real,
      0 < delta ->
      (forall n, delta <= ‖1 - (links n).prod‖) ->
      0 < C ->
      (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
      0 < mu ->
      (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
      (forall n, Energy n <= Gap n) ->
      forall Delta0 dUV : Real,
        0 < dUV ->
        Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
        ClaySchurLossTransferExistenceAssumptions
          C mu delta Delta0 dUV
  continuumTransfer :
    forall C mu delta : Real,
      0 < delta ->
      (forall n, delta <= ‖1 - (links n).prod‖) ->
      0 < C ->
      (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
      0 < mu ->
      (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
      (forall n, Energy n <= Gap n) ->
      forall Delta0 dUV : Real,
        0 < dUV ->
        Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
        ClayContinuumTransferAssumptions DeltaYM Delta0

/--
The seven analytic obligations imply the all-sub-obligations theorem.
-/
theorem ClaySevenAnalyticObligations.imply_all_sub_obligations_mass_gap
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
    clay_all_sub_obligations_conditional_yang_mills_mass_gap
      h.holonomySeparation
      h.holonomyCurvatureControl
      h.curvatureCoercivity
      h.finiteGapLowerComparison
      h.scaleTransfer
      h.schurTransfer
      h.continuumTransfer

/--
The seven analytic obligations imply the mass-gap summary.
-/
theorem ClaySevenAnalyticObligations.imply_mass_gap_summary
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
  exact
    clay_all_sub_obligations_mass_gap_summary
      h.holonomySeparation
      h.holonomyCurvatureControl
      h.curvatureCoercivity
      h.finiteGapLowerComparison
      h.scaleTransfer
      h.schurTransfer
      h.continuumTransfer

/--
The seven analytic obligations imply the two-obligation theorem.
-/
theorem ClaySevenAnalyticObligations.to_two_obligation_theorem
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
  let hHol :
      ClayRawHolonomyExistenceAssumptions
        links Gap Energy curvatureNorm :=
    clay_holonomy_sub_obligations_to_raw_holonomy_existence
      h.holonomySeparation
      h.holonomyCurvatureControl
      h.curvatureCoercivity
      h.finiteGapLowerComparison
  refine ⟨hHol, ?_⟩
  intro C mu delta hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound
  exact
    clay_transfer_sub_obligations_to_raw_transfer_existence
      (h.scaleTransfer
        C mu delta
        hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound)
      (h.schurTransfer
        C mu delta
        hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound)
      (h.continuumTransfer
        C mu delta
        hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound)

/--
Headline seven-obligation conditional Yang--Mills mass-gap theorem.
-/
theorem clay_seven_analytic_obligations_conditional_yang_mills_mass_gap
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
  exact ClaySevenAnalyticObligations.imply_all_sub_obligations_mass_gap h

end RussoYM

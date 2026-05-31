import RussoYM.ClayTwoObligationTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Holonomy Existence Sub-Obligations

This file splits the raw holonomy/coercivity existence obligation into four
natural analytic sub-obligations:

1. holonomy separation: produce `delta > 0`;
2. holonomy-curvature control: produce `C > 0`;
3. curvature coercivity: produce `mu > 0`;
4. finite gap lower comparison: prove `Energy n <= Gap n`.

Together these imply `ClayRawHolonomyExistenceAssumptions`.
-/

/--
Holonomy separation existence.

There exists `delta > 0` such that every regulator index has holonomy deviation
bounded below by `delta`.
-/
structure ClayHolonomySeparationExistenceAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R) : Prop where
  exists_separation :
    ∃ delta : Real,
      0 < delta
        ∧ forall n, delta <= ‖1 - (links n).prod‖

/--
Holonomy-curvature control existence.

There exists `C > 0` such that holonomy deviation is controlled by
`C * curvatureNorm n`.
-/
structure ClayHolonomyCurvatureControlExistenceAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (curvatureNorm : Nat -> Real) : Prop where
  exists_control :
    ∃ C : Real,
      0 < C
        ∧ forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n

/--
Curvature coercivity existence.

There exists `mu > 0` such that energy controls squared curvature norm.
-/
structure ClayCurvatureCoercivityExistenceAssumptions
    (Energy curvatureNorm : Nat -> Real) : Prop where
  exists_coercivity :
    ∃ mu : Real,
      0 < mu
        ∧ forall n, mu * (curvatureNorm n)^2 <= Energy n

/--
Finite gap lower comparison.

The finite-regulator gap dominates the energy lower quantity.
-/
structure ClayFiniteGapLowerComparisonAssumptions
    (Gap Energy : Nat -> Real) : Prop where
  gap_lower :
    forall n, Energy n <= Gap n

/--
Holonomy separation existence exposes a separation witness.
-/
theorem ClayHolonomySeparationExistenceAssumptions.exists_delta_witness
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    (h :
      ClayHolonomySeparationExistenceAssumptions links) :
    ∃ delta : Real,
      0 < delta
        ∧ forall n, delta <= ‖1 - (links n).prod‖ := by
  exact h.exists_separation

/--
Holonomy-curvature control existence exposes a control witness.
-/
theorem ClayHolonomyCurvatureControlExistenceAssumptions.exists_C_witness
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {curvatureNorm : Nat -> Real}
    (h :
      ClayHolonomyCurvatureControlExistenceAssumptions
        links curvatureNorm) :
    ∃ C : Real,
      0 < C
        ∧ forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n := by
  exact h.exists_control

/--
Curvature coercivity existence exposes a coercivity witness.
-/
theorem ClayCurvatureCoercivityExistenceAssumptions.exists_mu_witness
    {Energy curvatureNorm : Nat -> Real}
    (h :
      ClayCurvatureCoercivityExistenceAssumptions
        Energy curvatureNorm) :
    ∃ mu : Real,
      0 < mu
        ∧ forall n, mu * (curvatureNorm n)^2 <= Energy n := by
  exact h.exists_coercivity

/--
Finite gap lower comparison exposes the raw gap lower inequality.
-/
theorem ClayFiniteGapLowerComparisonAssumptions.expose_gap_lower
    {Gap Energy : Nat -> Real}
    (h :
      ClayFiniteGapLowerComparisonAssumptions Gap Energy) :
    forall n, Energy n <= Gap n := by
  exact h.gap_lower

/--
The four holonomy/coercivity sub-obligations imply raw holonomy existence.
-/
theorem clay_holonomy_sub_obligations_to_raw_holonomy_existence
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    (hSep :
      ClayHolonomySeparationExistenceAssumptions links)
    (hControl :
      ClayHolonomyCurvatureControlExistenceAssumptions
        links curvatureNorm)
    (hCoercive :
      ClayCurvatureCoercivityExistenceAssumptions
        Energy curvatureNorm)
    (hGap :
      ClayFiniteGapLowerComparisonAssumptions Gap Energy) :
    ClayRawHolonomyExistenceAssumptions
      links Gap Energy curvatureNorm := by
  rcases hSep.exists_separation with
    ⟨delta, hDelta_pos, hSepBound⟩
  rcases hControl.exists_control with
    ⟨C, hC_pos, hControlBound⟩
  rcases hCoercive.exists_coercivity with
    ⟨mu, hMu_pos, hEnergyBound⟩
  exact
    { exists_holonomy_data :=
        ⟨C, mu, delta,
          hDelta_pos,
          hSepBound,
          hC_pos,
          hControlBound,
          hMu_pos,
          hEnergyBound,
          hGap.gap_lower⟩ }

/--
The four holonomy/coercivity sub-obligations plus transfer existence imply the
two-obligation Clay theorem.
-/
theorem clay_holonomy_sub_obligations_with_transfer_imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hSep :
      ClayHolonomySeparationExistenceAssumptions links)
    (hControl :
      ClayHolonomyCurvatureControlExistenceAssumptions
        links curvatureNorm)
    (hCoercive :
      ClayCurvatureCoercivityExistenceAssumptions
        Energy curvatureNorm)
    (hGap :
      ClayFiniteGapLowerComparisonAssumptions Gap Energy)
    (hTransferForWitness :
      forall C mu delta : Real,
        0 < delta ->
        (forall n, delta <= ‖1 - (links n).prod‖) ->
        0 < C ->
        (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
        0 < mu ->
        (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
        (forall n, Energy n <= Gap n) ->
        ClayRawTransferExistenceAssumptions DeltaYM C mu delta) :
    0 < DeltaYM := by
  have hHol :
      ClayRawHolonomyExistenceAssumptions
        links Gap Energy curvatureNorm := by
    exact
      clay_holonomy_sub_obligations_to_raw_holonomy_existence
        hSep hControl hCoercive hGap
  exact
    clay_two_obligations_conditional_yang_mills_mass_gap
      hHol hTransferForWitness

/--
The four holonomy/coercivity sub-obligations plus transfer existence imply the
mass-gap summary.
-/
theorem clay_holonomy_sub_obligations_with_transfer_imply_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hSep :
      ClayHolonomySeparationExistenceAssumptions links)
    (hControl :
      ClayHolonomyCurvatureControlExistenceAssumptions
        links curvatureNorm)
    (hCoercive :
      ClayCurvatureCoercivityExistenceAssumptions
        Energy curvatureNorm)
    (hGap :
      ClayFiniteGapLowerComparisonAssumptions Gap Energy)
    (hTransferForWitness :
      forall C mu delta : Real,
        0 < delta ->
        (forall n, delta <= ‖1 - (links n).prod‖) ->
        0 < C ->
        (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
        0 < mu ->
        (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
        (forall n, Energy n <= Gap n) ->
        ClayRawTransferExistenceAssumptions DeltaYM C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  have hHol :
      ClayRawHolonomyExistenceAssumptions
        links Gap Energy curvatureNorm := by
    exact
      clay_holonomy_sub_obligations_to_raw_holonomy_existence
        hSep hControl hCoercive hGap
  exact
    clay_two_obligations_mass_gap_summary
      hHol hTransferForWitness

end RussoYM

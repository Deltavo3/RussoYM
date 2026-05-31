import RussoYM.ClaySeparatedAnalyticObligations

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Raw Holonomy Existence

This file isolates the first major analytic existence obligation.

The fully raw Clay theorem ultimately needs constants `C`, `mu`, and `delta`
satisfying:

1. `0 < delta`,
2. `forall n, delta <= ‖1 - (links n).prod‖`,
3. `0 < C`,
4. `forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n`,
5. `0 < mu`,
6. `forall n, mu * (curvatureNorm n)^2 <= Energy n`,
7. `forall n, Energy n <= Gap n`.

This file gives this obligation its own name and connects it to the separated
analytic-obligation ledger.
-/

/--
Raw holonomy/coercivity existence obligation.

This says there exist constants `C`, `mu`, and `delta` satisfying the raw
holonomy, curvature-control, coercivity, and finite-gap lower data.
-/
structure ClayRawHolonomyExistenceAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real) : Prop where
  exists_holonomy_data :
    ∃ C mu delta : Real,
      0 < delta
        ∧ (forall n, delta <= ‖1 - (links n).prod‖)
        ∧ 0 < C
        ∧ (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n)
        ∧ 0 < mu
        ∧ (forall n, mu * (curvatureNorm n)^2 <= Energy n)
        ∧ (forall n, Energy n <= Gap n)

/--
Raw holonomy existence exposes the constants `C`, `mu`, and `delta`.
-/
theorem ClayRawHolonomyExistenceAssumptions.exists_holonomy_witness_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    (h :
      ClayRawHolonomyExistenceAssumptions
        links Gap Energy curvatureNorm) :
    ∃ C mu delta : Real,
      0 < delta
        ∧ (forall n, delta <= ‖1 - (links n).prod‖)
        ∧ 0 < C
        ∧ (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n)
        ∧ 0 < mu
        ∧ (forall n, mu * (curvatureNorm n)^2 <= Energy n)
        ∧ (forall n, Energy n <= Gap n) := by
  exact h.exists_holonomy_data

/--
Separated analytic obligations imply raw holonomy existence.
-/
theorem ClaySeparatedAnalyticObligations.to_raw_holonomy_existence
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClaySeparatedAnalyticObligations
        links Gap Energy curvatureNorm DeltaYM) :
    ClayRawHolonomyExistenceAssumptions
      links Gap Energy curvatureNorm := by
  rcases h.exists_separated_data with
    ⟨C, mu, delta,
      hDelta_pos,
      hSep,
      hC_pos,
      hControl,
      hMu_pos,
      hEnergy,
      hGap,
      hTransfer⟩
  exact
    { exists_holonomy_data :=
        ⟨C, mu, delta,
          hDelta_pos,
          hSep,
          hC_pos,
          hControl,
          hMu_pos,
          hEnergy,
          hGap⟩ }

/--
Raw holonomy existence plus a transfer obligation for the same holonomy
constants gives separated analytic obligations.

This is the useful recombination theorem: after proving holonomy/coercivity
existence, it remains to prove transfer existence for those constants.
-/
theorem ClayRawHolonomyExistenceAssumptions.to_separated_analytic_obligations
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hHol :
      ClayRawHolonomyExistenceAssumptions
        links Gap Energy curvatureNorm)
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
    ClaySeparatedAnalyticObligations
      links Gap Energy curvatureNorm DeltaYM := by
  rcases hHol.exists_holonomy_data with
    ⟨C, mu, delta,
      hDelta_pos,
      hSep,
      hC_pos,
      hControl,
      hMu_pos,
      hEnergy,
      hGap⟩
  exact
    { exists_separated_data :=
        ⟨C, mu, delta,
          hDelta_pos,
          hSep,
          hC_pos,
          hControl,
          hMu_pos,
          hEnergy,
          hGap,
          hTransferForWitness
            C mu delta
            hDelta_pos hSep hC_pos hControl hMu_pos hEnergy hGap⟩ }

/--
Raw holonomy existence plus transfer existence for the holonomy witnesses implies
positive continuum Yang--Mills gap.
-/
theorem ClayRawHolonomyExistenceAssumptions.imply_positive_continuum_gap_with_transfer
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hHol :
      ClayRawHolonomyExistenceAssumptions
        links Gap Energy curvatureNorm)
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
  exact
    ClaySeparatedAnalyticObligations.imply_positive_continuum_gap
      (ClayRawHolonomyExistenceAssumptions.to_separated_analytic_obligations
        hHol hTransferForWitness)

/--
Raw holonomy existence plus transfer existence for the holonomy witnesses implies
the mass-gap summary.
-/
theorem ClayRawHolonomyExistenceAssumptions.imply_mass_gap_summary_with_transfer
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hHol :
      ClayRawHolonomyExistenceAssumptions
        links Gap Energy curvatureNorm)
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
  exact
    ClaySeparatedAnalyticObligations.imply_mass_gap_summary
      (ClayRawHolonomyExistenceAssumptions.to_separated_analytic_obligations
        hHol hTransferForWitness)

end RussoYM

import RussoYM.ClayRawTransferExistence

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Two-Obligation Theorem

This file states the remaining Clay endpoint as exactly two analytic
obligations:

1. raw holonomy/coercivity existence;
2. raw transfer existence for the holonomy/coercivity witnesses.

This is the cleanest roadmap theorem before attacking the hard analysis.
-/

/--
Two-obligation theorem: raw holonomy/coercivity existence plus raw transfer
existence gives the analytic existence program.
-/
theorem clay_two_obligations_to_analytic_existence_program
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
    ClayAnalyticExistenceProgram
      links Gap Energy curvatureNorm DeltaYM := by
  exact
    { holonomyExistence := hHol
      transferForHolonomyWitness := hTransferForWitness }

/--
Two-obligation theorem: raw holonomy/coercivity existence plus raw transfer
existence gives separated analytic obligations.
-/
theorem clay_two_obligations_to_separated_analytic_obligations
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
  exact
    ClayAnalyticExistenceProgram.to_separated_analytic_obligations
      (clay_two_obligations_to_analytic_existence_program
        hHol hTransferForWitness)

/--
Two-obligation theorem: raw holonomy/coercivity existence plus raw transfer
existence gives positive continuum Yang--Mills gap.
-/
theorem clay_two_obligations_conditional_yang_mills_mass_gap
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
    ClayAnalyticExistenceProgram.imply_positive_continuum_gap
      (clay_two_obligations_to_analytic_existence_program
        hHol hTransferForWitness)

/--
Two-obligation theorem: raw holonomy/coercivity existence plus raw transfer
existence gives the mass-gap summary.
-/
theorem clay_two_obligations_mass_gap_summary
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
    ClayAnalyticExistenceProgram.imply_mass_gap_summary
      (clay_two_obligations_to_analytic_existence_program
        hHol hTransferForWitness)

/--
Two-obligation theorem: raw holonomy/coercivity existence plus raw transfer
existence gives the concrete witness package.
-/
theorem clay_two_obligations_concrete_witness_package
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
    ∃ DeltaFine Delta0 dUV C mu delta : Real,
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta
        ∧ ((0 < mu * (delta / C)^2
              ∧ forall n, mu * (delta / C)^2 <= Gap n)
            ∧ (0 < Delta0
                ∧ Delta0 <= DeltaFine
                ∧ Delta0 <= DeltaYM)
            ∧ 0 < DeltaYM) := by
  exact
    ClayAnalyticExistenceProgram.imply_exists_concrete_witness_package
      (clay_two_obligations_to_analytic_existence_program
        hHol hTransferForWitness)

end RussoYM

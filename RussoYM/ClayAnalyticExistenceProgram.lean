import RussoYM.ClayRawHolonomyExistence

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Analytic Existence Program

This file packages the remaining hard analytic proof obligations into a single
program-level structure.

The algebraic Clay theorem is complete.  What remains analytically is:

1. prove raw holonomy/coercivity existence;
2. prove transfer existence for the resulting holonomy/coercivity witnesses.

Together these imply the separated analytic obligations, hence the explicit raw
data theorem, hence the positive continuum Yang--Mills gap.
-/

/--
Analytic existence program for the Clay endpoint.

This contains:

1. raw holonomy/coercivity existence;
2. transfer existence for any constants satisfying the raw holonomy/coercivity
   witness conditions.
-/
structure ClayAnalyticExistenceProgram
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM : Real) : Prop where
  holonomyExistence :
    ClayRawHolonomyExistenceAssumptions
      links Gap Energy curvatureNorm
  transferForHolonomyWitness :
    forall C mu delta : Real,
      0 < delta ->
      (forall n, delta <= ‖1 - (links n).prod‖) ->
      0 < C ->
      (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
      0 < mu ->
      (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
      (forall n, Energy n <= Gap n) ->
      ClayRawTransferExistenceAssumptions DeltaYM C mu delta

/--
The analytic existence program implies separated analytic obligations.
-/
theorem ClayAnalyticExistenceProgram.to_separated_analytic_obligations
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayAnalyticExistenceProgram
        links Gap Energy curvatureNorm DeltaYM) :
    ClaySeparatedAnalyticObligations
      links Gap Energy curvatureNorm DeltaYM := by
  exact
    ClayRawHolonomyExistenceAssumptions.to_separated_analytic_obligations
      h.holonomyExistence
      h.transferForHolonomyWitness

/--
The analytic existence program implies explicit raw-data assumptions.
-/
theorem ClayAnalyticExistenceProgram.to_explicit_raw_data_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayAnalyticExistenceProgram
        links Gap Energy curvatureNorm DeltaYM) :
    ClayExplicitRawDataAssumptions
      links Gap Energy curvatureNorm DeltaYM := by
  exact
    ClaySeparatedAnalyticObligations.to_explicit_raw_data_assumptions
      (ClayAnalyticExistenceProgram.to_separated_analytic_obligations h)

/--
The analytic existence program implies positive continuum Yang--Mills gap.
-/
theorem ClayAnalyticExistenceProgram.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayAnalyticExistenceProgram
        links Gap Energy curvatureNorm DeltaYM) :
    0 < DeltaYM := by
  exact
    ClaySeparatedAnalyticObligations.imply_positive_continuum_gap
      (ClayAnalyticExistenceProgram.to_separated_analytic_obligations h)

/--
The analytic existence program implies the mass-gap summary.
-/
theorem ClayAnalyticExistenceProgram.imply_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayAnalyticExistenceProgram
        links Gap Energy curvatureNorm DeltaYM) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClaySeparatedAnalyticObligations.imply_mass_gap_summary
      (ClayAnalyticExistenceProgram.to_separated_analytic_obligations h)

/--
The analytic existence program implies the concrete witness package.
-/
theorem ClayAnalyticExistenceProgram.imply_exists_concrete_witness_package
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayAnalyticExistenceProgram
        links Gap Energy curvatureNorm DeltaYM) :
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
    ClaySeparatedAnalyticObligations.imply_exists_concrete_witness_package
      (ClayAnalyticExistenceProgram.to_separated_analytic_obligations h)

/--
Headline analytic-existence-program conditional Yang--Mills mass-gap theorem.
-/
theorem clay_analytic_existence_program_conditional_yang_mills_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayAnalyticExistenceProgram
        links Gap Energy curvatureNorm DeltaYM) :
    0 < DeltaYM := by
  exact ClayAnalyticExistenceProgram.imply_positive_continuum_gap h

end RussoYM

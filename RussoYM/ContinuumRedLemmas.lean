import Mathlib
import RussoYM.ContinuumPreservation

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Continuum Red Lemmas

This file decomposes the epsilon-style finite-to-continuum gap preservation
assumption into named red-lemma interfaces.

The goal is to isolate the remaining analytic continuum obligations:

1. a uniform finite-regulator lower bound,
2. an epsilon-style finite-to-continuum approximation from below.

Together these imply the existing `UniformFiniteToContinuumGapAssumptions`.
-/

/--
Uniform finite-regulator lower gap assumption.
-/
structure UniformFiniteGapLowerAssumptions
    (Delta0 : Real)
    (Gap : Nat -> Real) : Prop where
  Delta0_positive :
    0 < Delta0
  finite_gap_lower :
    forall n, Delta0 <= Gap n

/--
Epsilon-style finite-to-continuum approximation assumption.

For every `eta > 0`, some finite-regulator gap lies within `eta` below
`DeltaYM`.
-/
structure EpsilonContinuumApproximationAssumptions
    (DeltaYM : Real)
    (Gap : Nat -> Real) : Prop where
  approximate_continuum_upper :
    forall eta : Real, 0 < eta -> exists n : Nat, Gap n - eta <= DeltaYM

/--
Combined continuum red-lemma assumptions.
-/
structure ContinuumRedLemmaAssumptions
    (DeltaYM Delta0 : Real)
    (Gap : Nat -> Real) : Prop where
  finiteLower :
    UniformFiniteGapLowerAssumptions Delta0 Gap
  epsilonApproximation :
    EpsilonContinuumApproximationAssumptions DeltaYM Gap

/--
The decomposed continuum red lemmas imply the packaged finite-to-continuum
gap-preservation assumptions.
-/
theorem ContinuumRedLemmaAssumptions.imply_uniform_finite_to_continuum_gap_assumptions
    {DeltaYM Delta0 : Real}
    {Gap : Nat -> Real}
    (h : ContinuumRedLemmaAssumptions DeltaYM Delta0 Gap) :
    UniformFiniteToContinuumGapAssumptions DeltaYM Delta0 Gap := by
  exact
    { Delta0_positive := h.finiteLower.Delta0_positive
      finite_gap_lower := h.finiteLower.finite_gap_lower
      approximate_continuum_upper :=
        h.epsilonApproximation.approximate_continuum_upper }

/--
The decomposed continuum red lemmas imply a positive continuum gap.
-/
theorem ContinuumRedLemmaAssumptions.imply_continuum_gap
    {DeltaYM Delta0 : Real}
    {Gap : Nat -> Real}
    (h : ContinuumRedLemmaAssumptions DeltaYM Delta0 Gap) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact UniformFiniteToContinuumGapAssumptions.imply_continuum_gap
    (ContinuumRedLemmaAssumptions.imply_uniform_finite_to_continuum_gap_assumptions h)

/--
The decomposed continuum red lemmas imply the original `ContinuumGapAssumptions`
interface.
-/
theorem ContinuumRedLemmaAssumptions.imply_continuum_gap_assumptions
    {DeltaYM Delta0 : Real}
    {Gap : Nat -> Real}
    (h : ContinuumRedLemmaAssumptions DeltaYM Delta0 Gap) :
    ContinuumGapAssumptions DeltaYM Delta0 := by
  exact UniformFiniteToContinuumGapAssumptions.imply_continuum_gap_assumptions
    (ContinuumRedLemmaAssumptions.imply_uniform_finite_to_continuum_gap_assumptions h)

end RussoYM

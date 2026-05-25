import RussoYM.ContinuumRedLemmas

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Epsilon Continuum Survival

This file names the Clay-side epsilon-continuum survival obligation.

It does not prove the analytic epsilon-to-zero theorem from primitive analysis.
Instead, it isolates the exact red lemma that must later be proved:

finite-regulator gap information survives the epsilon-continuum limit.
-/

/--
Named epsilon-continuum survival red-lemma packet.

This is the Clay-side analytic survival obligation: the finite-regulator gap
sequence `Gap` transfers to the continuum Yang--Mills gap `DeltaYM`.
-/
structure EpsilonContinuumSurvivalAssumptions
    (DeltaYM : Real)
    (Gap : Nat -> Real) : Prop where
  epsilonContinuumApproximation :
    EpsilonContinuumApproximationAssumptions DeltaYM Gap

/--
The named epsilon-continuum survival packet recovers the existing epsilon
continuum approximation packet.
-/
theorem EpsilonContinuumSurvivalAssumptions.to_epsilon_continuum_approximation
    {DeltaYM : Real}
    {Gap : Nat -> Real}
    (h : EpsilonContinuumSurvivalAssumptions DeltaYM Gap) :
    EpsilonContinuumApproximationAssumptions DeltaYM Gap := by
  exact h.epsilonContinuumApproximation

/--
The named epsilon-continuum survival packet can be combined with the finite
lower-bound packet to recover the decomposed continuum red-lemma packet.
-/
theorem EpsilonContinuumSurvivalAssumptions.to_continuum_red_lemmas
    {DeltaYM Delta0 : Real}
    {Gap : Nat -> Real}
    (hFinite : UniformFiniteGapLowerAssumptions Delta0 Gap)
    (hSurvival : EpsilonContinuumSurvivalAssumptions DeltaYM Gap) :
    ContinuumRedLemmaAssumptions DeltaYM Delta0 Gap := by
  exact
    { finiteLower := hFinite
      epsilonApproximation :=
        EpsilonContinuumSurvivalAssumptions.to_epsilon_continuum_approximation
          hSurvival }

end RussoYM

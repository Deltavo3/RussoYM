import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Continuum Gap Interface

This file records the final algebraic endpoint of the gap-preserving
continuum-convergence step.

It does not prove norm-resolvent convergence or construct continuum
Yang--Mills. It packages the conclusion of such an analytic theorem:

a uniform finite-regulator gap lower bound Delta0 survives in the
continuum Hamiltonian gap DeltaYM.
-/

/--
Continuum gap-preservation assumptions.

`Delta0` is the uniform finite-regulator lower bound.
`DeltaYM` is the continuum Yang--Mills gap lower bound.
-/
structure ContinuumGapAssumptions
    (DeltaYM Delta0 : Real) : Prop where
  hDelta0_pos : 0 < Delta0
  hGap_preserved : Delta0 <= DeltaYM

/--
If a positive uniform finite-regulator gap is preserved in the continuum
limit, then the continuum Yang--Mills gap is positive.
-/
theorem ContinuumGapAssumptions.imply_continuum_gap
    {DeltaYM Delta0 : Real}
    (h : ContinuumGapAssumptions DeltaYM Delta0) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  have hYM_pos : 0 < DeltaYM := by
    exact lt_of_lt_of_le h.hDelta0_pos h.hGap_preserved
  exact ⟨h.hGap_preserved, hYM_pos⟩

end RussoYM

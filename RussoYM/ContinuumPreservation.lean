import Mathlib
import RussoYM.ContinuumGap

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Continuum Gap Preservation

This file records an epsilon-style algebraic version of continuum gap
preservation.

It does not prove analytic convergence of finite-regulator Hamiltonians.
It proves the order-theoretic closure step:

if a positive lower bound survives up to arbitrarily small loss, then it
survives exactly.
-/

/--
Approximate continuum gap preservation.

For every positive `eta`, the continuum gap is at least `Delta0 - eta`.
-/
structure ApproxContinuumGapAssumptions
    (DeltaYM Delta0 : Real) : Prop where
  Delta0_positive :
    0 < Delta0
  approximate_preservation :
    forall eta : Real, 0 < eta -> Delta0 - eta <= DeltaYM

/--
Approximate preservation implies exact preservation.

If `DeltaYM >= Delta0 - eta` for every `eta > 0`, then `DeltaYM >= Delta0`.
-/
theorem ApproxContinuumGapAssumptions.imply_continuum_gap
    {DeltaYM Delta0 : Real}
    (h : ApproxContinuumGapAssumptions DeltaYM Delta0) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  have hpres : Delta0 <= DeltaYM := by
    by_contra hnot
    have hlt : DeltaYM < Delta0 := by
      exact lt_of_not_ge hnot
    let eta : Real := (Delta0 - DeltaYM) / 2
    have heta : 0 < eta := by
      dsimp [eta]
      linarith
    have happrox : Delta0 - eta <= DeltaYM := by
      exact h.approximate_preservation eta heta
    dsimp [eta] at happrox
    linarith
  have hYM_pos : 0 < DeltaYM := by
    exact lt_of_lt_of_le h.Delta0_positive hpres
  exact ⟨hpres, hYM_pos⟩

/--
Approximate preservation produces the existing `ContinuumGapAssumptions`
interface.
-/
theorem ApproxContinuumGapAssumptions.imply_continuum_gap_assumptions
    {DeltaYM Delta0 : Real}
    (h : ApproxContinuumGapAssumptions DeltaYM Delta0) :
    ContinuumGapAssumptions DeltaYM Delta0 := by
  have hgap : Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact ApproxContinuumGapAssumptions.imply_continuum_gap h
  exact
    { hDelta0_pos := h.Delta0_positive
      hGap_preserved := hgap.1 }

/--
Uniform finite-to-continuum gap preservation assumptions.

`Gap n` is the finite-regulator gap at index `n`.

The assumptions say:

1. every finite gap is bounded below by `Delta0`,
2. for every `eta > 0`, some finite gap is close enough to the continuum gap:
   `Gap n - eta <= DeltaYM`.
-/
structure UniformFiniteToContinuumGapAssumptions
    (DeltaYM Delta0 : Real)
    (Gap : Nat -> Real) : Prop where
  Delta0_positive :
    0 < Delta0
  finite_gap_lower :
    forall n, Delta0 <= Gap n
  approximate_continuum_upper :
    forall eta : Real, 0 < eta -> exists n : Nat, Gap n - eta <= DeltaYM

/--
Uniform finite lower bounds plus epsilon continuum approximation imply the
continuum gap is positive.
-/
theorem UniformFiniteToContinuumGapAssumptions.imply_continuum_gap
    {DeltaYM Delta0 : Real}
    {Gap : Nat -> Real}
    (h : UniformFiniteToContinuumGapAssumptions DeltaYM Delta0 Gap) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  have hApprox : ApproxContinuumGapAssumptions DeltaYM Delta0 := by
    refine
      { Delta0_positive := h.Delta0_positive
        approximate_preservation := ?_ }
    intro eta heta
    obtain ⟨n, hn⟩ := h.approximate_continuum_upper eta heta
    have hlow : Delta0 - eta <= Gap n - eta := by
      linarith [h.finite_gap_lower n]
    exact le_trans hlow hn
  exact ApproxContinuumGapAssumptions.imply_continuum_gap hApprox

/--
Uniform finite-to-continuum preservation produces the existing
`ContinuumGapAssumptions` interface.
-/
theorem UniformFiniteToContinuumGapAssumptions.imply_continuum_gap_assumptions
    {DeltaYM Delta0 : Real}
    {Gap : Nat -> Real}
    (h : UniformFiniteToContinuumGapAssumptions DeltaYM Delta0 Gap) :
    ContinuumGapAssumptions DeltaYM Delta0 := by
  have hgap : Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact UniformFiniteToContinuumGapAssumptions.imply_continuum_gap h
  exact
    { hDelta0_pos := h.Delta0_positive
      hGap_preserved := hgap.1 }

end RussoYM

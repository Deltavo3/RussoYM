import RussoYM.ContinuumRedLemmas

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Continuum Finite-Lower Reduction

This file reduces the finite-continuum lower-bound packet by separating the
positivity of `Delta0` from the finite-regulator lower-bound estimate.

The positivity of `Delta0` can be supplied by the Layer-One scale normalization
theory, so the remaining continuum finite-lower obligation is only

  forall n, Delta0 <= Gap n.
-/

/--
Reduced finite-regulator lower-bound assumption.

This keeps only the actual finite lower-bound estimate.  Positivity of
`Delta0` is supplied separately.
-/
structure FiniteGapLowerOnlyAssumptions
    (Delta0 : Real)
    (Gap : Nat -> Real) : Prop where
  finite_gap_lower :
    forall n, Delta0 <= Gap n

/--
The reduced finite-gap lower assumption plus positivity of `Delta0` recovers
the existing `UniformFiniteGapLowerAssumptions` packet.
-/
theorem FiniteGapLowerOnlyAssumptions.to_uniform_finite_gap_lower
    {Delta0 : Real}
    {Gap : Nat -> Real}
    (hDelta0_pos : 0 < Delta0)
    (h : FiniteGapLowerOnlyAssumptions Delta0 Gap) :
    UniformFiniteGapLowerAssumptions Delta0 Gap := by
  exact
    { Delta0_positive := hDelta0_pos
      finite_gap_lower := h.finite_gap_lower }

/--
The reduced finite-gap lower assumption exposes the finite lower-bound estimate.
-/
theorem FiniteGapLowerOnlyAssumptions.imply_finite_gap_lower
    {Delta0 : Real}
    {Gap : Nat -> Real}
    (h : FiniteGapLowerOnlyAssumptions Delta0 Gap) :
    forall n, Delta0 <= Gap n := by
  exact h.finite_gap_lower

end RussoYM

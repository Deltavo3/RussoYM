import Mathlib
import RussoYM.LayerOneCriterion

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Layer One Interface

This file gives a named interface for the Clay-compatible Layer 1
finite-regulator fine-gap criterion.

It does not prove the analytic red lemmas. It packages their algebraic
output into one assumption structure and exposes the uniform fine-gap
conclusion.
-/

/--
Layer 1 finite-regulator assumptions.

This interface wraps the final algebraic gap-lifting assumptions:

* positive block margin,
* positive UV margin,
* target gap defined as half the decoupled gap,
* mixing loss at most half the decoupled gap,
* fine gap bounded below by decoupled gap minus mixing loss.
-/
structure LayerOneAssumptions
    (DeltaFine Delta0 dBlock dUV Cmix eps ell : Real)
    (kappa : Nat) : Prop where
  fineGap :
    LayerOneFineGapAssumptions
      DeltaFine Delta0 dBlock dUV Cmix eps ell kappa

/--
Layer 1 finite-regulator endpoint.

The named interface conclusion: under the Layer 1 assumptions, the fine gap
has a uniform positive lower bound.
-/
theorem LayerOneAssumptions.imply_uniform_fine_gap
    {DeltaFine Delta0 dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (h :
      LayerOneAssumptions
        DeltaFine Delta0 dBlock dUV Cmix eps ell kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact LayerOneFineGapAssumptions.imply_uniform_fine_gap h.fineGap

end RussoYM

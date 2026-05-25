import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Fine Lower Red Lemmas

This file isolates the final finite/fine-Hamiltonian lower-bound estimate used
in the Clay-compatible Layer One route.
-/

/--
Schur/Feshbach-style fine lower-bound estimate.
-/
structure FineLowerSchurComplementAssumptions
    (DeltaFine dBlock dUV Cmix eps ell : Real)
    (kappa : Nat) : Prop where
  fine_lower_bound :
    min dBlock dUV - 2 * Cmix * (eps / ell)^kappa <= DeltaFine

/--
The Schur/Feshbach fine-lower interface implies the finite/fine lower-bound
inequality used by the Layer One gap criterion.
-/
theorem FineLowerSchurComplementAssumptions.imply_fine_lower
    {DeltaFine dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (h :
      FineLowerSchurComplementAssumptions
        DeltaFine dBlock dUV Cmix eps ell kappa) :
    min dBlock dUV - 2 * Cmix * (eps / ell)^kappa <= DeltaFine := by
  exact h.fine_lower_bound

/--
Named red-lemma packet for the finite/fine lower-bound step.
-/
structure FineLowerRedLemmaAssumptions
    (DeltaFine dBlock dUV Cmix eps ell : Real)
    (kappa : Nat) : Prop where
  schurComplement :
    FineLowerSchurComplementAssumptions
      DeltaFine dBlock dUV Cmix eps ell kappa

/--
The fine-lower red-lemma packet implies the finite/fine lower-bound inequality.
-/
theorem FineLowerRedLemmaAssumptions.imply_fine_lower
    {DeltaFine dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (h :
      FineLowerRedLemmaAssumptions
        DeltaFine dBlock dUV Cmix eps ell kappa) :
    min dBlock dUV - 2 * Cmix * (eps / ell)^kappa <= DeltaFine := by
  exact FineLowerSchurComplementAssumptions.imply_fine_lower h.schurComplement

end RussoYM

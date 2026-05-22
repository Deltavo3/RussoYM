import Mathlib
import RussoYM.LayerOneInterface
import RussoYM.ContinuumGap

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Criterion

This file packages the final algebraic endpoint of the Layer 1 program:

Layer One finite-regulator uniform fine gap
+ gap-preserving continuum convergence
=> positive continuum Yang--Mills gap.

It does not prove the analytic red lemmas.
-/

/--
Final Clay-compatible assumptions.

`DeltaFine` is the finite-regulator fine gap.
`Delta0` is the uniform positive lower bound.
`DeltaYM` is the continuum Yang--Mills gap.
-/
structure ClayYMGapAssumptions
    (DeltaYM DeltaFine Delta0 dBlock dUV Cmix eps ell : Real)
    (kappa : Nat) : Prop where
  layerOne :
    LayerOneAssumptions
      DeltaFine Delta0 dBlock dUV Cmix eps ell kappa
  continuum :
    ContinuumGapAssumptions DeltaYM Delta0

/--
Final algebraic endpoint:

if Layer One gives a positive uniform finite-regulator gap and the
gap-preserving continuum theorem carries that lower bound to continuum
Yang--Mills, then the continuum Yang--Mills gap is positive.
-/
theorem ClayYMGapAssumptions.imply_clay_gap
    {DeltaYM DeltaFine Delta0 dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (h :
      ClayYMGapAssumptions
        DeltaYM DeltaFine Delta0 dBlock dUV Cmix eps ell kappa) :
    Delta0 <= DeltaFine ∧ 0 < DeltaFine ∧ Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  have hLayer :
      Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
    exact LayerOneAssumptions.imply_uniform_fine_gap h.layerOne
  have hCont :
      Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact ContinuumGapAssumptions.imply_continuum_gap h.continuum
  exact ⟨hLayer.1, hLayer.2.2, hCont.1, hCont.2⟩

end RussoYM

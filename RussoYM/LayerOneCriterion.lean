import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Layer One Criterion

This file packages the final algebraic gap-lifting step in the
Clay-compatible Layer 1 architecture.

It does not prove the analytic red lemmas. It records the clean algebra:

uniform block gap
+ uniform UV gap
+ sufficiently small block/UV mixing
=> uniform positive fine gap.
-/

/--
Layer 1 fine-gap assumptions.

`DeltaFine` is the finite-regulator/fine Hamiltonian gap lower bound.
`Delta0` is the target uniform lower bound.
`dBlock` and `dUV` are the uniform block and UV gap margins.
`Cmix * (eps / ell)^kappa` is the quasi-local mixing error.
-/
structure LayerOneFineGapAssumptions
    (DeltaFine Delta0 dBlock dUV Cmix eps ell : Real)
    (kappa : Nat) : Prop where
  hBlock_pos : 0 < dBlock
  hUV_pos : 0 < dUV
  hDelta0_def : Delta0 = (1 / 2) * min dBlock dUV
  hMix_small :
    2 * Cmix * (eps / ell)^kappa <= (1 / 2) * min dBlock dUV
  hFine_lower :
    min dBlock dUV - 2 * Cmix * (eps / ell)^kappa <= DeltaFine

/--
The Layer 1 algebraic endpoint:

if the block/UV gaps are positive and the mixing loss is at most half of the
decoupled gap, then the fine gap has a uniform positive lower bound.
-/
theorem LayerOneFineGapAssumptions.imply_uniform_fine_gap
    {DeltaFine Delta0 dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (h :
      LayerOneFineGapAssumptions
        DeltaFine Delta0 dBlock dUV Cmix eps ell kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  have hmin_pos : 0 < min dBlock dUV := by
    exact lt_min h.hBlock_pos h.hUV_pos
  have hDelta0_pos : 0 < Delta0 := by
    rw [h.hDelta0_def]
    positivity
  have hDelta0_le :
      Delta0 <= min dBlock dUV - 2 * Cmix * (eps / ell)^kappa := by
    rw [h.hDelta0_def]
    nlinarith [h.hMix_small]
  have hDelta0_le_fine : Delta0 <= DeltaFine := by
    exact le_trans hDelta0_le h.hFine_lower
  have hFine_pos : 0 < DeltaFine := by
    exact lt_of_lt_of_le hDelta0_pos hDelta0_le_fine
  exact ⟨hDelta0_le_fine, hDelta0_pos, hFine_pos⟩

end RussoYM

import RussoYM.ClayDelta0MixingAudit

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Fine Gap From Schur Mixing

This file extracts the Layer-One fine-gap conclusion

  Delta0 <= DeltaFine

from:

1. positive Layer-One scale normalization,
2. primitive mixing control targeted at Delta0,
3. the Schur/Feshbach fine-lower estimate.

It does not prove the Schur/Feshbach estimate itself.  It proves that once the
Schur/Feshbach estimate and the Delta0-targeted mixing budget are available,
the desired Layer-One lower bound follows.
-/

/--
Primitive mixing packets targeted at `Delta0` imply the mixing-small estimate
with target `Delta0`.
-/
theorem mixing_small_from_delta0_primitive_packets
    {Cmix eps ell rho Delta0 : Real}
    {kappa : Nat}
    (hPos : MixingScalePositivityAssumptions Cmix eps ell)
    (hSep : MultiplicativeScaleSeparationAssumptions eps ell rho)
    (hBudget : MixingRhoBudgetAssumptions Cmix rho Delta0 kappa) :
    2 * Cmix * (eps / ell)^kappa <= Delta0 := by
  have hMix :
      FiniteMixingRedLemmaAssumptions Cmix eps ell rho Delta0 kappa := by
    exact
      finite_mixing_red_lemmas_from_primitive_packets
        hPos hSep hBudget
  exact FiniteMixingRedLemmaAssumptions.imply_mixing_small hMix

/--
Schur/Feshbach fine lower bound plus Delta0-targeted primitive mixing control
implies the Layer-One fine lower bound `Delta0 <= DeltaFine`.
-/
theorem FineLowerSchurComplementAssumptions.imply_delta0_le_deltaFine
    {DeltaFine Delta0 dBlock dUV Cmix eps ell rho : Real}
    {kappa : Nat}
    (hScale :
      LayerOnePositiveScaleAssumptions Delta0 dBlock dUV)
    (hPos : MixingScalePositivityAssumptions Cmix eps ell)
    (hSep : MultiplicativeScaleSeparationAssumptions eps ell rho)
    (hBudget : MixingRhoBudgetAssumptions Cmix rho Delta0 kappa)
    (hFine :
      FineLowerSchurComplementAssumptions
        DeltaFine dBlock dUV Cmix eps ell kappa) :
    Delta0 <= DeltaFine := by
  have hMixSmall :
      2 * Cmix * (eps / ell)^kappa <= Delta0 := by
    exact
      mixing_small_from_delta0_primitive_packets
        hPos hSep hBudget
  have hFineLower :
      min dBlock dUV - 2 * Cmix * (eps / ell)^kappa <= DeltaFine := by
    exact hFine.fine_lower_bound
  have hDelta0Def :
      Delta0 = (1 / 2) * min dBlock dUV := by
    exact hScale.hDelta0_def
  have hDelta0_le_schur :
      Delta0 <= min dBlock dUV - 2 * Cmix * (eps / ell)^kappa := by
    linarith
  exact le_trans hDelta0_le_schur hFineLower

/--
The Delta0-targeted Clay mixing audit implies the Layer-One fine lower bound.
-/
theorem ClayDelta0MixingAudit.imply_delta0_le_deltaFine
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDelta0MixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    Delta0 <= DeltaFine := by
  exact
    FineLowerSchurComplementAssumptions.imply_delta0_le_deltaFine
      h.positiveScaleNormalization
      h.mixingPositivity
      h.mixingScaleSeparation
      h.mixingBudgetDelta0
      h.fineLowerSchur

/--
The Delta0-targeted Clay mixing audit implies the Layer-One fine gap data.
-/
theorem ClayDelta0MixingAudit.imply_layer_one_fine_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDelta0MixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  have hDelta0Fine : Delta0 <= DeltaFine := by
    exact ClayDelta0MixingAudit.imply_delta0_le_deltaFine h
  have hDelta0Pos : 0 < Delta0 := by
    exact
      LayerOnePositiveScaleAssumptions.imply_delta0_positive
        h.positiveScaleNormalization
  have hDeltaFinePos : 0 < DeltaFine := by
    exact lt_of_lt_of_le hDelta0Pos hDelta0Fine
  exact ⟨hDelta0Fine, hDelta0Pos, hDeltaFinePos⟩

end RussoYM

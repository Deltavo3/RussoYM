import RussoYM.ClayPrimitiveMixingAudit

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Delta0 Mixing Audit

This file refines the primitive mixing audit by expressing the mixing rho-budget
directly in terms of the Layer-One reference gap `Delta0`.

Instead of assuming

  2 * Cmix * rho^kappa <= (1 / 2) * min block dUV,

we assume the cleaner equivalent target

  2 * Cmix * rho^kappa <= Delta0,

and use the positive scale normalization identity

  Delta0 = (1 / 2) * min block dUV

to recover the previous audit.
-/

/--
A rho-budget with target `Delta0` can be converted into the old rho-budget
target `(1 / 2) * min dBlock dUV` using the Layer-One scale definition.
-/
theorem mixing_rho_budget_to_half_min_from_delta0
    {Delta0 dBlock dUV Cmix rho : Real}
    {kappa : Nat}
    (hScale :
      LayerOnePositiveScaleAssumptions Delta0 dBlock dUV)
    (hBudget :
      MixingRhoBudgetAssumptions Cmix rho Delta0 kappa) :
    MixingRhoBudgetAssumptions
      Cmix rho ((1 / 2) * min dBlock dUV) kappa := by
  have hbudget_le :
      2 * Cmix * rho^kappa <= Delta0 := by
    exact hBudget.rho_budget
  rw [hScale.hDelta0_def] at hbudget_le
  exact
    { rho_budget := hbudget_le }

/--
Clay audit with the primitive mixing budget targeted directly at `Delta0`.
-/
structure ClayDelta0MixingAudit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real)
    (kappa : Nat) : Prop where
  holonomySeparation :
    UniformHolonomySeparationAssumptions links delta
  holonomyCurvatureControl :
    UniformHolonomyCurvatureControlAssumptions links curvatureNorm C
  curvatureCoercivity :
    UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu
  finiteGapLower :
    UniformGapLowerBoundAssumptions Gap Energy
  positiveScaleNormalization :
    LayerOnePositiveScaleAssumptions
      Delta0 (mu * (delta / C)^2) dUV
  mixingPositivity :
    MixingScalePositivityAssumptions Cmix eps ell
  mixingScaleSeparation :
    MultiplicativeScaleSeparationAssumptions eps ell rho
  mixingBudgetDelta0 :
    MixingRhoBudgetAssumptions Cmix rho Delta0 kappa
  fineLowerSchur :
    FineLowerSchurComplementAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  continuumApproximation :
    EpsilonContinuumApproximationAssumptions DeltaYM Gap

/--
The Delta0-targeted mixing audit implies the primitive mixing audit.
-/
theorem ClayDelta0MixingAudit.to_primitive_mixing_audit
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
    ClayPrimitiveMixingAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  have hBudgetHalfMin :
      MixingRhoBudgetAssumptions
        Cmix rho ((1 / 2) * min (mu * (delta / C)^2) dUV) kappa := by
    exact
      mixing_rho_budget_to_half_min_from_delta0
        h.positiveScaleNormalization
        h.mixingBudgetDelta0
  exact
    { holonomySeparation := h.holonomySeparation
      holonomyCurvatureControl := h.holonomyCurvatureControl
      curvatureCoercivity := h.curvatureCoercivity
      finiteGapLower := h.finiteGapLower
      positiveScaleNormalization := h.positiveScaleNormalization
      mixingPositivity := h.mixingPositivity
      mixingScaleSeparation := h.mixingScaleSeparation
      mixingBudget := hBudgetHalfMin
      fineLowerSchur := h.fineLowerSchur
      continuumApproximation := h.continuumApproximation }

/--
Conditional mass-gap theorem from the Delta0-targeted mixing audit.
-/
theorem ClayDelta0MixingAudit.imply_conditional_mass_gap
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
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayPrimitiveMixingAudit.imply_conditional_mass_gap
      (ClayDelta0MixingAudit.to_primitive_mixing_audit h)

/--
Positive continuum Yang--Mills gap from the Delta0-targeted mixing audit.
-/
theorem ClayDelta0MixingAudit.imply_positive_continuum_gap
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
    0 < DeltaYM := by
  exact
    ClayPrimitiveMixingAudit.imply_positive_continuum_gap
      (ClayDelta0MixingAudit.to_primitive_mixing_audit h)

end RussoYM

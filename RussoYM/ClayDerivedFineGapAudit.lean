import RussoYM.FineGapFromSchurMixing

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Derived Fine Gap Audit

This file records the current strongest Clay audit route after deriving the
Layer-One fine gap data from the Schur/Feshbach lower bound and Delta0-targeted
mixing control.
-/

/--
Current strongest audit route.

The fine gap data is not assumed separately. It is derived from:

1. positive scale normalization,
2. primitive Delta0-targeted mixing control,
3. Schur/Feshbach fine-lower estimate.
-/
structure ClayDerivedFineGapAudit
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
The derived fine-gap audit implies the Delta0-targeted mixing audit.
-/
theorem ClayDerivedFineGapAudit.to_delta0_mixing_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDerivedFineGapAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayDelta0MixingAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact
    { holonomySeparation := h.holonomySeparation
      holonomyCurvatureControl := h.holonomyCurvatureControl
      curvatureCoercivity := h.curvatureCoercivity
      finiteGapLower := h.finiteGapLower
      positiveScaleNormalization := h.positiveScaleNormalization
      mixingPositivity := h.mixingPositivity
      mixingScaleSeparation := h.mixingScaleSeparation
      mixingBudgetDelta0 := h.mixingBudgetDelta0
      fineLowerSchur := h.fineLowerSchur
      continuumApproximation := h.continuumApproximation }

/--
The derived fine-gap audit implies Layer-One fine gap data.
-/
theorem ClayDerivedFineGapAudit.imply_layer_one_fine_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDerivedFineGapAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact
    ClayDelta0MixingAudit.imply_layer_one_fine_gap_data
      (ClayDerivedFineGapAudit.to_delta0_mixing_audit h)

/--
Conditional mass-gap theorem from the derived fine-gap audit.
-/
theorem ClayDerivedFineGapAudit.imply_conditional_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDerivedFineGapAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayDelta0MixingAudit.imply_conditional_mass_gap
      (ClayDerivedFineGapAudit.to_delta0_mixing_audit h)

/--
Positive continuum Yang--Mills gap from the derived fine-gap audit.
-/
theorem ClayDerivedFineGapAudit.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDerivedFineGapAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayDelta0MixingAudit.imply_positive_continuum_gap
      (ClayDerivedFineGapAudit.to_delta0_mixing_audit h)

end RussoYM

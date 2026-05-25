import RussoYM.ClayFiniteLowerAudit
import RussoYM.FiniteGapLowerFromHolonomy

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Holonomy Finite-Lower Audit

This file refines the reduced finite-lower audit by removing the separate
finite lower-bound-only assumption.

The finite lower-bound-only obligation is derived from:

1. the holonomy/coercivity red-lemma packet,
2. positive Layer-One scale normalization.
-/

/--
Clay audit in which the continuum finite-lower-only obligation is no longer
assumed separately. It is derived from holonomy/coercivity and positive scale
normalization.
-/
structure ClayHolonomyFiniteLowerAudit
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
  finiteMixing :
    FiniteMixingRedLemmaAssumptions
      Cmix eps ell rho ((1 / 2) * min (mu * (delta / C)^2) dUV) kappa
  fineLowerSchur :
    FineLowerSchurComplementAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  continuumApproximation :
    EpsilonContinuumApproximationAssumptions DeltaYM Gap

/--
The holonomy finite-lower audit implies the reduced finite-lower audit.
-/
theorem ClayHolonomyFiniteLowerAudit.to_reduced_finite_lower_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyFiniteLowerAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayReducedFiniteLowerAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  have hHolonomy :
      UniformHolonomyRedLemmaAssumptions
        links Gap Energy curvatureNorm C mu delta := by
    exact
      { separation := h.holonomySeparation
        curvatureControl := h.holonomyCurvatureControl
        coercivity := h.curvatureCoercivity
        gapLower := h.finiteGapLower }
  have hFiniteLowerOnly :
      FiniteGapLowerOnlyAssumptions Delta0 Gap := by
    exact
      FiniteGapLowerOnlyAssumptions.from_holonomy_and_positive_scale
        hHolonomy h.positiveScaleNormalization
  exact
    { holonomySeparation := h.holonomySeparation
      holonomyCurvatureControl := h.holonomyCurvatureControl
      curvatureCoercivity := h.curvatureCoercivity
      finiteGapLower := h.finiteGapLower
      positiveScaleNormalization := h.positiveScaleNormalization
      finiteMixing := h.finiteMixing
      fineLowerSchur := h.fineLowerSchur
      continuumFiniteLowerOnly := hFiniteLowerOnly
      continuumApproximation := h.continuumApproximation }

/--
Conditional mass-gap theorem from the holonomy finite-lower audit.
-/
theorem ClayHolonomyFiniteLowerAudit.imply_conditional_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyFiniteLowerAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayReducedFiniteLowerAudit.imply_conditional_mass_gap
      (ClayHolonomyFiniteLowerAudit.to_reduced_finite_lower_audit h)

/--
Positive continuum Yang--Mills gap from the holonomy finite-lower audit.
-/
theorem ClayHolonomyFiniteLowerAudit.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyFiniteLowerAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayReducedFiniteLowerAudit.imply_positive_continuum_gap
      (ClayHolonomyFiniteLowerAudit.to_reduced_finite_lower_audit h)

end RussoYM

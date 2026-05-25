import RussoYM.ContinuumFiniteLowerReduction
import RussoYM.ClayConditionalEndpoint



set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-
# Clay Finite-Lower Audit

This file refines the positive-scale atomic audit by replacing the continuum
finite-lower packet with the reduced finite lower-bound-only assumption.

The missing positivity of `Delta0` is derived from the positive Layer-One scale
normalization data.
-/

/--
Positive-scale atomic audit with the continuum finite-lower obligation reduced
to only the finite lower-bound estimate.
-/
structure ClayReducedFiniteLowerAudit
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
  continuumFiniteLowerOnly :
    FiniteGapLowerOnlyAssumptions Delta0 Gap
  continuumApproximation :
    EpsilonContinuumApproximationAssumptions DeltaYM Gap

/--
The reduced finite-lower audit implies the previous positive-scale atomic audit.
-/
theorem ClayReducedFiniteLowerAudit.to_positive_scale_atomic_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayReducedFiniteLowerAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayPositiveScaleAtomicAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  have hDelta0_pos : 0 < Delta0 := by
    exact
      LayerOnePositiveScaleAssumptions.imply_delta0_positive
        h.positiveScaleNormalization
  exact
    { holonomySeparation := h.holonomySeparation
      holonomyCurvatureControl := h.holonomyCurvatureControl
      curvatureCoercivity := h.curvatureCoercivity
      finiteGapLower := h.finiteGapLower
      positiveScaleNormalization := h.positiveScaleNormalization
      finiteMixing := h.finiteMixing
      fineLowerSchur := h.fineLowerSchur
      continuumFiniteLower :=
        FiniteGapLowerOnlyAssumptions.to_uniform_finite_gap_lower
          hDelta0_pos h.continuumFiniteLowerOnly
      continuumApproximation := h.continuumApproximation }

/--
Headline conditional mass-gap theorem from the reduced finite-lower audit.
-/
theorem ClayReducedFiniteLowerAudit.imply_conditional_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayReducedFiniteLowerAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    clay_conditional_mass_gap_summary
      (ClayReducedFiniteLowerAudit.to_positive_scale_atomic_audit h)

/--
Positive continuum Yang--Mills gap from the reduced finite-lower audit.
-/
theorem ClayReducedFiniteLowerAudit.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayReducedFiniteLowerAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    clay_conditional_positive_continuum_gap
      (ClayReducedFiniteLowerAudit.to_positive_scale_atomic_audit h)

end RussoYM

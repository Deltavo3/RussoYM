import RussoYM.ClayAtomicAssumptionAudit
import RussoYM.LayerOneScaleNormalization

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Positive-Scale Audit

This file refines the atomic Clay audit by replacing the Layer-One scale
normalization packet with primitive positive scale data.

It proves that positive block/UV scale data is enough to recover the scale
red-lemma packet used by the atomic Clay endpoint.
-/

/--
Atomic Clay audit with the scale-normalization obligation replaced by primitive
positive scale data.
-/
structure ClayPositiveScaleAtomicAudit
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
  continuumFiniteLower :
    UniformFiniteGapLowerAssumptions Delta0 Gap
  continuumApproximation :
    EpsilonContinuumApproximationAssumptions DeltaYM Gap

/--
The positive-scale atomic audit implies the previous atomic audit.
-/
theorem ClayPositiveScaleAtomicAudit.to_atomic_red_lemma_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPositiveScaleAtomicAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayAtomicRedLemmaAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact
    { holonomySeparation := h.holonomySeparation
      holonomyCurvatureControl := h.holonomyCurvatureControl
      curvatureCoercivity := h.curvatureCoercivity
      finiteGapLower := h.finiteGapLower
      scaleNormalization :=
        LayerOnePositiveScaleAssumptions.to_scale_red_lemmas
          h.positiveScaleNormalization
      finiteMixing := h.finiteMixing
      fineLowerSchur := h.fineLowerSchur
      continuumFiniteLower := h.continuumFiniteLower
      continuumApproximation := h.continuumApproximation }

/--
Clay gap endpoint from the positive-scale atomic audit.
-/
theorem ClayPositiveScaleAtomicAudit.imply_clay_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPositiveScaleAtomicAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact
    ClayAtomicRedLemmaAudit.imply_clay_gap
      (ClayPositiveScaleAtomicAudit.to_atomic_red_lemma_audit h)

/--
Positive continuum Yang--Mills gap endpoint from the positive-scale atomic audit.
-/
theorem ClayPositiveScaleAtomicAudit.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPositiveScaleAtomicAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayAtomicRedLemmaAudit.imply_positive_continuum_gap
      (ClayPositiveScaleAtomicAudit.to_atomic_red_lemma_audit h)

end RussoYM

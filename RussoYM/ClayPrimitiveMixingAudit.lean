import RussoYM.ClayHolonomyFiniteLowerAudit
import RussoYM.MixingRedLemmas

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Primitive Mixing Audit

This file refines the holonomy finite-lower audit by unpacking the finite
mixing red-lemma packet into its already-existing primitive components:

1. mixing/scale positivity,
2. multiplicative scale separation,
3. rho-budget estimate.

It does not add new mixing theory. It only removes one packaging layer from
the current Clay audit route.
-/

/--
Primitive mixing packets imply the packaged finite mixing red-lemma assumptions.
-/
theorem finite_mixing_red_lemmas_from_primitive_packets
    {Cmix eps ell rho target : Real}
    {kappa : Nat}
    (hPos : MixingScalePositivityAssumptions Cmix eps ell)
    (hSep : MultiplicativeScaleSeparationAssumptions eps ell rho)
    (hBudget : MixingRhoBudgetAssumptions Cmix rho target kappa) :
    FiniteMixingRedLemmaAssumptions Cmix eps ell rho target kappa := by
  exact
    { positivity := hPos
      scaleSeparation := hSep
      budget := hBudget }

/--
Clay audit with the finite mixing packet unpacked into primitive mixing
components.
-/
structure ClayPrimitiveMixingAudit
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
  mixingBudget :
    MixingRhoBudgetAssumptions
      Cmix rho ((1 / 2) * min (mu * (delta / C)^2) dUV) kappa
  fineLowerSchur :
    FineLowerSchurComplementAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  continuumApproximation :
    EpsilonContinuumApproximationAssumptions DeltaYM Gap

/--
The primitive mixing audit implies the holonomy finite-lower audit.
-/
theorem ClayPrimitiveMixingAudit.to_holonomy_finite_lower_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPrimitiveMixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayHolonomyFiniteLowerAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  have hFiniteMixing :
      FiniteMixingRedLemmaAssumptions
        Cmix eps ell rho ((1 / 2) * min (mu * (delta / C)^2) dUV) kappa := by
    exact
      finite_mixing_red_lemmas_from_primitive_packets
        h.mixingPositivity
        h.mixingScaleSeparation
        h.mixingBudget
  exact
    { holonomySeparation := h.holonomySeparation
      holonomyCurvatureControl := h.holonomyCurvatureControl
      curvatureCoercivity := h.curvatureCoercivity
      finiteGapLower := h.finiteGapLower
      positiveScaleNormalization := h.positiveScaleNormalization
      finiteMixing := hFiniteMixing
      fineLowerSchur := h.fineLowerSchur
      continuumApproximation := h.continuumApproximation }

/--
Conditional mass-gap theorem from the primitive mixing audit.
-/
theorem ClayPrimitiveMixingAudit.imply_conditional_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPrimitiveMixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayHolonomyFiniteLowerAudit.imply_conditional_mass_gap
      (ClayPrimitiveMixingAudit.to_holonomy_finite_lower_audit h)

/--
Positive continuum Yang--Mills gap from the primitive mixing audit.
-/
theorem ClayPrimitiveMixingAudit.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPrimitiveMixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayHolonomyFiniteLowerAudit.imply_positive_continuum_gap
      (ClayPrimitiveMixingAudit.to_holonomy_finite_lower_audit h)

end RussoYM

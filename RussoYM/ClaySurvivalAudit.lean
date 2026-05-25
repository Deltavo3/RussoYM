import RussoYM.ClayStrongestConditional
import RussoYM.EpsilonContinuumSurvival

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Survival Audit

This file refines the strongest conditional Clay route by replacing the raw
epsilon-continuum approximation packet with the named epsilon-continuum
survival red-lemma packet.

This keeps the Clay endpoint explicitly separated from the physical
interpretation layer: the remaining analytic obligation is precisely survival
of the gap through the epsilon-to-zero continuum construction.
-/

/--
Strongest current Clay audit route with the epsilon-continuum step named as a
survival red lemma.
-/
structure ClaySurvivalAudit
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
  epsilonSurvival :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The survival audit implies the derived fine-gap audit.
-/
theorem ClaySurvivalAudit.to_derived_fine_gap_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClaySurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayDerivedFineGapAudit
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
      continuumApproximation :=
        EpsilonContinuumSurvivalAssumptions.to_epsilon_continuum_approximation
          h.epsilonSurvival }

/--
The survival audit implies the strongest conditional Yang--Mills gap data.
-/
theorem ClaySurvivalAudit.imply_strongest_conditional_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClaySurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    strongest_conditional_yang_mills_gap_data
      (ClaySurvivalAudit.to_derived_fine_gap_audit h)

/--
The survival audit implies the strongest conditional Yang--Mills mass-gap
summary.
-/
theorem ClaySurvivalAudit.imply_strongest_conditional_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClaySurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    strongest_conditional_yang_mills_mass_gap
      (ClaySurvivalAudit.to_derived_fine_gap_audit h)

end RussoYM

import RussoYM.ClaySurvivalConsequences
import RussoYM.UniformHolonomyRedLemmas

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Holonomy Packet Survival Audit

This file refines the survival audit by replacing the four separate holonomy
fields with the already-existing `UniformHolonomyRedLemmaAssumptions` packet.

This keeps the current strongest Clay route organized as:

1. uniform holonomy red-lemma packet,
2. positive scale data,
3. Delta0-targeted primitive mixing control,
4. Schur/Feshbach fine-lower estimate,
5. epsilon-continuum survival.
-/

/--
Survival audit with the holonomy side packaged into the existing uniform
holonomy red-lemma packet.
-/
structure ClayHolonomyPacketSurvivalAudit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real)
    (kappa : Nat) : Prop where
  holonomyPacket :
    UniformHolonomyRedLemmaAssumptions
      links Gap Energy curvatureNorm C mu delta
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
The holonomy-packet survival audit implies the previous survival audit.
-/
theorem ClayHolonomyPacketSurvivalAudit.to_survival_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyPacketSurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClaySurvivalAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact
    { holonomySeparation := h.holonomyPacket.separation
      holonomyCurvatureControl := h.holonomyPacket.curvatureControl
      curvatureCoercivity := h.holonomyPacket.coercivity
      finiteGapLower := h.holonomyPacket.gapLower
      positiveScaleNormalization := h.positiveScaleNormalization
      mixingPositivity := h.mixingPositivity
      mixingScaleSeparation := h.mixingScaleSeparation
      mixingBudgetDelta0 := h.mixingBudgetDelta0
      fineLowerSchur := h.fineLowerSchur
      epsilonSurvival := h.epsilonSurvival }

/--
The holonomy-packet survival audit implies Layer-One fine gap data.
-/
theorem ClayHolonomyPacketSurvivalAudit.imply_layer_one_fine_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyPacketSurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact
    ClaySurvivalAudit.imply_layer_one_fine_gap_data
      (ClayHolonomyPacketSurvivalAudit.to_survival_audit h)

/--
The holonomy-packet survival audit implies continuum gap data.
-/
theorem ClayHolonomyPacketSurvivalAudit.imply_continuum_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyPacketSurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact
    ClaySurvivalAudit.imply_continuum_gap_data
      (ClayHolonomyPacketSurvivalAudit.to_survival_audit h)

/--
The holonomy-packet survival audit implies the strongest conditional mass-gap
summary.
-/
theorem ClayHolonomyPacketSurvivalAudit.imply_strongest_conditional_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyPacketSurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClaySurvivalAudit.imply_strongest_conditional_mass_gap
      (ClayHolonomyPacketSurvivalAudit.to_survival_audit h)

/--
The holonomy-packet survival audit implies the full survival gap data.
-/
theorem ClayHolonomyPacketSurvivalAudit.imply_full_survival_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyPacketSurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClaySurvivalAudit.imply_full_survival_gap_data
      (ClayHolonomyPacketSurvivalAudit.to_survival_audit h)

end RussoYM

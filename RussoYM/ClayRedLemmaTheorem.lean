import RussoYM.ClayHolonomyPacketSurvivalAudit

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Red Lemma Theorem

This file exposes the clean red-lemma theorem for the current RussoYM Clay
route.

The theorem says that the strongest conditional Yang--Mills mass-gap endpoint
follows from five named red-lemma packets:

1. uniform holonomy red lemmas,
2. positive Layer-One scale normalization,
3. Delta0-targeted mixing red lemmas,
4. Schur/Feshbach fine-lower estimate,
5. epsilon-continuum survival.
-/

/--
Delta0-targeted mixing red-lemma packet.

This packages the primitive mixing assumptions in the form used by the current
strongest Clay route.
-/
structure Delta0TargetedMixingRedLemmaAssumptions
    (Cmix eps ell rho Delta0 : Real)
    (kappa : Nat) : Prop where
  positivity :
    MixingScalePositivityAssumptions Cmix eps ell
  scaleSeparation :
    MultiplicativeScaleSeparationAssumptions eps ell rho
  budgetDelta0 :
    MixingRhoBudgetAssumptions Cmix rho Delta0 kappa

/--
The Delta0-targeted mixing packet implies the finite mixing red-lemma packet
with target `Delta0`.
-/
theorem Delta0TargetedMixingRedLemmaAssumptions.to_finite_mixing_red_lemmas
    {Cmix eps ell rho Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0TargetedMixingRedLemmaAssumptions
        Cmix eps ell rho Delta0 kappa) :
    FiniteMixingRedLemmaAssumptions Cmix eps ell rho Delta0 kappa := by
  exact
    finite_mixing_red_lemmas_from_primitive_packets
      h.positivity h.scaleSeparation h.budgetDelta0

/--
Clean red-lemma assumptions for the current strongest Clay theorem.
-/
structure ClayRedLemmaTheoremAssumptions
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
  scalePacket :
    LayerOnePositiveScaleAssumptions
      Delta0 (mu * (delta / C)^2) dUV
  mixingPacket :
    Delta0TargetedMixingRedLemmaAssumptions
      Cmix eps ell rho Delta0 kappa
  fineLowerPacket :
    FineLowerSchurComplementAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  survivalPacket :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The clean red-lemma theorem assumptions imply the holonomy-packet survival
audit.
-/
theorem ClayRedLemmaTheoremAssumptions.to_holonomy_packet_survival_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayHolonomyPacketSurvivalAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact
    { holonomyPacket := h.holonomyPacket
      positiveScaleNormalization := h.scalePacket
      mixingPositivity := h.mixingPacket.positivity
      mixingScaleSeparation := h.mixingPacket.scaleSeparation
      mixingBudgetDelta0 := h.mixingPacket.budgetDelta0
      fineLowerSchur := h.fineLowerPacket
      epsilonSurvival := h.survivalPacket }

/--
Full strongest conditional Yang--Mills gap data from the clean red-lemma
theorem assumptions.
-/
theorem ClayRedLemmaTheoremAssumptions.imply_strongest_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClayHolonomyPacketSurvivalAudit.imply_full_survival_gap_data
      (ClayRedLemmaTheoremAssumptions.to_holonomy_packet_survival_audit h)

/--
Clean red-lemma theorem: the strongest conditional Yang--Mills mass-gap
summary follows from the five named red-lemma packets.
-/
theorem clay_red_lemma_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayHolonomyPacketSurvivalAudit.imply_strongest_conditional_mass_gap
      (ClayRedLemmaTheoremAssumptions.to_holonomy_packet_survival_audit h)

/--
Clean red-lemma theorem: the positive continuum Yang--Mills gap follows from
the five named red-lemma packets.
-/
theorem clay_red_lemma_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    (clay_red_lemma_theorem_implies_mass_gap h).2

end RussoYM

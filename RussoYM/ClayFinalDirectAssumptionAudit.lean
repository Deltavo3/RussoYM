import RussoYM.ClayFinalDirectTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Final Direct Assumption Audit

This file exposes the remaining direct obligations behind the final direct Clay
theorem.

The current final theorem has reduced the conditional Yang--Mills mass-gap
endpoint to the following direct packets:

1. uniform holonomy/coercivity red lemmas,
2. reduced Layer-One scale data,
3. a Schur/Feshbach lower bound with a direct loss budget,
4. direct continuum survival: Delta0 <= DeltaYM.

This file records these obligations explicitly before we begin proving or
reducing them from more primitive analytic mathematics.
-/

/--
The final direct assumptions imply the holonomy red-lemma packet.
-/
theorem ClayFinalDirectAssumptions.audit_holonomy_packet
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    UniformHolonomyRedLemmaAssumptions
      links Gap Energy curvatureNorm C mu delta := by
  exact h.holonomyPacket

/--
The final direct assumptions imply the reduced Layer-One scale packet.
-/
theorem ClayFinalDirectAssumptions.audit_reduced_scale_packet
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    LayerOneReducedScaleAssumptions
      Delta0 (mu * (delta / C)^2) dUV := by
  exact h.reducedScalePacket

/--
The final direct assumptions imply the existence of a Schur/Feshbach loss
satisfying both the loss budget and the Schur lower bound.
-/
theorem ClayFinalDirectAssumptions.audit_schur_loss_budget_packet
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ∃ loss : Real,
      SchurLossBudgetAssumptions loss Delta0
        ∧ SchurFeshbachLossLowerAssumptions
          DeltaFine (mu * (delta / C)^2) dUV loss := by
  exact h.existsLossBudget

/--
The final direct assumptions imply the direct continuum survival packet.
-/
theorem ClayFinalDirectAssumptions.audit_continuum_survival_packet
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ContinuumGapSurvivalAssumptions DeltaYM Delta0 := by
  exact h.continuumSurvival

/--
Final direct assumption audit: all remaining direct packets exposed together.
-/
theorem ClayFinalDirectAssumptions.audit_remaining_direct_packets
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    UniformHolonomyRedLemmaAssumptions
      links Gap Energy curvatureNorm C mu delta
      ∧ LayerOneReducedScaleAssumptions
        Delta0 (mu * (delta / C)^2) dUV
      ∧ (∃ loss : Real,
          SchurLossBudgetAssumptions loss Delta0
            ∧ SchurFeshbachLossLowerAssumptions
              DeltaFine (mu * (delta / C)^2) dUV loss)
      ∧ ContinuumGapSurvivalAssumptions DeltaYM Delta0 := by
  exact
    ⟨ClayFinalDirectAssumptions.audit_holonomy_packet h,
      ClayFinalDirectAssumptions.audit_reduced_scale_packet h,
      ClayFinalDirectAssumptions.audit_schur_loss_budget_packet h,
      ClayFinalDirectAssumptions.audit_continuum_survival_packet h⟩

end RussoYM

import RussoYM.ClaySeparatedKappaTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Schur Loss Form

This file refines the Schur/Feshbach fine-lower packet by separating the
generic Schur loss from its concrete mixing-loss expression.

Instead of using only

  min dBlock dUV - 2 * Cmix * (eps / ell)^kappa <= DeltaFine,

we introduce:

  min dBlock dUV - loss <= DeltaFine,

together with

  loss = 2 * Cmix * (eps / ell)^kappa.

This is closer to the analytic Schur/Feshbach proof structure.
-/

/--
Generic Schur/Feshbach lower bound with an abstract loss term.
-/
structure SchurFeshbachLossLowerAssumptions
    (DeltaFine dBlock dUV loss : Real) : Prop where
  schur_loss_lower :
    min dBlock dUV - loss <= DeltaFine

/--
Concrete kappa-dependent mixing loss identity.
-/
structure KappaMixingLossIdentity
    (loss Cmix eps ell : Real)
    (kappa : Nat) : Prop where
  loss_eq :
    loss = 2 * Cmix * (eps / ell)^kappa

/--
A generic Schur/Feshbach loss lower bound plus the concrete kappa mixing-loss
identity recovers the previous fine-lower Schur complement packet.
-/
theorem SchurFeshbachLossLowerAssumptions.to_fine_lower_schur
    {DeltaFine dBlock dUV loss Cmix eps ell : Real}
    {kappa : Nat}
    (hSchur :
      SchurFeshbachLossLowerAssumptions
        DeltaFine dBlock dUV loss)
    (hLoss :
      KappaMixingLossIdentity loss Cmix eps ell kappa) :
    FineLowerSchurComplementAssumptions
      DeltaFine dBlock dUV Cmix eps ell kappa := by
  have hLower :
      min dBlock dUV - 2 * Cmix * (eps / ell)^kappa <= DeltaFine := by
    rw [← hLoss.loss_eq]
    exact hSchur.schur_loss_lower
  exact
    { fine_lower_bound := hLower }

/--
Existential-kappa assumptions with the Schur/Feshbach packet written in
loss form.
-/
structure ClaySchurLossKappaAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real) : Prop where
  holonomyPacket :
    UniformHolonomyRedLemmaAssumptions
      links Gap Energy curvatureNorm C mu delta
  reducedScalePacket :
    LayerOneReducedScaleAssumptions
      Delta0 (mu * (delta / C)^2) dUV
  mixingScaleData :
    Delta0MixingScaleData Cmix eps ell q
  existsKappaLoss :
    ∃ kappa : Nat,
      ∃ loss : Real,
        Delta0MixingKappaDecayBudget Cmix q Delta0 kappa
          ∧ KappaMixingLossIdentity loss Cmix eps ell kappa
          ∧ SchurFeshbachLossLowerAssumptions
            DeltaFine (mu * (delta / C)^2) dUV loss
  survivalPacket :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The Schur-loss kappa assumptions imply the separated-kappa assumptions.
-/
theorem ClaySchurLossKappaAssumptions.to_separated_kappa_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    ClayMixingSeparatedKappaAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta := by
  refine
    { holonomyPacket := h.holonomyPacket
      reducedScalePacket := h.reducedScalePacket
      mixingScaleData := h.mixingScaleData
      existsKappa := ?_
      survivalPacket := h.survivalPacket }
  rcases h.existsKappaLoss with ⟨kappa, loss, hDecay, hLoss, hSchur⟩
  have hFine :
      FineLowerSchurComplementAssumptions
        DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa := by
    exact
      SchurFeshbachLossLowerAssumptions.to_fine_lower_schur
        hSchur hLoss
  exact ⟨kappa, hDecay, hFine⟩

/--
Schur-loss theorem: full strongest gap data.
-/
theorem ClaySchurLossKappaAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClayMixingSeparatedKappaAssumptions.imply_full_gap_data
      (ClaySchurLossKappaAssumptions.to_separated_kappa_assumptions h)

/--
Schur-loss theorem: strongest conditional mass-gap summary.
-/
theorem ClaySchurLossKappaAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayMixingSeparatedKappaAssumptions.imply_mass_gap
      (ClaySchurLossKappaAssumptions.to_separated_kappa_assumptions h)

/--
Schur-loss theorem: positive continuum Yang--Mills gap.
-/
theorem ClaySchurLossKappaAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    0 < DeltaYM := by
  exact
    ClayMixingSeparatedKappaAssumptions.imply_positive_continuum_gap
      (ClaySchurLossKappaAssumptions.to_separated_kappa_assumptions h)

end RussoYM

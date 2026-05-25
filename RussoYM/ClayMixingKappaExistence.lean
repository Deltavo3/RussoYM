import RussoYM.ClayMixingDecayBudget

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Mixing Kappa Existence

This file converts the mixing-decay criterion into an existential-kappa form.

Analytically, one usually chooses `kappa` large enough so that

  q^kappa <= Delta0 / (2 * Cmix).

So instead of fixing `kappa` globally, this file packages the current Clay route
under the assumption that there exists a `kappa` satisfying both the mixing
decay budget and the Schur/Feshbach fine-lower estimate.
-/

/--
Existential-kappa version of the current reduced-scale/mixing-decay Clay
assumptions.

The holonomy, scale, and survival data are independent of `kappa`.  The mixing
decay budget and Schur/Feshbach fine-lower estimate are allowed to hold for
some suitable `kappa`.
-/
structure ClayMixingKappaExistenceAssumptions
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
  existsKappa :
    ∃ kappa : Nat,
      Delta0MixingDecayBudgetAssumptions
        Cmix eps ell q Delta0 kappa
        ∧ FineLowerSchurComplementAssumptions
          DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  survivalPacket :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The existential-kappa assumptions produce a concrete `kappa` satisfying the
mixing-decay direct Clay assumptions.
-/
theorem ClayMixingKappaExistenceAssumptions.exists_decay_budget_direct_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingKappaExistenceAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    ∃ kappa : Nat,
      ClayMixingDecayBudgetDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa := by
  rcases h.existsKappa with ⟨kappa, hMix, hFine⟩
  exact
    ⟨kappa,
      { holonomyPacket := h.holonomyPacket
        reducedScalePacket := h.reducedScalePacket
        mixingDecayBudget := hMix
        fineLowerPacket := hFine
        survivalPacket := h.survivalPacket }⟩

/--
Existential-kappa theorem: full strongest gap data.
-/
theorem ClayMixingKappaExistenceAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingKappaExistenceAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  rcases
    ClayMixingKappaExistenceAssumptions.exists_decay_budget_direct_assumptions h
    with ⟨kappa, hkappa⟩
  exact ClayMixingDecayBudgetDirectAssumptions.imply_full_gap_data hkappa

/--
Existential-kappa theorem: strongest conditional mass-gap summary.
-/
theorem ClayMixingKappaExistenceAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingKappaExistenceAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  rcases
    ClayMixingKappaExistenceAssumptions.exists_decay_budget_direct_assumptions h
    with ⟨kappa, hkappa⟩
  exact ClayMixingDecayBudgetDirectAssumptions.imply_mass_gap hkappa

/--
Existential-kappa theorem: positive continuum Yang--Mills gap.
-/
theorem ClayMixingKappaExistenceAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingKappaExistenceAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    0 < DeltaYM := by
  exact (ClayMixingKappaExistenceAssumptions.imply_mass_gap h).2

end RussoYM

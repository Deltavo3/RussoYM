import RussoYM.ClayMixingKappaExistence

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Mixing Separated Kappa

This file separates the kappa-independent mixing scale data from the
kappa-dependent decay and Schur/Feshbach data.

The kappa-independent data are:

  0 < Cmix,
  0 <= eps,
  0 < ell,
  eps <= q * ell.

The kappa-dependent data are:

  q^kappa <= Delta0 / (2 * Cmix),
  FineLowerSchurComplementAssumptions ... kappa.
-/

/--
Kappa-independent mixing scale data.
-/
structure Delta0MixingScaleData
    (Cmix eps ell q : Real) : Prop where
  hCmix_pos :
    0 < Cmix
  hEps_nonneg :
    0 <= eps
  hEll_pos :
    0 < ell
  hScaleSeparation :
    eps <= q * ell

/--
Kappa-dependent mixing decay budget.
-/
structure Delta0MixingKappaDecayBudget
    (Cmix q Delta0 : Real)
    (kappa : Nat) : Prop where
  q_decay_budget :
    q^kappa <= Delta0 / (2 * Cmix)

/--
Mixing scale data plus a kappa-dependent decay budget recover the previous
decay-budget mixing assumptions.
-/
theorem Delta0MixingScaleData.with_kappa_decay_budget
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (hScale : Delta0MixingScaleData Cmix eps ell q)
    (hDecay : Delta0MixingKappaDecayBudget Cmix q Delta0 kappa) :
    Delta0MixingDecayBudgetAssumptions Cmix eps ell q Delta0 kappa := by
  exact
    { hCmix_pos := hScale.hCmix_pos
      hEps_nonneg := hScale.hEps_nonneg
      hEll_pos := hScale.hEll_pos
      hScaleSeparation := hScale.hScaleSeparation
      q_decay_budget := hDecay.q_decay_budget }

/--
Separated-kappa version of the current Clay assumptions.

The mixing scale data are independent of `kappa`.  The existence of a suitable
`kappa` only needs to provide the decay budget and Schur/Feshbach fine-lower
packet.
-/
structure ClayMixingSeparatedKappaAssumptions
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
  existsKappa :
    ∃ kappa : Nat,
      Delta0MixingKappaDecayBudget Cmix q Delta0 kappa
        ∧ FineLowerSchurComplementAssumptions
          DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  survivalPacket :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The separated-kappa assumptions imply the previous existential-kappa assumptions.
-/
theorem ClayMixingSeparatedKappaAssumptions.to_mixing_kappa_existence_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    ClayMixingKappaExistenceAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta := by
  refine
    { holonomyPacket := h.holonomyPacket
      reducedScalePacket := h.reducedScalePacket
      existsKappa := ?_
      survivalPacket := h.survivalPacket }
  rcases h.existsKappa with ⟨kappa, hDecay, hFine⟩
  exact
    ⟨kappa,
      Delta0MixingScaleData.with_kappa_decay_budget
        h.mixingScaleData hDecay,
      hFine⟩

/--
Separated-kappa theorem: full strongest gap data.
-/
theorem ClayMixingSeparatedKappaAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    ClayMixingKappaExistenceAssumptions.imply_full_gap_data
      (ClayMixingSeparatedKappaAssumptions.to_mixing_kappa_existence_assumptions h)

/--
Separated-kappa theorem: strongest conditional mass-gap summary.
-/
theorem ClayMixingSeparatedKappaAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ClayMixingKappaExistenceAssumptions.imply_mass_gap
      (ClayMixingSeparatedKappaAssumptions.to_mixing_kappa_existence_assumptions h)

/--
Separated-kappa theorem: positive continuum Yang--Mills gap.
-/
theorem ClayMixingSeparatedKappaAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    0 < DeltaYM := by
  exact
    ClayMixingKappaExistenceAssumptions.imply_positive_continuum_gap
      (ClayMixingSeparatedKappaAssumptions.to_mixing_kappa_existence_assumptions h)

end RussoYM

import Mathlib
import RussoYM.FiniteMixingSuppression

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Mixing Red Lemmas

This file decomposes the multiplicative finite mixing-suppression assumption
into named red-lemma interfaces.

The goal is to isolate the remaining analytic mixing obligations:

1. positivity of the mixing/scale parameters,
2. multiplicative scale separation `eps <= rho * ell`,
3. the rho-budget estimate.

Together these imply the existing multiplicative finite mixing-suppression
interface.
-/

/--
Basic positivity assumptions for finite mixing suppression.
-/
structure MixingScalePositivityAssumptions
    (Cmix eps ell : Real) : Prop where
  Cmix_nonneg :
    0 <= Cmix
  eps_nonneg :
    0 <= eps
  ell_positive :
    0 < ell

/--
Multiplicative scale-separation assumption.

This is the physical scale-separation form:

  eps <= rho * ell.
-/
structure MultiplicativeScaleSeparationAssumptions
    (eps ell rho : Real) : Prop where
  scale_separation :
    eps <= rho * ell

/--
Rho-budget assumption for finite mixing suppression.
-/
structure MixingRhoBudgetAssumptions
    (Cmix rho target : Real)
    (kappa : Nat) : Prop where
  rho_budget :
    2 * Cmix * rho^kappa <= target

/--
Decomposed finite mixing red-lemma assumptions.
-/
structure FiniteMixingRedLemmaAssumptions
    (Cmix eps ell rho target : Real)
    (kappa : Nat) : Prop where
  positivity :
    MixingScalePositivityAssumptions Cmix eps ell
  scaleSeparation :
    MultiplicativeScaleSeparationAssumptions eps ell rho
  budget :
    MixingRhoBudgetAssumptions Cmix rho target kappa

/--
The decomposed finite mixing red lemmas imply the packaged multiplicative
scale-separation mixing assumptions.
-/
theorem FiniteMixingRedLemmaAssumptions.imply_multiplicative_scale_assumptions
    {Cmix eps ell rho target : Real}
    {kappa : Nat}
    (h : FiniteMixingRedLemmaAssumptions Cmix eps ell rho target kappa) :
    FiniteMixingMultiplicativeScaleAssumptions
      Cmix eps ell rho target kappa := by
  exact
    { Cmix_nonneg := h.positivity.Cmix_nonneg
      eps_nonneg := h.positivity.eps_nonneg
      ell_positive := h.positivity.ell_positive
      scale_separation := h.scaleSeparation.scale_separation
      rho_budget := h.budget.rho_budget }

/--
The decomposed finite mixing red lemmas imply the finite mixing-smallness
bound.
-/
theorem FiniteMixingRedLemmaAssumptions.imply_mixing_small
    {Cmix eps ell rho target : Real}
    {kappa : Nat}
    (h : FiniteMixingRedLemmaAssumptions Cmix eps ell rho target kappa) :
    2 * Cmix * (eps / ell)^kappa <= target := by
  exact FiniteMixingMultiplicativeScaleAssumptions.imply_mixing_small
    (FiniteMixingRedLemmaAssumptions.imply_multiplicative_scale_assumptions h)

/--
Layer-One-shaped decomposed mixing red-lemma assumptions.
-/
structure LayerOneMixingRedLemmaAssumptions
    (dBlock dUV Cmix eps ell rho : Real)
    (kappa : Nat) : Prop where
  finiteMixing :
    FiniteMixingRedLemmaAssumptions
      Cmix eps ell rho ((1 / 2) * min dBlock dUV) kappa

/--
The decomposed Layer One mixing red lemmas imply the packaged multiplicative
Layer One mixing assumptions.
-/
theorem LayerOneMixingRedLemmaAssumptions.imply_layer_one_multiplicative_scale_assumptions
    {dBlock dUV Cmix eps ell rho : Real}
    {kappa : Nat}
    (h : LayerOneMixingRedLemmaAssumptions
      dBlock dUV Cmix eps ell rho kappa) :
    LayerOneMixingMultiplicativeScaleAssumptions
      dBlock dUV Cmix eps ell rho kappa := by
  exact
    { mixing :=
        FiniteMixingRedLemmaAssumptions.imply_multiplicative_scale_assumptions
          h.finiteMixing }

/--
The decomposed Layer One mixing red lemmas imply the Layer One mixing-smallness
bound.
-/
theorem LayerOneMixingRedLemmaAssumptions.imply_layer_one_mixing_small
    {dBlock dUV Cmix eps ell rho : Real}
    {kappa : Nat}
    (h : LayerOneMixingRedLemmaAssumptions
      dBlock dUV Cmix eps ell rho kappa) :
    2 * Cmix * (eps / ell)^kappa <= (1 / 2) * min dBlock dUV := by
  exact LayerOneMixingMultiplicativeScaleAssumptions.imply_layer_one_mixing_small
    (LayerOneMixingRedLemmaAssumptions.imply_layer_one_multiplicative_scale_assumptions h)

end RussoYM

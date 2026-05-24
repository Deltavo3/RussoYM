import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Finite Mixing Suppression

This file records the finite algebraic core of the multiscale mixing
suppression red lemma.

It proves that if the scale ratio `eps / ell` is bounded by a control ratio
`rho`, then the quasi-local mixing term

  2 * Cmix * (eps / ell)^kappa

is bounded by the easier budget

  2 * Cmix * rho^kappa.

This does not prove the analytic quasi-local expansion. It proves the algebraic
closure once the scale-separation estimate is supplied.
-/

/--
Power monotonicity for nonnegative real numbers.
-/
theorem real_pow_le_of_nonneg_le
    {x rho : Real}
    (hx : 0 <= x)
    (hxrho : x <= rho) :
    forall k : Nat, x^k <= rho^k := by
  intro k
  induction k with
  | zero =>
      simp
  | succ k ih =>
      have hrho_nonneg : 0 <= rho := by
        exact le_trans hx hxrho
      calc
        x^(Nat.succ k) = x^k * x := by
          rw [pow_succ]
        _ <= rho^k * rho := by
          exact mul_le_mul ih hxrho hx (pow_nonneg hrho_nonneg k)
        _ = rho^(Nat.succ k) := by
          rw [pow_succ]

/--
If the ratio term is bounded by `rho`, then the mixing expression is bounded
by the corresponding `rho` budget.
-/
theorem finite_mixing_suppression_of_ratio_bound
    {Cmix eps ell rho target : Real}
    {kappa : Nat}
    (hCmix : 0 <= Cmix)
    (hratio_nonneg : 0 <= eps / ell)
    (hratio_le : eps / ell <= rho)
    (hbudget : 2 * Cmix * rho^kappa <= target) :
    2 * Cmix * (eps / ell)^kappa <= target := by
  have hpow :
      (eps / ell)^kappa <= rho^kappa := by
    exact real_pow_le_of_nonneg_le hratio_nonneg hratio_le kappa
  have hcoef_nonneg : 0 <= 2 * Cmix := by
    exact mul_nonneg (by norm_num) hCmix
  have hmix_le_budget :
      2 * Cmix * (eps / ell)^kappa <= 2 * Cmix * rho^kappa := by
    exact mul_le_mul_of_nonneg_left hpow hcoef_nonneg
  exact le_trans hmix_le_budget hbudget

/--
Scale-separation version using `0 <= eps` and `0 < ell` to prove
`0 <= eps / ell`.
-/
theorem finite_mixing_suppression_of_scale_separation
    {Cmix eps ell rho target : Real}
    {kappa : Nat}
    (hCmix : 0 <= Cmix)
    (heps : 0 <= eps)
    (hell : 0 < ell)
    (hratio_le : eps / ell <= rho)
    (hbudget : 2 * Cmix * rho^kappa <= target) :
    2 * Cmix * (eps / ell)^kappa <= target := by
  have hratio_nonneg : 0 <= eps / ell := by
    exact div_nonneg heps (le_of_lt hell)
  exact finite_mixing_suppression_of_ratio_bound
    hCmix hratio_nonneg hratio_le hbudget

/--
Finite mixing suppression assumptions.

`rho` is a scale-ratio upper bound for `eps / ell`.
`target` is the allowed mixing budget.
-/
structure FiniteMixingSuppressionAssumptions
    (Cmix eps ell rho target : Real)
    (kappa : Nat) : Prop where
  Cmix_nonneg :
    0 <= Cmix
  eps_nonneg :
    0 <= eps
  ell_positive :
    0 < ell
  ratio_bound :
    eps / ell <= rho
  rho_budget :
    2 * Cmix * rho^kappa <= target

/--
Finite mixing suppression endpoint.
-/
theorem FiniteMixingSuppressionAssumptions.imply_mixing_small
    {Cmix eps ell rho target : Real}
    {kappa : Nat}
    (h : FiniteMixingSuppressionAssumptions Cmix eps ell rho target kappa) :
    2 * Cmix * (eps / ell)^kappa <= target := by
  exact finite_mixing_suppression_of_scale_separation
    h.Cmix_nonneg
    h.eps_nonneg
    h.ell_positive
    h.ratio_bound
    h.rho_budget

/--
Layer-One-shaped mixing suppression assumptions.

This specializes the target to

  (1 / 2) * min dBlock dUV,

which is exactly the mixing-smallness hypothesis used by `LayerOneCriterion`.
-/
structure LayerOneMixingSuppressionAssumptions
    (dBlock dUV Cmix eps ell rho : Real)
    (kappa : Nat) : Prop where
  mixing :
    FiniteMixingSuppressionAssumptions
      Cmix eps ell rho ((1 / 2) * min dBlock dUV) kappa

/--
Layer-One-shaped mixing suppression endpoint.
-/
theorem LayerOneMixingSuppressionAssumptions.imply_layer_one_mixing_small
    {dBlock dUV Cmix eps ell rho : Real}
    {kappa : Nat}
    (h : LayerOneMixingSuppressionAssumptions
      dBlock dUV Cmix eps ell rho kappa) :
    2 * Cmix * (eps / ell)^kappa <= (1 / 2) * min dBlock dUV := by
  exact FiniteMixingSuppressionAssumptions.imply_mixing_small h.mixing

end RussoYM

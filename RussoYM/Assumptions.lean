import Mathlib
import RussoYM.FillingBound
import RussoYM.MassGapCriterion

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Assumptions Interface

This file separates proved algebra from unproved analytic assumptions.

It does not prove the hard Yang--Mills analytic lemmas.
Instead, it packages them as structured hypotheses.

The point is to make the Lean project clearly say:

  if the analytic red lemmas are supplied,
  then the already-proved algebraic closure gives the desired gap conclusion.
-/

/-!
## FRT finite-filter assumptions

These are the assumptions needed for the FRT operational finite-filter gap.
-/

structure FRTFiniteFilterAssumptions
    (E Q D K N C epsMin epsMax delta : Real) where
  distance_coercivity : D^2 <= N * Q
  energy_coercivity : K * Q <= E
  K_positive : 0 < K
  N_nonnegative : 0 <= N
  Q_nonnegative : 0 <= Q
  C_positive : 0 < C
  epsMin_positive : 0 < epsMin
  epsMax_positive : 0 < epsMax
  filling_bound : N <= C * (epsMax / epsMin)^2
  finite_info_separation : delta <= D
  delta_positive : 0 < delta

/-
If the FRT finite-filter assumptions hold, then the final FRT operational
gap theorem follows.
-/
theorem FRTFiniteFilterAssumptions.imply_operational_gap
    {E Q D K N C epsMin epsMax delta : Real}
    (h : FRTFiniteFilterAssumptions E Q D K N C epsMin epsMax delta) :
    ((K / C) * (epsMin / epsMax)^2) * delta^2 <= E
      ∧ 0 < ((K / C) * (epsMin / epsMax)^2) * delta^2
      ∧ 0 < E := by
  exact frt_finite_filter_operational_gap
    h.energy_coercivity
    h.distance_coercivity
    h.K_positive
    h.N_nonnegative
    h.Q_nonnegative
    h.C_positive
    h.epsMin_positive
    h.epsMax_positive
    h.filling_bound
    h.finite_info_separation
    h.delta_positive

/-!
## Raw YM analytic assumptions

These package the analytic assumptions for the conditional raw YM route.

They include:

1. controlled RG step recursion,
2. controlled RG remainder,
3. inverse-coupling relation,
4. positivity of couplings,
5. positivity of the square-root threshold,
6. positivity of UV/block constants,
7. small mixing at every step that crosses the threshold.

The algebraic conclusion is supplied by `exists_positive_fine_gap_from_controlled_rg`.
-/

structure RawYMAnalyticAssumptions
    (y R u : Nat -> Real)
    (betaLog theta Ccl r Cloc lambdaPhys cUV ell Clift omega : Real) where
  rg_step :
    forall k, y (Nat.succ k) = y k - betaLog + R k
  rg_remainder :
    forall k, R k <= theta * betaLog
  inverse_relation :
    forall k, y k = 1 / u k
  coupling_positive :
    forall k, 0 < u k
  threshold_positive :
    0 < xstabSqrt Ccl r Cloc lambdaPhys
  theta_lt_one :
    theta < 1
  betaLog_positive :
    0 < betaLog
  Ccl_positive :
    0 < Ccl
  Cloc_positive :
    0 < Cloc
  lambda_positive :
    0 < lambdaPhys
  cUV_positive :
    0 < cUV
  ell_positive :
    0 < ell
  small_mixing :
    forall k,
      xstabSqrt Ccl r Cloc lambdaPhys < u k ->
        Clift * omega <
          min
            (blockGapLower (u k) Ccl r Cloc lambdaPhys)
            (cUV / ell)

/-
If the raw YM analytic assumptions hold, then there exists a positive
fine-lattice gap lower bound at some RG step.
-/
theorem RawYMAnalyticAssumptions.imply_exists_positive_fine_gap
    {y R u : Nat -> Real}
    {betaLog theta Ccl r Cloc lambdaPhys cUV ell Clift omega : Real}
    (h :
      RawYMAnalyticAssumptions
        y R u betaLog theta Ccl r Cloc lambdaPhys cUV ell Clift omega) :
    exists n : Nat,
      0 < fineGapLower (u n) Ccl r Cloc lambdaPhys cUV ell Clift omega := by
  exact exists_positive_fine_gap_from_controlled_rg
    y R u
    h.rg_step
    h.rg_remainder
    h.inverse_relation
    h.coupling_positive
    h.threshold_positive
    h.theta_lt_one
    h.betaLog_positive
    h.Ccl_positive
    h.Cloc_positive
    h.lambda_positive
    h.cUV_positive
    h.ell_positive
    h.small_mixing

/-!
## Summary theorem names

The two main assumption-interface theorems are:

  FRTFiniteFilterAssumptions.imply_operational_gap

and

  RawYMAnalyticAssumptions.imply_exists_positive_fine_gap
-/

end RussoYM

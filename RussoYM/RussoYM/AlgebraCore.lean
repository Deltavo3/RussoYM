import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false

namespace RussoYM

/-!
# Algebra Core

First Lean-checked algebra lemmas for the FRT/YM proof program.
-/

theorem coercivity_implication_mul
    {E Q D K N : Real}
    (hE : K * Q <= E)
    (hD : D^2 <= N * Q)
    (hK : 0 <= K)
    (hN : 0 <= N) :
    K * D^2 <= N * E := by
  have h1 : K * D^2 <= K * (N * Q) := by
    exact mul_le_mul_of_nonneg_left hD hK
  have h2 : K * (N * Q) = N * (K * Q) := by
    ring
  have h3 : N * (K * Q) <= N * E := by
    exact mul_le_mul_of_nonneg_left hE hN
  calc
    K * D^2 <= K * (N * Q) := h1
    _ = N * (K * Q) := h2
    _ <= N * E := h3

/-
Division version of coercivity.

If `D^2 ≤ N * Q`, `K * Q ≤ E`, and `N > 0`,
then `(K / N) * D^2 ≤ E`.
-/
theorem coercivity_implication_div
    {E Q D K N : Real}
    (hE : K * Q <= E)
    (hD : D^2 <= N * Q)
    (hK : 0 <= K)
    (hN : 0 < N) :
    (K / N) * D^2 <= E := by
  have hmul : K * D^2 <= N * E := by
    exact coercivity_implication_mul hE hD hK (le_of_lt hN)
  have hdiv : (K * D^2) / N <= (N * E) / N := by
    exact div_le_div_of_nonneg_right hmul (le_of_lt hN)
  have hleft : (K / N) * D^2 = (K * D^2) / N := by
    ring
  have hright : (N * E) / N = E := by
    field_simp [ne_of_gt hN]
  calc
    (K / N) * D^2 = (K * D^2) / N := hleft
    _ <= (N * E) / N := hdiv
    _ = E := hright

theorem finite_information_gap
    {E D mu delta : Real}
    (hE : mu * D^2 <= E)
    (hD : delta <= D)
    (hmu : 0 <= mu)
    (hdelta : 0 <= delta) :
    mu * delta^2 <= E := by
  have hD_nonneg : 0 <= D := le_trans hdelta hD
  have hsquare : delta^2 <= D^2 := by
    nlinarith [hD, hdelta, hD_nonneg, sq_nonneg (D - delta)]
  have hmul : mu * delta^2 <= mu * D^2 := by
    exact mul_le_mul_of_nonneg_left hsquare hmu
  exact le_trans hmul hE

/-!
## Electric support gap

Abstract Gauss-law version:

If every non-vacuum physical excitation has at least `m_min` active edges,
and each active edge costs at least `lambdaG`, then every non-vacuum excitation
has energy at least `lambdaG * m_min`.
-/

universe u

variable {State : Type u}

theorem electric_support_gap
    (activeCard : State -> Nat)
    (energy : State -> Real)
    (NonVacuum : State -> Prop)
    {m_min : Nat}
    {lambdaG : Real}
    (hlambda : 0 <= lambdaG)
    (hsize : forall s, NonVacuum s -> m_min <= activeCard s)
    (henergy : forall s, NonVacuum s -> lambdaG * (activeCard s : Real) <= energy s) :
    forall s, NonVacuum s -> lambdaG * (m_min : Real) <= energy s := by
  intro s hs
  have hcard_nat : m_min <= activeCard s := hsize s hs
  have hcard_real : (m_min : Real) <= (activeCard s : Real) := by
    exact_mod_cast hcard_nat
  have hmul : lambdaG * (m_min : Real) <= lambdaG * (activeCard s : Real) := by
    exact mul_le_mul_of_nonneg_left hcard_real hlambda
  exact le_trans hmul (henergy s hs)

/-
Strong-coupling condition from the quadratic inequality.

This is the clean algebraic heart of the threshold argument.

If

  C * Cloc + C * r * x < lambda * x^2

and `x > 0`, then

  C * (Cloc / x^2 + r / x) < lambda.
-/
theorem strong_coupling_from_quadratic
    {C r Cloc lambda x : Real}
    (hx : 0 < x)
    (hquad : C * Cloc + C * r * x < lambda * x^2) :
    C * (Cloc / x^2 + r / x) < lambda := by
  have hx_ne : x ≠ 0 := ne_of_gt hx
  have hx2_pos : 0 < x^2 := sq_pos_of_pos hx
  have hx2_ne : x^2 ≠ 0 := ne_of_gt hx2_pos
  have hdiv : (C * Cloc + C * r * x) / x^2 < (lambda * x^2) / x^2 := by
    exact div_lt_div_of_pos_right hquad hx2_pos
  have hleft :
      (C * Cloc + C * r * x) / x^2 =
        C * (Cloc / x^2 + r / x) := by
    field_simp [hx_ne, hx2_ne]
  have hright : (lambda * x^2) / x^2 = lambda := by
    field_simp [hx2_ne]
  rw [hleft] at hdiv
  rw [hright] at hdiv
  exact hdiv

/-
YM-style wrapper for the strong-coupling block stability condition.

Read `g2` as `g_l^2`.

If

  Ccl * Cloc + Ccl * r * g2 < lambdaPhys * g2^2

then

  Ccl * (Cloc / g2^2 + r / g2) < lambdaPhys.

This is the exact algebraic condition used in the block-gap theorem.
-/
theorem block_stability_condition
    {Ccl r Cloc lambdaPhys g2 : Real}
    (hg2 : 0 < g2)
    (hquad : Ccl * Cloc + Ccl * r * g2 < lambdaPhys * g2^2) :
    Ccl * (Cloc / g2^2 + r / g2) < lambdaPhys := by
  exact strong_coupling_from_quadratic hg2 hquad

  /-
If the perturbation strength is strictly smaller than the physical electric gap,
then the block-gap lower bound is strictly positive.

This corresponds to:

  Delta_l >= g2 * (lambdaPhys - Ccl * kappa)

and the bracket is positive if

  Ccl * kappa < lambdaPhys.
-/
theorem block_gap_lower_bound_positive
    {g2 lambdaPhys Ccl kappa : Real}
    (hg2 : 0 < g2)
    (hstab : Ccl * kappa < lambdaPhys) :
    0 < g2 * (lambdaPhys - Ccl * kappa) := by
  have hbracket : 0 < lambdaPhys - Ccl * kappa := by
    exact sub_pos.mpr hstab
  exact mul_pos hg2 hbracket

  /-
Direct version using the YM block variables.

If

  Ccl * (Cloc / g2^2 + r / g2) < lambdaPhys

then

  g2 * (lambdaPhys - Ccl * (Cloc / g2^2 + r / g2)) > 0.
-/
theorem block_gap_positive_from_stability
    {Ccl r Cloc lambdaPhys g2 : Real}
    (hg2 : 0 < g2)
    (hstab : Ccl * (Cloc / g2^2 + r / g2) < lambdaPhys) :
    0 < g2 * (lambdaPhys - Ccl * (Cloc / g2^2 + r / g2)) := by
  exact block_gap_lower_bound_positive hg2 hstab

/-
Combined wrapper:

If the quadratic strong-coupling condition holds,

  Ccl * Cloc + Ccl * r * g2 < lambdaPhys * g2^2,

then the block-gap lower bound is positive:

  g2 * (lambdaPhys - Ccl * (Cloc / g2^2 + r / g2)) > 0.
-/
theorem block_gap_positive_from_quadratic
    {Ccl r Cloc lambdaPhys g2 : Real}
    (hg2 : 0 < g2)
    (hquad : Ccl * Cloc + Ccl * r * g2 < lambdaPhys * g2^2) :
    0 < g2 * (lambdaPhys - Ccl * (Cloc / g2^2 + r / g2)) := by
  have hstab : Ccl * (Cloc / g2^2 + r / g2) < lambdaPhys := by
    exact block_stability_condition hg2 hquad
  exact block_gap_positive_from_stability hg2 hstab

/-
FRT finite-information gap from coercivity.

If

  D^2 <= N * Q,
  K * Q <= E,
  delta <= D,

then

  (K / N) * delta^2 <= E.

This is the abstract Lean version of:

  E >= (K/N) D_epsilon^2
  and D_epsilon >= delta_info
  implies E >= (K/N) delta_info^2.
-/
theorem frt_gap_from_coercivity
    {E Q D K N delta : Real}
    (hE : K * Q <= E)
    (hD : D^2 <= N * Q)
    (hK : 0 <= K)
    (hN : 0 < N)
    (hdelta : delta <= D)
    (hdelta_nonneg : 0 <= delta) :
    (K / N) * delta^2 <= E := by
  have hcoercive : (K / N) * D^2 <= E := by
    exact coercivity_implication_div hE hD hK hN
  have hKdiv_nonneg : 0 <= K / N := by
    exact div_nonneg hK (le_of_lt hN)
  exact finite_information_gap hcoercive hdelta hKdiv_nonneg hdelta_nonneg

end RussoYM

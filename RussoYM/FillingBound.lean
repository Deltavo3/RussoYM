import Mathlib
import RussoYM.AlgebraCore

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Filling Bound

This file formalizes the denominator-free version of the finite-filter
constant assembly.

Instead of immediately proving

  E >= (K / B) * delta^2,

we first prove the equivalent safe form

  K * delta^2 <= B * E,

where `B` is the filling bound for `N`.

This avoids harder division algebra for now.
-/

/-
Finite-filter gap assembly, denominator-free.

Assumptions:

  D^2 <= N * Q
  K * Q <= E
  N <= B
  delta <= D

with nonnegativity assumptions.

Conclusion:

  K * delta^2 <= B * E.
-/
theorem finite_filter_gap_mul
    {E Q D K N B delta : Real}
    (hE : K * Q <= E)
    (hD : D^2 <= N * Q)
    (hK : 0 <= K)
    (hN : 0 <= N)
    (hB : N <= B)
    (hQ : 0 <= Q)
    (hdelta : delta <= D)
    (hdelta_nonneg : 0 <= delta) :
    K * delta^2 <= B * E := by
  have hKD2_NE : K * D^2 <= N * E := by
    exact coercivity_implication_mul hE hD hK hN

  have hD_nonneg : 0 <= D := by
    exact le_trans hdelta_nonneg hdelta

  have hdelta_square : delta^2 <= D^2 := by
    nlinarith [hdelta, hdelta_nonneg, hD_nonneg, sq_nonneg (D - delta)]

  have hKdelta_KD : K * delta^2 <= K * D^2 := by
    exact mul_le_mul_of_nonneg_left hdelta_square hK

  have hE_nonneg : 0 <= E := by
    have hKQ_nonneg : 0 <= K * Q := by
      exact mul_nonneg hK hQ
    exact le_trans hKQ_nonneg hE

  have hNE_BE : N * E <= B * E := by
    exact mul_le_mul_of_nonneg_right hB hE_nonneg

  exact le_trans (le_trans hKdelta_KD hKD2_NE) hNE_BE

/-
Geometry filling-bound specialization.

If

  N <= C * (epsMax / epsMin)^2,

then the denominator-free FRT gap bound becomes

  K * delta^2 <= C * (epsMax / epsMin)^2 * E.
-/
theorem finite_filter_gap_with_geometry_mul
    {E Q D K N C epsMin epsMax delta : Real}
    (hE : K * Q <= E)
    (hD : D^2 <= N * Q)
    (hK : 0 <= K)
    (hN : 0 <= N)
    (hQ : 0 <= Q)
    (hNbound : N <= C * (epsMax / epsMin)^2)
    (hdelta : delta <= D)
    (hdelta_nonneg : 0 <= delta) :
    K * delta^2 <= (C * (epsMax / epsMin)^2) * E := by
  exact finite_filter_gap_mul
    hE hD hK hN hNbound hQ hdelta hdelta_nonneg

/-
The geometric filling constant is positive if `C`, `epsMin`, and `epsMax`
are positive.
-/
theorem filling_geometry_constant_positive
    {C epsMin epsMax : Real}
    (hC : 0 < C)
    (hmin : 0 < epsMin)
    (hmax : 0 < epsMax) :
    0 < C * (epsMax / epsMin)^2 := by
  have hratio : 0 < epsMax / epsMin := by
    exact div_pos hmax hmin
  have hratio2 : 0 < (epsMax / epsMin)^2 := by
    exact sq_pos_of_pos hratio
  exact mul_pos hC hratio2

/-
Finite-filter gap assembly with division.

From the denominator-free bound

  K * delta^2 <= B * E

and `B > 0`, derive

  (K / B) * delta^2 <= E.
-/
theorem finite_filter_gap_div
    {E Q D K N B delta : Real}
    (hE : K * Q <= E)
    (hD : D^2 <= N * Q)
    (hK : 0 <= K)
    (hN : 0 <= N)
    (hBpos : 0 < B)
    (hNbound : N <= B)
    (hQ : 0 <= Q)
    (hdelta : delta <= D)
    (hdelta_nonneg : 0 <= delta) :
    (K / B) * delta^2 <= E := by
  have hmul : K * delta^2 <= B * E := by
    exact finite_filter_gap_mul
      hE hD hK hN hNbound hQ hdelta hdelta_nonneg
  have hdiv : (K * delta^2) / B <= (B * E) / B := by
    exact div_le_div_of_nonneg_right hmul (le_of_lt hBpos)
  have hleft : (K / B) * delta^2 = (K * delta^2) / B := by
    ring
  have hright : (B * E) / B = E := by
    field_simp [ne_of_gt hBpos]
  calc
    (K / B) * delta^2 = (K * delta^2) / B := hleft
    _ <= (B * E) / B := hdiv
    _ = E := hright

/-
Geometry filling-bound specialization with division.

If

  N <= C * (epsMax / epsMin)^2,

then

  (K / (C * (epsMax / epsMin)^2)) * delta^2 <= E.
-/
theorem finite_filter_gap_with_geometry_div
    {E Q D K N C epsMin epsMax delta : Real}
    (hE : K * Q <= E)
    (hD : D^2 <= N * Q)
    (hK : 0 <= K)
    (hN : 0 <= N)
    (hQ : 0 <= Q)
    (hC : 0 < C)
    (hmin : 0 < epsMin)
    (hmax : 0 < epsMax)
    (hNbound : N <= C * (epsMax / epsMin)^2)
    (hdelta : delta <= D)
    (hdelta_nonneg : 0 <= delta) :
    (K / (C * (epsMax / epsMin)^2)) * delta^2 <= E := by
  have hBpos : 0 < C * (epsMax / epsMin)^2 := by
    exact filling_geometry_constant_positive hC hmin hmax
  exact finite_filter_gap_div
    hE hD hK hN hBpos hNbound hQ hdelta hdelta_nonneg

/-
Positive energy from the geometric finite-filter bound.

If the constants `K`, `C`, `epsMin`, `epsMax`, and `delta` are positive,
then the finite-filter lower bound forces `E > 0`.
-/
theorem finite_filter_energy_positive_with_geometry
    {E Q D K N C epsMin epsMax delta : Real}
    (hE : K * Q <= E)
    (hD : D^2 <= N * Q)
    (hK : 0 < K)
    (hN : 0 <= N)
    (hQ : 0 <= Q)
    (hC : 0 < C)
    (hmin : 0 < epsMin)
    (hmax : 0 < epsMax)
    (hNbound : N <= C * (epsMax / epsMin)^2)
    (hdelta : delta <= D)
    (hdelta_pos : 0 < delta) :
    0 < E := by
  have hbound :
      (K / (C * (epsMax / epsMin)^2)) * delta^2 <= E := by
    exact finite_filter_gap_with_geometry_div
      hE hD (le_of_lt hK) hN hQ hC hmin hmax hNbound hdelta
      (le_of_lt hdelta_pos)
  have hBpos : 0 < C * (epsMax / epsMin)^2 := by
    exact filling_geometry_constant_positive hC hmin hmax
  have hcoeff_pos : 0 < K / (C * (epsMax / epsMin)^2) := by
    exact div_pos hK hBpos
  have hdelta2_pos : 0 < delta^2 := by
    exact sq_pos_of_pos hdelta_pos
  have hlower_pos :
      0 < (K / (C * (epsMax / epsMin)^2)) * delta^2 := by
    exact mul_pos hcoeff_pos hdelta2_pos
  exact lt_of_lt_of_le hlower_pos hbound

/-
Rewrite the geometric filling coefficient.

This proves the algebraic identity

  K / (C * (epsMax / epsMin)^2)
    =
  (K / C) * (epsMin / epsMax)^2.

This is the form used in the FRT finite-filter gap estimate.
-/
theorem geometry_coefficient_rewrite
    {K C epsMin epsMax : Real}
    (hC : C ≠ 0)
    (hmin : epsMin ≠ 0)
    (hmax : epsMax ≠ 0) :
    K / (C * (epsMax / epsMin)^2)
      =
    (K / C) * (epsMin / epsMax)^2 := by
  field_simp [hC, hmin, hmax]

/-
Finite-filter gap with the coefficient rewritten in the usual FRT form.

Instead of

  (K / (C * (epsMax / epsMin)^2)) * delta^2 <= E,

this proves

  ((K / C) * (epsMin / epsMax)^2) * delta^2 <= E.
-/
theorem finite_filter_gap_with_geometry_rewritten
    {E Q D K N C epsMin epsMax delta : Real}
    (hE : K * Q <= E)
    (hD : D^2 <= N * Q)
    (hK : 0 <= K)
    (hN : 0 <= N)
    (hQ : 0 <= Q)
    (hC : 0 < C)
    (hmin : 0 < epsMin)
    (hmax : 0 < epsMax)
    (hNbound : N <= C * (epsMax / epsMin)^2)
    (hdelta : delta <= D)
    (hdelta_nonneg : 0 <= delta) :
    ((K / C) * (epsMin / epsMax)^2) * delta^2 <= E := by
  have hmain :
      (K / (C * (epsMax / epsMin)^2)) * delta^2 <= E := by
    exact finite_filter_gap_with_geometry_div
      hE hD hK hN hQ hC hmin hmax hNbound hdelta hdelta_nonneg
  have hrewrite :
      K / (C * (epsMax / epsMin)^2)
        =
      (K / C) * (epsMin / epsMax)^2 := by
    exact geometry_coefficient_rewrite
      (K := K)
      (C := C)
      (epsMin := epsMin)
      (epsMax := epsMax)
      (ne_of_gt hC)
      (ne_of_gt hmin)
      (ne_of_gt hmax)
  rw [hrewrite] at hmain
  exact hmain

/-
Positive energy in the rewritten FRT coefficient form.
-/
theorem finite_filter_energy_positive_with_geometry_rewritten
    {E Q D K N C epsMin epsMax delta : Real}
    (hE : K * Q <= E)
    (hD : D^2 <= N * Q)
    (hK : 0 < K)
    (hN : 0 <= N)
    (hQ : 0 <= Q)
    (hC : 0 < C)
    (hmin : 0 < epsMin)
    (hmax : 0 < epsMax)
    (hNbound : N <= C * (epsMax / epsMin)^2)
    (hdelta : delta <= D)
    (hdelta_pos : 0 < delta) :
    0 < E := by
  have hbound :
      ((K / C) * (epsMin / epsMax)^2) * delta^2 <= E := by
    exact finite_filter_gap_with_geometry_rewritten
      hE hD (le_of_lt hK) hN hQ hC hmin hmax hNbound hdelta
      (le_of_lt hdelta_pos)
  have hKdiv_pos : 0 < K / C := by
    exact div_pos hK hC
  have hratio_pos : 0 < epsMin / epsMax := by
    exact div_pos hmin hmax
  have hcoeff_pos : 0 < (K / C) * (epsMin / epsMax)^2 := by
    exact mul_pos hKdiv_pos (sq_pos_of_pos hratio_pos)
  have hdelta2_pos : 0 < delta^2 := by
    exact sq_pos_of_pos hdelta_pos
  have hlower_pos :
      0 < ((K / C) * (epsMin / epsMax)^2) * delta^2 := by
    exact mul_pos hcoeff_pos hdelta2_pos
  exact lt_of_lt_of_le hlower_pos hbound

/-
The exact rewritten FRT gap constant is positive.

If

  K > 0,
  C > 0,
  epsMin > 0,
  epsMax > 0,
  delta > 0,

then

  ((K / C) * (epsMin / epsMax)^2) * delta^2 > 0.
-/
theorem rewritten_frt_gap_constant_positive
    {K C epsMin epsMax delta : Real}
    (hK : 0 < K)
    (hC : 0 < C)
    (hmin : 0 < epsMin)
    (hmax : 0 < epsMax)
    (hdelta : 0 < delta) :
    0 < ((K / C) * (epsMin / epsMax)^2) * delta^2 := by
  have hKdiv_pos : 0 < K / C := by
    exact div_pos hK hC
  have hratio_pos : 0 < epsMin / epsMax := by
    exact div_pos hmin hmax
  have hratio_sq_pos : 0 < (epsMin / epsMax)^2 := by
    exact sq_pos_of_pos hratio_pos
  have hcoeff_pos : 0 < (K / C) * (epsMin / epsMax)^2 := by
    exact mul_pos hKdiv_pos hratio_sq_pos
  have hdelta_sq_pos : 0 < delta^2 := by
    exact sq_pos_of_pos hdelta
  exact mul_pos hcoeff_pos hdelta_sq_pos

/-
Final named FRT finite-filter operational gap theorem.

This is the paper-style statement:

If

  D^2 <= N * Q,
  K * Q <= E,
  N <= C * (epsMax / epsMin)^2,
  delta <= D,

then

  ((K / C) * (epsMin / epsMax)^2) * delta^2 <= E.

Under strict positivity of the constants, the lower-bound constant is positive,
so `E > 0`.
-/
theorem frt_finite_filter_operational_gap
    {E Q D K N C epsMin epsMax delta : Real}
    (hE : K * Q <= E)
    (hD : D^2 <= N * Q)
    (hK : 0 < K)
    (hN : 0 <= N)
    (hQ : 0 <= Q)
    (hC : 0 < C)
    (hmin : 0 < epsMin)
    (hmax : 0 < epsMax)
    (hNbound : N <= C * (epsMax / epsMin)^2)
    (hdelta : delta <= D)
    (hdelta_pos : 0 < delta) :
    ((K / C) * (epsMin / epsMax)^2) * delta^2 <= E
      ∧ 0 < ((K / C) * (epsMin / epsMax)^2) * delta^2
      ∧ 0 < E := by
  have hbound :
      ((K / C) * (epsMin / epsMax)^2) * delta^2 <= E := by
    exact finite_filter_gap_with_geometry_rewritten
      hE hD (le_of_lt hK) hN hQ hC hmin hmax hNbound hdelta
      (le_of_lt hdelta_pos)
  have hgap_pos :
      0 < ((K / C) * (epsMin / epsMax)^2) * delta^2 := by
    exact rewritten_frt_gap_constant_positive hK hC hmin hmax hdelta_pos
  have hE_pos : 0 < E := by
    exact lt_of_lt_of_le hgap_pos hbound
  exact ⟨hbound, hgap_pos, hE_pos⟩

end RussoYM

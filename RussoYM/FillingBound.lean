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

end RussoYM

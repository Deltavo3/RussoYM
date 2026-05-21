import Mathlib
import RussoYM.AlgebraCore
import RussoYM.OperationalGap

set_option linter.style.whitespace false
set_option linter.style.longLine false

namespace RussoYM

/-!
# FRT Constants

This file formalizes simple constant-comparison lemmas for the
finite-resolution / finite-filter gap estimates.
-/

/-
If an energy lower bound holds with coefficient `mu`, and `mu0 <= mu`,
then the weaker lower bound with coefficient `mu0` also holds.
-/
theorem weaken_quadratic_coefficient
    {E D mu mu0 : Real}
    (hE : mu * D^2 <= E)
    (hmu : mu0 <= mu)
    (hD2 : 0 <= D^2) :
    mu0 * D^2 <= E := by
  have hcoeff : mu0 * D^2 <= mu * D^2 := by
    exact mul_le_mul_of_nonneg_right hmu hD2
  exact le_trans hcoeff hE

/-
Same theorem, but with `D^2` nonnegativity filled automatically.
-/
theorem weaken_quadratic_coefficient_auto
    {E D mu mu0 : Real}
    (hE : mu * D^2 <= E)
    (hmu : mu0 <= mu) :
    mu0 * D^2 <= E := by
  exact weaken_quadratic_coefficient hE hmu (sq_nonneg D)

/-
If `E >= mu * D^2`, `mu >= mu0`, and non-vacuum sectors have `D >= delta`,
then `E >= mu0 * delta^2`.
-/
theorem finite_information_gap_with_weaker_constant
    {E D mu mu0 delta : Real}
    (hE : mu * D^2 <= E)
    (hmu : mu0 <= mu)
    (hdelta : delta <= D)
    (hmu0_nonneg : 0 <= mu0)
    (hdelta_nonneg : 0 <= delta) :
    mu0 * delta^2 <= E := by
  have hE0 : mu0 * D^2 <= E := by
    exact weaken_quadratic_coefficient_auto hE hmu
  exact finite_information_gap hE0 hdelta hmu0_nonneg hdelta_nonneg

/-
Positive weaker gap constant.

If `mu0 > 0` and `delta > 0`, then `mu0 * delta^2 > 0`.
-/
theorem weaker_gap_constant_positive
    {mu0 delta : Real}
    (hmu0 : 0 < mu0)
    (hdelta : 0 < delta) :
    0 < mu0 * delta^2 := by
  have hdelta2 : 0 < delta^2 := by
    exact sq_pos_of_pos hdelta
  exact mul_pos hmu0 hdelta2

/-
If the finite-information lower bound uses a positive weaker coefficient,
then the energy is strictly positive.
-/
theorem energy_positive_from_weaker_constant
    {E D mu mu0 delta : Real}
    (hE : mu * D^2 <= E)
    (hmu : mu0 <= mu)
    (hmu0_pos : 0 < mu0)
    (hdelta : delta <= D)
    (hdelta_pos : 0 < delta) :
    0 < E := by
  have hbound : mu0 * delta^2 <= E := by
    exact finite_information_gap_with_weaker_constant
      hE hmu hdelta (le_of_lt hmu0_pos) (le_of_lt hdelta_pos)
  have hpos : 0 < mu0 * delta^2 := by
    exact weaker_gap_constant_positive hmu0_pos hdelta_pos
  exact lt_of_lt_of_le hpos hbound

end RussoYM

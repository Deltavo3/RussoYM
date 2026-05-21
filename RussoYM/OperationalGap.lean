import Mathlib
import RussoYM.AlgebraCore

set_option linter.style.whitespace false
set_option linter.style.longLine false

namespace RussoYM

/-!
# Operational Gap

This file formalizes the positivity of the FRT finite-information gap constant.

It proves that if

  K > 0,
  N > 0,
  delta > 0,

then

  (K / N) * delta^2 > 0.

Then it combines this with the already-proved coercivity theorem.
-/

/-
The FRT gap constant is positive if `K`, `N`, and `delta` are positive.
-/
theorem frt_gap_constant_positive
    {K N delta : Real}
    (hK : 0 < K)
    (hN : 0 < N)
    (hdelta : 0 < delta) :
    0 < (K / N) * delta^2 := by
  have hKdiv : 0 < K / N := by
    exact div_pos hK hN
  have hdelta2 : 0 < delta^2 := by
    exact sq_pos_of_pos hdelta
  exact mul_pos hKdiv hdelta2

/-
If the FRT coercivity hypotheses hold and the finite-information separation
constant is positive, then every non-vacuum energy lower bound is positive.
-/
theorem frt_energy_positive_from_coercivity
    {E Q D K N delta : Real}
    (hE : K * Q <= E)
    (hD : D^2 <= N * Q)
    (hK : 0 < K)
    (hN : 0 < N)
    (hdelta : delta <= D)
    (hdelta_pos : 0 < delta) :
    0 < E := by
  have hgap_bound : (K / N) * delta^2 <= E := by
    exact frt_gap_from_coercivity hE hD (le_of_lt hK) hN hdelta (le_of_lt hdelta_pos)
  have hgap_pos : 0 < (K / N) * delta^2 := by
    exact frt_gap_constant_positive hK hN hdelta_pos
  exact lt_of_lt_of_le hgap_pos hgap_bound

end RussoYM

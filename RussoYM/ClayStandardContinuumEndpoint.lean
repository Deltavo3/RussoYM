import Mathlib.Data.Real.Basic

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Standard Continuum Endpoint

This file packages the final standard-continuum endpoint.

It does not prove FRT-modified Yang--Mills.
It does not keep a permanent finite-resolution cutoff.
It states the abstract continuum endpoint:

  if a positive finite-regulator lower bound survives the continuum limit,
  then the continuum Yang--Mills mass gap is positive.

The hard analytic burden is hidden only in the explicit assumption
`ContinuumSurvival`.
-/

/--
A minimal abstract structure for the standard continuum endpoint.

`DeltaYM` is the continuum Yang--Mills mass gap.

`Delta0` is the regulator-independent positive lower bound produced by the
finite-regulator holonomy/sector argument.

`ContinuumSurvival` states that this lower bound survives the regulator limit
into the continuum Yang--Mills Hamiltonian/spectrum.
-/
structure ClayStandardContinuumEndpointAssumptions where
  DeltaYM : Real
  Delta0 : Real
  Delta0_pos : 0 < Delta0
  ContinuumSurvival : Delta0 <= DeltaYM

/--
The standard continuum Clay endpoint:

if a regulator-independent positive lower bound survives the continuum limit,
then the continuum Yang--Mills mass gap is positive.
-/
theorem clay_standard_continuum_gap
    (h : ClayStandardContinuumEndpointAssumptions) :
    0 < h.DeltaYM := by
  exact lt_of_lt_of_le h.Delta0_pos h.ContinuumSurvival

/--
Scale-matched version.

If the finite-regulator mechanism produces

  Delta0 = (eta / C)^2 * LambdaYM

with eta > 0, C > 0, LambdaYM > 0, and this lower bound survives the continuum
limit, then the continuum Yang--Mills gap is positive.
-/
theorem clay_standard_continuum_gap_from_scale_matched_bound
    {DeltaYM eta C LambdaYM : Real}
    (heta : 0 < eta)
    (hC : 0 < C)
    (hLambda : 0 < LambdaYM)
    (hSurvive : (eta / C)^2 * LambdaYM <= DeltaYM) :
    0 < DeltaYM := by
  have hdiv_pos : 0 < eta / C := by
    exact div_pos heta hC
  have hsquare_pos : 0 < (eta / C)^2 := by
    exact sq_pos_of_pos hdiv_pos
  have hDelta0_pos : 0 < (eta / C)^2 * LambdaYM := by
    exact mul_pos hsquare_pos hLambda
  exact lt_of_lt_of_le hDelta0_pos hSurvive

/--
A version using an abstract finite-regulator lower-bound constant.

This is the theorem that should be cited after proving:

  H_n >= Delta0 (I - P_n)

and proving continuum survival:

  H_YM >= Delta0 (I - P).
-/
theorem clay_standard_continuum_gap_from_uniform_bound
    {DeltaYM Delta0 : Real}
    (hDelta0_pos : 0 < Delta0)
    (hSurvive : Delta0 <= DeltaYM) :
    0 < DeltaYM := by
  exact lt_of_lt_of_le hDelta0_pos hSurvive

end RussoYM

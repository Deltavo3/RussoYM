import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Margin Threshold Algebra

This file records the small algebraic facts behind margin crossing.

The key idea is:

  sigma > 0
  x > 0

implies

  x < (1 + sigma) * x.

So crossing the margin target `(1 + sigma) * x` automatically implies
crossing the base threshold `x`.
-/

/--
A positive margin target lies strictly above the base positive threshold.
-/
theorem margin_target_above_threshold
    {sigma x : Real}
    (hsigma : 0 < sigma)
    (hx : 0 < x) :
    x < (1 + sigma) * x := by
  nlinarith [hsigma, hx]

/--
If a quantity crosses the margin target, then it also crosses the base
threshold.
-/
theorem threshold_lt_of_margin_lt
    {sigma x u : Real}
    (hsigma : 0 < sigma)
    (hx : 0 < x)
    (hmargin : (1 + sigma) * x < u) :
    x < u := by
  exact lt_trans (margin_target_above_threshold hsigma hx) hmargin

end RussoYM

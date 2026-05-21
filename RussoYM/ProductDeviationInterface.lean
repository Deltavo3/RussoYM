import Mathlib
import RussoYM.ProductDeviation

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Product Deviation Interface

This file packages the general product-deviation theorem as an interface.

We have already proved the two-, three-, and four-factor normed versions in
`ProductDeviation.lean`.

The fully general finite-product theorem still needs a separate finite-product
formalization. This file isolates the remaining ingredients:

1. a triangle/telescoping estimate,
2. a finite Cauchy estimate.

Once those are supplied, the product-deviation conclusion follows immediately.
-/

/-
Abstract assumptions for a general product-deviation estimate.

Think of:

  dProd = ||1 - product A_i||
  sumDev = sum_i ||1 - A_i||
  sumSq = sum_i ||1 - A_i||^2
  m = number of factors
-/
structure ProductDeviationAssumptions
    (dProd sumDev sumSq m : Real) where
  dProd_nonnegative : 0 <= dProd
  sumDev_nonnegative : 0 <= sumDev
  triangle_bound : dProd <= sumDev
  cauchy_bound : sumDev^2 <= m * sumSq

/-
The abstract product-deviation conclusion.

From the product-deviation assumptions, conclude:

  dProd^2 <= m * sumSq.
-/
theorem ProductDeviationAssumptions.imply_product_deviation
    {dProd sumDev sumSq m : Real}
    (h : ProductDeviationAssumptions dProd sumDev sumSq m) :
    dProd^2 <= m * sumSq := by
  exact product_deviation_from_triangle_and_cauchy
    h.dProd_nonnegative
    h.sumDev_nonnegative
    h.triangle_bound
    h.cauchy_bound

/-
Normed version of the product-deviation interface.

Think of:

  z = 1 - product A_i

and `sumDev`, `sumSq`, `m` as above.
-/
structure NormProductDeviationAssumptions
    {V : Type*}
    [SeminormedAddCommGroup V]
    (z : V)
    (sumDev sumSq m : Real) where
  sumDev_nonnegative : 0 <= sumDev
  triangle_bound : ‖z‖ <= sumDev
  cauchy_bound : sumDev^2 <= m * sumSq

/-
The normed abstract product-deviation conclusion.

From the normed assumptions, conclude:

  ||z||^2 <= m * sumSq.
-/
theorem NormProductDeviationAssumptions.imply_norm_product_deviation
    {V : Type*}
    [SeminormedAddCommGroup V]
    {z : V}
    {sumDev sumSq m : Real}
    (h : NormProductDeviationAssumptions z sumDev sumSq m) :
    ‖z‖^2 <= m * sumSq := by
  exact norm_product_deviation_from_triangle_and_cauchy
    h.sumDev_nonnegative
    h.triangle_bound
    h.cauchy_bound

/-!
## Current status

The remaining task for the full product-deviation theorem is to prove,
for a finite product of norm-nonincreasing factors:

  ||1 - product A_i|| <= sum_i ||1 - A_i||

and

  (sum_i ||1 - A_i||)^2 <= m * sum_i ||1 - A_i||^2.

Once those are formalized, this interface immediately gives:

  ||1 - product A_i||^2 <= m * sum_i ||1 - A_i||^2.
-/

end RussoYM

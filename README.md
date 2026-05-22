# RussoYM Lean Formalization

This project formalizes the algebraic skeleton of the FRT/YM proof program in Lean 4.

It does **not** yet prove the full Yang--Mills mass gap. The analytic and nonperturbative assumptions, such as RG control, quasi-local block diagonalization, UV Poincare estimates, and continuum convergence, remain external theorem assumptions.

The goal of this Lean project is to verify the algebraic closure steps that connect those assumptions.

---

## Current headline theorems

### `RussoYM/Assumptions.lean`

This file separates proved algebra from unproved analytic assumptions.

Important structures:

```lean
FRTFiniteFilterAssumptions
RawYMAnalyticAssumptions
```

### FRT finite-filter operational gap

It proves the paper-style finite-filter bound:

```text
D^2 <= N * Q
K * Q <= E
N <= C * (epsMax / epsMin)^2
delta <= D
```

implies:

```text
((K / C) * (epsMin / epsMax)^2) * delta^2 <= E
```

and, under strict positivity of the constants, also proves:

```text
0 < ((K / C) * (epsMin / epsMax)^2) * delta^2
0 < E
```

This is the formalized FRT operational finite-information gap result.

---

### Conditional raw YM mass-gap criterion

The main raw-YM-side wrapper theorem is:

```lean
exists_positive_fine_gap_from_controlled_rg
```

It packages the conditional route:

```text
controlled RG crossing
+ square-root strong-coupling threshold
+ positive UV gap
+ small mixing
=> exists a positive fine-lattice gap lower bound
```

This does not prove the analytic RG or continuum pieces. It proves the algebraic closure once those assumptions are supplied.

---

## File map

## Layer 1 Clay-Compatible Gap Criterion

The current formalization now includes a Layer 1 endpoint for the Clay-compatible
Yang--Mills gap program.

The Layer 1 architecture separates the proof into:

1. finite-regulator/fine-gap algebra,
2. an interface packaging the Layer 1 assumptions,
3. a continuum gap-preservation interface,
4. a final Clay YM gap criterion.

- `RussoYM/LayerOneRedLemmas.lean`
  - records the remaining analytic red lemmas as named formal assumptions:
    uniform curvature form/coercivity, uniform RG remainder estimates,
    uniform multiscale mixing suppression, and gap-preserving continuum
    construction.

Relevant Lean files:

- `RussoYM/LayerOneCriterion.lean`
  - proves the algebraic fine-gap lifting endpoint:
    block gap + UV gap + small mixing implies a positive fine gap.

- `RussoYM/LayerOneInterface.lean`
  - wraps the Layer 1 fine-gap assumptions into a named interface.

- `RussoYM/ContinuumGap.lean`
  - packages the continuum gap-preservation assumption:
    a positive uniform finite-regulator gap survives the continuum limit.

- `RussoYM/ClayCriterion.lean`
  - combines the Layer 1 endpoint with continuum gap preservation to conclude
    a positive continuum Yang--Mills gap.

- `RussoYM/TheoremIndex.lean`
  - exposes the public endpoint:
    `theorem_index_clay_ym_gap`.

The final endpoint is conditional. It does not claim to prove the analytic red
lemmas. It records the algebraic implication:

```text
LayerOneAssumptions
+ ContinuumGapAssumptions
=> DeltaYM > 0
```

### `RussoYM/AlgebraCore.lean`

Core algebraic lemmas.

Important results:

```lean
coercivity_implication_mul
coercivity_implication_div
finite_information_gap
electric_support_gap
strong_coupling_from_quadratic
block_stability_condition
block_gap_positive_from_quadratic
frt_gap_from_coercivity
```

This file proves the basic implications:

```text
D^2 <= N * Q
K * Q <= E
```

gives:

```text
(K / N) * D^2 <= E
```

and with finite-information separation:

```text
D >= delta
```

gives a positive non-vacuum lower bound.

---

### `RussoYM/FillingBound.lean`

Finite-filter filling-bound algebra.

Important results:

```lean
finite_filter_gap_mul
finite_filter_gap_div
finite_filter_gap_with_geometry_div
geometry_coefficient_rewrite
finite_filter_gap_with_geometry_rewritten
rewritten_frt_gap_constant_positive
frt_finite_filter_operational_gap
```

This file proves the finite-filter coefficient:

```text
K / (C * (epsMax / epsMin)^2)
=
(K / C) * (epsMin / epsMax)^2
```

and packages the final FRT operational gap theorem.

---

### `RussoYM/Threshold.lean`

Square-root strong-coupling threshold algebra.

Important results:

```lean
quadratic_positive_from_sqrt_threshold
strong_coupling_from_sqrt_threshold
block_gap_positive_from_sqrt_threshold
```

This file proves that the threshold condition:

```text
x > (C*r + sqrt((C*r)^2 + 4*lambda*C*Cloc)) / (2*lambda)
```

implies:

```text
C * (Cloc / x^2 + r / x) < lambda
```

and therefore:

```text
0 < x * (lambda - C * (Cloc / x^2 + r / x))
```

This is the algebraic strong-coupling block-gap threshold.

---

### `RussoYM/RGCrossing.lean`

Controlled RG crossing algebra.

Important results:

```lean
controlled_rg_step_bound
controlled_rg_inverse_decreases
controlled_rg_linear_bound
controlled_rg_crosses_below
coupling_crosses_from_inverse
controlled_rg_coupling_crosses
controlled_rg_eventually_below
controlled_rg_eventually_coupling_crosses
```

This file proves that if inverse coupling obeys:

```text
y_{n+1} = y_n - betaLog + R_n
R_n <= theta * betaLog
theta < 1
betaLog > 0
```

then inverse coupling eventually drops below any threshold, and therefore the physical coupling eventually crosses the corresponding threshold.

---

### `RussoYM/ProofSkeleton.lean`

Gap-lifting algebra.

Important results:

```lean
decoupled_gap_positive
gap_lifting_lower_bound_positive
gap_lifting_with_uv_scale
raw_gap_algebraic_closure
```

This file proves:

```text
positive block gap
+ positive UV gap
+ small mixing
=> positive fine-lattice gap lower bound
```

---

### `RussoYM/RawClosure.lean`

Raw YM closure skeleton.

Important results:

```lean
raw_gap_from_controlled_rg_and_stability
exists_raw_gap_from_eventual_rg
raw_gap_from_controlled_rg_and_sqrt_threshold
exists_raw_gap_from_eventual_rg_and_sqrt_threshold
```

This file connects controlled RG crossing to the strong-coupling block gap and then to the fine-lattice gap.

The strongest current theorem here uses the actual square-root threshold formula.

---

### `RussoYM/MassGapCriterion.lean`

Named criterion wrapper.

Important definitions:

```lean
xstabSqrt
blockGapLower
fineGapLower
```

Important theorem:

```lean
exists_positive_fine_gap_from_controlled_rg
```

This is the clean named wrapper for the conditional raw YM algebraic route.

---

### `RussoYM/OperationalGap.lean`

Positivity of the FRT operational gap constant.

Important results:

```lean
frt_gap_constant_positive
frt_energy_positive_from_coercivity
```

This proves that if:

```text
K > 0
N > 0
delta > 0
```

then:

```text
(K / N) * delta^2 > 0
```

and hence the finite-information energy lower bound is strictly positive.

---

### `RussoYM/FRTConstants.lean`

Constant-comparison lemmas.

Important results:

```lean
weaken_quadratic_coefficient
weaken_quadratic_coefficient_auto
finite_information_gap_with_weaker_constant
weaker_gap_constant_positive
energy_positive_from_weaker_constant
```

This file handles weakening a coefficient:

```text
mu0 <= mu
E >= mu * D^2
```

implies:

```text
E >= mu0 * D^2
```

---

### `RussoYM/ProductDeviation.lean`

Product-deviation estimates.

Important results:

```lean
square_sum_two_le
two_factor_deviation_bound
norm_add_sq_le_two
two_factor_product_deviation_norm_sq
three_factor_product_deviation_norm_sq
four_factor_product_deviation_norm_sq
product_deviation_from_triangle_and_cauchy
norm_product_deviation_from_triangle_and_cauchy
```

This file proves the two-, three-, and four-factor versions of the normed product-deviation estimate, together with abstract triangle/Cauchy wrappers.

---

### `RussoYM/ListProductDeviation.lean`

Finite-list product-deviation estimates.

Important results:

```lean
list_prod_norm_le_one
norm_one_sub_list_prod_le_sum
list_product_triangle_interface
```

This file proves the finite-list product-deviation endpoint:

‖1 - xs.prod‖ ≤ (xs.map fun x => ‖1 - x‖).sum

under the standard assumption:

∀ x ∈ xs, ‖x‖ ≤ 1

The public theorem-index endpoint is:

theorem_index_list_product_triangle_interface

## Current verified chains

### FRT operational chain

Lean verifies:

```text
D^2 <= N * Q
K * Q <= E
N <= C * (epsMax / epsMin)^2
D >= delta
```

implies:

```text
((K / C) * (epsMin / epsMax)^2) * delta^2 <= E
```

and if the constants are strictly positive:

```text
0 < E
```

---

### Conditional raw YM algebraic chain

Lean verifies:

```text
controlled RG crossing
=> coupling crosses xstab
=> square-root threshold condition
=> positive block-gap lower bound
=> gap lifting with UV positivity and small mixing
=> positive fine-lattice gap lower bound
```

The final named wrapper is:

```lean
exists_positive_fine_gap_from_controlled_rg
```

---

## What remains unproved analytically

The Lean project currently assumes, but does not prove, the main analytic red
lemmas required for the Clay-compatible Layer 1 route:

1. uniform curvature form/coercivity,
2. uniform RG remainder estimates,
3. uniform multiscale mixing suppression,
4. gap-preserving continuum construction.

Additional refinements still outside the current Lean algebra include:

5. gauge-covariant RG decomposition,
6. controlled nonperturbative Yang--Mills RG crossing,
7. holonomy-specific/product-deviation analytic estimates beyond the current
   finite-list algebraic theorem.

The Lean project currently verifies the algebraic closure once those assumptions
are supplied.

---

## Build

Run:

```powershell
lake build
```

Expected output:

```text
Build completed successfully
```

Check repo state:

```powershell
git status
```

Expected output:

```text
nothing to commit, working tree clean
```
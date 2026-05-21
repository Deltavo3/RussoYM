# RussoYM Lean Formalization

This project formalizes the algebraic skeleton of the FRT/YM proof program in Lean 4.

It does **not** yet prove the full Yang--Mills mass gap. The analytic and nonperturbative assumptions, such as RG control, quasi-local block diagonalization, UV Poincare estimates, and continuum convergence, remain external theorem assumptions.

The goal of this Lean project is to verify the algebraic closure steps that connect those assumptions.

---

## File map

### `RussoYM/AlgebraCore.lean`

This file proves the core algebraic lemmas.

Main results:

- `coercivity_implication_mul`

  From:

  ```text
  D^2 <= N * Q
  K * Q <= E
  ```

  proves:

  ```text
  K * D^2 <= N * E
  ```

- `coercivity_implication_div`

  From:

  ```text
  D^2 <= N * Q
  K * Q <= E
  N > 0
  ```

  proves:

  ```text
  (K / N) * D^2 <= E
  ```

- `finite_information_gap`

  From:

  ```text
  E >= mu * D^2
  D >= delta
  ```

  proves:

  ```text
  E >= mu * delta^2
  ```

- `electric_support_gap`

  Abstract Gauss-law support lemma: if every non-vacuum excitation has at least `m_min` active edges, and each active edge costs at least `lambdaG`, then:

  ```text
  energy >= lambdaG * m_min
  ```

- `strong_coupling_from_quadratic`

  Converts the quadratic strong-coupling condition into the block stability inequality.

- `block_stability_condition`

  YM-style wrapper for the strong-coupling block stability condition.

- `block_gap_positive_from_quadratic`

  Proves that the block-gap lower bound is positive under the quadratic stability condition.

- `frt_gap_from_coercivity`

  Combines coercivity and finite-information separation to obtain the FRT finite-information gap lower bound.

---

### `RussoYM/ProofSkeleton.lean`

This file connects the algebraic block gap, UV gap, and mixing assumptions.

Main results:

- `decoupled_gap_positive`

  If the block gap and UV gap are positive, then the decoupled gap is positive.

- `gap_lifting_lower_bound_positive`

  If the mixing term is smaller than the decoupled gap, then the lifted fine-lattice gap lower bound is positive.

- `gap_lifting_with_uv_scale`

  Specializes the UV gap to the form:

  ```text
  cUV / ell
  ```

- `raw_gap_algebraic_closure`

  Combines:

  ```text
  strong-coupling block positivity
  UV positivity
  small mixing
  ```

  to prove a positive fine-lattice gap lower bound.

---

### `RussoYM/RGCrossing.lean`

This file formalizes the algebra behind controlled RG crossing.

It does **not** prove Yang--Mills RG control. It only proves that if the inverse coupling decreases by a controlled amount, then the coupling eventually crosses a threshold.

Main results:

- `inverse_coupling_strict_decrease`

  If:

  ```text
  yNext <= y - step
  step > 0
  ```

  then:

  ```text
  yNext < y
  ```

- `controlled_rg_step_bound`

  If:

  ```text
  yNext = y - betaLog + R
  R <= theta * betaLog
  ```

  then:

  ```text
  yNext <= y - (1 - theta) * betaLog
  ```

- `controlled_rg_inverse_decreases`

  If `theta < 1` and `betaLog > 0`, then inverse coupling strictly decreases.

- `inverse_coupling_linear_bound`

  If every step decreases inverse coupling by at least `step`, then:

  ```text
  y n <= y 0 - n * step
  ```

- `controlled_rg_linear_bound`

  Controlled RG version of the finite-step linear bound.

- `controlled_rg_crosses_below`

  If the linear bound lies below a threshold, then the actual inverse coupling lies below that threshold.

- `coupling_crosses_from_inverse`

  If:

  ```text
  y = 1 / u
  y < 1 / x
  u > 0
  x > 0
  ```

  then:

  ```text
  x < u
  ```

- `controlled_rg_coupling_crosses`

  Converts controlled inverse-coupling crossing into actual coupling threshold crossing.

---

### `RussoYM/RawClosure.lean`

This file connects controlled RG crossing to the raw gap algebraic closure.

Main result:

- `raw_gap_from_controlled_rg_and_stability`

  If controlled RG crossing reaches the stability threshold, and crossing implies the strong-coupling quadratic condition, then the fine-lattice gap lower bound is positive.

This is the current formal Lean skeleton of the conditional raw YM route.

---

### `RussoYM/OperationalGap.lean`

This file proves positivity of the FRT operational finite-information gap constant.

Main results:

- `frt_gap_constant_positive`

  If:

  ```text
  K > 0
  N > 0
  delta > 0
  ```

  then:

  ```text
  (K / N) * delta^2 > 0
  ```

- `frt_energy_positive_from_coercivity`

  Combines coercivity and finite-information separation to prove:

  ```text
  E > 0
  ```

  for non-vacuum finite-information sectors.

---

## Current formalized chain

The Lean project currently verifies:

```text
finite-filter coercivity
+ finite-information separation
=> positive FRT operational gap
```

and:

```text
controlled RG crossing algebra
+ strong-coupling block stability algebra
+ UV gap assumption
+ small mixing assumption
=> positive fine-lattice gap lower bound
```

---

## What remains unproved analytically

The project currently assumes, but does not prove:

1. gauge-covariant RG decomposition,
2. controlled Yang--Mills RG crossing,
3. quasi-local block diagonalization,
4. UV Poincare gap,
5. continuum convergence preserving the gap.

These are the real analytic/nonperturbative Yang--Mills obligations.

The Lean project is currently verifying the algebraic closure once those assumptions are supplied.

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
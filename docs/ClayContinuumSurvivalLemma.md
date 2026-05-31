# Clay Continuum Survival Lemma

## Purpose

This file develops the paper-level proof of remaining obligation 5:

[
\Delta_0 \leq \Delta_{\mathrm{YM}}.
]

This is the most dangerous remaining transfer step. It cannot be assumed. It must be proved from the regulator limit, uniform lower bounds, and no-collapse conditions.

---

# Safety Rule

This lemma may use:

1. definitions of finite-regulator gaps;
2. definitions of the continuum Yang--Mills gap;
3. lower semicontinuity of quadratic forms if proved or properly established;
4. monotone convergence of regulated Hamiltonians if proved;
5. compactness or tightness preventing sector collapse;
6. uniform constants from the finite-regulator estimates.

This lemma may not use:

1. the continuum mass gap;
2. confinement;
3. the statement (\Delta_{\mathrm{YM}}>0);
4. any theorem implying (\Delta_{\mathrm{YM}}>0) without deriving it from the finite-regulator lower bounds.

---

# Core Problem

The finite-regulator proof produces a lower bound

[
\Delta_0>0.
]

The continuum claim is:

[
\Delta_0\leq\Delta_{\mathrm{YM}}.
]

This requires showing that the lower bound survives the limit (n\to\infty).

The danger is that finite-regulator gaps can collapse in the continuum limit unless there is a uniform lower bound and the limiting procedure preserves the relevant non-vacuum sector.

---

# Safe Definition of Continuum Gap

Define the continuum Yang--Mills gap by

[
\Delta_{\mathrm{YM}}
====================

\inf\left{
\langle \psi,H_{\mathrm{YM}}\psi\rangle:
|\psi|=1,\
\psi\perp\mathrm{Vac}
\right}.
]

This definition alone does not assert that (\Delta_{\mathrm{YM}}>0).

---

# Finite Lower Bound Input

For each regulator level (n), suppose the proof establishes:

[
\Delta_0\leq \mathrm{Gap}(n)
]

with the same (\Delta_0>0) independent of (n).

Equivalently, for every normalized non-vacuum finite-regulator state (\psi_n),

[
\Delta_0
\leq
\langle \psi_n,H_n\psi_n\rangle.
]

This is a uniform finite-regulator lower bound.

---

# Continuum Survival Principle

A safe continuum survival theorem should have the form:

If:

1. (H_n\to H_{\mathrm{YM}}) in a suitable lower-semicontinuous sense;
2. finite non-vacuum states approximate continuum non-vacuum states;
3. the vacuum sector converges without swallowing the non-vacuum sector;
4. (\Delta_0\leq \langle\psi_n,H_n\psi_n\rangle) uniformly for all normalized non-vacuum (\psi_n);

then:

[
\Delta_0\leq
\langle\psi,H_{\mathrm{YM}}\psi\rangle
]

for every normalized continuum non-vacuum (\psi).

Taking the infimum over continuum non-vacuum states gives:

[
\Delta_0\leq\Delta_{\mathrm{YM}}.
]

---

# No-Collapse Requirement

The most important hidden condition is no-collapse:

A continuum non-vacuum state must not be approximated only by finite-regulator states that fall into the vacuum sector.

Equivalently, the finite-resolution nontrivial sector must remain separated from the trivial/vacuum sector in the limit.

This links continuum survival back to obligation 1, compact/nontrivial holonomy sector separation.

---

# Lower Semicontinuity Route

A standard safe route is lower semicontinuity.

Let (\psi_n\to\psi) in the regulator-to-continuum topology.

Assume:

[
\langle\psi,H_{\mathrm{YM}}\psi\rangle
\leq?
]

Careful: lower semicontinuity usually gives

[
\langle\psi,H_{\mathrm{YM}}\psi\rangle
\leq
\liminf_{n\to\infty}
\langle\psi_n,H_n\psi_n\rangle
]

or

[
\langle\psi,H_{\mathrm{YM}}\psi\rangle
\leq \liminf E_n
]

depending on the direction of convergence.

But to transfer a finite lower bound to the continuum, we need:

[
\Delta_0\leq
\langle\psi,H_{\mathrm{YM}}\psi\rangle.
]

If all we know is

[
\langle\psi,H_{\mathrm{YM}}\psi\rangle
\leq
\liminf E_n,
]

then the direction is not enough.

We need a convergence theorem strong enough to prevent the continuum energy from dropping below the finite lower bound.

Possible sufficient conditions:

1. strong resolvent convergence plus spectral lower-bound preservation;
2. Mosco convergence of closed quadratic forms with spectral lower-bound preservation;
3. monotone increasing convergence of Hamiltonians from below;
4. Γ-convergence with preservation of minimizers and lower bounds.

---

# Spectral Lower-Bound Route

A safer abstract theorem is:

If (H_n\geq \Delta_0 P_n^\perp) uniformly on finite non-vacuum sectors, and the continuum limit preserves this operator inequality in the non-vacuum sector, then

[
H_{\mathrm{YM}}\geq \Delta_0 P^\perp.
]

Then automatically:

[
\Delta_{\mathrm{YM}}\geq \Delta_0.
]

This is the cleanest conceptual route.

---

# Main Paper Lemma

## Lemma: Uniform Spectral Lower Bound Survives Regulator Limit

Let (H_n) be regulated Yang--Mills Hamiltonians with vacuum projections (P_n). Let (H_{\mathrm{YM}}) be the continuum Hamiltonian with vacuum projection (P).

Assume:

1. (H_n\geq \Delta_0(I-P_n)) for every (n).
2. (H_n\to H_{\mathrm{YM}}) in a convergence mode preserving lower spectral bounds.
3. (P_n\to P) in a compatible sense.
4. Non-vacuum sector does not collapse into the vacuum sector.

Then:

[
H_{\mathrm{YM}}\geq \Delta_0(I-P).
]

Therefore:

[
\Delta_0\leq\Delta_{\mathrm{YM}}.
]

---

# What Must Be Proved

This file reduces continuum survival to four precise tasks:

1. Prove a uniform operator lower bound:
   [
   H_n\geq\Delta_0(I-P_n).
   ]

2. Define the convergence (H_n\to H_{\mathrm{YM}}).

3. Prove this convergence preserves lower spectral bounds.

4. Prove vacuum/non-vacuum projections converge without collapse:
   [
   P_n\to P.
   ]

---

# Relation to Old Lean Sources

The old proof already split continuum survival into:

```lean
UniformFiniteGapLowerAssumptions Delta0 Gap
EpsilonContinuumApproximationAssumptions DeltaYM Gap
```

The new interpretation is:

1. `UniformFiniteGapLowerAssumptions` should represent
   [
   \Delta_0\leq\mathrm{Gap}(n)
   ]
   uniformly.

2. `EpsilonContinuumApproximationAssumptions` should represent the theorem that the continuum gap is not below the uniform finite lower bound.

The second piece is the hard analytic step.

---

# Status

Continuum survival is not proved yet.

It is now reduced to a precise operator-limit theorem.

---

# Risk Assessment

Risk level: very high.

This is the main place where a finite-regulator proof can fail. We must not assume that a finite lower bound survives the continuum limit unless the convergence theorem explicitly preserves the lower bound.

---

# Next Decision

We need to choose the continuum-limit framework:

1. strong resolvent convergence,
2. Mosco convergence of quadratic forms,
3. monotone convergence of quadratic forms,
4. Γ-convergence,
5. another regulator-specific convergence theorem.

The proof should use whichever framework best matches the original FRT/Yang--Mills regulator construction.

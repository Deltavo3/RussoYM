# Clay Original Proof Map

## Purpose

This file maps the Yang--Mills/FRT proof route onto the remaining analytic obligations.

The goal is to keep a clean audit of:

1. what Lean has already verified;
2. what is definition-level;
3. what is paper-level analysis;
4. what remains open;
5. where the proof could accidentally assume the mass gap.

---

# Core Safety Rule

We may use standard Yang--Mills definitions, local identities, norm inequalities, finite-regulator algebra, and local holonomy-curvature estimates.

We may not use any theorem or assumption that already implies a positive Yang--Mills mass gap.

In particular, we must not assume

[
\inf \operatorname{Spec}(H_{\mathrm{YM}}\setminus{0})>0
]

or anything equivalent to it.

---

# Original Five Obligations

The Lean roadmap originally reduced the Clay endpoint to five obligations:

1. compact/nontrivial holonomy sector separation;
2. holonomy-curvature control;
3. curvature coercivity;
4. finite gap lower comparison;
5. continuum survival.

If these are proved honestly, the Lean chain reaches

[
0<\Delta_{\mathrm{YM}}.
]

---

# Obligation 1: Holonomy Sector Separation

## Original target

[
\exists\delta>0,\quad
\forall n,\quad
\delta\leq |1-U_n|,
]

where

[
U_n=(\mathrm{links}\ n).\mathrm{prod}.
]

## Current route

The old compact-sector route has been replaced by a more direct finite-resolution sector condition.

Dedicated files:

```text
docs/ClayCompactHolonomySectorLemma.md
docs/ClayNontrivialHolonomySectorDefinition.md
docs/ClayHolonomySectorMapDefinition.md
docs/ClayDirectHolonomySectorChoice.md
RussoYM/ClayDirectHolonomySector.lean
```

The direct finite-resolution sector condition is

[
\forall n,\quad
2\epsilon_{\mathrm{hol}}
\leq
|1-(\mathrm{links}\ n).\mathrm{prod}|.
]

Lean verifies that this gives holonomy separation with witness

[
\delta=2\epsilon_{\mathrm{hol}}.
]

## Status

Lean-packaged under the direct sector assumption.

## Remaining burden

Justify the direct sector membership condition in the paper as a legitimate finite-resolution holonomy-sector selection, not as an energy or mass-gap assumption.

Risk: medium-high.

---

# Obligation 2: Holonomy-Curvature Control

## Original target

[
\exists C>0,\quad
\forall n,\quad
|1-U_n|
\leq
C,\operatorname{curvatureNorm}(n).
]

## Current route

Dedicated files:

```text
docs/ClayHolonomyCurvatureControlLemma.md
docs/ClayHolonomyCurvatureControlProofPlan.md
docs/ClayLocalHolonomyFluxEstimate.md
docs/ClayFluxEnergyComparison.md
RussoYM/ClayHolonomyCurvatureEnergyPackaging.lean
```

Lean packages holonomy-curvature control from two paper-level estimates:

[
|1-U_n|
\leq
C_{\mathrm{loc}}\operatorname{FluxNorm}(n),
]

and

[
\operatorname{FluxNorm}(n)
\leq
A_{\mathrm{fac}}\operatorname{curvatureNorm}(n).
]

Lean verifies that these imply

[
|1-U_n|
\leq
(C_{\mathrm{loc}}A_{\mathrm{fac}})
\operatorname{curvatureNorm}(n).
]

## Status

Lean-packaged from local flux estimates.

## Remaining burden

Prove on paper:

1. local holonomy/flux estimate;
2. flux-to-energy comparison;
3. positivity of (C_{\mathrm{loc}}) and (A_{\mathrm{fac}});
4. uniformity of constants in (n).

Risk: medium.

---

# Obligation 3: Curvature Coercivity

## Original target

[
\exists\mu>0,\quad
\forall n,\quad
\mu(\operatorname{curvatureNorm}(n))^2
\leq
\operatorname{Energy}(n).
]

## Current route

Dedicated files:

```text
docs/ClayCurvatureCoercivityLemma.md
docs/ClayEnergyNormConvention.md
RussoYM/ClayEnergyNormCoercivity.lean
```

Use the energy-norm convention:

[
\operatorname{curvatureNorm}(n)=|F_n|*{E,n},
\qquad
\operatorname{Energy}(n)=|F_n|*{E,n}^{2}.
]

Then

[
\operatorname{Energy}(n)
========================

(\operatorname{curvatureNorm}(n))^2.
]

Lean verifies curvature coercivity with

[
\mu=1.
]

## Status

Definition-level discharged under the energy-norm convention.

Risk: low, assuming definitions are used consistently.

---

# Obligation 4: Finite Gap Lower Comparison

## Original target

[
\forall n,\quad
\operatorname{Energy}(n)\leq \operatorname{Gap}(n).
]

## Important correction

The Lean variable `Energy n` should not be interpreted in the paper as an arbitrary energy value.

It should be interpreted as a universal lower-bound scale:

[
\operatorname{Lower}(n).
]

Thus the Lean comparison should be read as

[
\operatorname{Lower}(n)\leq \operatorname{Gap}(n).
]

Dedicated files:

```text
docs/ClayFiniteGapComparisonLemma.md
docs/ClayUniversalLowerBoundDefinition.md
docs/ClaySectorSpecificGapTheorem.md
docs/ClaySectorCoverageProblem.md
docs/ClaySectorSpecificProofAssembly.md
```

## Sector-specific safe theorem

The proof currently supports a sector-specific result.

Inside a fixed resolved nontrivial holonomy sector,

[
\Delta_{\lambda_*}
==================

\left(
\frac{2\epsilon_{\mathrm{hol}}}
{C_{\mathrm{loc}}A_{\mathrm{fac}}}
\right)^2

> 0
> ]

and

[
\Delta_{\lambda_*}
\leq
\operatorname{Gap}*{\lambda**}(n).
]

This is the strongest safe finite-regulator theorem before sector coverage is proved.

## Full finite-regulator upgrade

To claim the full finite-regulator Yang--Mills gap, we need sector coverage:

[
\mathcal N_n
\subseteq
\bigcup_{\lambda\neq\lambda_{\mathrm{id}}}
\mathcal S_{n,\lambda}.
]

That is, every normalized non-vacuum state must be detected by some resolved nontrivial holonomy sector with uniform constants.

## Status

Sector-specific theorem stated and assembled.

Full finite-regulator gap remains conditional on sector coverage.

Risk: high.

---

# Obligation 5: Continuum Survival

## Target

[
\Delta_0\leq \Delta_{\mathrm{YM}}.
]

Dedicated file:

```text
docs/ClayContinuumSurvivalLemma.md
```

The desired operator-limit form is:

[
H_n\geq \Delta_0(I-P_n)
\quad\Longrightarrow\quad
H_{\mathrm{YM}}\geq \Delta_0(I-P).
]

This requires:

1. a precise regulator convergence framework;
2. convergence of vacuum projections (P_n\to P);
3. no collapse of non-vacuum states;
4. preservation of lower spectral bounds.

## Status

Not proved.

Risk: very high.

---

# Current Lean-Packaged Components

Lean now verifies:

1. direct sector condition gives holonomy separation;
2. energy-norm identity gives curvature coercivity with (\mu=1);
3. local flux estimate plus flux-to-energy comparison gives holonomy-curvature control;
4. the conditional chain from these packaged assumptions to the mass-gap endpoint remains available.

---

# Current Honest Mathematical Result

The current safe result is:

[
\boxed{
\text{sector-specific finite-regulator lower-bound mechanism}
}
]

More explicitly, under the direct sector condition, local holonomy/flux estimate, flux-to-energy comparison, and energy-norm convention,

[
\operatorname{Gap}*{\lambda**}(n)
\geq
\Delta_{\lambda_*}>0.
]

This is not yet the full Clay theorem.

---

# Remaining Hard Theorems

The remaining hard mathematical work is:

1. prove the local holonomy/flux estimate;
2. prove flux-to-energy comparison with uniform constants;
3. prove sector coverage if claiming the full finite-regulator gap;
4. prove continuum survival.

The two hardest upgrades are:

1. sector coverage;
2. continuum survival.

---

# Paper 1 Claim Boundary

Dedicated file:

```text
docs/ClayPaper1ClaimBoundary.md
```

Paper 1 should be framed as:

[
\text{a Lean-verified conditional reduction and sector-specific gap mechanism.}
]

It should not claim a completed Clay-level proof unless sector coverage and continuum survival are proved.

---

# Current Status

The project now has a clean conditional Lean scaffold and a safe sector-specific finite-regulator theorem.

Full Clay proof status: not complete yet.

Next meaningful work:

1. Lean-package the sector-specific lower-bound algebra, or
2. begin the paper proof of the local holonomy/flux estimate.

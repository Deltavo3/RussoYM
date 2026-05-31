# Clay Paper 1 Claim Boundary

## Purpose

This file records the honest claim boundary for the current Yang--Mills/FRT project.

The goal is to prevent the paper from overstating the result.

---

# Current Verified Position

The Lean project has verified the algebraic and logical route from named analytic obligations to a positive Yang--Mills mass-gap endpoint.

The proof has also been sharpened by:

1. discharging curvature coercivity under the energy-norm convention;
2. discharging holonomy separation from a direct finite-resolution sector condition;
3. packaging holonomy-curvature control from local flux estimates;
4. identifying the finite-gap comparison direction issue;
5. separating sector-specific lower bounds from the full finite-regulator gap;
6. isolating sector coverage as a separate hard theorem;
7. isolating continuum survival as a separate hard theorem.

---

# Safe Paper 1 Claim

The current safe claim is:

[
\text{A Lean-verified conditional reduction of the Yang--Mills mass-gap route to explicit analytic obligations,}
]

together with a sector-specific finite-resolution lower-bound mechanism.

More concretely:

[
\text{direct resolved holonomy sector}
+
\text{local holonomy/flux control}
+
\text{energy-norm convention}
\Rightarrow
\text{sector-specific finite-regulator lower bound}.
]

This is honest and useful.

---

# What Paper 1 Should Not Claim Yet

Paper 1 should not claim a complete Clay-level proof unless the following are proved:

1. local holonomy/flux estimate;
2. flux-to-energy comparison;
3. sector coverage for all normalized non-vacuum finite-regulator states;
4. continuum survival of the lower bound.

In particular, Paper 1 should not say:

[
0<\Delta_{\mathrm{YM}}
]

as an unconditional theorem unless sector coverage and continuum survival are proved.

---

# Safe Main Theorem Statement

A safe main theorem could be:

## Theorem: Conditional Sector-Specific Gap Mechanism

Assume:

1. a direct resolved nontrivial holonomy sector condition;
2. a local holonomy/flux estimate;
3. a flux-to-energy comparison;
4. the energy-norm convention;
5. a sector-specific finite-regulator gap definition.

Then there exists

[
\Delta_{\lambda_*}>0
]

such that

[
\Delta_{\lambda_*}
\leq
\mathrm{Gap}*{\lambda**}(n)
]

for every regulator level (n).

Moreover, Lean verifies the algebraic packaging of the route from these assumptions to the stated lower bound.

---

# Conditional Full-Gap Theorem

A second theorem can be stated conditionally:

## Theorem: Conditional Full Gap Upgrade

If, in addition to the sector-specific hypotheses, one proves:

1. sector coverage:
   [
   \mathcal N_n
   \subseteq
   \bigcup_{\lambda\neq\lambda_{\mathrm{id}}}\mathcal S_{n,\lambda},
   ]

2. uniform lower-bound constants across resolved nontrivial sectors;

3. continuum survival:
   [
   \Delta_0\leq \Delta_{\mathrm{YM}},
   ]

then the full continuum Yang--Mills gap follows.

This theorem is conditional until those analytic steps are proved.

---

# Paper 1 Framing

The paper should be framed as:

[
\text{a rigorous finite-resolution reduction and proof audit,}
]

not as a final Clay proof.

A good subtitle would be:

[
\text{A Lean-Verified Conditional Reduction and Sector-Specific Gap Mechanism.}
]

---

# Paper 2 Goal

Paper 2 should target the remaining analytic completion:

1. prove local holonomy/flux estimate;
2. prove flux-to-energy comparison;
3. prove sector coverage or clearly restrict to sector-specific theorem;
4. prove continuum survival.

Only after those are complete should the project claim a full Clay-level proof.

---

# Current Status

Paper 1: plausible as a conditional/sector-specific Lean-verified framework.

Full Clay proof: not complete yet.

Main remaining hard upgrades:

1. sector coverage;
2. continuum survival.

# Clay Energy-Norm Convention

## Purpose

This file records the preferred convention for the curvature norm used in the reduced Yang--Mills mass-gap roadmap.

The goal is to avoid introducing an unnecessary second curvature norm and to make curvature coercivity a definition-level fact rather than an additional analytic assumption.

---

# Convention

For each regulator level (n), let (F_n) be the regulated Yang--Mills curvature.

Define the regulated curvature norm by

[
\mathrm{curvatureNorm}(n)
:=
|F_n|_{E,n},
]

where (|\cdot|_{E,n}) is the norm induced by the regulated Yang--Mills energy quadratic form.

Define the regulated energy by

[
\mathrm{Energy}(n)
:=
|F_n|_{E,n}^{2}.
]

Then

[
\mathrm{Energy}(n)
==================

(\mathrm{curvatureNorm}(n))^{2}.
]

---

# Consequence: Curvature Coercivity

The reduced roadmap requires:

[
\exists \mu>0,\quad
\forall n,\quad
\mu(\mathrm{curvatureNorm}(n))^{2}
\leq
\mathrm{Energy}(n).
]

Under the energy-norm convention, choose

[
\mu=1.
]

Then

[
1\cdot(\mathrm{curvatureNorm}(n))^{2}
=====================================

\mathrm{Energy}(n),
]

so the coercivity obligation holds immediately.

This does not assume a mass gap. It is only a definition-level identity.

---

# Effect on the Remaining Proof

With this convention, obligation 3 is reduced to checking that the definitions are used consistently.

The real analytic burden moves to obligation 2:

[
\exists C>0,\quad
\forall n,\quad
|1-U_n|
\leq
C,|F_n|_{E,n}.
]

Thus obligations 2 and 3 combine into one main analytic estimate:

[
\text{uniform holonomy-curvature control in the energy norm}.
]

---

# What Still Must Be Proved

We still need a paper proof of:

[
|1-U_n|
\leq
C,|F_n|_{E,n}
]

with (C) independent of (n).

This should follow from:

1. a local holonomy-curvature estimate,
2. Cauchy--Schwarz,
3. uniform regulator geometry,
4. local-to-global energy comparison.

None of these steps may use confinement, a spectral gap, or continuum mass-gap survival.

---

# Updated Reduced Burden

After adopting the energy-norm convention, the proof burden becomes:

1. Compact/nontrivial holonomy sector separation.
2. Uniform holonomy-curvature control in the energy norm.
3. Finite gap lower comparison.
4. Continuum survival.

Curvature coercivity remains in the Lean roadmap as a formal obligation, but it should now be discharged by definition with (\mu=1).

---

# Lean Verification Plan

This convention is a good candidate for selective Lean verification later.

A future Lean lemma should have the schematic form:

```lean
Energy n = (curvatureNorm n)^2
->
ClayCurvatureCoercivityExistenceAssumptions Energy curvatureNorm
```

with witness:

```lean
mu = 1
```

This is safe to Lean-prove because it is purely algebraic/definitional and does not assert a positive spectral gap.

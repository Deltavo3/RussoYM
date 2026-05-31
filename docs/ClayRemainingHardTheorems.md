# Clay Remaining Hard Theorems

## Purpose

This file lists the remaining hard mathematical theorems after the Lean scaffold and paper audits.

The goal is to separate:

1. what Lean has already packaged;
2. what is paper-level analysis;
3. what is still open or dangerous.

---

# Already Lean-Packaged

## 1. Holonomy separation from direct sector

Lean verifies:

[
\forall n,\quad
2\epsilon_{\mathrm{hol}}
\leq
|1-(\mathrm{links}\ n).\mathrm{prod}|
]

implies

[
\exists \delta>0,\quad
\forall n,\quad
\delta
\leq
|1-(\mathrm{links}\ n).\mathrm{prod}|.
]

Witness:

[
\delta=2\epsilon_{\mathrm{hol}}.
]

---

## 2. Curvature coercivity from energy norm

Lean verifies that if

[
\mathrm{Energy}(n)
==================

(\mathrm{curvatureNorm}(n))^2,
]

then curvature coercivity holds with

[
\mu=1.
]

---

## 3. Holonomy-curvature control packaging

Lean verifies that

[
|1-U_n|
\leq
C_{\mathrm{loc}}\operatorname{FluxNorm}(n)
]

and

[
\operatorname{FluxNorm}(n)
\leq
A_{\mathrm{fac}}\operatorname{curvatureNorm}(n)
]

imply

[
|1-U_n|
\leq
(C_{\mathrm{loc}}A_{\mathrm{fac}})
\operatorname{curvatureNorm}(n).
]

---

# Remaining Hard Theorem 1: Local Holonomy/Flux Estimate

## Target

Prove

[
|1-U_n|
\leq
C_{\mathrm{loc}}\operatorname{FluxNorm}(n).
]

## Meaning

Holonomy deviation is controlled by curvature flux through the resolved loop/plaquette surface.

## Allowed tools

1. path-ordered exponential estimates;
2. nonabelian Stokes-type estimates;
3. lattice plaquette expansion;
4. local curvature-flux bounds.

## Forbidden tools

1. spectral gap;
2. confinement;
3. continuum survival;
4. any positive-energy lower bound.

## Status

Not proved.

Risk: medium.

---

# Remaining Hard Theorem 2: Flux-to-Energy Comparison

## Target

Prove

[
\operatorname{FluxNorm}(n)
\leq
A_{\mathrm{fac}}\operatorname{curvatureNorm}(n).
]

Under the energy-norm convention:

[
\operatorname{curvatureNorm}(n)=|F_n|_{E,n}.
]

## Meaning

The local flux norm is controlled by the global regulated energy norm.

## Likely route

1. Cauchy--Schwarz;
2. uniform area bound;
3. local-to-global (L^2) comparison.

## Status

Not proved.

Risk: medium-low if regulator geometry is fixed and uniform.

---

# Remaining Hard Theorem 3: Sector Coverage

## Target

Prove that every normalized non-vacuum finite-regulator state is detected by a resolved nontrivial holonomy sector.

Schematic form:

[
\mathcal N_n
\subseteq
\bigcup_{\lambda\neq\lambda_{\mathrm{id}}}
\mathcal S_{n,\lambda}.
]

## Meaning

The sector-specific lower-bound mechanism applies to the whole finite-regulator non-vacuum sector.

## Danger

This is not automatic.

A non-vacuum excitation could be invisible to the chosen resolved holonomy observables unless we prove the holonomy sector family is complete enough.

## Status

Not proved.

Risk: high.

---

# Remaining Hard Theorem 4: Continuum Survival

## Target

Prove

[
\Delta_0\leq \Delta_{\mathrm{YM}}.
]

Equivalently, show that a uniform finite-regulator lower bound survives the continuum limit.

## Possible operator form

If

[
H_n\geq \Delta_0(I-P_n)
]

for every (n), prove

[
H_{\mathrm{YM}}\geq \Delta_0(I-P).
]

## Needed inputs

1. regulator convergence framework;
2. convergence of vacuum projections;
3. no collapse of non-vacuum states;
4. preservation of lower spectral bounds.

## Status

Not proved.

Risk: very high.

---

# Current Honest Proof State

The current project has a strong conditional Lean-verified scaffold and a sector-specific finite-regulator gap mechanism.

The full Clay-level proof still requires:

1. local holonomy/flux estimate;
2. flux-to-energy comparison;
3. sector coverage;
4. continuum survival.

The two hardest remaining steps are:

1. sector coverage;
2. continuum survival.

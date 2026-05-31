# Clay Holonomy Sector Map Definition

## Purpose

This file refines the finite-resolution holonomy sector map

[
q_{\mathrm{hol}}:G^m\to\Lambda_{\mathrm{hol}}
]

used to define the admissible nontrivial holonomy sector

[
K=q_{\mathrm{hol}}^{-1}(\lambda_*).
]

The goal is to define (q_{\mathrm{hol}}) without using energy, confinement, or a spectral lower bound.

---

# Setup

Let (G) be the compact gauge group.

Let

[
\Gamma={\gamma_1,\ldots,\gamma_m}
]

be a fixed finite family of resolved test loops or plaquette loops.

For a regulated connection (A_n), define

[
V_n
===

# \operatorname{Hol}_{\Gamma}(A_n)

(\operatorname{Hol}*{A_n}(\gamma_1),\ldots,\operatorname{Hol}*{A_n}(\gamma_m))
\in G^m.
]

The identity tuple is

[
\mathbf 1=(1,\ldots,1)\in G^m.
]

Since (G) is compact, (G^m) is compact.

---

# Resolution Metric

Choose a continuous metric or norm-induced distance

[
d_{\mathrm{hol}}:G^m\times G^m\to\mathbb R_{\geq0}.
]

For example,

[
d_{\mathrm{hol}}(V,W)
=====================

\max_{1\leq j\leq m}|V_j-W_j|.
]

Define the identity distance function

[
r(V)=d_{\mathrm{hol}}(V,\mathbf 1).
]

Since (d_{\mathrm{hol}}) is continuous, (r) is continuous.

---

# Identity Cell and Nontrivial Cell

Choose a finite holonomy resolution threshold

[
\epsilon_{\mathrm{hol}}>0.
]

Define the resolved identity cell by

[
K_{\mathrm{id}}
===============

{V\in G^m:r(V)\leq \epsilon_{\mathrm{hol}}}.
]

Define the resolved nontrivial exterior sector by

[
K_{\mathrm{nontriv}}
====================

{V\in G^m:r(V)\geq 2\epsilon_{\mathrm{hol}}}.
]

The buffer region

[
\epsilon_{\mathrm{hol}}<r(V)<2\epsilon_{\mathrm{hol}}
]

is left undecided. It is a transition region between resolved identity and resolved nontrivial holonomy.

This avoids forcing near-identity configurations into a nontrivial sector.

---

# Sector Map

Define

[
\Lambda_{\mathrm{hol}}
======================

{\lambda_{\mathrm{id}},\lambda_*,\lambda_{\mathrm{buffer}}}.
]

Define

[
q_{\mathrm{hol}}(V)
===================

\begin{cases}
\lambda_{\mathrm{id}}, & r(V)\leq \epsilon_{\mathrm{hol}},\
\lambda_*, & r(V)\geq 2\epsilon_{\mathrm{hol}},\
\lambda_{\mathrm{buffer}}, & \epsilon_{\mathrm{hol}}<r(V)<2\epsilon_{\mathrm{hol}}.
\end{cases}
]

Then

[
K=q_{\mathrm{hol}}^{-1}(\lambda_*)
==================================

# K_{\mathrm{nontriv}}

{V\in G^m:r(V)\geq 2\epsilon_{\mathrm{hol}}}.
]

---

# Compactness

Because (r) is continuous,

[
K_{\mathrm{nontriv}}=r^{-1}([2\epsilon_{\mathrm{hol}},\infty))
]

is closed.

Since

[
K_{\mathrm{nontriv}}\subseteq G^m
]

and (G^m) is compact, (K_{\mathrm{nontriv}}) is compact.

Thus the compactness part of the sector-separation lemma is satisfied.

---

# Identity Exclusion

Since

[
r(\mathbf 1)=0
]

and

[
0<\epsilon_{\mathrm{hol}},
]

we have

[
\mathbf 1\notin K_{\mathrm{nontriv}}.
]

Indeed,

[
r(\mathbf 1)=0<2\epsilon_{\mathrm{hol}}.
]

So the identity tuple is excluded from the nontrivial sector.

---

# Uniform Holonomy Separation

For every

[
V\in K_{\mathrm{nontriv}},
]

we have

[
r(V)\geq 2\epsilon_{\mathrm{hol}}.
]

If the resolved product observable (U(V)) is chosen so that

[
|1-U(V)|
\geq c_{\mathrm{prod}}, r(V)
]

for some (c_{\mathrm{prod}}>0), then

[
|1-U(V)|
\geq
2c_{\mathrm{prod}}\epsilon_{\mathrm{hol}}.
]

Therefore, if

[
V_n=\operatorname{Hol}*{\Gamma}(A_n)\in K*{\mathrm{nontriv}}
]

for all (n), then

[
\delta
======

2c_{\mathrm{prod}}\epsilon_{\mathrm{hol}}
]

satisfies

[
\delta\leq|1-U_n|
]

for all (n).

---

# Simpler Direct Version

If (U_n) itself is the measured holonomy observable and

[
r(V_n)=|1-U_n|,
]

then no product comparison constant is needed.

In that case, for all (V_n\in K_{\mathrm{nontriv}}),

[
|1-U_n|\geq 2\epsilon_{\mathrm{hol}}.
]

So we may take

[
\delta=2\epsilon_{\mathrm{hol}}.
]

This is the preferred version if compatible with the existing Lean variable

[
U_n=(\mathrm{links}\ n).\mathrm{prod}.
]

---

# Why the Buffer Region Matters

The buffer region prevents us from pretending that every non-identity holonomy is uniformly separated from identity.

Without a buffer, one might define

[
K={V:V\neq\mathbf 1}.
]

But this set is not closed in a useful way away from identity, and its distance to identity is zero.

The finite-resolution definition avoids this by only calling a sector resolved-nontrivial when it is separated from identity by at least the resolution threshold.

This is not a mass-gap assumption. It is a finite-resolution distinction rule.

---

# Regulator Sector Assumption

The remaining paper assumption is:

[
V_n\in K_{\mathrm{nontriv}}
]

for all regulator levels (n).

Equivalently,

[
r(V_n)\geq 2\epsilon_{\mathrm{hol}}.
]

This says the regulator sequence is being studied inside a fixed resolved nontrivial holonomy sector.

This is safe if it is a sector selection, analogous to choosing a topological or boundary sector, not an energy lower bound.

---

# Resulting Sector Theorem

## Lemma: Finite-Resolution Holonomy Sector Separation

Assume:

1. (G) is compact.
2. (G^m) is equipped with a continuous holonomy distance (d_{\mathrm{hol}}).
3. (\epsilon_{\mathrm{hol}}>0).
4. (K_{\mathrm{nontriv}}={V:r(V)\geq2\epsilon_{\mathrm{hol}}}).
5. (V_n\in K_{\mathrm{nontriv}}) for all (n).
6. (r(V_n)=|1-U_n|), or more generally
   [
   |1-U_n|\geq c_{\mathrm{prod}}r(V_n)
   ]
   with (c_{\mathrm{prod}}>0).

Then there exists (\delta>0) such that

[
\forall n,\quad
\delta\leq|1-U_n|.
]

In the direct case,

[
\delta=2\epsilon_{\mathrm{hol}}.
]

In the product-comparison case,

[
\delta=2c_{\mathrm{prod}}\epsilon_{\mathrm{hol}}.
]

---

# Status

This gives a concrete finite-resolution definition of the nontrivial holonomy sector.

The remaining proof tasks are:

1. decide whether to use the direct version (r(V_n)=|1-U_n|);
2. if not, prove the product comparison
   [
   |1-U_n|\geq c_{\mathrm{prod}}r(V_n);
   ]
3. justify that the regulator sequence belongs to the resolved nontrivial sector.

Risk level: reduced from high to medium-high.

The main danger is now localized to the sector-membership assumption.

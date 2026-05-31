# Clay Compact Holonomy Sector Separation Lemma

## Purpose

This file develops the paper-level proof of remaining obligation 1:

[
\exists \delta>0,\quad
\forall n,\quad
\delta \leq |1-U_n|,
]

where

[
U_n=(\mathrm{links}\ n).\mathrm{prod}.
]

This is the compact/nontrivial holonomy sector separation requirement.

---

# Safety Rule

This lemma may use:

1. compactness of an explicitly defined admissible sector;
2. continuity of the norm map (U\mapsto |1-U|);
3. exclusion of the trivial identity holonomy from the admissible sector;
4. finite-resolution sector definitions;
5. closedness of the admissible nontrivial sector.

This lemma may not use:

1. a positive Yang--Mills mass gap;
2. confinement;
3. a spectral lower bound;
4. continuum survival;
5. any assumption that says nontrivial excitations already have positive energy.

---

# Target

We need a uniform lower bound:

[
\delta \leq |1-U_n|
]

for all regulator levels (n).

This prevents the nontrivial holonomy sector from collapsing into the trivial identity sector.

---

# Basic Compactness Argument

Let (K) be the admissible nontrivial holonomy sector.

Assume:

1. (U_n\in K) for every (n).
2. (K) is compact.
3. (1\notin K).
4. The norm-distance map

[
d_1(U)=|1-U|
]

is continuous.

Since (K) is compact, (d_1) attains a minimum on (K). Let

[
\delta=\min_{U\in K}|1-U|.
]

Since (1\notin K), and (K) is compact/closed, the minimum cannot be (0). Therefore

[
\delta>0.
]

Thus, for every (U\in K),

[
\delta\leq |1-U|.
]

Since (U_n\in K), we get

[
\delta\leq |1-U_n|
]

for every (n).

---

# Important Subtlety

The condition

[
1\notin K
]

is not enough by itself if (K) is not closed or compact.

For example, (K) could contain elements approaching (1), even though (1\notin K). Then

[
\inf_{U\in K}|1-U|=0.
]

Therefore, the proof needs one of the following:

1. (K) compact and (1\notin K);
2. (K) closed and there is a known positive distance to (1);
3. finite-resolution discreteness giving a minimum distance from the identity sector;
4. a sector label/topological charge that is locally constant and excludes convergence to identity.

---

# What Is (K)?

The proof must define (K) honestly.

Possible definition:

[
K={U:\ q_{\mathcal A}(U)=q_{\mathrm{nontriv}}},
]

where (q_{\mathcal A}) is the finite-resolution sector map and (q_{\mathrm{nontriv}}) is a fixed nontrivial sector label.

Then the proof must show:

1. (U_n\in K) because the regulator sequence is restricted to that sector.
2. (1\notin K) because identity holonomy belongs to the trivial sector.
3. (K) is compact, or finite-resolution compact, in the regulated holonomy topology.
4. The distance to identity is continuous.

---

# Finite-Resolution Version

In a finite-resolution framework, compactness may be replaced by finite distinguishability.

If the holonomy space is partitioned into finitely resolved cells, and the identity cell is distinct from the nontrivial sector cell, then there is a positive resolution distance between the two cells.

Let (K_{\mathrm{nontriv}}) be the resolved nontrivial sector and (K_{\mathrm{id}}) the resolved identity sector.

Assume:

[
K_{\mathrm{nontriv}}\cap K_{\mathrm{id}}=\varnothing.
]

If the resolution metric has minimum distinguishable separation (\epsilon_{\mathrm{hol}}>0), then

[
\operatorname{dist}(K_{\mathrm{nontriv}},K_{\mathrm{id}})
\geq
\epsilon_{\mathrm{hol}}.
]

Then choose

[
\delta=\epsilon_{\mathrm{hol}}.
]

This gives the desired holonomy separation.

---

# Main Lemma: Compact Sector Separation

## Lemma

Let (K) be a compact subset of the holonomy normed space. Suppose:

1. (U_n\in K) for every (n).
2. (1\notin K).
3. (U\mapsto |1-U|) is continuous.

Then there exists (\delta>0) such that

[
\forall n,\quad
\delta\leq|1-U_n|.
]

## Proof

Define

[
f(U)=|1-U|.
]

Since (f) is continuous and (K) is compact, (f) attains a minimum on (K). Let

[
\delta=\min_{U\in K}f(U).
]

For all (U\in K),

[
\delta\leq f(U)=|1-U|.
]

If (\delta=0), then there exists (U_0\in K) such that

[
|1-U_0|=0.
]

Since the norm is definite,

[
U_0=1.
]

But this contradicts (1\notin K). Therefore,

[
\delta>0.
]

Since (U_n\in K) for every (n),

[
\delta\leq|1-U_n|.
]

---

# What Must Be Proved for the Paper

The compactness lemma itself is elementary.

The real burden is proving that the chosen admissible nontrivial sector (K) satisfies the hypotheses.

We must prove:

1. (K) is compact, or finite-resolution compact.
2. (U_n\in K) for every (n).
3. Identity holonomy (1) is excluded from (K).
4. The sector definition does not already assume a positive energy gap.

---

# Danger Check

The sector condition is safe if it only says:

[
U_n \text{ lies in a nontrivial resolved holonomy class.}
]

It becomes dangerous if it says:

[
U_n \text{ lies in a class with energy at least } \Delta.
]

The latter would write the gap into the proof.

So the sector must be defined topologically, geometrically, or finite-resolution operationally — not energetically.

---

# Relation to Lean

Lean already verifies the implication:

[
\text{compact/nontrivial sector certificate}
\Rightarrow
\text{holonomy separation}.
]

The remaining paper work is to justify the certificate from the actual regulator construction.

A future Lean theorem could formalize the compactness argument abstractly, but this is not urgent. The urgent part is defining (K) correctly in the paper.

---

# Status

Obligation 1 is reduced to defining and proving properties of the nontrivial holonomy sector (K).

Current status: not fully proved.

Risk level: high.

Main open point:

[
\text{What exactly is the admissible nontrivial sector }K?
]

---

# Next Decision

Choose the sector definition:

1. topological sector,
2. Wilson-loop/holonomy sector,
3. finite-resolution sector label,
4. boundary/charge sector,
5. other regulator-specific sector.

Recommendation:

Use a finite-resolution holonomy sector label if it can be defined without energy assumptions.

This best matches the finite-resolution structure and avoids directly assuming a spectral gap.

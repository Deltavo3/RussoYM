# Clay Universal Lower-Bound Definition

## Purpose

This file defines the finite-regulator lower-bound quantity used in the Yang--Mills mass-gap route.

The goal is to avoid confusing an ordinary energy value with a universal lower-bound scale.

The Lean variable currently called

[
\mathrm{Energy}(n)
]

should be interpreted in the paper as

[
\mathrm{Lower}(n).
]

The finite gap comparison obligation should therefore be read as

[
\mathrm{Lower}(n)\leq \mathrm{Gap}(n).
]

---

# Why the Rename Is Necessary

The current Lean obligation is

[
\forall n,\quad
\mathrm{Energy}(n)\leq \mathrm{Gap}(n).
]

This direction is correct only if (\mathrm{Energy}(n)) is a universal lower-bound scale.

If (\mathrm{Energy}(n)) were the infimum over a smaller selected sector, then usually the inequality would go the opposite way:

[
\mathrm{Gap}(n)\leq \mathrm{Energy}(n).
]

Therefore, in the paper, we should write

[
\mathrm{Lower}(n)
]

instead of

[
\mathrm{Energy}(n).
]

---

# Finite-Regulator Gap

For each regulator level (n), define the finite-regulator physical Hilbert space

[
\mathcal H_n.
]

Let

[
H_n:\mathcal H_n\to\mathcal H_n
]

be the regulated Yang--Mills Hamiltonian.

Let (P_n) be the projection onto the finite-regulator vacuum sector.

Define the normalized non-vacuum sector by

[
\mathcal N_n
============

{\psi\in\mathcal H_n:
|\psi|=1,\
P_n\psi=0}.
]

Define the finite-regulator spectral gap by

[
\mathrm{Gap}(n)
===============

\inf_{\psi\in\mathcal N_n}
\langle\psi,H_n\psi\rangle.
]

This definition does not assert that (\mathrm{Gap}(n)) is uniformly positive in (n).

---

# Universal Lower-Bound Quantity

Define (\mathrm{Lower}(n)) to be a number satisfying

[
\forall \psi\in\mathcal N_n,\quad
\mathrm{Lower}(n)
\leq
\langle\psi,H_n\psi\rangle.
]

Then, by taking the infimum over (\mathcal N_n),

[
\mathrm{Lower}(n)\leq \mathrm{Gap}(n).
]

This is the correct interpretation of the Lean comparison

[
\mathrm{Energy}(n)\leq \mathrm{Gap}(n).
]

---

# Candidate Lower Bound From Holonomy Separation

The route developed so far gives:

1. direct holonomy sector separation:
   [
   \delta\leq |1-U_n|;
   ]

2. holonomy-curvature control:
   [
   |1-U_n|\leq C|F_n|_{E,n};
   ]

3. energy-norm coercivity:
   [
   \mathrm{Energy}*{\mathrm{YM},n}=|F_n|*{E,n}^{2}.
   ]

Combining the first two gives

[
\frac{\delta}{C}\leq |F_n|_{E,n}.
]

Squaring gives

[
\left(\frac{\delta}{C}\right)^2
\leq
|F_n|_{E,n}^{2}.
]

Thus the natural lower-bound scale is

[
\mathrm{Lower}(n)
=================

\left(\frac{\delta}{C}\right)^2
]

or, with a coercivity constant (\mu),

[
\mathrm{Lower}(n)
=================

\mu\left(\frac{\delta}{C}\right)^2.
]

Under the energy-norm convention, (\mu=1).

---

# Required Universality

The key remaining proof is not the algebra above.

The key remaining proof is showing that this lower-bound applies to every normalized non-vacuum state in the sector used to define (\mathrm{Gap}(n)).

We need:

[
\forall \psi\in\mathcal N_n,\quad
\mu\left(\frac{\delta}{C}\right)^2
\leq
\langle\psi,H_n\psi\rangle.
]

This is only valid if every normalized non-vacuum state counted by (\mathrm{Gap}(n)) lies in, or decomposes into, the resolved nontrivial holonomy sector where the direct sector separation applies.

---

# Sector Coverage Requirement

There are two possible safe routes.

## Route A: Gap Restricted to the Resolved Nontrivial Sector

Define a sector-specific gap:

[
\mathrm{Gap}*{\lambda**}(n)
===========================

\inf_{\psi\in\mathcal N_{n,\lambda_*}}
\langle\psi,H_n\psi\rangle.
]

Then the proof gives

[
\mathrm{Lower}(n)\leq \mathrm{Gap}*{\lambda**}(n).
]

This is safer and easier, but it proves a sector-specific gap, not necessarily the full Yang--Mills mass gap.

## Route B: Non-Vacuum Sector Covered by Resolved Nontrivial Sectors

Show that every non-vacuum state belongs to a resolved nontrivial holonomy sector with a uniform lower-bound constant.

Then the proof gives the full finite-regulator comparison

[
\mathrm{Lower}(n)\leq \mathrm{Gap}(n).
]

This is stronger, but harder.

---

# Main Danger

The current direct sector condition proves separation only inside a chosen sector.

It does not automatically prove a lower bound for every non-vacuum excitation.

Therefore, the paper must decide whether the theorem is:

1. a sector-specific finite gap theorem; or
2. a full finite-regulator Yang--Mills gap theorem.

For the full theorem, we must prove sector coverage.

---

# Paper Lemma

## Lemma: Universal Lower Bound Implies Finite Gap Comparison

Let

[
\mathcal N_n
============

{\psi\in\mathcal H_n:
|\psi|=1,\
P_n\psi=0}.
]

Let

[
\mathrm{Gap}(n)
===============

\inf_{\psi\in\mathcal N_n}
\langle\psi,H_n\psi\rangle.
]

If

[
\forall\psi\in\mathcal N_n,\quad
\mathrm{Lower}(n)
\leq
\langle\psi,H_n\psi\rangle,
]

then

[
\mathrm{Lower}(n)\leq \mathrm{Gap}(n).
]

---

# Status

The finite gap comparison is reduced to a sector-coverage question.

Known:

[
\text{direct sector separation}
+
\text{holonomy-curvature control}
+
\text{energy-norm coercivity}
\Rightarrow
\text{lower bound inside the resolved nontrivial sector}.
]

Still needed:

[
\text{resolved nontrivial sector lower bound}
\Rightarrow
\text{universal non-vacuum lower bound}.
]

---

# Risk Assessment

Risk level: high.

The proof is safe only if we either:

1. explicitly state a sector-specific gap theorem; or
2. prove sector coverage for all non-vacuum excitations.

We must not silently replace a sector-specific lower bound with a full spectral gap.

---

# Next Decision

Decide whether Paper 1 states:

[
\mathrm{Gap}*{\lambda**}(n)>0
]

for a fixed resolved nontrivial sector, or whether it claims the full finite-regulator gap.

Recommendation:

Proceed first with a sector-specific theorem.

Then separately prove or formulate the sector-coverage theorem needed for the full Clay claim.

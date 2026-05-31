# Clay Finite Gap Lower Comparison Lemma

## Purpose

This file develops the paper-level proof of remaining obligation 4:

[
\forall n,\quad
\mathrm{Energy}(n)\leq \mathrm{Gap}(n).
]

This is one of the dangerous points in the proof, because if (\mathrm{Gap}(n)) is defined incorrectly, the proof may accidentally write the desired mass gap into the assumptions.

The goal is to define (\mathrm{Gap}(n)) independently and prove the comparison from the regulated spectral setup.

---

# Safety Rule

This lemma may use:

1. the finite-dimensional regulated Hilbert space at level (n);
2. the regulated Yang--Mills Hamiltonian (H_n);
3. the definition of the finite-regulator spectral gap;
4. the variational principle / Rayleigh quotient;
5. nonnegativity of the regulated energy.

This lemma may not use:

1. a continuum mass gap;
2. confinement;
3. a uniform positive lower bound independent of (n);
4. continuum survival;
5. any claim that (\inf_n \mathrm{Gap}(n)>0).

---

# Required Definitions

For each regulator level (n), define:

[
\mathcal H_n
]

as the finite-regulator physical Hilbert space.

Let

[
H_n:\mathcal H_n\to\mathcal H_n
]

be the regulated Yang--Mills Hamiltonian.

Let the vacuum sector be represented by the kernel or ground state sector of (H_n).

Define the finite-regulator gap independently by

[
\mathrm{Gap}(n)
===============

\inf\left{
\langle \psi,H_n\psi\rangle:
\psi\in\mathcal H_n,\
|\psi|=1,\
\psi\perp \mathrm{Vac}_n
\right}.
]

This definition is safe because it does not assert that (\mathrm{Gap}(n)) is uniformly positive in (n). It only defines the finite-regulator excitation threshold.

---

# Comparison Target

The Lean roadmap currently uses an auxiliary quantity

[
\mathrm{Energy}(n).
]

The required comparison is:

[
\mathrm{Energy}(n)\leq \mathrm{Gap}(n).
]

This means (\mathrm{Energy}(n)) must be a proven lower bound for every normalized non-vacuum excitation at level (n).

So the safe route is not to define (\mathrm{Energy}(n)) as the energy of one arbitrary configuration.

Instead, define (\mathrm{Energy}(n)) as a finite-regulator lower-bound functional:

[
\mathrm{Energy}(n)
==================

\inf\left{
E_n(\psi):
\psi\in\mathcal H_n,\
|\psi|=1,\
\psi\perp \mathrm{Vac}_n,\
\psi\in \mathcal S_n
\right},
]

where (\mathcal S_n) is the admissible nontrivial sector under consideration.

Then prove that the sector used for the gap comparison is contained in the non-vacuum excitation sector.

---

# Safe Lemma Form

## Lemma: Finite Gap Dominates Sector Energy Lower Bound

Assume:

1. (\mathcal S_n\subseteq {\psi:\psi\perp\mathrm{Vac}_n}).
2. Every (\psi\in\mathcal S_n) is normalized or is normalized before evaluation.
3. (E_n(\psi)=\langle\psi,H_n\psi\rangle).
4. (\mathrm{Energy}(n)) is the infimum of (E_n) over (\mathcal S_n).
5. (\mathrm{Gap}(n)) is the infimum of (E_n) over all normalized non-vacuum states.

Then, because (\mathcal S_n) is a subset of the non-vacuum sector, the direction of the inequality must be checked carefully.

If (\mathcal S_n\subseteq\text{NonVacuum}_n), then

[
\inf_{\psi\in\text{NonVacuum}*n} E_n(\psi)
\leq
\inf*{\psi\in\mathcal S_n} E_n(\psi).
]

That gives

[
\mathrm{Gap}(n)\leq \mathrm{Energy}(n),
]

which is the opposite of the current Lean obligation.

Therefore, the current Lean direction

[
\mathrm{Energy}(n)\leq \mathrm{Gap}(n)
]

means (\mathrm{Energy}(n)) should not be the infimum over a smaller sector unless that sector is the full non-vacuum sector.

Instead, (\mathrm{Energy}(n)) must be a universal lower-bound quantity satisfying

[
\mathrm{Energy}(n)\leq E_n(\psi)
]

for every normalized non-vacuum (\psi). Then taking the infimum gives

[
\mathrm{Energy}(n)\leq \mathrm{Gap}(n).
]

---

# Correct Interpretation

The safe interpretation is:

[
\mathrm{Energy}(n)
]

is not a selected energy level and not the infimum over a smaller sector.

It is a proven universal finite-regulator lower-bound expression, such as

[
\mu(\mathrm{curvatureNorm}(n))^2
]

or

[
\mu\left(\frac{\delta}{C}\right)^2.
]

Then the finite gap lower comparison is valid if we prove:

[
\forall \psi\perp\mathrm{Vac}_n,\quad
\mathrm{Energy}(n)\leq
\langle\psi,H_n\psi\rangle.
]

Taking the infimum over normalized non-vacuum states gives:

[
\mathrm{Energy}(n)\leq\mathrm{Gap}(n).
]

---

# Main Danger

The comparison

[
\mathrm{Energy}(n)\leq\mathrm{Gap}(n)
]

is not automatic.

It requires (\mathrm{Energy}(n)) to be a lower bound on the whole non-vacuum sector.

If (\mathrm{Energy}(n)) is only a lower bound on a selected nontrivial sector, then this comparison may fail unless that sector is exactly the sector defining the gap.

---

# Possible Fix

To avoid ambiguity, rename the auxiliary quantity in the paper:

[
\mathrm{Lower}(n)
]

instead of

[
\mathrm{Energy}(n).
]

Then the obligation becomes:

[
\forall n,\quad
\mathrm{Lower}(n)\leq\mathrm{Gap}(n).
]

This is clearer because (\mathrm{Lower}(n)) is explicitly a lower-bound quantity, not an energy of a particular state.

The Lean variable can remain `Energy` for now, but the paper should explain that it represents a lower-bound energy scale, not an arbitrary energy eigenvalue.

---

# Paper Lemma

## Lemma: Universal Lower Bound Implies Finite Gap Lower Comparison

For each (n), let

[
\mathrm{Gap}(n)
===============

\inf\left{
\langle \psi,H_n\psi\rangle:
|\psi|=1,\
\psi\perp \mathrm{Vac}_n
\right}.
]

Suppose there exists a real number (\mathrm{Lower}(n)) such that for every normalized non-vacuum state (\psi),

[
\mathrm{Lower}(n)
\leq
\langle\psi,H_n\psi\rangle.
]

Then

[
\mathrm{Lower}(n)\leq\mathrm{Gap}(n).
]

Thus the Lean obligation

[
\mathrm{Energy}(n)\leq\mathrm{Gap}(n)
]

is valid if `Energy n` is interpreted as (\mathrm{Lower}(n)).

---

# Status

Obligation 4 is not yet proved.

It is reduced to proving that the finite-regulator lower-bound expression derived from holonomy separation and curvature coercivity applies to every normalized non-vacuum excitation in the sector used to define (\mathrm{Gap}(n)).

---

# Risk Assessment

Risk level: high.

This is a possible proof-direction issue.

We must verify that the Lean variable `Energy` is being used as a universal lower-bound scale, not as an energy value over a smaller sector.

---

# Next Decision

Decide whether to rename the paper quantity:

[
\mathrm{Energy}(n)
\quad\leadsto\quad
\mathrm{Lower}(n)
]

in the exposition.

Recommendation:

Use `Lower(n)` in the paper and keep `Energy` in Lean only as a legacy variable name.

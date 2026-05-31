# Clay Direct Holonomy Sector Choice

## Purpose

This file records the preferred direct version of the finite-resolution holonomy sector.

Instead of defining a larger holonomy tuple \(V_n\) and then proving a separate product-comparison estimate

\[
\|1-U_n\|\geq c_{\mathrm{prod}}r(V_n),
\]

we choose the resolved holonomy observable itself to be

\[
U_n=(\mathrm{links}\ n).\mathrm{prod}.
\]

Then the finite-resolution nontrivial sector is defined directly by the distance of \(U_n\) from identity.

---

# Direct Sector Definition

Let \(G\) be the compact gauge group or regulated holonomy normed space.

For each regulator level \(n\), define

\[
U_n=(\mathrm{links}\ n).\mathrm{prod}.
\]

Choose a finite holonomy resolution threshold

\[
\epsilon_{\mathrm{hol}}>0.
\]

Define the resolved identity sector by

\[
K_{\mathrm{id}}
=
\{U\in G:\|1-U\|\leq \epsilon_{\mathrm{hol}}\}.
\]

Define the resolved nontrivial sector by

\[
K_*
=
\{U\in G:\|1-U\|\geq 2\epsilon_{\mathrm{hol}}\}.
\]

The buffer region

\[
\epsilon_{\mathrm{hol}}<\|1-U\|<2\epsilon_{\mathrm{hol}}
\]

is left unresolved.

---

# Sector Membership Assumption

The nontrivial-sector assumption is

\[
U_n\in K_*
\]

for all \(n\).

Equivalently,

\[
\|1-U_n\|\geq 2\epsilon_{\mathrm{hol}}
\]

for all \(n\).

This is a finite-resolution sector selection. It does not say that the state has positive energy. It only says that the resolved holonomy observable is distinguishable from identity at the chosen holonomy resolution.

---

# Immediate Separation

If

\[
U_n\in K_*
\]

for all \(n\), then

\[
2\epsilon_{\mathrm{hol}}\leq \|1-U_n\|
\]

for all \(n\).

Therefore the holonomy separation obligation holds with

\[
\delta=2\epsilon_{\mathrm{hol}}.
\]

Since

\[
\epsilon_{\mathrm{hol}}>0,
\]

we have

\[
\delta>0.
\]

---

# Why This Is Safer

This avoids needing an extra comparison theorem between a larger holonomy tuple distance and the product holonomy distance.

The proof becomes direct:

\[
\text{resolved nontrivial holonomy sector}
\Rightarrow
\text{uniform holonomy separation}.
\]

The remaining issue is not algebraic. The remaining issue is justifying that the regulator sequence is legitimately being studied inside a fixed resolved nontrivial holonomy sector.

---

# Does This Assume the Gap?

No.

The condition

\[
\|1-U_n\|\geq 2\epsilon_{\mathrm{hol}}
\]

is a holonomy-resolution condition, not an energy condition.

It becomes dangerous only if \(\epsilon_{\mathrm{hol}}\) is chosen from an energy lower bound. We do not do that.

Instead, \(\epsilon_{\mathrm{hol}}\) is part of the finite-resolution holonomy measurement structure.

---

# Relation to Lean

The current Lean holonomy separation obligation is:

\[
\exists\delta>0,\quad
\forall n,\quad
\delta\leq\|1-(\mathrm{links}\ n).\mathrm{prod}\|.
\]

The direct sector choice proves this immediately from the sector condition with:

\[
\delta=2\epsilon_{\mathrm{hol}}.
\]

A future Lean lemma could formalize this as:

```lean
theorem holonomy_separation_of_direct_sector
    {eps : Real}
    (heps : 0 < eps)
    (hsector : forall n, 2 * eps <= ‖1 - (links n).prod‖) :
    ClayHolonomySeparationExistenceAssumptions links
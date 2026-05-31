# Clay Holonomy-Curvature Control Proof Plan

## Purpose

This file turns the holonomy-curvature control audit into a concrete proof plan.

The current remaining obligation is:

\[
\exists C>0,\quad
\forall n,\quad
\|1-U_n\|
\leq
C\|F_n\|_{E,n}.
\]

Here

\[
U_n=(\mathrm{links}\ n).\mathrm{prod}
\]

and

\[
\|F_n\|_{E,n}
\]

is the regulated Yang--Mills energy norm.

---

# Desired Lemma

## Uniform Holonomy-Curvature Control in Energy Norm

Assume for every regulator level \(n\):

1. \(U_n\) is the holonomy around a resolved loop or plaquette \(\gamma_n\).
2. \(\gamma_n\) bounds a resolved surface \(\Sigma_n\).
3. The local holonomy estimate holds:

   \[
   \|1-U_n\|
   \leq
   C_{\mathrm{loc}}
   \int_{\Sigma_n}|F_n|.
   \]

4. The areas are uniformly bounded:

   \[
   |\Sigma_n|\leq A_{\max}.
   \]

5. Local curvature is controlled by the global energy norm:

   \[
   \|F_n\|_{L^2(\Sigma_n)}
   \leq
   \|F_n\|_{E,n}.
   \]

Then

\[
\|1-U_n\|
\leq
C_{\mathrm{loc}}A_{\max}^{1/2}\|F_n\|_{E,n}.
\]

Therefore the holonomy-curvature control obligation holds with

\[
C=C_{\mathrm{loc}}A_{\max}^{1/2}.
\]

---

# Proof

Starting from the local holonomy estimate,

\[
\|1-U_n\|
\leq
C_{\mathrm{loc}}
\int_{\Sigma_n}|F_n|.
\]

By Cauchy--Schwarz,

\[
\int_{\Sigma_n}|F_n|
\leq
|\Sigma_n|^{1/2}\|F_n\|_{L^2(\Sigma_n)}.
\]

By the uniform area bound,

\[
|\Sigma_n|^{1/2}\leq A_{\max}^{1/2}.
\]

By local-to-global energy comparison,

\[
\|F_n\|_{L^2(\Sigma_n)}
\leq
\|F_n\|_{E,n}.
\]

Combining,

\[
\|1-U_n\|
\leq
C_{\mathrm{loc}}A_{\max}^{1/2}\|F_n\|_{E,n}.
\]

Let

\[
C=C_{\mathrm{loc}}A_{\max}^{1/2}.
\]

If \(C_{\mathrm{loc}}>0\) and \(A_{\max}>0\), then \(C>0\).

---

# Three Sublemmas Needed

## Sublemma 1: Local Holonomy Estimate

\[
\|1-U_n\|
\leq
C_{\mathrm{loc}}
\int_{\Sigma_n}|F_n|.
\]

This is the main geometric estimate.

It must be proved from holonomy/curvature geometry, not from an energy gap.

Possible sources:

1. nonabelian Stokes estimate;
2. path-ordered exponential variation estimate;
3. lattice plaquette expansion estimate;
4. Wilson-loop curvature flux estimate.

---

## Sublemma 2: Uniform Regulator Area Bound

\[
|\Sigma_n|\leq A_{\max}.
\]

This is a regulator-geometry condition.

It should follow from the finite family of resolved test loops/plaquettes or from the fixed finite-resolution observation scale.

Important: \(A_{\max}\) must be independent of \(n\).

---

## Sublemma 3: Local-to-Global Energy Comparison

\[
\|F_n\|_{L^2(\Sigma_n)}
\leq
\|F_n\|_{E,n}.
\]

This should be definition-level if the energy norm is global \(L^2\)-type curvature norm and \(\Sigma_n\) is a subregion of the regulated domain.

---

# Lean Relevance

Lean should not try to prove the geometric local holonomy estimate yet.

Lean can verify the algebraic packaging:

If

\[
\|1-U_n\|\leq C_{\mathrm{loc}}\operatorname{FluxNorm}(n),
\]

\[
\operatorname{FluxNorm}(n)\leq A_{\max}^{1/2}\operatorname{EnergyNorm}(n),
\]

and

\[
C=C_{\mathrm{loc}}A_{\max}^{1/2},
\]

then

\[
\|1-U_n\|\leq C\operatorname{EnergyNorm}(n).
\]

But the geometric estimate itself should be paper-first.

---

# Updated Status

Obligation 2 is reduced to:

1. a local holonomy estimate;
2. a uniform area bound;
3. local-to-global energy comparison.

Risk level: medium.

Main remaining mathematical task:

Prove or properly cite a local holonomy-curvature estimate that does not assume any spectral gap.
# Clay Block-RG Conditional Master Theorem

## Purpose

This document records the current Yang--Mills Clay proof architecture.

The goal is to separate:

1. finite-dimensional/probability lemmas that are structurally closed;
2. continuum-survival lemmas;
3. genuinely open analytic Yang--Mills / constructive RG pillars.

This file does not claim the Clay theorem is finished. It records the conditional theorem:

\[
\text{local block positivity + Dobrushin tensorization + Mosco/vacuum convergence}
\Longrightarrow
\Delta_{\mathrm{YM}}>0.
\]

The proof is standard-Yang--Mills-facing. The Action Tax language is only bookkeeping for the exact projected/RG action contribution from unresolved Yang--Mills modes. It is not an added physical energy term.

---

# 1. Main conditional theorem

Let \(G\) be a compact simple gauge group.

Let \(a_n\to0\) be a regulator sequence, with bare coupling tuned so that

\[
\Lambda_{\mathrm{YM}}>0
\]

is fixed.

Let \(H_n^{\mathrm{phys}}\) be the finite-regulator physical Yang--Mills Hamiltonian, with vacuum projection \(P_n\).

Let \(H_{\mathrm{YM}}\) be the reconstructed continuum Yang--Mills Hamiltonian, with vacuum projection \(P\).

The target is:

\[
H_{\mathrm{YM}}
\geq
m(I-P)
\]

for some

\[
m>0.
\]

Equivalently,

\[
\Delta_{\mathrm{YM}}\geq m>0.
\]

---

# 2. Block kernel positivity

Fix physical block size

\[
\ell=K\Lambda_{\mathrm{YM}}^{-1}.
\]

Let \(X_B\) be the compact coarse block holonomy space.

Let

\[
K_{\ell,n}^{\mathrm{ren}}(U,dV)
\]

be the exact renormalized Yang--Mills block kernel.

Assume the block kernel satisfies a reference-measure minorization:

\[
K_{\ell,n}^{\mathrm{ren}}(U,dV)
\geq
\alpha_\mu\mu_B(dV),
\]

where \(\mu_B\) is the normalized reference/Haar block measure and

\[
\alpha_\mu>0
\]

is independent of the microscopic regulator.

Assume the block equilibrium measure satisfies

\[
d\nu_B=\rho_Bd\mu_B,
\]

with

\[
0<m_B\leq \rho_B\leq M_B<\infty.
\]

Then

\[
\mu_B(dV)\geq \frac{1}{M_B}\nu_B(dV).
\]

Therefore,

\[
K_{\ell,n}^{\mathrm{ren}}(U,dV)
\geq
\frac{\alpha_\mu}{M_B}\nu_B(dV).
\]

Define

\[
\alpha_B=\frac{\alpha_\mu}{M_B}>0.
\]

Then

\[
K_{\ell,n}^{\mathrm{ren}}(U,dV)
\geq
\alpha_B\nu_B(dV).
\]

This is the true Doeblin minorization relative to the actual block equilibrium measure.

---

# 3. Minorization implies block Poincare

Assume

\[
K_B(x,dy)\geq \alpha_B\nu_B(dy).
\]

Then

\[
K_B(x,dy)
=
\alpha_B\nu_B(dy)
+
(1-\alpha_B)\widetilde K_B(x,dy)
\]

for another Markov kernel \(\widetilde K_B\).

For every mean-zero block function \(f\),

\[
\int f\,d\nu_B=0,
\]

so

\[
K_Bf=(1-\alpha_B)\widetilde K_Bf.
\]

Thus

\[
\|K_Bf\|_{L^2(\nu_B)}
\leq
(1-\alpha_B)\|f\|_{L^2(\nu_B)}.
\]

If

\[
K_B=e^{-\tau_BH_B},
\]

then

\[
e^{-\tau_B\gamma_B}
\leq
1-\alpha_B.
\]

Hence

\[
\gamma_B
\geq
-\frac{1}{\tau_B}\log(1-\alpha_B).
\]

With

\[
\tau_B\sim K\Lambda_{\mathrm{YM}}^{-1},
\]

we get

\[
\gamma_B
\geq
c_K\Lambda_{\mathrm{YM}},
\]

where

\[
c_K=
\frac{-\log(1-\alpha_B)}{K}>0.
\]

Therefore each block satisfies

\[
\operatorname{Var}_{B_i}(f)
\leq
\frac{1}{c_K\Lambda_{\mathrm{YM}}}
\mathcal E_{i,n}(f,f).
\]

This step is structurally closed.

---

# 4. Dobrushin perturbation estimate

Assume the renormalized block action has an interaction expansion

\[
S_{\mathrm{eff}}^{(K)}
=
\sum_X\Phi_X.
\]

The conditional law in block \(i\) depends on outside data through the terms \(X\ni i\).

If two outside configurations differ only at block \(j\), then the only changing terms satisfy

\[
X\ni i,j.
\]

Define

\[
\Delta_{ij}
=
\sum_{X\ni i,j}
\|\Phi_X\|_{\mathrm{osc}}.
\]

Then the conditional densities differ by at most an exponential factor controlled by \(\Delta_{ij}\), so

\[
\mathsf C_{ij}
\leq
C
\sum_{X\ni i,j}
\|\Phi_X\|_{\mathrm{osc}}.
\]

Summing over \(j\neq i\),

\[
\sum_{j\neq i}\mathsf C_{ij}
\leq
C
\sum_{X\ni i}
|X|
\|\Phi_X\|_{\mathrm{osc}}.
\]

Therefore, if

\[
\sup_i
\sum_{X\ni i}
|X|
\|\Phi_X\|_{\mathrm{osc}}
\leq
\varepsilon_K
\]

and

\[
C\varepsilon_K<1,
\]

then Dobrushin weak dependence holds:

\[
\sup_i\sum_{j\neq i}\mathsf C_{ij}<1.
\]

This finite-dimensional probability step is structurally closed.

---

# 5. Exponential influence bound implies Dobrushin

A sufficient influence estimate is

\[
\mathsf C_{ij}
\leq
\frac{C}{K}e^{-c\,d(i,j)}.
\]

Then

\[
\sum_{j\neq i}\mathsf C_{ij}
\leq
\frac{C}{K}
\sum_{j\neq i}e^{-c\,d(i,j)}.
\]

Grouping by distance \(r\), with \(N(r)\lesssim r^{d-1}\),

\[
\sum_{j\neq i}e^{-c\,d(i,j)}
\leq
\sum_{r\geq1}C_dr^{d-1}e^{-cr}
=
C_{\mathrm{sum}}<\infty.
\]

Thus

\[
\sup_i\sum_{j\neq i}\mathsf C_{ij}
\leq
\frac{CC_{\mathrm{sum}}}{K}.
\]

For \(K>CC_{\mathrm{sum}}\),

\[
\sup_i\sum_{j\neq i}\mathsf C_{ij}<1.
\]

So Dobrushin holds.

This step is structurally closed once the Yang--Mills block influence estimate is proved.

---

# 6. Approximate tensorization

Dobrushin weak dependence implies approximate tensorization:

\[
\operatorname{Var}_{\nu_n}(f)
\leq
C_{\mathrm{AT}}
\sum_i
\mathbb E_{\nu_n}
[
\operatorname{Var}_{B_i}(f)
],
\]

with

\[
C_{\mathrm{AT}}
\leq
\frac{1}{1-\theta}
\]

where

\[
\theta=\sup_i\sum_{j\neq i}\mathsf C_{ij}<1.
\]

---

# 7. Bounded-overlap energy comparison

Assume the global Dirichlet form decomposes into nonnegative local pieces:

\[
\mathcal E_n(f,f)
=
\sum_{d\in\mathcal D_n}
\mathcal E_{d,n}(f,f).
\]

For each block \(B_i\), let

\[
\mathcal E_{i,n}(f,f)
=
\sum_{d\in\mathcal D_n(i)}
\mathcal E_{d,n}(f,f).
\]

Assume each local degree belongs to at most \(C_{\mathrm{ov}}\) block collars:

\[
\#\{i:d\in\mathcal D_n(i)\}
\leq
C_{\mathrm{ov}}.
\]

Then

\[
\sum_i\mathcal E_{i,n}(f,f)
\leq
C_{\mathrm{ov}}\mathcal E_n(f,f).
\]

With expectation,

\[
\sum_i
\mathbb E_{\nu_n}
[
\mathcal E_{i,n}(f,f)
]
\leq
C_{\mathrm{ov}}\mathcal E_n(f,f).
\]

This step is closed.

---

# 8. Global finite-regulator Poincare inequality

Start with approximate tensorization:

\[
\operatorname{Var}_{\nu_n}(f)
\leq
C_{\mathrm{AT}}
\sum_i
\mathbb E_{\nu_n}
[
\operatorname{Var}_{B_i}(f)
].
\]

Apply block Poincare:

\[
\operatorname{Var}_{B_i}(f)
\leq
\frac{1}{c_K\Lambda_{\mathrm{YM}}}
\mathcal E_{i,n}(f,f).
\]

Then

\[
\operatorname{Var}_{\nu_n}(f)
\leq
\frac{C_{\mathrm{AT}}}{c_K\Lambda_{\mathrm{YM}}}
\sum_i
\mathbb E_{\nu_n}
[
\mathcal E_{i,n}(f,f)
].
\]

Use bounded overlap:

\[
\sum_i
\mathbb E_{\nu_n}
[
\mathcal E_{i,n}(f,f)
]
\leq
C_{\mathrm{ov}}\mathcal E_n(f,f).
\]

Thus

\[
\operatorname{Var}_{\nu_n}(f)
\leq
\frac{C_{\mathrm{AT}}C_{\mathrm{ov}}}
{c_K\Lambda_{\mathrm{YM}}}
\mathcal E_n(f,f).
\]

Rearrange:

\[
\mathcal E_n(f,f)
\geq
\frac{c_K}{C_{\mathrm{AT}}C_{\mathrm{ov}}}
\Lambda_{\mathrm{YM}}
\operatorname{Var}_{\nu_n}(f).
\]

Define

\[
c_\ast=
\frac{c_K}{C_{\mathrm{AT}}C_{\mathrm{ov}}}>0.
\]

Then

\[
\mathcal E_n(f,f)
\geq
c_\ast\Lambda_{\mathrm{YM}}
\operatorname{Var}_{\nu_n}(f).
\]

For \(f\perp\operatorname{Ran}(P_n)\),

\[
\operatorname{Var}_{\nu_n}(f)=\|f\|^2.
\]

Therefore

\[
H_n^{\mathrm{phys}}
\geq
c_\ast\Lambda_{\mathrm{YM}}(I-P_n).
\]

So

\[
\Delta_n^{\mathrm{phys}}
\geq
c_\ast\Lambda_{\mathrm{YM}}>0.
\]

This global finite-regulator step is closed once block Poincare and Dobrushin are available.

---

# 9. Continuum survival

Assume

\[
Q_n\xrightarrow{\mathrm{Mosco}}Q_{\mathrm{YM}}
\]

and

\[
P_n\to P.
\]

Then

\[
H_n^{\mathrm{phys}}
\geq
c_\ast\Lambda_{\mathrm{YM}}(I-P_n)
\]

passes to

\[
H_{\mathrm{YM}}
\geq
c_\ast\Lambda_{\mathrm{YM}}(I-P).
\]

Therefore

\[
\Delta_{\mathrm{YM}}
\geq
c_\ast\Lambda_{\mathrm{YM}}>0.
\]

---

# 10. Continuum bridge decomposition

## F1. Mosco liminf

Need

\[
Q_{\mathrm{YM}}(\psi)
\leq
\liminf_n Q_n(\psi_n).
\]

Reduced to:

1. lattice-to-continuum energy consistency;
2. gauge compactness for bounded curvature energy;
3. weak lower semicontinuity.

## F2. Mosco recovery

Need finite-regulator approximations \((A_n,E_n)\) for every continuum finite-energy Gauss-law configuration \((A,E)\), with

\[
Q_n(A_n,E_n)\to Q_{\mathrm{YM}}(A,E).
\]

Reduced to:

1. density of smooth Gauss-law data;
2. holonomy discretization of \(A\);
3. electric flux/cell-average discretization of \(E\);
4. vanishing-energy correction enforcing exact discrete Gauss law.

## F3. Vacuum projection convergence

Need

\[
P_n\to P.
\]

This follows from zero-energy rigidity:

Finite regulator:

\[
Q_n=0
\Rightarrow
E_n=0,\quad U_p=1
\Rightarrow
\text{flat lattice connection}
\Rightarrow
\text{gauge-trivial vacuum}.
\]

Continuum:

\[
Q_{\mathrm{YM}}=0
\Rightarrow
E=0,\quad F_A=0
\Rightarrow
\text{flat finite-energy connection}
\Rightarrow
\text{gauge-trivial vacuum}
\]

in the chosen trivial sector.

This is not a mass-gap assumption.

---

# 11. Genuinely open analytic pillars

The finite-dimensional/probability skeleton is now mostly closed.

The genuinely hard remaining analytic work is:

## A. Fixed-scale local Wilson/block continuum construction

Need unique limits:

\[
\lim_{n\to\infty}
\langle W_{\gamma_1}\cdots W_{\gamma_r}\rangle_n.
\]

## B. Fixed-scale block kernel convergence and positivity

Need

\[
K_{\ell,n}^{\mathrm{ren}}
\to
K_\ell^{\mathrm{ren}}
\quad
\text{in }C^1
\]

and

\[
K_\ell^{\mathrm{ren}}(U,V)>0.
\]

## C. Renormalized block potential regularity

Need

\[
\|V_{\ell,n}^{\mathrm{ren}}\|_{C^2(X_B)}
\leq
C_K.
\]

## D. \(C^2\) RG irrelevance of regulator remainders

Need

\[
\|R_{\ell,n}\|_{C_\theta^2L_y^\infty}\to0.
\]

## E. Boundary-local and quasi-local exact block RG action

Need

\[
\mathsf C_{ij}
\leq
\frac{C}{K}e^{-c\,d(i,j)}.
\]

Equivalent target:

\[
\sup_i
\sum_{X\ni i}
|X|\|\Phi_X\|_{\mathrm{osc}}
\leq
\frac{C}{K}
\]

for large \(K\).

## F. Mosco liminf and recovery

Need full proof of

\[
Q_n\xrightarrow{\mathrm{Mosco}}Q_{\mathrm{YM}}.
\]

---

# 12. Current status

Closed / structurally solved:

```text
1. bounded-overlap energy comparison;
2. minorization implies block Poincare;
3. Dobrushin perturbation estimate;
4. exponential influence bound implies Dobrushin;
5. approximate tensorization plus block Poincare implies global finite-regulator Poincare;
6. zero-energy rigidity route for vacuum convergence.
```
Still open analytic pillars:

A. local continuum Wilson/block construction;
B. block kernel convergence and positivity;
C. renormalized block potential C^2 regularity;
D. C^2 RG irrelevance;
E. quasi-local/boundary-local RG influence estimate;
F. Mosco liminf and recovery.

The conditional theorem is now:

A--F
=>
H_YM >= c_* Lambda_YM (I - P)
=>
Delta_YM > 0.


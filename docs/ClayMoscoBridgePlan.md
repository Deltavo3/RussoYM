# Clay Mosco Bridge Plan

## Purpose

This file records Master II of the Clay-facing Yang--Mills mass gap route.

Master II is the Mosco continuum bridge:

Q_n -> Q_YM in the Mosco sense

and

P_n -> P.

Its purpose is to transfer the finite-regulator lower bound

H_n^phys >= c_* Lambda_YM (I - P_n)

to the continuum bound

H_YM >= c_* Lambda_YM (I - P).

Therefore, once Master I gives the finite-regulator gap, Master II makes the gap survive the continuum limit.

---

# 1. Master II statement

Let Q_n be the finite-regulator Yang--Mills quadratic form.

Let Q_YM be the continuum Yang--Mills quadratic form.

Let P_n be the finite-regulator vacuum projection.

Let P be the continuum vacuum projection.

Master II requires:

1. Mosco liminf;
2. Mosco recovery;
3. vacuum projection convergence.

Together:

Q_n -> Q_YM in the Mosco sense

and

P_n -> P.

Then the lower bound transfers:

H_n^phys >= c_* Lambda_YM (I - P_n)

implies

H_YM >= c_* Lambda_YM (I - P).

Thus:

Delta_YM >= c_* Lambda_YM > 0.

---

# 2. F1: Mosco liminf

## Target

If psi_n converges weakly to psi, prove:

Q_YM(psi) <= liminf Q_n(psi_n).

For Yang--Mills initial data, this means:

If finite-regulator physical configurations (A_n,E_n) have bounded energy and converge weakly after gauge fixing, then the continuum limit (A,E) satisfies:

Q_YM(A,E) <= liminf Q_n(A_n,E_n).

Also, the continuum limit must satisfy Gauss law:

D_A E = 0.

---

## F1.a Electric lower semicontinuity

Assume interpolated electric fields satisfy:

E_n -> E weakly in L^2_loc.

Then weak lower semicontinuity gives:

||E||_L2^2 <= liminf ||E_n||_L2^2.

Therefore:

Q_E,YM(E) <= liminf Q_E,n(E_n).

This part is structurally standard once interpolation is energy-consistent.

---

## F1.b Magnetic lower semicontinuity

Assume bounded magnetic energy:

sup_n Q_B,n(A_n) < infinity.

The magnetic energy is built from plaquette holonomies:

Q_B,n(A_n) roughly equals sum_p a_n^3 dist_G(U_p,1)^2 / a_n^4.

The target is to extract a continuum connection A such that:

F_n -> F_A weakly in L^2_loc,

and

int |F_A|^2 <= liminf Q_B,n(A_n).

The key analytic tool is lattice Uhlenbeck compactness.

---

## F1.c Lattice Uhlenbeck compactness

Needed theorem:

Bounded plaquette energy implies that, after lattice gauge transformations and interpolation, a subsequence satisfies:

A_n^g -> A weakly in a local Sobolev topology,

and

F_{A_n^g} -> F_A weakly in L^2_loc.

The local version should say:

On cubes with sufficiently small plaquette energy, choose a lattice Coulomb/Uhlenbeck gauge so that the link variables can be written as

U_e^g = exp(a_n A_{e,n})

with a uniform W^{1,2}-type estimate:

||A_n||_{W^{1,2}(Q)} <= C ||F_n||_{L^2(Q)}.

Bad cubes may carry concentration energy. This is allowed for liminf because concentration produces a nonnegative defect measure.

---

## F1.d Defect measure formulation

From bounded magnetic energy, extract measures:

|F_n|^2 dx -> mu

weakly as Radon measures.

On good regions, gauge compactness identifies the weak curvature limit as F_A.

Then:

mu >= |F_A|^2 dx.

The difference

mu - |F_A|^2 dx

is a nonnegative defect measure.

Therefore:

int |F_A|^2 dx <= mu(total) <= liminf Q_B,n(A_n).

This proves magnetic liminf even if curvature energy concentrates.

---

## F1.e Curvature identification

After local gauge fixing and interpolation, prove:

F_n -> F_A

in distributions, where

F_A = dA + A wedge A.

The nonlinear term is controlled because in three dimensions:

W^{1,2}_loc embeds compactly into L^p_loc for p < 6.

Thus A_n -> A strongly in L^p_loc for p < 6, which is enough to pass the quadratic term A_n wedge A_n to A wedge A distributionally.

---

## F1.f Gauss-law passage

Finite-regulator physical states satisfy exact discrete Gauss law:

G_n(A_n) E_n = 0.

For every smooth compactly supported gauge parameter phi, sample phi on the lattice as phi_n.

Discrete weak Gauss law gives:

<E_n, G_n(A_n)^* phi_n>_n = 0.

If:

E_n -> E weakly in L^2_loc

and

G_n(A_n)^* phi_n -> D_A^* phi strongly in L^2_loc,

then passing to the limit gives:

<E, D_A^* phi> = 0.

Therefore:

D_A E = 0

in distributions.

This shows weak limits of exact physical lattice states are continuum physical states.

---

## F1 summary

Mosco liminf follows from:

1. energy-consistent interpolation;
2. electric weak lower semicontinuity;
3. lattice Uhlenbeck compactness;
4. curvature identification;
5. defect measure control;
6. Gauss-law passage.

The central hard theorem is lattice Uhlenbeck compactness from bounded plaquette energy.

---

# 3. F2: Mosco recovery

## Target

For every finite-energy continuum physical state psi, construct finite-regulator physical states psi_n such that:

psi_n -> psi strongly

and

Q_n(psi_n) -> Q_YM(psi).

For Yang--Mills data, this means:

Given finite-energy (A,E) satisfying D_A E = 0, construct lattice data (A_n,E_n) satisfying exact discrete Gauss law:

G_n(A_n) E_n = 0

and

Q_n(A_n,E_n) -> Q_YM(A,E).

---

## F2.a Smooth exact Gauss-law density

First approximate finite-energy data by smooth exact Gauss-law data.

Given (A,E) satisfying D_A E = 0, choose smooth approximations:

A_m^0 -> A,

E_m^0 -> E,

with energy convergence.

The naive smooth approximation may not satisfy Gauss law exactly. Its defect is:

r_m = D_{A_m^0} E_m^0.

Correct by solving the covariant Poisson equation:

D_{A_m^0} D_{A_m^0}^* phi_m = r_m.

Then set:

E_m = E_m^0 - D_{A_m^0}^* phi_m.

This gives:

D_{A_m^0} E_m = 0.

If the right-inverse estimate holds:

||D_{A_m^0}^* phi_m||_L2 <= C ||r_m||_H^{-1},

and r_m -> 0 in H^{-1}, then:

E_m -> E in L^2.

Thus smooth exact Gauss-law data are dense.

Open analytic input:

uniform continuum covariant right-inverse estimate on the complement of gauge zero modes.

---

## F2.b Holonomy discretization recovers magnetic energy

For smooth A, define link variables by edge holonomy:

U_e^{(n)} = P exp integral_e A.

For a plaquette p,

U_p^{(n)} = exp(a_n^2 F_ij(x_p) + O(a_n^3)).

Therefore:

dist_G(U_p^{(n)},1)^2 = a_n^4 |F_ij(x_p)|^2 + O(a_n^5).

Thus the lattice magnetic energy converges to:

1/2 int |F_A|^2 dx.

This part is a standard consistency estimate for smooth fields.

---

## F2.c Flux discretization recovers electric energy

For smooth E, define the lattice electric variable by dual-face flux average:

E_e^{(n)} = a_n^{-2} integral_{S_e} E dot n_e dS.

Then:

E_e^{(n)} = E_i(x_e) + O(a_n).

Therefore the lattice electric energy converges to:

1/2 int |E|^2 dx.

This part is also standard for smooth fields.

---

## F2.d Small discrete Gauss defect

If smooth continuum data satisfy:

D_A E = 0,

then the holonomy/flux discretization satisfies:

r_n = G_n(A_n) E_n^0 -> 0

in H_n^{-1}.

The pointwise consistency estimate is:

G_n(A_n)E_n^0(v) = D_A E(x_v) + O(a_n).

Since D_A E = 0:

G_n(A_n)E_n^0(v) = O(a_n).

Thus:

||r_n||_{H_n^{-1}} -> 0.

This gives the small defect needed for correction.

---

## F2.e Discrete Gauss-law correction

Solve:

G_n(A_n) G_n(A_n)^* phi_n = r_n.

Set:

E_n = E_n^0 - G_n(A_n)^* phi_n.

Then:

G_n(A_n) E_n = 0.

To prove the correction has vanishing energy, need:

||G_n(A_n)^* phi_n||_{L_n^2} <= C ||r_n||_{H_n^{-1}}.

This follows from the discrete covariant Poincare estimate:

||phi_n||_{H_n^1} <= C ||G_n(A_n)^* phi_n||_{L_n^2}

on the complement of zero modes.

Then:

||E_n - E_n^0||_{L_n^2} -> 0.

Therefore:

Q_n(A_n,E_n) -> Q_YM(A,E).

---

## F2 summary

Mosco recovery follows from:

1. smooth exact Gauss-law density;
2. holonomy discretization of A;
3. flux discretization of E;
4. small discrete Gauss defect;
5. discrete covariant right-inverse correction;
6. diagonal sequence selection for general finite-energy data.

The main hard recovery inputs are:

1. smooth exact Gauss-law density;
2. uniform discrete covariant right-inverse estimate.

---

# 4. F3: Vacuum projection convergence

## Target

Prove:

P_n -> P.

This is needed to transfer:

H_n^phys >= c_* Lambda_YM (I - P_n)

to

H_YM >= c_* Lambda_YM (I - P).

---

## F3.a Finite-regulator zero-energy rigidity

If:

Q_n(A_n,E_n) = 0,

then every nonnegative energy term vanishes.

Thus:

E_n = 0

and

U_p = 1 for every plaquette p.

All plaquette holonomies are trivial, so the lattice connection is flat.

On a simply connected lattice with fixed vacuum boundary, every flat lattice connection is gauge equivalent to the trivial connection.

Therefore:

ker H_n = finite-regulator vacuum sector.

---

## F3.b Continuum zero-energy rigidity

If:

Q_YM(A,E) = 0,

then:

E = 0

and

F_A = 0.

A finite-energy flat connection on R^3 in the trivial sector is gauge equivalent to A = 0.

Therefore:

ker H_YM = continuum vacuum sector.

---

## F3.c Projection convergence

Mosco convergence plus zero-energy rigidity identifies the zero-energy subspaces.

Thus:

P_n -> P.

This does not assume the mass gap. It only uses convergence of forms and rigidity of the zero-energy sector.

---

# 5. Abstract transfer theorem

Assume:

1. Q_n -> Q_YM in the Mosco sense;
2. P_n -> P;
3. H_n^phys >= m(I - P_n), with m independent of n.

Then:

H_YM >= m(I - P).

Proof:

Take a recovery sequence f_n -> f with Q_n(f_n) -> Q_YM(f).

The finite-regulator inequality gives:

Q_n(f_n) >= m ||(I - P_n)f_n||^2.

Since P_n -> P:

(I - P_n)f_n -> (I - P)f.

Passing to the limit gives:

Q_YM(f) >= m ||(I - P)f||^2.

Therefore:

H_YM >= m(I - P).

With m = c_* Lambda_YM, this gives:

Delta_YM >= c_* Lambda_YM > 0.

---

# 6. Current Master II status

Structurally closed:

1. electric lower semicontinuity;
2. magnetic liminf once lattice Uhlenbeck compactness is available;
3. Gauss-law passage once local strong A_n -> A is available;
4. holonomy discretization energy recovery for smooth fields;
5. flux discretization energy recovery for smooth fields;
6. small discrete Gauss defect for smooth Gauss-law data;
7. discrete correction once right-inverse estimate is available;
8. zero-energy rigidity route for P_n -> P;
9. abstract Mosco-transfer theorem.

Still open analytic inputs:

1. lattice Uhlenbeck compactness from bounded plaquette energy;
2. curvature identification for rough bounded-energy lattice sequences;
3. smooth exact Gauss-law density;
4. continuum covariant right-inverse estimate for smoothing correction;
5. discrete covariant right-inverse estimate for recovery correction.

This is the Master II roadmap.

# Clay Two Master Problems

## Purpose

This file records the final reduced proof map for the Clay-facing Yang--Mills mass gap route.

The longer conditional theorem is in:

docs/ClayBlockRGConditionalMasterTheorem.md

The current reduction is:

Master I: constructive fixed-scale RG

Master II: Mosco continuum bridge

If both master problems are solved, the Yang--Mills mass gap follows.

---

# 1. Final reduction

The desired conclusion is:

H_YM >= c_* Lambda_YM (I - P)

and therefore:

Delta_YM > 0.

Here:

- H_YM is the continuum Yang--Mills Hamiltonian.
- P is the continuum vacuum projection.
- Lambda_YM is the generated Yang--Mills scale.
- c_* > 0 is the constant produced by the finite-regulator block gap argument.

The route is:

Master I
=>
finite-regulator gap

Master II
=>
finite-regulator gap survives the continuum limit

Therefore:

Master I + Master II
=>
continuum Yang--Mills mass gap.

---

# 2. Master I: constructive fixed-scale RG

## Statement

At fixed physical block scale

ell = K Lambda_YM^{-1},

prove that the exact blocked Yang--Mills action converges universally:

A_{ell,n} = A_{ell,*} + R_{ell,n} + c_n

with

||R_{ell,n}||_{C_theta^2 L_y^infty} -> 0.

Here:

- A_{ell,n} is the finite-regulator fixed-scale fiber action.
- A_{ell,*} is the universal continuum fixed-scale fiber action.
- R_{ell,n} is the irrelevant regulator-dependent remainder.
- c_n is a theta-independent normalization constant.

## What Master I gives

Master I gives:

1. unique fixed-scale Wilson/block observable limits;
2. weak block kernel convergence;
3. uniform C^2 regularity of renormalized block potentials;
4. uniform C^2 block kernel smoothing bounds;
5. strict positivity of the fixed-scale block kernel;
6. finite-regulator block minorization;
7. block Poincare;
8. Dobrushin weak dependence / approximate tensorization;
9. global finite-regulator Poincare;
10. finite-regulator mass gap.

So Master I implies:

H_n^phys >= c_* Lambda_YM (I - P_n).

---

# 3. Master II: Mosco continuum bridge

## Statement

Prove:

Q_n -> Q_YM in the Mosco sense

and

P_n -> P.

Here:

- Q_n is the finite-regulator Yang--Mills quadratic form.
- Q_YM is the continuum Yang--Mills quadratic form.
- P_n is the finite-regulator vacuum projection.
- P is the continuum vacuum projection.

## Mosco liminf

If psi_n converges weakly to psi, prove:

Q_YM(psi) <= liminf Q_n(psi_n).

This requires:

1. lattice-to-continuum energy consistency;
2. gauge compactness;
3. weak lower semicontinuity;
4. identification of weak curvature limits.

## Mosco recovery

For every continuum finite-energy physical state psi, construct psi_n such that:

psi_n -> psi strongly

and

Q_n(psi_n) -> Q_YM(psi).

This requires:

1. smooth Gauss-law density;
2. holonomy discretization of the connection;
3. electric flux discretization;
4. correction to exact discrete Gauss law with vanishing energy cost.

## Vacuum convergence

Use zero-energy rigidity.

Finite regulator:

Q_n = 0
=>
E_n = 0 and all plaquette holonomies are trivial
=>
flat lattice connection
=>
gauge-trivial vacuum.

Continuum:

Q_YM = 0
=>
E = 0 and F_A = 0
=>
flat finite-energy connection
=>
gauge-trivial vacuum in the trivial sector.

Therefore:

P_n -> P.

## What Master II gives

Master II transfers the finite-regulator lower bound to the continuum:

H_n^phys >= c_* Lambda_YM (I - P_n)

passes to:

H_YM >= c_* Lambda_YM (I - P).

Therefore:

Delta_YM >= c_* Lambda_YM > 0.

---

# 4. Final theorem

If Master I and Master II hold, then:

H_YM >= c_* Lambda_YM (I - P)

with c_* > 0.

Therefore:

Delta_YM > 0.

---

# 5. Current status

Closed downstream pieces:

1. bounded-overlap energy comparison;
2. minorization implies block Poincare;
3. Dobrushin perturbation estimate;
4. exponential influence bound implies Dobrushin;
5. approximate tensorization plus block Poincare implies global finite-regulator Poincare;
6. strict positivity of Feynman--Kac block kernels under bounded potential;
7. weak kernel convergence from convergence of Wilson/matrix block observables;
8. abstract Mosco-transfer theorem.

Still open master problems:

1. constructive fixed-scale RG convergence with C^2 control and quasi-locality;
2. Mosco liminf/recovery for the continuum Yang--Mills bridge.

This is the clean reduced Clay-facing proof map.

# Clay Constructive RG Plan

## Purpose

This file records Master I of the Clay-facing Yang--Mills mass gap route.

Master I is the constructive fixed-scale RG problem.

Its purpose is to prove that the exact blocked Yang--Mills action converges universally at a fixed physical block scale with enough regularity and quasi-locality to produce the finite-regulator mass gap.

The matching Master II roadmap is:

docs/ClayMoscoBridgePlan.md

The longer conditional theorem is:

docs/ClayBlockRGConditionalMasterTheorem.md

The two-master-problem summary is:

docs/ClayTwoMasterProblems.md

---

# 1. Master I statement

Fix physical block scale:

ell = K Lambda_YM^{-1}.

Let A_{ell,n} be the finite-regulator fixed-scale blocked/fiber action.

Master I requires a universal fixed-scale limit:

A_{ell,n} = A_{ell,*} + R_{ell,n} + c_n

with

||R_{ell,n}||_{C_theta^2 L_y^infty} -> 0.

Here:

- A_{ell,*} is the universal fixed-scale continuum block action.
- R_{ell,n} is the regulator-dependent irrelevant remainder.
- c_n is a theta-independent normalization constant.
- theta denotes resolved coarse block coordinates.
- y denotes unresolved fiber variables.

The required convergence must be strong enough to give:

1. unique fixed-scale Wilson/block limits;
2. weak block kernel convergence;
3. uniform C^2 regularity of renormalized block potentials;
4. uniform C^2 block kernel smoothing;
5. strict positivity of the fixed-scale block kernel;
6. quasi-local and boundary-local block interactions;
7. Dobrushin weak dependence;
8. finite-regulator global Poincare;
9. finite-regulator mass gap.

Thus Master I should imply:

H_n^phys >= c_* Lambda_YM (I - P_n).

---

# 2. A: fixed-scale Wilson/block continuum construction

## Target

For every fixed block Wilson/matrix observable F, prove that:

lim_{n -> infinity} <F>_n

exists uniquely when Lambda_YM is held fixed.

For block kernels, the needed matrix element convergence is:

<F, K_{ell,n}^{ren} G> -> <F, K_{ell}^{ren} G>

for all block observables F and G.

## Finite-dimensional implication

If the Wilson/matrix observables form a dense algebra on the compact block space X_B, and all matrix elements converge, then:

K_{ell,n}^{ren} -> K_ell^{ren}

weakly as kernels.

This implication is structurally closed.

## Remaining analytic input

The hard part is uniqueness of fixed-scale continuum limits.

Needed theorem:

At fixed physical scale ell, all regulators tuned to the same Lambda_YM give the same fixed-scale Wilson/block observables.

This should follow from constructive RG universality and suppression of irrelevant regulator-dependent terms.

---

# 3. B: block kernel convergence and positivity

## Target

Prove:

K_{ell,n}^{ren} -> K_ell^{ren} in C^1

and

K_ell^{ren}(U,V) > 0

for all U,V in X_B.

Then compactness gives:

K_ell^{ren}(U,V) >= m_K > 0.

C^1 convergence then gives, for large n:

K_{ell,n}^{ren}(U,V) >= m_K / 2.

Therefore:

K_{ell,n}^{ren}(U,dV) >= alpha_mu mu_B(dV)

with alpha_mu = m_K / 2.

This gives reference-measure minorization.

## Finite-dimensional theorem

Weak kernel convergence plus uniform C^2 smoothing implies C^1 kernel convergence.

That is:

K_n weakly -> K

and

sup_n ||K_n||_{C^2} < infinity

imply:

K_n -> K in C^1.

This compactness theorem is structurally closed.

## Positivity theorem

If X_B is compact and connected in the chosen sector, the heat kernel is strictly positive, and the renormalized potential is bounded, then the Feynman--Kac kernel is strictly positive:

K_ell^{ren}(U,V) > 0.

Then compactness gives uniform positivity.

This finite-dimensional positivity theorem is structurally closed.

## Remaining analytic inputs

Need to prove:

1. weak block kernel convergence from fixed-scale Wilson/block limits;
2. uniform C^2 smoothing bounds;
3. bounded renormalized fixed-scale potential;
4. correct sector decomposition if X_B has multiple connected components.

---

# 4. C: renormalized block potential C^2 regularity

## Target

The renormalized block potential is:

V_{ell,n}^{ren}(theta) = -log Z_{ell,n}(theta).

Need:

||V_{ell,n}^{ren}||_{C^2(X_B)} <= C_K

uniformly in n.

## Derivative identities

Let:

Z_n(theta) = integral exp(-A_n(theta,y)) dy.

Define the conditional fiber measure:

d mu_{theta,n}(y) = Z_n(theta)^{-1} exp(-A_n(theta,y)) dy.

Then:

partial_i V_n = E_{theta,n}[partial_i A_n].

And:

partial_{ij}^2 V_n
=
E_{theta,n}[partial_{ij}^2 A_n]
-
Cov_{theta,n}(partial_i A_n, partial_j A_n).

Therefore uniform C_theta^2 bounds on A_n imply uniform C^2 bounds on V_n.

## Sufficient condition

If:

A_{ell,n} = A_{ell,*} + R_{ell,n} + c_n

with

||A_{ell,*}||_{C_theta^2 L_y^infty} <= C_K

and

||R_{ell,n}||_{C_theta^2 L_y^infty} -> 0,

then:

||V_{ell,n}^{ren}||_{C^2(X_B)} <= C_K'.

This finite-dimensional calculus step is structurally closed.

## Remaining analytic input

Need fixed-scale RG convergence of the fiber action in C_theta^2.

---

# 5. D: C^2 irrelevant remainder control

## Target

Prove:

||R_{ell,n}||_{C_theta^2 L_y^infty} -> 0.

The expected RG expansion is:

R_{ell,n}
=
sum_alpha u_{alpha,n}(ell) O_alpha^{(ell)}(theta,y),

where each O_alpha is irrelevant.

For irrelevant operators:

|u_{alpha,n}(ell)|
<=
C_alpha (a_n / ell)^{p_alpha} |log(a_n Lambda_YM)|^{q_alpha}

with p_alpha > 0.

If:

||O_alpha^{(ell)}||_{C_theta^2 L_y^infty} <= D_{alpha,K}

and the irrelevant tower is summable:

sum_alpha C_alpha D_{alpha,K}
(a_n / ell)^{p_alpha}
|log(a_n Lambda_YM)|^{q_alpha}
-> 0,

then:

||R_{ell,n}||_{C_theta^2 L_y^infty} -> 0.

## Finite-dimensional implication

Summably irrelevant C_theta^2 RG tower implies C_theta^2 vanishing remainder.

This summability implication is structurally closed.

## Remaining analytic input

Need to prove the exact blocked Yang--Mills action has a summably irrelevant regulator-dependent tower after all relevant and marginal-renormalized pieces are absorbed into A_{ell,*}.

This is one of the central constructive RG tasks.

---

# 6. E: quasi-local and boundary-local RG influence

## Target

Prove Dobrushin influence decay:

C_{ij} <= (C / K) exp(-c d(i,j)).

This implies:

sup_i sum_{j != i} C_{ij} <= C_sum / K.

For large K:

sup_i sum_{j != i} C_{ij} < 1.

Therefore Dobrushin weak dependence holds, and approximate tensorization follows.

## Interaction-potential route

If the effective block action has expansion:

S_eff^{(K)} = sum_X Phi_X,

then changing block j affects the conditional law in block i only through interactions X containing both i and j.

The finite-dimensional estimate is:

C_{ij} <= C sum_{X containing i,j} ||Phi_X||_osc.

Therefore:

sum_{j != i} C_{ij}
<=
C sum_{X containing i} |X| ||Phi_X||_osc.

So it is enough to prove:

sup_i sum_{X containing i} |X| ||Phi_X||_osc <= C / K.

## Boundary-locality route

The desired factor 1/K comes from boundary-to-volume suppression at block size:

ell = K Lambda_YM^{-1}.

A neighboring block only touches a block through its boundary, while the internal block mixing acts through the volume.

So the dimensionless boundary injection should satisfy:

beta_K <= C_boundary / K.

Then block mixing gives exponential propagation damping:

C_{ij} <= (C / K) exp(-c d(i,j)).

## Structurally closed finite-dimensional steps

Closed:

1. Dobrushin perturbation estimate from oscillation interactions;
2. exponential influence bound implies Dobrushin row-sum condition;
3. Dobrushin weak dependence implies approximate tensorization;
4. approximate tensorization plus block Poincare implies global finite-regulator Poincare.

## Remaining analytic input

Need to prove the exact blocked Yang--Mills action is quasi-local and boundary-local at fixed physical scale, with no unsuppressed volume-strength inter-block couplings.

This is the other central constructive RG task.

---

# 7. Master I downstream chain

If Master I proves A through E, then:

1. fixed-scale Wilson/block limits give weak kernel convergence;
2. C^2 RG convergence gives uniform C^2 potential and kernel bounds;
3. weak convergence plus uniform C^2 gives C^1 kernel convergence;
4. Feynman--Kac positivity gives strict positive limit kernel;
5. C^1 convergence plus positivity gives finite-regulator block minorization;
6. block minorization gives block Poincare;
7. quasi-locality gives Dobrushin weak dependence;
8. Dobrushin gives approximate tensorization;
9. block Poincare plus tensorization plus bounded overlap gives global finite-regulator Poincare;
10. global Poincare gives finite-regulator mass gap:

H_n^phys >= c_* Lambda_YM (I - P_n).

---

# 8. Current Master I status

Structurally closed downstream pieces:

1. weak kernel convergence from Wilson/matrix observable convergence;
2. weak convergence plus uniform C^2 implies C^1 kernel convergence;
3. strict positivity of bounded-potential Feynman--Kac kernels;
4. C_theta^2 action control implies C^2 renormalized potential control;
5. summably irrelevant tower implies C_theta^2 vanishing remainder;
6. Dobrushin perturbation estimate;
7. exponential influence bound implies Dobrushin;
8. approximate tensorization plus block Poincare gives global Poincare;
9. bounded-overlap energy comparison;
10. minorization implies block Poincare.

Open constructive RG inputs:

1. unique fixed-scale Wilson/block continuum limits;
2. C_theta^2 convergence of fixed-scale fiber actions;
3. summable irrelevant tower for regulator-dependent remainders;
4. uniform C^2 block kernel smoothing;
5. quasi-locality of exact blocked action;
6. boundary-locality / 1/K inter-block influence;
7. sector control for compact connected block spaces.

This is the Master I roadmap.

---

# 9. Final Master I theorem

If the constructive fixed-scale RG theorem holds with:

A_{ell,n} = A_{ell,*} + R_{ell,n} + c_n

and

||R_{ell,n}||_{C_theta^2 L_y^infty} -> 0,

plus quasi-local/boundary-local block influence, then:

H_n^phys >= c_* Lambda_YM (I - P_n)

with c_* > 0 independent of n.

Then Master II transfers this to the continuum.

Therefore:

Master I + Master II => Delta_YM > 0.

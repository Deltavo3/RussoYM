# Clay Original Proof Map

## Purpose

This file maps the original Yang–Mills/FRT proof argument onto the five remaining analytic obligations identified in `docs/ClayProofAudit.md`.

The goal is to determine which parts of the original proof are already rigorous, which parts need clarification, which parts need new lemmas, and which parts risk assuming the mass gap.

---

# Reduced Five Obligations

The current Lean roadmap reduces the proof to:

1. Compact/nontrivial holonomy sector separation.
2. Holonomy-curvature control.
3. Curvature coercivity.
4. Finite gap lower comparison.
5. Continuum survival.

If these five are proved, Lean already verifies the conditional route to:

[
0 < \Delta_{\mathrm{YM}}.
]

---

# Audit Rule

We may use standard Yang–Mills definitions, local identities, norm inequalities, and local holonomy-curvature estimates.

We may not use any theorem or assumption that already implies a positive Yang–Mills mass gap.

In particular, we must not assume:

[
\inf \operatorname{Spec}(H_{\mathrm{YM}} \setminus {0}) > 0
]

or anything equivalent to it.

---

# Obligation 1: Compact / Nontrivial Holonomy Sector Separation

## Lean target

[
\exists \delta > 0,\quad
\forall n,\quad
\delta \leq |1 - U_n|.
]

where

[
U_n = (\mathrm{links}\ n).\mathrm{prod}.
]

## Original proof source

TODO: Insert the paragraph or lemma from the original proof that argues the regulator sequence remains in a nontrivial holonomy sector.

## Claimed argument

Expected structure:

1. Define admissible nontrivial sector (K).
2. Show (U_n \in K) for all (n).
3. Show (1 \notin K).
4. Show (K) is compact, closed, or finite-resolution compact.
5. Conclude (\inf_{U\in K}|1-U|>0).

## Status

Pending original-proof check.

## Risk level

High.

This is one of the places where the mass gap could be smuggled in if “nontrivial sector” is defined too strongly.

## Does this need Lean?

Not immediately. First prove on paper.

Lean already verifies:

[
\text{compact sector certificate}
\Rightarrow
\text{holonomy separation}.
]

---

# Obligation 2: Holonomy-Curvature Control

## Lean target

[
\exists C>0,\quad
\forall n,\quad
|1-U_n|\leq C,\mathrm{curvatureNorm}(n).
]

## Original proof source

TODO: Insert the paragraph or lemma from the original proof giving holonomy deviation control by curvature.

## Claimed argument

Expected structure:

1. Define (U_n) as a product of holonomies around a loop/plaquette.
2. Define (\mathrm{curvatureNorm}(n)).
3. Prove a local estimate:

[
|1-\mathrm{Hol}(\gamma)|
\leq
C|F_A|_{\text{local}}.
]

4. Show constants are uniform in (n).

## Status

Pending original-proof check.

## Risk level

Medium.

This is probably a standard local estimate, but the exact norm and uniformity matter.

## Does this need Lean?

Maybe later, once the exact norm definitions are stable.

---

# Obligation 3: Curvature Coercivity

## Lean target

[
\exists \mu>0,\quad
\forall n,\quad
\mu(\mathrm{curvatureNorm}(n))^2
\leq
\mathrm{Energy}(n).
]

## Original proof source

TODO: Insert the paragraph or lemma from the original proof defining energy and curvature norm.

## Claimed argument

Expected structure:

1. Define regulated Yang–Mills energy.
2. Define curvature norm compatibly.
3. Prove energy controls curvature squared by definition or finite-dimensional norm equivalence.

## Status

Pending original-proof check.

## Risk level

Medium-low if definitions are chosen honestly.

High if energy is defined in a way that already assumes the gap.

## Does this need Lean?

Probably yes if the definitions are simple enough.

This is one of the best candidates for selective Lean verification.

---

# Obligation 4: Finite Gap Lower Comparison

## Lean target

[
\forall n,\quad
\mathrm{Energy}(n)\leq \mathrm{Gap}(n).
]

## Original proof source

TODO: Insert the paragraph or lemma from the original proof defining finite-regulator gap.

## Claimed argument

Expected structure:

1. Define (\mathrm{Gap}(n)) independently.
2. Define (\mathrm{Energy}(n)) independently.
3. Prove the energy lower quantity is bounded above by the finite-regulator gap.

## Status

Pending original-proof check.

## Risk level

High.

This is dangerous if (\mathrm{Gap}(n)) is defined in a way that already contains the desired lower bound.

## Does this need Lean?

Maybe, but only after the definitions are clarified.

---

# Obligation 5: Continuum Survival

## Lean target

[
\Delta_0 \leq \Delta_{\mathrm{YM}}.
]

## Original proof source

TODO: Insert the paragraph or lemma from the original proof arguing that the finite-regulator lower bound survives the continuum limit.

## Claimed argument

Expected structure:

1. Define (\Delta_{\mathrm{YM}}).
2. Define the regulator limit.
3. Prove lower semicontinuity or monotonicity of the gap under the limit.
4. Show the sequence cannot collapse into the trivial sector.
5. Show the constants (\delta,C,\mu,\Delta_0) are uniform.

## Status

Pending original-proof check.

## Risk level

Very high.

This is the other major place where the proof could accidentally assume the conclusion.

## Does this need Lean?

Eventually maybe. First prove carefully on paper.

---

# Initial Classification Table


| Obligation                              |                               Old Lean source found? |                Rigorous? |                     Needs new lemma? | Needs Lean? |      Risk |
| --------------------------------------- | ---------------------------------------------------: | -----------------------: | -----------------------------------: | ----------: | --------: |
| 1. Compact/nontrivial sector separation |                                               Partly |                  Not yet |                                  Yes | Maybe later |      High |
| 2. Holonomy-curvature control           |                         Yes, as an assumption packet | Not yet from definitions |                                  Yes |       Maybe |    Medium |
| 3. Curvature coercivity                 |                        Yes, algebraic support exists |                   Partly | Yes, analytic definition-level lemma |      Likely |    Medium |
| 4. Finite gap lower comparison          |                         Yes, as an assumption packet |                  Not yet |                                  Yes |       Maybe |      High |
| 5. Continuum survival                   | Yes, split into finite lower + epsilon approximation |                  Not yet |                                  Yes | Maybe later | Very high |

## Source Mapping Notes

### Obligation 1: Compact/nontrivial holonomy sector separation

Old source appears through:

```lean
UniformHolonomySeparationAssumptions links delta
```

and in the older atomic audit as:

```lean
holonomySeparation :
  UniformHolonomySeparationAssumptions links delta
```

Current status: this was previously treated as an assumption. Our newer Lean work has improved the shape by replacing it with a compact/nontrivial sector certificate, but the compact-sector theorem itself is not yet proved.

Conclusion: paper proof required.

---

### Obligation 2: Holonomy-curvature control

Old source appears through:

```lean
UniformHolonomyCurvatureControlAssumptions links curvatureNorm C
```

and in the older atomic audit as:

```lean
holonomyCurvatureControl :
  UniformHolonomyCurvatureControlAssumptions links curvatureNorm C
```

Current status: this was previously treated as an analytic red lemma. It should be proved by a local holonomy-curvature estimate, not by any mass-gap input.

Conclusion: paper lemma required; Lean optional after definitions stabilize.

---

### Obligation 3: Curvature coercivity

Old source appears through:

```lean
UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu
```

and in the older atomic audit as:

```lean
curvatureCoercivity :
  UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu
```

There is also algebraic support in `AlgebraCore.lean`, including:

```lean
coercivity_implication_mul
coercivity_implication_div
finite_information_gap
frt_gap_from_coercivity
```

Current status: the algebra is already Lean-verified, but the analytic Yang–Mills definition-level coercivity still needs proof. We must show that the regulated energy genuinely controls the chosen curvature norm.

Conclusion: likely worth Lean-verifying once the definitions are fixed.

---

### Obligation 4: Finite gap lower comparison

Old source appears through:

```lean
UniformGapLowerBoundAssumptions Gap Energy
```

and in the older atomic audit as:

```lean
finiteGapLower :
  UniformGapLowerBoundAssumptions Gap Energy
```

Current status: this is dangerous because if `Gap` is defined incorrectly, the proof could accidentally write in the desired lower bound.

Conclusion: must define `Gap n` independently and prove `Energy n <= Gap n` from the regulator spectral setup.

---

### Obligation 5: Continuum survival

Old source appears split into:

```lean
UniformFiniteGapLowerAssumptions Delta0 Gap
EpsilonContinuumApproximationAssumptions DeltaYM Gap
```

and in the older atomic audit as:

```lean
continuumFiniteLower :
  UniformFiniteGapLowerAssumptions Delta0 Gap

continuumApproximation :
  EpsilonContinuumApproximationAssumptions DeltaYM Gap
```

Current status: this is the most important remaining transfer-side proof. The old proof already recognized that continuum survival should be split into a uniform finite lower bound plus an epsilon/continuum approximation step.

Conclusion: paper proof required first. Lean should only package it after the analytic argument is stable.


---

# Updated Status After Paper-Audit Files

The remaining proof burden has now been sharpened.

## Obligation 1: Compact/nontrivial holonomy sector separation

Status: reduced to a compact-sector or finite-resolution-sector separation lemma.

Dedicated audit file:

```text
docs/ClayCompactHolonomySectorLemma.md
```

Current requirement:

Define the admissible nontrivial sector (K) without using energy or a spectral lower bound. Then prove:

1. (U_n\in K) for all (n).
2. (1\notin K).
3. (K) is compact, closed with positive separation, or finite-resolution separated from the identity sector.
4. The distance map (U\mapsto |1-U|) is continuous.

Risk: high.

## Obligation 1 Update: Nontrivial Holonomy Sector Defined

Dedicated definition file:

```text
docs/ClayNontrivialHolonomySectorDefinition.md
```

The nontrivial sector is now proposed as a finite-resolution holonomy-sector fiber:

[
K=q_{\mathrm{hol}}^{-1}(\lambda_*),
\qquad
\lambda_*\neq \lambda_{\mathrm{id}}.
]

Here (q_{\mathrm{hol}}) is a finite-resolution holonomy sector map

[
q_{\mathrm{hol}}:G^m\to\Lambda_{\mathrm{hol}},
]

and (\lambda_{\mathrm{id}}) is the resolved identity-sector label.

This is safe because (K) is defined by resolved holonomy data, not by energy, confinement, or a spectral lower bound.

The remaining paper burden for obligation 1 is now:

1. define (q_{\mathrm{hol}}) precisely;
2. prove the identity tuple (\mathbf 1) maps to (\lambda_{\mathrm{id}});
3. choose (\lambda_*\neq\lambda_{\mathrm{id}});
4. prove the regulator sequence satisfies (\operatorname{Hol}_{\Gamma}(A_n)\in K);
5. prove (K) is compact, usually by proving it is a closed fiber of (q_{\mathrm{hol}}) inside compact (G^m);
6. prove the resolved holonomy product map (U:K\to G) is continuous;
7. prove (U(V)=1) forces the resolved identity sector, so (U(V)=1) cannot occur inside (K).

Thus obligation 1 is reduced to a precise finite-resolution holonomy-sector theorem:

[
K=q_{\mathrm{hol}}^{-1}(\lambda_*),
\qquad
K\subseteq G^m\text{ compact},
\qquad
\mathbf 1\notin K
]

implies

[
\exists \delta>0,\quad
\forall n,\quad
\delta\leq|1-U_n|.
]

Status: reduced but not fully proved.

Risk: still high, but localized.

## Obligation 1 Direct-Sector Lean Update

Dedicated Lean file:

```text
RussoYM/ClayDirectHolonomySector.lean
```

The direct finite-resolution sector condition

∀n,2ϵ
hol
	​

≤∥1−(links n).prod∥

now Lean-verifies the holonomy separation obligation with witness

δ=2ϵ
hol
	​

.

Thus the old compact-sector certificate is no longer the main formal route. The current route is:

direct resolved nontrivial holonomy sector⇒holonomy separation.

The remaining paper issue for obligation 1 is not algebraic. It is to justify the sector membership condition as a legitimate finite-resolution sector selection, not an energy or mass-gap assumption.

Status: Lean-packaged under direct sector assumption.

Remaining burden: justify direct sector membership in the paper.

---

## Obligation 2: Holonomy-curvature control

Status: reduced to uniform holonomy-curvature control in the energy norm.

Dedicated audit file:

```text
docs/ClayHolonomyCurvatureControlLemma.md
```

Current requirement:

Prove

[
|1-U_n|\leq C|F_n|_{E,n}
]

with (C) independent of (n).

This should come from:

1. local holonomy-curvature estimate,
2. Cauchy--Schwarz,
3. uniform regulator geometry,
4. local-to-global energy comparison.

Risk: medium.

---

## Obligation 3: Curvature coercivity

Status: definition-level discharged under the energy-norm convention.

Dedicated files:

```text
docs/ClayCurvatureCoercivityLemma.md
docs/ClayEnergyNormConvention.md
RussoYM/ClayEnergyNormCoercivity.lean
```

Current convention:

\[
\mathrm{curvatureNorm}(n)=\|F_n\|_{E,n},
\qquad
\mathrm{Energy}(n)=\|F_n\|_{E,n}^{2}.
\]

Then coercivity holds with

[
\mu=1.
]

Lean has verified the schematic implication:

[
\forall n,\ \mathrm{Energy}(n)=(\mathrm{curvatureNorm}(n))^2
\Rightarrow
\texttt{ClayCurvatureCoercivityExistenceAssumptions}.
]

Risk: low, assuming the definitions are used consistently.

---

## Obligation 4: Finite gap lower comparison

Status: direction issue identified and clarified.

Dedicated audit file:

```text
docs/ClayFiniteGapComparisonLemma.md
```

Current requirement:

The Lean variable currently called `Energy n` must be interpreted in the paper as a universal lower-bound scale, not as an arbitrary energy value or an infimum over a smaller selected sector.

Recommended paper notation:

[
\mathrm{Lower}(n)
]

instead of

[
\mathrm{Energy}(n).
]

The required comparison is:

[
\mathrm{Lower}(n)\leq \mathrm{Gap}(n).
]

This is valid only if (\mathrm{Lower}(n)) is proved to bound every normalized non-vacuum finite-regulator state from below.

Risk: high.

---

## Obligation 5: Continuum survival

Status: reduced to an operator-limit / spectral-lower-bound preservation theorem.

Dedicated audit file:

```text
docs/ClayContinuumSurvivalLemma.md
```

Current requirement:

Prove that a uniform finite-regulator lower bound survives the continuum limit:

[
H_n\geq \Delta_0(I-P_n)
\quad\Longrightarrow\quad
H_{\mathrm{YM}}\geq \Delta_0(I-P).
]

This requires:

1. a precise regulator convergence framework,
2. convergence of vacuum projections (P_n\to P),
3. no collapse of the non-vacuum sector,
4. preservation of lower spectral bounds.

Risk: very high.

---

# Updated Effective Burden

After the energy-norm convention, the proof is effectively reduced to four major analytic burdens:

1. Define and separate the compact/nontrivial holonomy sector.
2. Prove uniform holonomy-curvature control in the energy norm.
3. Prove the universal finite lower-bound comparison (\mathrm{Lower}(n)\leq\mathrm{Gap}(n)).
4. Prove continuum survival of the uniform lower bound.

Curvature coercivity remains in the Lean theorem chain, but it is now discharged by definition with (\mu=1).

---

# Immediate Work Plan

1. Locate the original proof paragraphs corresponding to each obligation.
2. Paste them under each obligation.
3. Mark each as:

   * rigorous,
   * needs clarification,
   * needs new lemma,
   * dangerous / may assume the conclusion.
4. Only after this audit, decide what Lean should verify next.

---

# Current Lean Conclusion

The current Lean state is strong enough that if the five obligations are proven honestly, then the mass-gap endpoint follows.

Therefore the next work is not more wrapper construction.

The next work is proving or repairing the five analytic obligations.

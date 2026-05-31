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

| Obligation                              | Original proof source found? | Rigorous? | Needs new lemma? | Needs Lean? |      Risk |
| --------------------------------------- | ---------------------------: | --------: | ---------------: | ----------: | --------: |
| 1. Compact/nontrivial sector separation |                         TODO |      TODO |             TODO | Maybe later |      High |
| 2. Holonomy-curvature control           |                         TODO |      TODO |             TODO |       Maybe |    Medium |
| 3. Curvature coercivity                 |                         TODO |      TODO |             TODO |      Likely |    Medium |
| 4. Finite gap lower comparison          |                         TODO |      TODO |             TODO |       Maybe |      High |
| 5. Continuum survival                   |                         TODO |      TODO |             TODO | Maybe later | Very high |

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

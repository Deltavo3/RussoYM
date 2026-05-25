import RussoYM.ClayDirectMixingRedLemmaTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Direct Red Lemma Theorem

This file exposes the cleanest current red-lemma theorem for the RussoYM Clay
route.

Compared with `ClayRedLemmaTheorem`, the mixing side has been reduced to the
direct Delta0-targeted mixing smallness inequality:

  2 * Cmix * (eps / ell)^kappa <= Delta0.

Thus the current theorem depends on five clean packets:

1. uniform holonomy red lemmas,
2. positive Layer-One scale normalization,
3. direct Delta0 mixing smallness,
4. Schur/Feshbach fine-lower estimate,
5. epsilon-continuum survival.
-/

/--
Current clean direct red-lemma assumptions.

This is just the already-built direct-mixing Clay assumption packet, but this
name records that it is now the clean front-door red-lemma theorem assumption
set.
-/
abbrev ClayDirectRedLemmaTheoremAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real)
    (kappa : Nat) : Prop :=
  ClayDirectMixingRedLemmaAssumptions
    links Gap Energy curvatureNorm
    DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa

/--
Current clean direct red-lemma theorem: full strongest gap data.
-/
theorem clay_direct_red_lemma_theorem_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayDirectMixingRedLemmaAssumptions.imply_full_gap_data h

/--
Current clean direct red-lemma theorem: strongest conditional Yang--Mills
mass-gap summary.
-/
theorem clay_direct_red_lemma_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact clay_direct_mixing_red_lemma_theorem_implies_mass_gap h

/--
Current clean direct red-lemma theorem: positive continuum Yang--Mills gap.
-/
theorem clay_direct_red_lemma_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    0 < DeltaYM := by
  exact clay_direct_mixing_red_lemma_theorem_implies_positive_continuum_gap h

end RussoYM

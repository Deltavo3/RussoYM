import RussoYM.ClayMixingSeparatedKappa

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Separated Kappa Theorem

This file exposes the cleanest current Clay theorem after reducing the mixing
side to separated kappa-independent and kappa-dependent data.

The current theorem assumes:

1. uniform holonomy red lemmas,
2. reduced Layer-One scale data,
3. kappa-independent mixing scale data,
4. existence of a kappa satisfying the decay budget and Schur/Feshbach fine
   lower estimate,
5. epsilon-continuum survival.

This is the cleanest current endpoint before attacking the remaining hard
analytic packets.
-/

/--
Cleanest current separated-kappa theorem: full strongest gap data.
-/
theorem clay_separated_kappa_theorem_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayMixingSeparatedKappaAssumptions.imply_full_gap_data h

/--
Cleanest current separated-kappa theorem: strongest conditional mass-gap
summary.
-/
theorem clay_separated_kappa_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayMixingSeparatedKappaAssumptions.imply_mass_gap h

/--
Cleanest current separated-kappa theorem: positive continuum Yang--Mills gap.
-/
theorem clay_separated_kappa_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    0 < DeltaYM := by
  exact ClayMixingSeparatedKappaAssumptions.imply_positive_continuum_gap h

end RussoYM

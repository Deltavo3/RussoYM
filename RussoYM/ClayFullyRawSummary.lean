import RussoYM.ClayFullyRawAudit

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Fully Raw Summary

This file gives the clean headline theorem for the fully raw conditional
Yang--Mills mass-gap endpoint.

At this point, all packaged assumptions have been expanded into raw positivity
and inequality data.
-/

/--
Headline fully raw conditional Yang--Mills mass-gap theorem.

This is the cleanest current conditional theorem:

raw holonomy separation,
raw holonomy-curvature control,
raw curvature coercivity,
raw finite gap lower bound,
raw UV scale data,
raw Schur/Feshbach loss bounds,
and raw continuum survival

imply a positive continuum Yang--Mills gap.
-/
theorem clay_fully_raw_conditional_yang_mills_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact ClayFullyRawAssumptions.imply_positive_continuum_gap h

/--
Headline fully raw conditional theorem with finite-regulator and continuum gap
data retained.
-/
theorem clay_fully_raw_conditional_yang_mills_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayFullyRawAssumptions.imply_mass_gap h

/--
Headline fully raw theorem with all strongest currently tracked gap data.
-/
theorem clay_fully_raw_conditional_yang_mills_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayFullyRawAssumptions.imply_full_gap_data h

end RussoYM

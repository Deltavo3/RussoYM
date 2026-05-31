import RussoYM.ClayFullyRawContinuumBridge

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Fully Raw Decomposed Theorem

This file proves the fully raw conditional Clay theorem by explicitly combining
the three extracted fully raw bridges:

1. raw holonomy/coercivity -> finite-regulator gap,
2. raw Schur/Feshbach -> Layer-One fine gap data,
3. raw continuum survival -> continuum gap data.

This gives a transparent decomposed proof of the fully raw endpoint.
-/

/--
Fully raw decomposed theorem: full strongest gap data.
-/
theorem ClayFullyRawAssumptions.imply_full_gap_data_decomposed
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
  have hFinite :
      ∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n := by
    exact ClayFullyRawAssumptions.imply_finite_gap_bound_via_raw_holonomy h
  have hFine :
      Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
    exact ClayFullyRawAssumptions.imply_layer_one_fine_gap_data_via_raw_schur h
  have hCont :
      Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact ClayFullyRawAssumptions.imply_continuum_gap_data_via_raw_continuum h
  exact ⟨hFinite, hFine, hCont, ⟨hFinite, hCont.2⟩⟩

/--
Fully raw decomposed theorem: mass-gap summary.
-/
theorem ClayFullyRawAssumptions.imply_mass_gap_decomposed
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
  exact
    ⟨ClayFullyRawAssumptions.imply_finite_gap_bound_via_raw_holonomy h,
      ClayFullyRawAssumptions.imply_positive_continuum_gap_via_raw_continuum h⟩

/--
Fully raw decomposed theorem: positive continuum Yang--Mills gap.
-/
theorem ClayFullyRawAssumptions.imply_positive_continuum_gap_decomposed
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
  exact ClayFullyRawAssumptions.imply_positive_continuum_gap_via_raw_continuum h

/--
Headline decomposed fully raw conditional Yang--Mills mass-gap theorem.
-/
theorem clay_fully_raw_decomposed_conditional_yang_mills_mass_gap
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
  exact ClayFullyRawAssumptions.imply_positive_continuum_gap_decomposed h

end RussoYM

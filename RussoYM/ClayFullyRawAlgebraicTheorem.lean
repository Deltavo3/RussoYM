import RussoYM.ClayRawContinuumAlgebra

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Fully Raw Algebraic Theorem

This file proves the fully raw conditional Clay endpoint by explicitly combining
the raw algebraic pieces:

1. raw holonomy/coercivity pointwise chain,
2. raw Schur/Feshbach transfer algebra,
3. raw continuum transfer algebra.

This is the cleanest algebraic proof of the fully raw endpoint.
-/

/--
Fully raw algebraic theorem: full strongest gap data.
-/
theorem ClayFullyRawAssumptions.imply_full_gap_data_by_raw_algebra
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
  have hConcrete :
      0 < mu * (delta / C)^2
        ∧ forall n, mu * (delta / C)^2 <= Gap n := by
    exact ClayFullyRawAssumptions.imply_concrete_gap_witness h
  have hFinite :
      ∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n := by
    exact ⟨mu * (delta / C)^2, hConcrete.1, hConcrete.2⟩
  have hFine :
      Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
    exact ClayFullyRawAssumptions.imply_fine_gap_data_by_raw_schur_algebra h
  have hCont :
      Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact ClayFullyRawAssumptions.imply_continuum_gap_data_by_raw_continuum_algebra h
  exact ⟨hFinite, hFine, hCont, ⟨hFinite, hCont.2⟩⟩

/--
Fully raw algebraic theorem: mass-gap summary.
-/
theorem ClayFullyRawAssumptions.imply_mass_gap_by_raw_algebra
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
  have hConcrete :
      0 < mu * (delta / C)^2
        ∧ forall n, mu * (delta / C)^2 <= Gap n := by
    exact ClayFullyRawAssumptions.imply_concrete_gap_witness h
  exact
    ⟨⟨mu * (delta / C)^2, hConcrete.1, hConcrete.2⟩,
      ClayFullyRawAssumptions.imply_positive_continuum_gap_by_raw_continuum_algebra h⟩

/--
Fully raw algebraic theorem: positive continuum Yang--Mills gap.
-/
theorem ClayFullyRawAssumptions.imply_positive_continuum_gap_by_raw_algebra
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
  exact ClayFullyRawAssumptions.imply_positive_continuum_gap_by_raw_continuum_algebra h

/--
Headline fully raw algebraic conditional Yang--Mills mass-gap theorem.
-/
theorem clay_fully_raw_algebraic_conditional_yang_mills_mass_gap
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
  exact ClayFullyRawAssumptions.imply_positive_continuum_gap_by_raw_algebra h

end RussoYM

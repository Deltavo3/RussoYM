import RussoYM.ClayFullyRawAlgebraicTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Existential Fully Raw Theorem

This file packages the fully raw algebraic Clay theorem existentially.

Instead of fixing all constants externally, we assume that there exist constants

  DeltaFine, Delta0, dUV, C, mu, delta

satisfying the fully raw assumptions.

This gives a cleaner mathematical endpoint:

  existence of fully raw Clay data
  -> positive continuum Yang--Mills gap.
-/

/--
Existential fully raw assumptions.

There exist constants satisfying the fully raw Clay assumption package.
-/
structure ClayExistentialFullyRawAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM : Real) : Prop where
  exists_raw_data :
    ∃ DeltaFine Delta0 dUV C mu delta : Real,
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta

/--
Expose the raw witness data from the existential package.
-/
theorem ClayExistentialFullyRawAssumptions.exists_raw_witness_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExistentialFullyRawAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    ∃ DeltaFine Delta0 dUV C mu delta : Real,
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta := by
  exact h.exists_raw_data

/--
Existential fully raw theorem: positive continuum Yang--Mills gap.
-/
theorem ClayExistentialFullyRawAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExistentialFullyRawAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    0 < DeltaYM := by
  rcases h.exists_raw_data with
    ⟨DeltaFine, Delta0, dUV, C, mu, delta, hRaw⟩
  exact
    ClayFullyRawAssumptions.imply_positive_continuum_gap_by_raw_algebra
      hRaw

/--
Existential fully raw theorem: finite-regulator mass-gap summary plus positive
continuum gap.
-/
theorem ClayExistentialFullyRawAssumptions.imply_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExistentialFullyRawAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  rcases h.exists_raw_data with
    ⟨DeltaFine, Delta0, dUV, C, mu, delta, hRaw⟩
  exact
    ClayFullyRawAssumptions.imply_mass_gap_by_raw_algebra
      hRaw

/--
Existential fully raw theorem: full strongest currently tracked gap data.
-/
theorem ClayExistentialFullyRawAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExistentialFullyRawAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    ∃ DeltaFine Delta0 dUV C mu delta : Real,
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta
        ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
            ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
            ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
            ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
                ∧ 0 < DeltaYM)) := by
  rcases h.exists_raw_data with
    ⟨DeltaFine, Delta0, dUV, C, mu, delta, hRaw⟩
  exact
    ⟨DeltaFine, Delta0, dUV, C, mu, delta,
      hRaw,
      ClayFullyRawAssumptions.imply_full_gap_data_by_raw_algebra hRaw⟩

/--
Headline existential fully raw conditional Yang--Mills mass-gap theorem.
-/
theorem clay_existential_fully_raw_conditional_yang_mills_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExistentialFullyRawAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    0 < DeltaYM := by
  exact ClayExistentialFullyRawAssumptions.imply_positive_continuum_gap h

end RussoYM

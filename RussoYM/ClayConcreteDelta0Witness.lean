import RussoYM.ClayConcreteGapWitness

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Concrete Delta0 Witness

This file records the concrete Layer-One transfer witness.

The fully raw assumptions imply:

  0 < Delta0,
  Delta0 <= DeltaFine,
  Delta0 <= DeltaYM.

Thus the same positive intermediate scale `Delta0` transfers into both the
fine gap and the continuum Yang--Mills gap.
-/

/--
Fully raw assumptions give positivity of the intermediate scale `Delta0`.
-/
theorem ClayFullyRawAssumptions.imply_concrete_delta0_positive
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
    0 < Delta0 := by
  exact ClayFullyRawAssumptions.imply_delta0_positive_via_raw_scale h

/--
Fully raw assumptions give the fine-gap transfer inequality.
-/
theorem ClayFullyRawAssumptions.imply_delta0_transfers_to_fine_gap
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
    Delta0 <= DeltaFine := by
  exact ClayFullyRawAssumptions.imply_delta0_le_deltaFine_via_raw_schur h

/--
Fully raw assumptions give the continuum-transfer inequality.
-/
theorem ClayFullyRawAssumptions.imply_delta0_transfers_to_continuum_gap
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
    Delta0 <= DeltaYM := by
  exact ClayFullyRawAssumptions.imply_delta0_le_deltaYM_via_raw_continuum h

/--
Fully raw assumptions give the concrete Delta0 transfer witness.
-/
theorem ClayFullyRawAssumptions.imply_concrete_delta0_transfer_witness
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
    0 < Delta0
      ∧ Delta0 <= DeltaFine
      ∧ Delta0 <= DeltaYM := by
  exact
    ⟨ClayFullyRawAssumptions.imply_concrete_delta0_positive h,
      ClayFullyRawAssumptions.imply_delta0_transfers_to_fine_gap h,
      ClayFullyRawAssumptions.imply_delta0_transfers_to_continuum_gap h⟩

/--
Fully raw assumptions give positivity of both transferred gaps.
-/
theorem ClayFullyRawAssumptions.imply_positive_transferred_fine_and_continuum_gaps
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
    0 < DeltaFine ∧ 0 < DeltaYM := by
  have hDelta0_pos : 0 < Delta0 := by
    exact ClayFullyRawAssumptions.imply_concrete_delta0_positive h
  have hFine : Delta0 <= DeltaFine := by
    exact ClayFullyRawAssumptions.imply_delta0_transfers_to_fine_gap h
  have hYM : Delta0 <= DeltaYM := by
    exact ClayFullyRawAssumptions.imply_delta0_transfers_to_continuum_gap h
  exact
    ⟨lt_of_lt_of_le hDelta0_pos hFine,
      lt_of_lt_of_le hDelta0_pos hYM⟩

/--
Fully raw assumptions give all concrete witnesses currently tracked:

1. finite-regulator witness `mu * (delta / C)^2`,
2. Delta0 transfer witness,
3. positive continuum Yang--Mills gap.
-/
theorem ClayFullyRawAssumptions.imply_concrete_witness_package
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
    (0 < mu * (delta / C)^2
      ∧ forall n, mu * (delta / C)^2 <= Gap n)
      ∧ (0 < Delta0
          ∧ Delta0 <= DeltaFine
          ∧ Delta0 <= DeltaYM)
      ∧ 0 < DeltaYM := by
  exact
    ⟨ClayFullyRawAssumptions.imply_concrete_gap_witness h,
      ClayFullyRawAssumptions.imply_concrete_delta0_transfer_witness h,
      ClayFullyRawAssumptions.imply_positive_continuum_gap_decomposed h⟩

end RussoYM

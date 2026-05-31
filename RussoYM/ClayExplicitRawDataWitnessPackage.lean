import RussoYM.ClayExplicitRawDataTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Explicit Raw Data Witness Package

This file exposes witness consequences directly from the explicit raw-data
conditional theorem.

The explicit raw-data assumptions already contain all constants, including the
Schur/Feshbach loss witness.  This file records the finite-gap witness,
Delta0-transfer witness, pointwise gap chain, and pointwise positivity chain.
-/

/--
Expose the explicit raw constants and Schur loss witness.
-/
theorem ClayExplicitRawDataAssumptions.exists_explicit_raw_witness_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExplicitRawDataAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    ∃ DeltaFine Delta0 dUV C mu delta loss : Real,
      0 < delta
        ∧ (forall n, delta <= ‖1 - (links n).prod‖)
        ∧ 0 < C
        ∧ (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n)
        ∧ 0 < mu
        ∧ (forall n, mu * (curvatureNorm n)^2 <= Energy n)
        ∧ (forall n, Energy n <= Gap n)
        ∧ 0 < dUV
        ∧ Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV
        ∧ loss <= Delta0
        ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine
        ∧ Delta0 <= DeltaYM := by
  exact h.exists_explicit_raw_data

/--
Explicit raw-data assumptions give the explicit finite-regulator gap witness.
-/
theorem ClayExplicitRawDataAssumptions.imply_exists_explicit_finite_gap_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExplicitRawDataAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    ∃ Delta DeltaFine Delta0 dUV C mu delta : Real,
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta
        ∧ Delta = mu * (delta / C)^2
        ∧ 0 < Delta
        ∧ forall n, Delta <= Gap n := by
  exact
    ClayExistentialFullyRawAssumptions.imply_exists_explicit_finite_gap_bound
      (ClayExplicitRawDataAssumptions.to_existential_fully_raw_assumptions h)

/--
Explicit raw-data assumptions give the concrete Delta0 transfer witness.
-/
theorem ClayExplicitRawDataAssumptions.imply_exists_delta0_transfer_witness
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExplicitRawDataAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    ∃ DeltaFine Delta0 dUV C mu delta : Real,
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta
        ∧ 0 < Delta0
        ∧ Delta0 <= DeltaFine
        ∧ Delta0 <= DeltaYM := by
  exact
    ClayExistentialFullyRawAssumptions.imply_exists_delta0_transfer_witness
      (ClayExplicitRawDataAssumptions.to_existential_fully_raw_assumptions h)

/--
Explicit raw-data assumptions give the pointwise finite-gap chain.
-/
theorem ClayExplicitRawDataAssumptions.imply_exists_pointwise_gap_chain
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExplicitRawDataAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    ∃ DeltaFine Delta0 dUV C mu delta : Real,
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta
        ∧ (forall n,
            delta / C <= curvatureNorm n
              ∧ (delta / C)^2 <= (curvatureNorm n)^2
              ∧ mu * (delta / C)^2 <= Energy n
              ∧ mu * (delta / C)^2 <= Gap n) := by
  exact
    ClayExistentialFullyRawAssumptions.imply_exists_pointwise_gap_chain
      (ClayExplicitRawDataAssumptions.to_existential_fully_raw_assumptions h)

/--
Explicit raw-data assumptions give the pointwise positivity chain.
-/
theorem ClayExplicitRawDataAssumptions.imply_exists_pointwise_positive_chain
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExplicitRawDataAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    ∃ DeltaFine Delta0 dUV C mu delta : Real,
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta
        ∧ 0 < delta / C
        ∧ (forall n, 0 < curvatureNorm n)
        ∧ 0 < mu * (delta / C)^2
        ∧ (forall n, 0 < Energy n)
        ∧ forall n, 0 < Gap n := by
  exact
    ClayExistentialFullyRawAssumptions.imply_exists_pointwise_positive_chain
      (ClayExplicitRawDataAssumptions.to_existential_fully_raw_assumptions h)

end RussoYM

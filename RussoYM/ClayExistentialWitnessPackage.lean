import RussoYM.ClayExistentialFullyRawTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Existential Witness Package

This file extracts the concrete witness data from the existential fully raw
Clay theorem.

From existential fully raw assumptions, we recover witnesses:

1. the finite-regulator witness `mu * (delta / C)^2`,
2. the intermediate transfer witness `Delta0`,
3. the positive continuum Yang--Mills gap.
-/

/--
Existential fully raw assumptions give a concrete witness package.
-/
theorem ClayExistentialFullyRawAssumptions.imply_exists_concrete_witness_package
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
        ∧ ((0 < mu * (delta / C)^2
              ∧ forall n, mu * (delta / C)^2 <= Gap n)
            ∧ (0 < Delta0
                ∧ Delta0 <= DeltaFine
                ∧ Delta0 <= DeltaYM)
            ∧ 0 < DeltaYM) := by
  rcases h.exists_raw_data with
    ⟨DeltaFine, Delta0, dUV, C, mu, delta, hRaw⟩
  exact
    ⟨DeltaFine, Delta0, dUV, C, mu, delta,
      hRaw,
      ClayFullyRawAssumptions.imply_concrete_witness_package hRaw⟩

/--
Existential fully raw assumptions give the explicit finite-regulator gap witness.
-/
theorem ClayExistentialFullyRawAssumptions.imply_exists_explicit_finite_gap_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (h :
      ClayExistentialFullyRawAssumptions
        links Gap Energy curvatureNorm DeltaYM) :
    ∃ Delta DeltaFine Delta0 dUV C mu delta : Real,
      ClayFullyRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta
        ∧ Delta = mu * (delta / C)^2
        ∧ 0 < Delta
        ∧ forall n, Delta <= Gap n := by
  rcases h.exists_raw_data with
    ⟨DeltaFine, Delta0, dUV, C, mu, delta, hRaw⟩
  exact
    ⟨mu * (delta / C)^2,
      DeltaFine, Delta0, dUV, C, mu, delta,
      hRaw,
      rfl,
      (ClayFullyRawAssumptions.imply_concrete_gap_witness hRaw).1,
      (ClayFullyRawAssumptions.imply_concrete_gap_witness hRaw).2⟩

/--
Existential fully raw assumptions give the concrete Delta0 transfer witness.
-/
theorem ClayExistentialFullyRawAssumptions.imply_exists_delta0_transfer_witness
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
        ∧ 0 < Delta0
        ∧ Delta0 <= DeltaFine
        ∧ Delta0 <= DeltaYM := by
  rcases h.exists_raw_data with
    ⟨DeltaFine, Delta0, dUV, C, mu, delta, hRaw⟩
  have hWitness :
      0 < Delta0
        ∧ Delta0 <= DeltaFine
        ∧ Delta0 <= DeltaYM := by
    exact ClayFullyRawAssumptions.imply_concrete_delta0_transfer_witness hRaw
  exact
    ⟨DeltaFine, Delta0, dUV, C, mu, delta,
      hRaw,
      hWitness.1,
      hWitness.2.1,
      hWitness.2.2⟩

/--
Existential fully raw assumptions give the pointwise finite-gap chain.
-/
theorem ClayExistentialFullyRawAssumptions.imply_exists_pointwise_gap_chain
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
        ∧ (forall n,
            delta / C <= curvatureNorm n
              ∧ (delta / C)^2 <= (curvatureNorm n)^2
              ∧ mu * (delta / C)^2 <= Energy n
              ∧ mu * (delta / C)^2 <= Gap n) := by
  rcases h.exists_raw_data with
    ⟨DeltaFine, Delta0, dUV, C, mu, delta, hRaw⟩
  exact
    ⟨DeltaFine, Delta0, dUV, C, mu, delta,
      hRaw,
      ClayFullyRawAssumptions.imply_pointwise_gap_chain_via_raw_holonomy hRaw⟩

/--
Existential fully raw assumptions give the pointwise positivity chain.
-/
theorem ClayExistentialFullyRawAssumptions.imply_exists_pointwise_positive_chain
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
        ∧ 0 < delta / C
        ∧ (forall n, 0 < curvatureNorm n)
        ∧ 0 < mu * (delta / C)^2
        ∧ (forall n, 0 < Energy n)
        ∧ forall n, 0 < Gap n := by
  rcases h.exists_raw_data with
    ⟨DeltaFine, Delta0, dUV, C, mu, delta, hRaw⟩
  have hPos :
      0 < delta / C
        ∧ (forall n, 0 < curvatureNorm n)
        ∧ 0 < mu * (delta / C)^2
        ∧ (forall n, 0 < Energy n)
        ∧ forall n, 0 < Gap n := by
    exact ClayFullyRawAssumptions.imply_pointwise_positive_chain_via_raw_holonomy hRaw
  exact
    ⟨DeltaFine, Delta0, dUV, C, mu, delta,
      hRaw,
      hPos.1,
      hPos.2.1,
      hPos.2.2.1,
      hPos.2.2.2.1,
      hPos.2.2.2.2⟩

end RussoYM

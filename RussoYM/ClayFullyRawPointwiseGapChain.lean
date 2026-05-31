import RussoYM.ClayFullyRawPointwiseConsequences

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Fully Raw Pointwise Gap Chain

This file bridges the pointwise raw holonomy/coercivity gap chain back to the
fully raw Clay assumptions.

The fully raw assumptions imply, for every regulator index `n`:

  delta / C <= curvatureNorm n,
  (delta / C)^2 <= (curvatureNorm n)^2,
  mu * (delta / C)^2 <= Energy n,
  mu * (delta / C)^2 <= Gap n.

This is the explicit pointwise finite-gap mechanism.
-/

/--
Fully raw assumptions imply the pointwise curvature lower bound.
-/
theorem ClayFullyRawAssumptions.imply_curvatureNorm_lower_bound_via_raw_holonomy
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
    forall n, delta / C <= curvatureNorm n := by
  exact
    ClayRawHolonomyAssumptions.imply_curvatureNorm_lower_bound
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw assumptions imply the pointwise squared curvature lower bound.
-/
theorem ClayFullyRawAssumptions.imply_curvatureNorm_square_lower_bound_via_raw_holonomy
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
    forall n, (delta / C)^2 <= (curvatureNorm n)^2 := by
  exact
    ClayRawHolonomyAssumptions.imply_curvatureNorm_square_lower_bound
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw assumptions imply the pointwise energy lower bound by the concrete
finite-regulator witness.
-/
theorem ClayFullyRawAssumptions.imply_energy_lower_by_concrete_witness_via_raw_holonomy
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
    forall n, mu * (delta / C)^2 <= Energy n := by
  exact
    ClayRawHolonomyAssumptions.imply_energy_lower_by_concrete_witness
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw assumptions imply the pointwise gap lower bound by the concrete
finite-regulator witness.
-/
theorem ClayFullyRawAssumptions.imply_gap_lower_by_concrete_witness_pointwise_via_raw_holonomy
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
    forall n, mu * (delta / C)^2 <= Gap n := by
  exact
    ClayRawHolonomyAssumptions.imply_gap_lower_by_concrete_witness_pointwise
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw assumptions imply the full pointwise finite-gap chain.
-/
theorem ClayFullyRawAssumptions.imply_pointwise_gap_chain_via_raw_holonomy
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
    forall n,
      delta / C <= curvatureNorm n
        ∧ (delta / C)^2 <= (curvatureNorm n)^2
        ∧ mu * (delta / C)^2 <= Energy n
        ∧ mu * (delta / C)^2 <= Gap n := by
  exact
    ClayRawHolonomyAssumptions.imply_pointwise_gap_chain
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw assumptions imply both the pointwise finite-gap chain and the
pointwise positivity chain.
-/
theorem ClayFullyRawAssumptions.imply_pointwise_gap_and_positive_chains
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
    (forall n,
      delta / C <= curvatureNorm n
        ∧ (delta / C)^2 <= (curvatureNorm n)^2
        ∧ mu * (delta / C)^2 <= Energy n
        ∧ mu * (delta / C)^2 <= Gap n)
      ∧ (0 < delta / C
          ∧ (forall n, 0 < curvatureNorm n)
          ∧ 0 < mu * (delta / C)^2
          ∧ (forall n, 0 < Energy n)
          ∧ forall n, 0 < Gap n) := by
  exact
    ⟨ClayFullyRawAssumptions.imply_pointwise_gap_chain_via_raw_holonomy h,
      ClayFullyRawAssumptions.imply_pointwise_positive_chain_via_raw_holonomy h⟩

end RussoYM

import RussoYM.ClayRawHolonomyPointwiseConsequences

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Fully Raw Pointwise Consequences

This file bridges the pointwise raw holonomy/coercivity consequences back to
the fully raw Clay assumptions.

The fully raw assumptions contain the raw holonomy/coercivity data, so they
imply pointwise positivity of:

  delta / C,
  curvatureNorm n,
  mu * (delta / C)^2,
  Energy n,
  Gap n.
-/

/--
Fully raw assumptions imply positivity of `delta / C`.
-/
theorem ClayFullyRawAssumptions.imply_delta_div_C_positive_via_raw_holonomy
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
    0 < delta / C := by
  exact
    ClayRawHolonomyAssumptions.imply_delta_div_C_positive
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw assumptions imply pointwise positivity of the curvature norm.
-/
theorem ClayFullyRawAssumptions.imply_curvatureNorm_positive_at_each_n_via_raw_holonomy
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
    forall n, 0 < curvatureNorm n := by
  exact
    ClayRawHolonomyAssumptions.imply_curvatureNorm_positive_at_each_n
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw assumptions imply positivity of the concrete block scale.
-/
theorem ClayFullyRawAssumptions.imply_concrete_block_positive_pointwise_via_raw_holonomy
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
    0 < mu * (delta / C)^2 := by
  exact
    ClayRawHolonomyAssumptions.imply_concrete_block_positive_pointwise
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw assumptions imply pointwise positivity of the energy.
-/
theorem ClayFullyRawAssumptions.imply_energy_positive_at_each_n_via_raw_holonomy
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
    forall n, 0 < Energy n := by
  exact
    ClayRawHolonomyAssumptions.imply_energy_positive_at_each_n
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw assumptions imply pointwise positivity of the finite-regulator gap.
-/
theorem ClayFullyRawAssumptions.imply_gap_positive_at_each_n_pointwise_via_raw_holonomy
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
    forall n, 0 < Gap n := by
  exact
    ClayRawHolonomyAssumptions.imply_gap_positive_at_each_n_pointwise
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw assumptions imply all pointwise positivity consequences.
-/
theorem ClayFullyRawAssumptions.imply_pointwise_positive_chain_via_raw_holonomy
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
    0 < delta / C
      ∧ (forall n, 0 < curvatureNorm n)
      ∧ 0 < mu * (delta / C)^2
      ∧ (forall n, 0 < Energy n)
      ∧ forall n, 0 < Gap n := by
  exact
    ClayRawHolonomyAssumptions.imply_pointwise_positive_chain
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

end RussoYM

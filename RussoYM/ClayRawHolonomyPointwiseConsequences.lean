import RussoYM.ClayRawHolonomyPointwise

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Raw Holonomy Pointwise Consequences

This file extracts positivity consequences from the pointwise raw
holonomy/coercivity gap chain.

The raw pointwise chain gives:

  delta / C <= curvatureNorm n,
  mu * (delta / C)^2 <= Energy n,
  mu * (delta / C)^2 <= Gap n.

Since `delta > 0`, `C > 0`, and `mu > 0`, this implies pointwise positivity of
curvature norm, energy, and finite-regulator gap.
-/

/--
Raw holonomy assumptions imply positivity of `delta / C`.
-/
theorem ClayRawHolonomyAssumptions.imply_delta_div_C_positive
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    0 < delta / C := by
  exact div_pos h.hDelta_pos h.hC_pos

/--
Raw holonomy assumptions imply pointwise positivity of the curvature norm.
-/
theorem ClayRawHolonomyAssumptions.imply_curvatureNorm_positive_at_each_n
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    forall n, 0 < curvatureNorm n := by
  intro n
  have hdelta_div_pos : 0 < delta / C := by
    exact ClayRawHolonomyAssumptions.imply_delta_div_C_positive h
  have hcurv_lower :
      delta / C <= curvatureNorm n := by
    exact ClayRawHolonomyAssumptions.imply_curvatureNorm_lower_bound h n
  exact lt_of_lt_of_le hdelta_div_pos hcurv_lower

/--
Raw holonomy assumptions imply pointwise positivity of the concrete block scale.
-/
theorem ClayRawHolonomyAssumptions.imply_concrete_block_positive_pointwise
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    0 < mu * (delta / C)^2 := by
  exact ClayRawHolonomyAssumptions.imply_block_scale_positive h

/--
Raw holonomy assumptions imply pointwise positivity of the energy.
-/
theorem ClayRawHolonomyAssumptions.imply_energy_positive_at_each_n
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    forall n, 0 < Energy n := by
  intro n
  have hblock_pos :
      0 < mu * (delta / C)^2 := by
    exact ClayRawHolonomyAssumptions.imply_concrete_block_positive_pointwise h
  have hEnergyLower :
      mu * (delta / C)^2 <= Energy n := by
    exact ClayRawHolonomyAssumptions.imply_energy_lower_by_concrete_witness h n
  exact lt_of_lt_of_le hblock_pos hEnergyLower

/--
Raw holonomy assumptions imply pointwise positivity of the finite-regulator gap.
-/
theorem ClayRawHolonomyAssumptions.imply_gap_positive_at_each_n_pointwise
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    forall n, 0 < Gap n := by
  intro n
  have hblock_pos :
      0 < mu * (delta / C)^2 := by
    exact ClayRawHolonomyAssumptions.imply_concrete_block_positive_pointwise h
  have hGapLower :
      mu * (delta / C)^2 <= Gap n := by
    exact ClayRawHolonomyAssumptions.imply_gap_lower_by_concrete_witness_pointwise h n
  exact lt_of_lt_of_le hblock_pos hGapLower

/--
Raw holonomy assumptions imply all pointwise positivity consequences together.
-/
theorem ClayRawHolonomyAssumptions.imply_pointwise_positive_chain
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    0 < delta / C
      ∧ (forall n, 0 < curvatureNorm n)
      ∧ 0 < mu * (delta / C)^2
      ∧ (forall n, 0 < Energy n)
      ∧ forall n, 0 < Gap n := by
  exact
    ⟨ClayRawHolonomyAssumptions.imply_delta_div_C_positive h,
      ClayRawHolonomyAssumptions.imply_curvatureNorm_positive_at_each_n h,
      ClayRawHolonomyAssumptions.imply_concrete_block_positive_pointwise h,
      ClayRawHolonomyAssumptions.imply_energy_positive_at_each_n h,
      ClayRawHolonomyAssumptions.imply_gap_positive_at_each_n_pointwise h⟩

end RussoYM

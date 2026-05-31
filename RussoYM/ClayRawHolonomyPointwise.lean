import RussoYM.ClayConcreteDelta0Witness

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Raw Holonomy Pointwise Chain

This file extracts the pointwise algebra behind the raw holonomy/coercivity
finite-gap route.

The chain is:

  delta <= ‖1 - prod links‖
  ‖1 - prod links‖ <= C * curvatureNorm n

therefore, since 0 < C,

  delta / C <= curvatureNorm n.

Then, using 0 < mu and energy coercivity,

  mu * (delta / C)^2 <= Energy n,

and finally the finite gap lower bound gives

  mu * (delta / C)^2 <= Gap n.
-/

/--
Raw holonomy assumptions imply the pointwise combined holonomy-curvature bound.
-/
theorem ClayRawHolonomyAssumptions.imply_delta_le_C_mul_curvatureNorm
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    forall n, delta <= C * curvatureNorm n := by
  intro n
  exact le_trans (h.hHolonomySep n) (h.hHolonomyControl n)

/--
Raw holonomy assumptions imply the pointwise curvature lower bound.
-/
theorem ClayRawHolonomyAssumptions.imply_curvatureNorm_lower_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    forall n, delta / C <= curvatureNorm n := by
  intro n
  have hdelta_le_Ccurv :
      delta <= C * curvatureNorm n := by
    exact ClayRawHolonomyAssumptions.imply_delta_le_C_mul_curvatureNorm h n
  rw [div_le_iff₀ h.hC_pos]
  nlinarith [hdelta_le_Ccurv]

/--
Raw holonomy assumptions imply the pointwise squared curvature lower bound.
-/
theorem ClayRawHolonomyAssumptions.imply_curvatureNorm_square_lower_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    forall n, (delta / C)^2 <= (curvatureNorm n)^2 := by
  intro n
  have hcurv_lower :
      delta / C <= curvatureNorm n := by
    exact ClayRawHolonomyAssumptions.imply_curvatureNorm_lower_bound h n
  have hdelta_div_pos : 0 < delta / C := by
    exact div_pos h.hDelta_pos h.hC_pos
  nlinarith

/--
Raw holonomy assumptions imply the pointwise energy lower bound by the concrete
finite-regulator witness.
-/
theorem ClayRawHolonomyAssumptions.imply_energy_lower_by_concrete_witness
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    forall n, mu * (delta / C)^2 <= Energy n := by
  intro n
  have hsquare :
      (delta / C)^2 <= (curvatureNorm n)^2 := by
    exact ClayRawHolonomyAssumptions.imply_curvatureNorm_square_lower_bound h n
  have hmul :
      mu * (delta / C)^2 <= mu * (curvatureNorm n)^2 := by
    exact mul_le_mul_of_nonneg_left hsquare (le_of_lt h.hMu_pos)
  exact le_trans hmul (h.hEnergyCoercive n)

/--
Raw holonomy assumptions imply the pointwise gap lower bound by the concrete
finite-regulator witness.
-/
theorem ClayRawHolonomyAssumptions.imply_gap_lower_by_concrete_witness_pointwise
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    forall n, mu * (delta / C)^2 <= Gap n := by
  intro n
  exact le_trans
    (ClayRawHolonomyAssumptions.imply_energy_lower_by_concrete_witness h n)
    (h.hGapLower n)

/--
Raw holonomy assumptions imply the full pointwise finite-gap chain.
-/
theorem ClayRawHolonomyAssumptions.imply_pointwise_gap_chain
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    forall n,
      delta / C <= curvatureNorm n
        ∧ (delta / C)^2 <= (curvatureNorm n)^2
        ∧ mu * (delta / C)^2 <= Energy n
        ∧ mu * (delta / C)^2 <= Gap n := by
  intro n
  exact
    ⟨ClayRawHolonomyAssumptions.imply_curvatureNorm_lower_bound h n,
      ClayRawHolonomyAssumptions.imply_curvatureNorm_square_lower_bound h n,
      ClayRawHolonomyAssumptions.imply_energy_lower_by_concrete_witness h n,
      ClayRawHolonomyAssumptions.imply_gap_lower_by_concrete_witness_pointwise h n⟩

end RussoYM

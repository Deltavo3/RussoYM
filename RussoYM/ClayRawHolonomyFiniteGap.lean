import RussoYM.ClayFullyRawSummary

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Raw Holonomy Finite Gap

This file starts the analytic phase by isolating the raw holonomy/coercivity
data needed to produce a positive finite-regulator gap.

The raw holonomy/coercivity data are:

1. 0 < delta,
2. forall n, delta <= ‖1 - (links n).prod‖,
3. 0 < C,
4. forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n,
5. 0 < mu,
6. forall n, mu * (curvatureNorm n)^2 <= Energy n,
7. forall n, Energy n <= Gap n.

From these, the finite gap lower bound follows:

  ∃ Delta, 0 < Delta ∧ forall n, Delta <= Gap n.

The concrete choice is

  Delta = mu * (delta / C)^2.
-/

/--
Raw holonomy/coercivity assumptions.
-/
structure ClayRawHolonomyAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (C mu delta : Real) : Prop where
  hDelta_pos :
    0 < delta
  hHolonomySep :
    forall n, delta <= ‖1 - (links n).prod‖
  hC_pos :
    0 < C
  hHolonomyControl :
    forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n
  hMu_pos :
    0 < mu
  hEnergyCoercive :
    forall n, mu * (curvatureNorm n)^2 <= Energy n
  hGapLower :
    forall n, Energy n <= Gap n

/--
Raw holonomy/coercivity assumptions imply the holonomy primitive obligation.
-/
theorem ClayRawHolonomyAssumptions.to_holonomy_primitive_obligation
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    ClayHolonomyPrimitiveObligation
      links Gap Energy curvatureNorm C mu delta := by
  exact
    ClayHolonomyPrimitiveObligation.of_packets
      (UniformHolonomySeparationAssumptions.of_raw
        h.hDelta_pos h.hHolonomySep)
      (UniformHolonomyCurvatureControlAssumptions.of_raw
        h.hC_pos h.hHolonomyControl)
      (UniformCurvatureCoercivityAssumptions.of_raw
        h.hMu_pos h.hEnergyCoercive)
      (UniformGapLowerBoundAssumptions.of_raw
        h.hGapLower)

/--
Raw holonomy/coercivity assumptions imply positivity of the block scale.
-/
theorem ClayRawHolonomyAssumptions.imply_block_scale_positive
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
  exact
    ClayHolonomyPrimitiveObligation.imply_block_scale_positive
      (ClayRawHolonomyAssumptions.to_holonomy_primitive_obligation h)

/--
Raw holonomy/coercivity assumptions imply the uniform finite gap lower bound.
-/
theorem ClayRawHolonomyAssumptions.imply_uniform_gap_lower
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
  exact
    (UniformHolonomyRedLemmaAssumptions.imply_uniform_positive_gap
      (ClayRawHolonomyAssumptions.to_holonomy_primitive_obligation h)).1

/--
Raw holonomy/coercivity assumptions imply a positive finite-regulator gap.
-/
theorem ClayRawHolonomyAssumptions.imply_finite_gap_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    ∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n := by
  exact
    ClayHolonomyPrimitiveObligation.imply_finite_gap_bound
      (ClayRawHolonomyAssumptions.to_holonomy_primitive_obligation h)

/--
Raw holonomy/coercivity assumptions imply each finite-regulator gap value is
positive.
-/
theorem ClayRawHolonomyAssumptions.imply_gap_positive_at_each_n
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
  have hBlock_pos :
      0 < mu * (delta / C)^2 := by
    exact ClayRawHolonomyAssumptions.imply_block_scale_positive h
  have hLower :
      mu * (delta / C)^2 <= Gap n := by
    exact ClayRawHolonomyAssumptions.imply_uniform_gap_lower h n
  exact lt_of_lt_of_le hBlock_pos hLower

end RussoYM

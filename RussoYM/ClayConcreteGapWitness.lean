import RussoYM.ClayFullyRawDecomposedTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Concrete Gap Witness

This file records the explicit finite-regulator gap witness produced by the raw
holonomy/coercivity route.

The concrete finite-regulator witness is

  Delta = mu * (delta / C)^2.

This is the finite gap lower bound extracted from raw holonomy separation,
holonomy-curvature control, curvature coercivity, and gap lower data.
-/

/--
Raw holonomy/coercivity assumptions give the concrete finite-regulator witness.
-/
theorem ClayRawHolonomyAssumptions.imply_concrete_gap_witness
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    0 < mu * (delta / C)^2
      ∧ forall n, mu * (delta / C)^2 <= Gap n := by
  exact
    ⟨ClayRawHolonomyAssumptions.imply_block_scale_positive h,
      ClayRawHolonomyAssumptions.imply_uniform_gap_lower h⟩

/--
Raw holonomy/coercivity assumptions give an existential finite-regulator gap
with the concrete witness recorded.
-/
theorem ClayRawHolonomyAssumptions.imply_explicit_finite_gap_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayRawHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    ∃ Delta : Real,
      Delta = mu * (delta / C)^2
        ∧ 0 < Delta
        ∧ forall n, Delta <= Gap n := by
  refine ⟨mu * (delta / C)^2, rfl, ?_, ?_⟩
  · exact ClayRawHolonomyAssumptions.imply_block_scale_positive h
  · exact ClayRawHolonomyAssumptions.imply_uniform_gap_lower h

/--
Fully raw assumptions give the concrete finite-regulator witness.
-/
theorem ClayFullyRawAssumptions.imply_concrete_gap_witness
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
    0 < mu * (delta / C)^2
      ∧ forall n, mu * (delta / C)^2 <= Gap n := by
  exact
    ClayRawHolonomyAssumptions.imply_concrete_gap_witness
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw assumptions give an existential finite-regulator gap with the concrete
witness recorded.
-/
theorem ClayFullyRawAssumptions.imply_explicit_finite_gap_bound
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
    ∃ Delta : Real,
      Delta = mu * (delta / C)^2
        ∧ 0 < Delta
        ∧ forall n, Delta <= Gap n := by
  exact
    ClayRawHolonomyAssumptions.imply_explicit_finite_gap_bound
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw assumptions give the concrete finite-regulator witness together with
the positive continuum Yang--Mills gap.
-/
theorem ClayFullyRawAssumptions.imply_concrete_gap_witness_and_continuum_gap
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
      ∧ 0 < DeltaYM := by
  exact
    ⟨ClayFullyRawAssumptions.imply_concrete_gap_witness h,
      ClayFullyRawAssumptions.imply_positive_continuum_gap_decomposed h⟩

end RussoYM

import RussoYM.ClayRawHolonomyFiniteGap

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Fully Raw Holonomy Bridge

This file connects the fully raw Clay assumptions to the isolated raw
holonomy/coercivity assumptions.

It records that the fully raw theorem contains enough raw holonomy/coercivity
data to produce the positive finite-regulator gap.
-/

/--
Fully raw Clay assumptions imply raw holonomy/coercivity assumptions.
-/
theorem ClayFullyRawAssumptions.to_raw_holonomy_assumptions
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
    ClayRawHolonomyAssumptions
      links Gap Energy curvatureNorm C mu delta := by
  exact
    { hDelta_pos := h.hDelta_pos
      hHolonomySep := h.hHolonomySep
      hC_pos := h.hC_pos
      hHolonomyControl := h.hHolonomyControl
      hMu_pos := h.hMu_pos
      hEnergyCoercive := h.hEnergyCoercive
      hGapLower := h.hGapLower }

/--
Fully raw Clay assumptions imply block scale positivity via raw holonomy data.
-/
theorem ClayFullyRawAssumptions.imply_block_scale_positive_via_raw_holonomy
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
    ClayRawHolonomyAssumptions.imply_block_scale_positive
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw Clay assumptions imply the uniform finite-regulator gap lower bound
via raw holonomy data.
-/
theorem ClayFullyRawAssumptions.imply_uniform_gap_lower_via_raw_holonomy
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
    ClayRawHolonomyAssumptions.imply_uniform_gap_lower
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw Clay assumptions imply a positive finite-regulator gap via raw
holonomy data.
-/
theorem ClayFullyRawAssumptions.imply_finite_gap_bound_via_raw_holonomy
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
    ∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n := by
  exact
    ClayRawHolonomyAssumptions.imply_finite_gap_bound
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

/--
Fully raw Clay assumptions imply positivity of each finite-regulator gap value.
-/
theorem ClayFullyRawAssumptions.imply_gap_positive_at_each_n_via_raw_holonomy
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
    ClayRawHolonomyAssumptions.imply_gap_positive_at_each_n
      (ClayFullyRawAssumptions.to_raw_holonomy_assumptions h)

end RussoYM

import RussoYM.ClayRawPrimitiveAudit

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Holonomy Primitive

This file begins opening the remaining holonomy/coercivity primitive packet.

The holonomy primitive obligation is currently the main named packet left in the
raw primitive theorem.  This file exposes its internal assumptions:

1. uniform holonomy separation,
2. uniform holonomy curvature control,
3. uniform curvature coercivity,
4. uniform finite gap lower bound.

The goal is to isolate the remaining analytic work before proving these pieces
from deeper geometry/analysis.
-/

/--
Construct the holonomy primitive obligation from its four constituent packets.
-/
theorem ClayHolonomyPrimitiveObligation.of_packets
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (hSep :
      UniformHolonomySeparationAssumptions links delta)
    (hControl :
      UniformHolonomyCurvatureControlAssumptions links curvatureNorm C)
    (hCoercive :
      UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu)
    (hGapLower :
      UniformGapLowerBoundAssumptions Gap Energy) :
    ClayHolonomyPrimitiveObligation
      links Gap Energy curvatureNorm C mu delta := by
  exact
    { separation := hSep
      curvatureControl := hControl
      coercivity := hCoercive
      gapLower := hGapLower }

/--
Audit: expose uniform holonomy separation.
-/
theorem ClayHolonomyPrimitiveObligation.audit_holonomy_separation
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta) :
    UniformHolonomySeparationAssumptions links delta := by
exact h.separation

/--
Audit: expose uniform holonomy curvature control.
-/
theorem ClayHolonomyPrimitiveObligation.audit_holonomy_curvature_control
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta) :
    UniformHolonomyCurvatureControlAssumptions links curvatureNorm C := by
exact h.curvatureControl

/--
Audit: expose uniform curvature coercivity.
-/
theorem ClayHolonomyPrimitiveObligation.audit_curvature_coercivity
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta) :
    UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu := by
exact h.coercivity

/--
Audit: expose the uniform finite gap lower bound.
-/
theorem ClayHolonomyPrimitiveObligation.audit_finite_gap_lower
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta) :
    UniformGapLowerBoundAssumptions Gap Energy := by
exact h.gapLower

/--
Holonomy primitive obligation gives positivity of the concrete block scale.
-/
theorem ClayHolonomyPrimitiveObligation.imply_block_scale_positive
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta) :
    0 < mu * (delta / C)^2 := by
  exact UniformHolonomyRedLemmaAssumptions.imply_block_scale_positive h

/--
Holonomy primitive obligation gives the uniform finite-regulator gap bound.
-/
theorem ClayHolonomyPrimitiveObligation.imply_finite_gap_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta) :
    ∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n := by
  exact
    ⟨mu * (delta / C)^2,
      ClayHolonomyPrimitiveObligation.imply_block_scale_positive h,
      (UniformHolonomyRedLemmaAssumptions.imply_uniform_positive_gap h).1⟩

/--
Audit: expose all four constituent holonomy primitive packets.
-/
theorem ClayHolonomyPrimitiveObligation.audit_all_packets
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta) :
    UniformHolonomySeparationAssumptions links delta
      ∧ UniformHolonomyCurvatureControlAssumptions links curvatureNorm C
      ∧ UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu
      ∧ UniformGapLowerBoundAssumptions Gap Energy := by
  exact
    ⟨ClayHolonomyPrimitiveObligation.audit_holonomy_separation h,
      ClayHolonomyPrimitiveObligation.audit_holonomy_curvature_control h,
      ClayHolonomyPrimitiveObligation.audit_curvature_coercivity h,
      ClayHolonomyPrimitiveObligation.audit_finite_gap_lower h⟩

end RussoYM

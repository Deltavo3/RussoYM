import RussoYM.ClayHolonomyExpandedRawAudit

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Holonomy Subpacket Primitives

This file opens the four holonomy/coercivity subpackets into their raw fields.

The holonomy-expanded raw theorem now assumes:

1. UniformHolonomySeparationAssumptions,
2. UniformHolonomyCurvatureControlAssumptions,
3. UniformCurvatureCoercivityAssumptions,
4. UniformGapLowerBoundAssumptions.

This file gives direct constructors and audits for each of these subpackets.
-/

/--
Construct uniform holonomy separation from raw positivity and separation.
-/
theorem UniformHolonomySeparationAssumptions.of_raw
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {delta : Real}
    (hDelta_pos : 0 < delta)
    (hSep : forall n, delta <= ‖1 - (links n).prod‖) :
    UniformHolonomySeparationAssumptions links delta := by
  exact
    { delta_positive := hDelta_pos
      holonomy_separation := hSep }

/--
Audit: uniform holonomy separation gives positivity of delta.
-/
theorem UniformHolonomySeparationAssumptions.audit_delta_positive
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {delta : Real}
    (h :
      UniformHolonomySeparationAssumptions links delta) :
    0 < delta := by
  exact h.delta_positive

/--
Audit: uniform holonomy separation gives the raw separation bound.
-/
theorem UniformHolonomySeparationAssumptions.audit_holonomy_separation
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {delta : Real}
    (h :
      UniformHolonomySeparationAssumptions links delta) :
    forall n, delta <= ‖1 - (links n).prod‖ := by
  exact h.holonomy_separation

/--
Construct uniform holonomy-curvature control from raw positivity and control.
-/
theorem UniformHolonomyCurvatureControlAssumptions.of_raw
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {curvatureNorm : Nat -> Real}
    {C : Real}
    (hC_pos : 0 < C)
    (hControl : forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) :
    UniformHolonomyCurvatureControlAssumptions links curvatureNorm C := by
  exact
    { C_positive := hC_pos
      holonomy_curvature_control := hControl }

/--
Audit: uniform holonomy-curvature control gives positivity of C.
-/
theorem UniformHolonomyCurvatureControlAssumptions.audit_C_positive
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {curvatureNorm : Nat -> Real}
    {C : Real}
    (h :
      UniformHolonomyCurvatureControlAssumptions links curvatureNorm C) :
    0 < C := by
  exact h.C_positive

/--
Audit: uniform holonomy-curvature control gives the raw control bound.
-/
theorem UniformHolonomyCurvatureControlAssumptions.audit_holonomy_curvature_control
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {curvatureNorm : Nat -> Real}
    {C : Real}
    (h :
      UniformHolonomyCurvatureControlAssumptions links curvatureNorm C) :
    forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n := by
  exact h.holonomy_curvature_control

/--
Construct uniform curvature coercivity from raw positivity and coercivity.
-/
theorem UniformCurvatureCoercivityAssumptions.of_raw
    {Energy curvatureNorm : Nat -> Real}
    {mu : Real}
    (hMu_pos : 0 < mu)
    (hCoercive : forall n, mu * (curvatureNorm n)^2 <= Energy n) :
    UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu := by
  exact
    { mu_positive := hMu_pos
      energy_coercive := hCoercive }

/--
Audit: uniform curvature coercivity gives positivity of mu.
-/
theorem UniformCurvatureCoercivityAssumptions.audit_mu_positive
    {Energy curvatureNorm : Nat -> Real}
    {mu : Real}
    (h :
      UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu) :
    0 < mu := by
  exact h.mu_positive

/--
Audit: uniform curvature coercivity gives the raw energy coercivity bound.
-/
theorem UniformCurvatureCoercivityAssumptions.audit_energy_coercive
    {Energy curvatureNorm : Nat -> Real}
    {mu : Real}
    (h :
      UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu) :
    forall n, mu * (curvatureNorm n)^2 <= Energy n := by
  exact h.energy_coercive

/--
Construct uniform finite gap lower bound from the raw gap lower inequality.
-/
theorem UniformGapLowerBoundAssumptions.of_raw
    {Gap Energy : Nat -> Real}
    (hLower : forall n, Energy n <= Gap n) :
    UniformGapLowerBoundAssumptions Gap Energy := by
  exact
    { gap_lower_bound := hLower }

/--
Audit: uniform finite gap lower bound gives the raw gap lower inequality.
-/
theorem UniformGapLowerBoundAssumptions.audit_gap_lower_bound
    {Gap Energy : Nat -> Real}
    (h :
      UniformGapLowerBoundAssumptions Gap Energy) :
    forall n, Energy n <= Gap n := by
  exact h.gap_lower_bound

end RussoYM

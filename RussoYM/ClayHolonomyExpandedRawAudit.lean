import RussoYM.ClayHolonomyExpandedRawTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Holonomy-Expanded Raw Audit

This file audits the current holonomy-expanded raw Clay theorem.

At this stage, the final raw theorem assumes the four holonomy packets directly,
together with raw scale, raw Schur/Feshbach, and raw continuum survival data.

This is the cleanest current endpoint before opening the individual holonomy
subpackets.
-/

/--
Audit: expose uniform holonomy separation.
-/
theorem ClayHolonomyExpandedRawAssumptions.audit_separation
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    UniformHolonomySeparationAssumptions links delta := by
  exact h.separation

/--
Audit: expose uniform holonomy curvature control.
-/
theorem ClayHolonomyExpandedRawAssumptions.audit_curvature_control
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    UniformHolonomyCurvatureControlAssumptions links curvatureNorm C := by
  exact h.curvatureControl

/--
Audit: expose uniform curvature coercivity.
-/
theorem ClayHolonomyExpandedRawAssumptions.audit_coercivity
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu := by
  exact h.coercivity

/--
Audit: expose uniform finite gap lower bound.
-/
theorem ClayHolonomyExpandedRawAssumptions.audit_gap_lower
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    UniformGapLowerBoundAssumptions Gap Energy := by
  exact h.gapLower

/--
Audit: expose UV positivity.
-/
theorem ClayHolonomyExpandedRawAssumptions.audit_uv_positive
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < dUV := by
  exact h.hUV_pos

/--
Audit: expose Delta0 normalization.
-/
theorem ClayHolonomyExpandedRawAssumptions.audit_delta0_definition
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV := by
  exact h.hDelta0_def

/--
Audit: expose raw Schur/Feshbach loss bounds.
-/
theorem ClayHolonomyExpandedRawAssumptions.audit_raw_schur_bounds
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ∃ loss : Real,
      loss <= Delta0
        ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine := by
  exact h.existsRawSchur

/--
Audit: expose direct continuum survival.
-/
theorem ClayHolonomyExpandedRawAssumptions.audit_continuum_survival
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 <= DeltaYM := by
  exact h.hContinuumSurvival

/--
Audit: expose all current holonomy-expanded raw assumptions together.
-/
theorem ClayHolonomyExpandedRawAssumptions.audit_all_holonomy_expanded_raw_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayHolonomyExpandedRawAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    UniformHolonomySeparationAssumptions links delta
      ∧ UniformHolonomyCurvatureControlAssumptions links curvatureNorm C
      ∧ UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu
      ∧ UniformGapLowerBoundAssumptions Gap Energy
      ∧ 0 < dUV
      ∧ Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV
      ∧ (∃ loss : Real,
          loss <= Delta0
            ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine)
      ∧ Delta0 <= DeltaYM := by
  exact
    ⟨ClayHolonomyExpandedRawAssumptions.audit_separation h,
      ClayHolonomyExpandedRawAssumptions.audit_curvature_control h,
      ClayHolonomyExpandedRawAssumptions.audit_coercivity h,
      ClayHolonomyExpandedRawAssumptions.audit_gap_lower h,
      ClayHolonomyExpandedRawAssumptions.audit_uv_positive h,
      ClayHolonomyExpandedRawAssumptions.audit_delta0_definition h,
      ClayHolonomyExpandedRawAssumptions.audit_raw_schur_bounds h,
      ClayHolonomyExpandedRawAssumptions.audit_continuum_survival h⟩

end RussoYM

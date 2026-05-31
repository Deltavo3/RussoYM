import RussoYM.ClayRawPrimitiveTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Raw Primitive Audit

This file audits the current raw primitive Clay theorem.

At this stage, the theorem assumes:

1. a holonomy/coercivity primitive packet,
2. raw UV positivity,
3. raw Delta0 normalization,
4. raw Schur/Feshbach loss bounds,
5. raw continuum survival.

This is the cleanest audit before opening the holonomy/coercivity packet.
-/

/--
The raw primitive assumptions expose the holonomy primitive obligation.
-/
theorem ClayRawPrimitiveAssumptions.audit_holonomy_obligation
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayRawPrimitiveAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ClayHolonomyPrimitiveObligation
      links Gap Energy curvatureNorm C mu delta := by
  exact h.holonomyObligation

/--
The raw primitive assumptions expose UV positivity.
-/
theorem ClayRawPrimitiveAssumptions.audit_uv_positive
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayRawPrimitiveAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < dUV := by
  exact h.hUV_pos

/--
The raw primitive assumptions expose the Delta0 normalization.
-/
theorem ClayRawPrimitiveAssumptions.audit_delta0_definition
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayRawPrimitiveAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV := by
  exact h.hDelta0_def

/--
The raw primitive assumptions expose the raw Schur/Feshbach loss bounds.
-/
theorem ClayRawPrimitiveAssumptions.audit_raw_schur_bounds
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayRawPrimitiveAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ∃ loss : Real,
      loss <= Delta0
        ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine := by
  exact h.existsRawSchur

/--
The raw primitive assumptions expose the direct continuum survival inequality.
-/
theorem ClayRawPrimitiveAssumptions.audit_continuum_survival
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayRawPrimitiveAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 <= DeltaYM := by
  exact h.hContinuumSurvival

/--
Raw primitive audit: all current raw obligations exposed together.
-/
theorem ClayRawPrimitiveAssumptions.audit_all_raw_obligations
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayRawPrimitiveAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ClayHolonomyPrimitiveObligation
      links Gap Energy curvatureNorm C mu delta
      ∧ 0 < dUV
      ∧ Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV
      ∧ (∃ loss : Real,
          loss <= Delta0
            ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine)
      ∧ Delta0 <= DeltaYM := by
  exact
    ⟨ClayRawPrimitiveAssumptions.audit_holonomy_obligation h,
      ClayRawPrimitiveAssumptions.audit_uv_positive h,
      ClayRawPrimitiveAssumptions.audit_delta0_definition h,
      ClayRawPrimitiveAssumptions.audit_raw_schur_bounds h,
      ClayRawPrimitiveAssumptions.audit_continuum_survival h⟩

end RussoYM

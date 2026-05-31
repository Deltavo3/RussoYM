import RussoYM.ClayFullyRawTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Fully Raw Audit

This file audits the fully raw conditional Clay theorem.

At this stage, all packaged red-lemma assumptions have been expanded into raw
positivity and inequality data.

This is the cleanest current endpoint before beginning the genuinely analytic
proof phase.
-/

/--
Audit: fully raw assumptions expose positivity of delta.
-/
theorem ClayFullyRawAssumptions.audit_delta_positive
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
    0 < delta := by
  exact h.hDelta_pos

/--
Audit: fully raw assumptions expose uniform holonomy separation.
-/
theorem ClayFullyRawAssumptions.audit_holonomy_separation
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
    forall n, delta <= ‖1 - (links n).prod‖ := by
  exact h.hHolonomySep

/--
Audit: fully raw assumptions expose positivity of C.
-/
theorem ClayFullyRawAssumptions.audit_C_positive
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
    0 < C := by
  exact h.hC_pos

/--
Audit: fully raw assumptions expose holonomy-curvature control.
-/
theorem ClayFullyRawAssumptions.audit_holonomy_control
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
    forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n := by
  exact h.hHolonomyControl

/--
Audit: fully raw assumptions expose positivity of mu.
-/
theorem ClayFullyRawAssumptions.audit_mu_positive
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
    0 < mu := by
  exact h.hMu_pos

/--
Audit: fully raw assumptions expose energy coercivity.
-/
theorem ClayFullyRawAssumptions.audit_energy_coercive
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
    forall n, mu * (curvatureNorm n)^2 <= Energy n := by
  exact h.hEnergyCoercive

/--
Audit: fully raw assumptions expose the finite gap lower bound.
-/
theorem ClayFullyRawAssumptions.audit_gap_lower
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
    forall n, Energy n <= Gap n := by
  exact h.hGapLower

/--
Audit: fully raw assumptions expose UV positivity.
-/
theorem ClayFullyRawAssumptions.audit_uv_positive
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
    0 < dUV := by
  exact h.hUV_pos

/--
Audit: fully raw assumptions expose the Delta0 normalization.
-/
theorem ClayFullyRawAssumptions.audit_delta0_definition
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
    Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV := by
  exact h.hDelta0_def

/--
Audit: fully raw assumptions expose the raw Schur/Feshbach bounds.
-/
theorem ClayFullyRawAssumptions.audit_raw_schur_bounds
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
    ∃ loss : Real,
      loss <= Delta0
        ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine := by
  exact h.existsRawSchur

/--
Audit: fully raw assumptions expose direct continuum survival.
-/
theorem ClayFullyRawAssumptions.audit_continuum_survival
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
    Delta0 <= DeltaYM := by
  exact h.hContinuumSurvival

/--
Audit: fully raw assumptions expose all current raw data together.
-/
theorem ClayFullyRawAssumptions.audit_all_fully_raw_data
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
    0 < delta
      ∧ (forall n, delta <= ‖1 - (links n).prod‖)
      ∧ 0 < C
      ∧ (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n)
      ∧ 0 < mu
      ∧ (forall n, mu * (curvatureNorm n)^2 <= Energy n)
      ∧ (forall n, Energy n <= Gap n)
      ∧ 0 < dUV
      ∧ Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV
      ∧ (∃ loss : Real,
          loss <= Delta0
            ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine)
      ∧ Delta0 <= DeltaYM := by
  exact
    ⟨ClayFullyRawAssumptions.audit_delta_positive h,
      ClayFullyRawAssumptions.audit_holonomy_separation h,
      ClayFullyRawAssumptions.audit_C_positive h,
      ClayFullyRawAssumptions.audit_holonomy_control h,
      ClayFullyRawAssumptions.audit_mu_positive h,
      ClayFullyRawAssumptions.audit_energy_coercive h,
      ClayFullyRawAssumptions.audit_gap_lower h,
      ClayFullyRawAssumptions.audit_uv_positive h,
      ClayFullyRawAssumptions.audit_delta0_definition h,
      ClayFullyRawAssumptions.audit_raw_schur_bounds h,
      ClayFullyRawAssumptions.audit_continuum_survival h⟩

end RussoYM

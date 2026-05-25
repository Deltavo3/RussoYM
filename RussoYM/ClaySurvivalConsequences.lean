import RussoYM.ClaySurvivalAudit
import RussoYM.ClayDerivedContinuumAudit

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Survival Consequences

This file records the direct consequences of the survival audit.

The purpose is to make the epsilon-continuum survival route explicit:

  ClaySurvivalAudit
  -> finite gap bound
  -> Layer-One fine gap data
  -> continuum gap data
  -> strongest conditional mass-gap data.
-/

/--
The survival audit implies Layer-One fine gap data.
-/
theorem ClaySurvivalAudit.imply_layer_one_fine_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClaySurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact
    ClayDerivedFineGapAudit.imply_layer_one_fine_gap_data
      (ClaySurvivalAudit.to_derived_fine_gap_audit h)

/--
The survival audit implies continuum gap data.
-/
theorem ClaySurvivalAudit.imply_continuum_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClaySurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact
    ClayDerivedFineGapAudit.imply_continuum_gap_data
      (ClaySurvivalAudit.to_derived_fine_gap_audit h)

/--
The survival audit implies both fine gap data and continuum gap data.
-/
theorem ClaySurvivalAudit.imply_fine_and_continuum_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClaySurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM) := by
  exact
    ⟨ClaySurvivalAudit.imply_layer_one_fine_gap_data h,
      ClaySurvivalAudit.imply_continuum_gap_data h⟩

/--
The survival audit implies the full strongest conditional Yang--Mills gap data.
-/
theorem ClaySurvivalAudit.imply_full_survival_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClaySurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClaySurvivalAudit.imply_strongest_conditional_gap_data h

end RussoYM

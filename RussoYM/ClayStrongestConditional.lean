import RussoYM.ClayDerivedContinuumAudit

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Strongest Conditional Endpoint

This file exposes the strongest current conditional Yang--Mills mass-gap
endpoint obtained from the audited RussoYM route.

It packages, from the current strongest audit assumptions:

1. a positive finite-volume gap lower bound,
2. Layer-One fine gap data,
3. continuum gap data,
4. the headline conditional mass-gap summary.
-/

/--
Strongest conditional Yang--Mills gap data currently available from the audited
route.
-/
theorem strongest_conditional_yang_mills_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDerivedFineGapAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  have hMass :
      (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
        ∧ 0 < DeltaYM := by
    exact ClayDerivedFineGapAudit.imply_conditional_mass_gap h
  have hFine :
      Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
    exact ClayDerivedFineGapAudit.imply_layer_one_fine_gap_data h
  have hCont :
      Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact ClayDerivedFineGapAudit.imply_continuum_gap_data h
  exact ⟨hMass.1, hFine, hCont, hMass⟩

/--
Strongest headline conditional Yang--Mills mass-gap theorem currently available
from the audited route.
-/
theorem strongest_conditional_yang_mills_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDerivedFineGapAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayDerivedFineGapAudit.imply_conditional_mass_gap h

/--
Strongest conditional positive continuum Yang--Mills gap theorem currently
available from the audited route.
-/
theorem strongest_conditional_yang_mills_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDerivedFineGapAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayDerivedFineGapAudit.imply_positive_continuum_gap_direct h

/--
Strongest conditional Layer-One fine gap theorem currently available from the
audited route.
-/
theorem strongest_conditional_yang_mills_layer_one_fine_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDerivedFineGapAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact ClayDerivedFineGapAudit.imply_layer_one_fine_gap_data h

end RussoYM

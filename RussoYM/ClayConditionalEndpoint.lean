import RussoYM.ClayPositiveScaleAudit

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Conditional Endpoint

This file records the clean formal conditional endpoint for the
Clay-compatible Yang--Mills mass-gap route.

It does not prove the analytic red lemmas from primitive analysis.  Instead, it
states the final conditional theorem obtained from the audited red-lemma
assumptions.
-/

/--
The positive-scale atomic audit gives an explicit positive finite-volume lower
bound for the finite gap sequence.
-/
theorem ClayPositiveScaleAtomicAudit.exists_positive_finite_gap_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPositiveScaleAtomicAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n := by
  refine ⟨mu * (delta / C)^2, ?_, ?_⟩
  · exact h.positiveScaleNormalization.hBlock_pos
  · exact (ClayPositiveScaleAtomicAudit.imply_clay_gap h).1

/--
Full conditional Clay-compatible gap data from the positive-scale atomic audit.
-/
theorem clay_conditional_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPositiveScaleAtomicAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact ClayPositiveScaleAtomicAudit.imply_clay_gap h

/--
Clean conditional positive continuum Yang--Mills gap endpoint.
-/
theorem clay_conditional_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPositiveScaleAtomicAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayPositiveScaleAtomicAudit.imply_positive_continuum_gap h

/--
Formal conditional mass-gap summary.

Under the audited red-lemma assumptions, there is a positive finite-volume gap
lower bound and the continuum Yang--Mills gap is positive.
-/
theorem clay_conditional_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPositiveScaleAtomicAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    ⟨ClayPositiveScaleAtomicAudit.exists_positive_finite_gap_bound h,
      clay_conditional_positive_continuum_gap h⟩

end RussoYM

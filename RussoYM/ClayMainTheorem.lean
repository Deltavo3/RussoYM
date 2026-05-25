import RussoYM.ClayConditionalEndpoint

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Main Theorem

This file exposes the headline formal conditional Yang--Mills mass-gap theorem.

It is conditional on the audited red-lemma assumptions developed in the Clay
endpoint pipeline.  The analytic red lemmas are not proved from primitive
analysis here; they are organized as explicit assumptions in the audit layer.
-/

/--
Headline conditional Yang--Mills mass-gap theorem.

Under the audited red-lemma assumptions, there exists a positive finite-volume
gap lower bound and the continuum Yang--Mills gap is positive.
-/
theorem conditional_yang_mills_mass_gap
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
  exact clay_conditional_mass_gap_summary h

/--
Headline conditional positive continuum Yang--Mills gap theorem.
-/
theorem conditional_yang_mills_positive_continuum_gap
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
  exact clay_conditional_positive_continuum_gap h

/--
Headline conditional positive finite-volume gap theorem.
-/
theorem conditional_yang_mills_finite_gap_bound
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
  exact ClayPositiveScaleAtomicAudit.exists_positive_finite_gap_bound h

end RussoYM

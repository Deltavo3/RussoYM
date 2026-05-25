import RussoYM.ClayDerivedFineGapAudit
import RussoYM.ContinuumRedLemmas

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Derived Continuum Audit

This file records the continuum-gap consequences of the current strongest Clay
audit route.

The finite lower-bound part is derived from holonomy/coercivity and positive
scale data. The continuum transfer is supplied by the epsilon-continuum
approximation packet.
-/

/--
The derived fine-gap audit implies the decomposed continuum red-lemma packet.

The finite lower-bound component is not assumed separately; it is reconstructed
from holonomy/coercivity and positive scale normalization.
-/
theorem ClayDerivedFineGapAudit.to_continuum_red_lemmas
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
    ContinuumRedLemmaAssumptions DeltaYM Delta0 Gap := by
  have hHolonomy :
      UniformHolonomyRedLemmaAssumptions
        links Gap Energy curvatureNorm C mu delta := by
    exact
      { separation := h.holonomySeparation
        curvatureControl := h.holonomyCurvatureControl
        coercivity := h.curvatureCoercivity
        gapLower := h.finiteGapLower }
  have hDelta0_pos : 0 < Delta0 := by
    exact
      LayerOnePositiveScaleAssumptions.imply_delta0_positive
        h.positiveScaleNormalization
  have hFiniteLowerOnly :
      FiniteGapLowerOnlyAssumptions Delta0 Gap := by
    exact
      FiniteGapLowerOnlyAssumptions.from_holonomy_and_positive_scale
        hHolonomy h.positiveScaleNormalization
  have hFiniteLower :
      UniformFiniteGapLowerAssumptions Delta0 Gap := by
    exact
      FiniteGapLowerOnlyAssumptions.to_uniform_finite_gap_lower
        hDelta0_pos hFiniteLowerOnly
  exact
    { finiteLower := hFiniteLower
      epsilonApproximation := h.continuumApproximation }

/--
The derived fine-gap audit implies continuum gap data.
-/
theorem ClayDerivedFineGapAudit.imply_continuum_gap_data
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
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact
    ContinuumRedLemmaAssumptions.imply_continuum_gap
      (ClayDerivedFineGapAudit.to_continuum_red_lemmas h)

/--
The derived fine-gap audit implies the positive continuum Yang--Mills gap.
-/
theorem ClayDerivedFineGapAudit.imply_positive_continuum_gap_direct
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
  exact (ClayDerivedFineGapAudit.imply_continuum_gap_data h).2

/--
The derived fine-gap audit implies both Layer-One fine gap data and continuum
gap data.
-/
theorem ClayDerivedFineGapAudit.imply_fine_and_continuum_gap_data
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
    (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM) := by
  exact
    ⟨ClayDerivedFineGapAudit.imply_layer_one_fine_gap_data h,
      ClayDerivedFineGapAudit.imply_continuum_gap_data h⟩

end RussoYM

import Mathlib
import RussoYM.Assumptions
import RussoYM.ProductDeviationInterface
import RussoYM.ListProductDeviation
import RussoYM.LayerOneCriterion
import RussoYM.LayerOneInterface
import RussoYM.ContinuumGap
import RussoYM.ClayCriterion
import RussoYM.LayerOneRedLemmas
import RussoYM.LayerOneMaster
import RussoYM.RGCrossing
import RussoYM.RawClosure

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Theorem Index

This file collects the current top-level theorem endpoints of the RussoYM
Lean formalization.

It is intentionally light: it does not add new analytic assumptions, and it
does not attempt the still-open analytic Yang--Mills work.

It records the current formalized endpoints:

1. FRT finite-filter operational gap.
2. Conditional raw YM fine-gap criterion.
3. Product-deviation interface.
-/

/-
Endpoint 1: FRT finite-filter operational gap.

This theorem is a named alias for:

  FRTFiniteFilterAssumptions.imply_operational_gap
-/
theorem theorem_index_frt_operational_gap
    {E Q D K N C epsMin epsMax delta : Real}
    (h : FRTFiniteFilterAssumptions E Q D K N C epsMin epsMax delta) :
    ((K / C) * (epsMin / epsMax)^2) * delta^2 <= E
      ∧ 0 < ((K / C) * (epsMin / epsMax)^2) * delta^2
      ∧ 0 < E := by
  exact FRTFiniteFilterAssumptions.imply_operational_gap h

/-
Endpoint 2: conditional raw YM positive fine-gap criterion.

This theorem is a named alias for:

  RawYMAnalyticAssumptions.imply_exists_positive_fine_gap
-/
theorem theorem_index_raw_fine_gap
    {y R u : Nat -> Real}
    {betaLog theta Ccl r Cloc lambdaPhys cUV ell Clift omega : Real}
    (h :
      RawYMAnalyticAssumptions
        y R u betaLog theta Ccl r Cloc lambdaPhys cUV ell Clift omega) :
    exists n : Nat,
      0 < fineGapLower (u n) Ccl r Cloc lambdaPhys cUV ell Clift omega := by
  exact RawYMAnalyticAssumptions.imply_exists_positive_fine_gap h

/-
Endpoint 3: abstract product-deviation interface.

This theorem is a named alias for:

  ProductDeviationAssumptions.imply_product_deviation
-/
theorem theorem_index_product_deviation
    {dProd sumDev sumSq m : Real}
    (h : ProductDeviationAssumptions dProd sumDev sumSq m) :
    dProd^2 <= m * sumSq := by
  exact ProductDeviationAssumptions.imply_product_deviation h

/-
Endpoint 4: normed product-deviation interface.

This theorem is a named alias for:

  NormProductDeviationAssumptions.imply_norm_product_deviation
-/
theorem theorem_index_norm_product_deviation
    {V : Type*}
    [SeminormedAddCommGroup V]
    {z : V}
    {sumDev sumSq m : Real}
    (h : NormProductDeviationAssumptions z sumDev sumSq m) :
    ‖z‖^2 <= m * sumSq := by
  exact NormProductDeviationAssumptions.imply_norm_product_deviation h

/-!
## List product deviation endpoint

This endpoint records the finite-list version of the product-deviation
estimate. It packages the bound

  ‖1 - xs.prod‖ ≤ ∑ x ∈ xs, ‖1 - x‖

under the standard norm-control assumptions.
-/

theorem theorem_index_list_product_triangle_interface
    {R : Type*} [NormedRing R] [NormOneClass R]
    (xs : List R)
    (hxs : ∀ x ∈ xs, ‖x‖ ≤ 1) :
    ‖1 - xs.prod‖ ≤ (xs.map fun x => ‖1 - x‖).sum := by
  exact list_product_triangle_interface xs hxs

/-
Endpoint 6: Layer One fine-gap criterion.

This theorem is a named alias for:

  LayerOneFineGapAssumptions.imply_uniform_fine_gap
-/
theorem theorem_index_layer_one_uniform_fine_gap
    {DeltaFine Delta0 dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (h :
      LayerOneFineGapAssumptions
        DeltaFine Delta0 dBlock dUV Cmix eps ell kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact LayerOneFineGapAssumptions.imply_uniform_fine_gap h

/-
Endpoint 7: Layer One assumptions interface.

This theorem is a named alias for:

  LayerOneAssumptions.imply_uniform_fine_gap
-/
theorem theorem_index_layer_one_assumptions_uniform_fine_gap
    {DeltaFine Delta0 dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (h :
      LayerOneAssumptions
        DeltaFine Delta0 dBlock dUV Cmix eps ell kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact LayerOneAssumptions.imply_uniform_fine_gap h

/-
Endpoint 8: continuum gap preservation interface.

This theorem is a named alias for:

  ContinuumGapAssumptions.imply_continuum_gap
-/
theorem theorem_index_continuum_gap
    {DeltaYM Delta0 : Real}
    (h : ContinuumGapAssumptions DeltaYM Delta0) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact ContinuumGapAssumptions.imply_continuum_gap h

/-
Endpoint 9: final Clay YM gap criterion.

This theorem is a named alias for:

  ClayYMGapAssumptions.imply_clay_gap
-/
theorem theorem_index_clay_ym_gap
    {DeltaYM DeltaFine Delta0 dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (h :
      ClayYMGapAssumptions
        DeltaYM DeltaFine Delta0 dBlock dUV Cmix eps ell kappa) :
    Delta0 <= DeltaFine ∧ 0 < DeltaFine ∧ Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact ClayYMGapAssumptions.imply_clay_gap h

  /-
Endpoint 10: Layer One red-lemma registry.

This theorem is a named alias for:

  LayerOneRedLemmaAssumptions.imply_all_red_lemmas
-/
theorem theorem_index_layer_one_red_lemmas
    {curvatureFormCoercivity : Prop}
    {rgRemainderEstimates : Prop}
    {multiscaleMixingSuppression : Prop}
    {gapPreservingContinuumConstruction : Prop}
    (h :
      LayerOneRedLemmaAssumptions
        curvatureFormCoercivity
        rgRemainderEstimates
        multiscaleMixingSuppression
        gapPreservingContinuumConstruction) :
    curvatureFormCoercivity
      ∧ rgRemainderEstimates
      ∧ multiscaleMixingSuppression
      ∧ gapPreservingContinuumConstruction := by
  exact LayerOneRedLemmaAssumptions.imply_all_red_lemmas h

/-
Endpoint 11: Layer One master registry.

This theorem is a named alias for:

  LayerOneMasterAssumptions.imply_master_endpoint
-/
theorem theorem_index_layer_one_master_endpoint
    {curvatureFormCoercivity : Prop}
    {rgRemainderEstimates : Prop}
    {multiscaleMixingSuppression : Prop}
    {gapPreservingContinuumConstruction : Prop}
    {DeltaYM DeltaFine Delta0 dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (h :
      LayerOneMasterAssumptions
        curvatureFormCoercivity
        rgRemainderEstimates
        multiscaleMixingSuppression
        gapPreservingContinuumConstruction
        DeltaYM DeltaFine Delta0 dBlock dUV Cmix eps ell kappa) :
    Delta0 <= DeltaFine
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM
      ∧ curvatureFormCoercivity
      ∧ rgRemainderEstimates
      ∧ multiscaleMixingSuppression
      ∧ gapPreservingContinuumConstruction := by
  exact LayerOneMasterAssumptions.imply_master_endpoint h

/-
Endpoint 12: controlled RG margin crossing.

This theorem is a named alias for:

  controlled_rg_eventually_margin_coupling_crosses
-/
theorem theorem_index_controlled_rg_margin_crossing
    (y R u : Nat -> Real)
    {betaLog theta sigma xstab : Real}
    (hEq : forall n, y (Nat.succ n) = y n - betaLog + R n)
    (hR : forall n, R n <= theta * betaLog)
    (hRel : forall n, y n = 1 / u n)
    (hupos : forall n, 0 < u n)
    (hsigma : 0 < sigma)
    (hxstab : 0 < xstab)
    (hTheta : theta < 1)
    (hBeta : 0 < betaLog) :
    exists n : Nat, (1 + sigma) * xstab < u n := by
  exact
    controlled_rg_eventually_margin_coupling_crosses
      y R u hEq hR hRel hupos hsigma hxstab hTheta hBeta

/-
Endpoint 13: raw closure from RG margin crossing and square-root threshold.

This theorem is a named alias for:

  exists_raw_gap_from_eventual_margin_rg_and_sqrt_threshold
-/
theorem theorem_index_raw_gap_from_margin_rg_and_sqrt_threshold
    (y R u : Nat -> Real)
    {betaLog theta sigma xstab Ccl r Cloc lambdaPhys cUV ell Clift omega : Real}
    (hEq : forall k, y (Nat.succ k) = y k - betaLog + R k)
    (hR : forall k, R k <= theta * betaLog)
    (hRel : forall k, y k = 1 / u k)
    (hupos : forall k, 0 < u k)
    (hsigma : 0 < sigma)
    (hxstab_def :
      xstab =
        (Ccl * r + Real.sqrt ((Ccl * r)^2 + 4 * lambdaPhys * Ccl * Cloc))
          / (2 * lambdaPhys))
    (hxstab : 0 < xstab)
    (hTheta : theta < 1)
    (hBeta : 0 < betaLog)
    (hCcl : 0 < Ccl)
    (hCloc : 0 < Cloc)
    (hlambda : 0 < lambdaPhys)
    (hcUV : 0 < cUV)
    (hell : 0 < ell)
    (hsmall :
      forall k,
        (1 + sigma) * xstab < u k ->
          Clift * omega <
            min
              ((u k) * (lambdaPhys - Ccl * (Cloc / (u k)^2 + r / (u k))))
              (cUV / ell)) :
    exists n : Nat,
      0 <
        min
          ((u n) * (lambdaPhys - Ccl * (Cloc / (u n)^2 + r / (u n))))
          (cUV / ell)
        - Clift * omega := by
  exact
    exists_raw_gap_from_eventual_margin_rg_and_sqrt_threshold
      y R u hEq hR hRel hupos hsigma hxstab_def hxstab
      hTheta hBeta hCcl hCloc hlambda hcUV hell hsmall

end RussoYM

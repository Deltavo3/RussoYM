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
import RussoYM.MassGapCriterion
import RussoYM.MarginThreshold
import RussoYM.ListProductDeviationInterface
import RussoYM.FiniteHolonomyEstimate
import RussoYM.FiniteCoercivity
import RussoYM.FiniteHolonomyCoercivity
import RussoYM.FiniteGapFromHolonomy
import RussoYM.UniformFiniteGapFromHolonomy
import RussoYM.LayerOneFromHolonomy
import RussoYM.ClayFromHolonomy
import RussoYM.FiniteMixingSuppression
import RussoYM.ContinuumPreservation
import RussoYM.UniformHolonomyCoercivity

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

/-
Endpoint 14: margin mass-gap criterion wrapper.

This theorem is a named alias for:

  exists_positive_fine_gap_from_controlled_margin_rg
-/
theorem theorem_index_margin_mass_gap_criterion
    (y R u : Nat -> Real)
    {betaLog theta sigma Ccl r Cloc lambdaPhys cUV ell Clift omega : Real}
    (hEq : forall k, y (Nat.succ k) = y k - betaLog + R k)
    (hR : forall k, R k <= theta * betaLog)
    (hRel : forall k, y k = 1 / u k)
    (hupos : forall k, 0 < u k)
    (hsigma : 0 < sigma)
    (hxstab_pos : 0 < xstabSqrt Ccl r Cloc lambdaPhys)
    (hTheta : theta < 1)
    (hBeta : 0 < betaLog)
    (hCcl : 0 < Ccl)
    (hCloc : 0 < Cloc)
    (hlambda : 0 < lambdaPhys)
    (hcUV : 0 < cUV)
    (hell : 0 < ell)
    (hsmall :
      forall k,
        (1 + sigma) * xstabSqrt Ccl r Cloc lambdaPhys < u k ->
          Clift * omega <
            min
              (blockGapLower (u k) Ccl r Cloc lambdaPhys)
              (cUV / ell)) :
    exists n : Nat,
      0 < fineGapLower (u n) Ccl r Cloc lambdaPhys cUV ell Clift omega := by
  exact
    exists_positive_fine_gap_from_controlled_margin_rg
      y R u hEq hR hRel hupos hsigma hxstab_pos
      hTheta hBeta hCcl hCloc hlambda hcUV hell hsmall

/-
Endpoint 15: margin raw YM assumptions interface.

This theorem is a named alias for:

  RawYMMarginAnalyticAssumptions.imply_exists_positive_fine_gap
-/
theorem theorem_index_margin_raw_ym_assumptions
    {y R u : Nat -> Real}
    {betaLog theta sigma Ccl r Cloc lambdaPhys cUV ell Clift omega : Real}
    (h :
      RawYMMarginAnalyticAssumptions
        y R u betaLog theta sigma Ccl r Cloc lambdaPhys cUV ell Clift omega) :
    exists n : Nat,
      0 < fineGapLower (u n) Ccl r Cloc lambdaPhys cUV ell Clift omega := by
  exact RawYMMarginAnalyticAssumptions.imply_exists_positive_fine_gap h

/-
Endpoint 16: margin target lies above threshold.

This theorem is a named alias for:

  margin_target_above_threshold
-/
theorem theorem_index_margin_target_above_threshold
    {sigma x : Real}
    (hsigma : 0 < sigma)
    (hx : 0 < x) :
    x < (1 + sigma) * x := by
  exact margin_target_above_threshold hsigma hx

/-
Endpoint 17: base threshold crossing from margin crossing.

This theorem is a named alias for:

  threshold_lt_of_margin_lt
-/
theorem theorem_index_threshold_lt_of_margin_lt
    {sigma x u : Real}
    (hsigma : 0 < sigma)
    (hx : 0 < x)
    (hmargin : (1 + sigma) * x < u) :
    x < u := by
  exact threshold_lt_of_margin_lt hsigma hx hmargin

/-
Endpoint 18: list deviation sum nonnegativity.

This theorem is a named alias for:

  list_deviation_sum_nonneg
-/
theorem theorem_index_list_deviation_sum_nonneg
    {R : Type*}
    [NormedRing R]
    (xs : List R) :
    0 <= (xs.map (fun a => ‖1 - a‖)).sum := by
  exact list_deviation_sum_nonneg xs

/-
Endpoint 19: squared list product deviation from finite Cauchy.

This theorem is a named alias for:

  list_product_deviation_norm_sq_from_cauchy
-/
theorem theorem_index_list_product_deviation_norm_sq_from_cauchy
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    (hxs : forall a, a ∈ xs -> ‖a‖ <= 1)
    (hcauchy :
      ((xs.map (fun a => ‖1 - a‖)).sum)^2
        <=
      (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := by
  exact list_product_deviation_norm_sq_from_cauchy xs hxs hcauchy

/-
Endpoint 20: finite-list Cauchy estimate.

This theorem is a named alias for:

  list_cauchy_sum_sq_le_length_mul_sum_sq
-/
theorem theorem_index_list_cauchy_sum_sq_le_length_mul_sum_sq
    (xs : List Real) :
    xs.sum^2 <= (xs.length : Real) * (xs.map (fun x => x^2)).sum := by
  exact list_cauchy_sum_sq_le_length_mul_sum_sq xs

/-
Endpoint 21: full squared finite-list product-deviation theorem.

This theorem is a named alias for:

  list_product_deviation_norm_sq
-/
theorem theorem_index_list_product_deviation_norm_sq
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    (hxs : forall a, a ∈ xs -> ‖a‖ <= 1) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := by
  exact list_product_deviation_norm_sq xs hxs

/-
Endpoint 22: list product deviation assumptions interface.

This theorem is a named alias for:

  ListProductDeviationAssumptions.imply_norm_sq_deviation
-/
theorem theorem_index_list_product_deviation_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    (h : ListProductDeviationAssumptions xs) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := by
  exact ListProductDeviationAssumptions.imply_norm_sq_deviation h

/-
Endpoint 23: unit-norm squared finite-list product-deviation theorem.

This theorem is a named alias for:

  list_product_deviation_norm_sq_of_norm_eq_one
-/
theorem theorem_index_list_product_deviation_norm_sq_of_norm_eq_one
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    (hxs : forall a, a ∈ xs -> ‖a‖ = 1) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := by
  exact list_product_deviation_norm_sq_of_norm_eq_one xs hxs

/-
Endpoint 24: unit-norm list product deviation assumptions interface.

This theorem is a named alias for:

  ListProductDeviationUnitAssumptions.imply_norm_sq_deviation
-/
theorem theorem_index_list_product_deviation_unit_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    (h : ListProductDeviationUnitAssumptions xs) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real) * (xs.map (fun a => ‖1 - a‖^2)).sum := by
  exact ListProductDeviationUnitAssumptions.imply_norm_sq_deviation h

/-
Endpoint 25: bounded sum of squared deviations.

This theorem is a named alias for:

  list_deviation_sq_sum_le_length_mul_sq_of_bound
-/
theorem theorem_index_list_deviation_sq_sum_le_length_mul_sq_of_bound
    {R : Type*}
    [NormedRing R]
    (xs : List R)
    {eps : Real}
    (heps : 0 <= eps)
    (hdev : forall a, a ∈ xs -> ‖1 - a‖ <= eps) :
    (xs.map (fun a => ‖1 - a‖^2)).sum
      <=
    (xs.length : Real) * eps^2 := by
  exact list_deviation_sq_sum_le_length_mul_sq_of_bound xs heps hdev

/-
Endpoint 26: uniform unit-norm list product deviation bound.

This theorem is a named alias for:

  list_product_deviation_norm_sq_of_norm_eq_one_and_dev_le
-/
theorem theorem_index_list_product_deviation_uniform_unit_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    {eps : Real}
    (heps : 0 <= eps)
    (hunit : forall a, a ∈ xs -> ‖a‖ = 1)
    (hdev : forall a, a ∈ xs -> ‖1 - a‖ <= eps) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real)^2 * eps^2 := by
  exact list_product_deviation_norm_sq_of_norm_eq_one_and_dev_le
    xs heps hunit hdev

/-
Endpoint 27: uniform unit-norm list product deviation assumptions interface.

This theorem is a named alias for:

  ListProductDeviationUniformUnitAssumptions.imply_uniform_norm_sq_deviation
-/
theorem theorem_index_list_product_deviation_uniform_unit_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    {eps : Real}
    (h : ListProductDeviationUniformUnitAssumptions xs eps) :
    ‖1 - xs.prod‖^2
      <=
    (xs.length : Real)^2 * eps^2 := by
  exact ListProductDeviationUniformUnitAssumptions.imply_uniform_norm_sq_deviation h

/-
Endpoint 28: unsquared uniform unit-norm list product deviation bound.

This theorem is a named alias for:

  list_product_deviation_norm_of_norm_eq_one_and_dev_le
-/
theorem theorem_index_list_product_deviation_uniform_unit_norm_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    {eps : Real}
    (heps : 0 <= eps)
    (hunit : forall a, a ∈ xs -> ‖a‖ = 1)
    (hdev : forall a, a ∈ xs -> ‖1 - a‖ <= eps) :
    ‖1 - xs.prod‖ <= (xs.length : Real) * eps := by
  exact list_product_deviation_norm_of_norm_eq_one_and_dev_le
    xs heps hunit hdev

/-
Endpoint 29: unsquared uniform unit-norm list product deviation assumptions.

This theorem is a named alias for:

  ListProductDeviationUniformUnitAssumptions.imply_uniform_norm_deviation
-/
theorem theorem_index_list_product_deviation_uniform_unit_norm_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    {eps : Real}
    (h : ListProductDeviationUniformUnitAssumptions xs eps) :
    ‖1 - xs.prod‖ <= (xs.length : Real) * eps := by
  exact ListProductDeviationUniformUnitAssumptions.imply_uniform_norm_deviation h

/-
Endpoint 30: target-error uniform unit-norm list product deviation bound.

This theorem is a named alias for:

  list_product_deviation_norm_le_delta_of_uniform_unit_dev
-/
theorem theorem_index_list_product_deviation_uniform_unit_le_delta
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    {eps delta : Real}
    (heps : 0 <= eps)
    (hunit : forall a, a ∈ xs -> ‖a‖ = 1)
    (hdev : forall a, a ∈ xs -> ‖1 - a‖ <= eps)
    (haccum : (xs.length : Real) * eps <= delta) :
    ‖1 - xs.prod‖ <= delta := by
  exact list_product_deviation_norm_le_delta_of_uniform_unit_dev
    xs heps hunit hdev haccum

/-
Endpoint 31: target-error uniform unit-norm list product deviation assumptions.

This theorem is a named alias for:

  ListProductDeviationUniformUnitAssumptions.imply_norm_deviation_le_delta
-/
theorem theorem_index_list_product_deviation_uniform_unit_assumptions_le_delta
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    {eps delta : Real}
    (h : ListProductDeviationUniformUnitAssumptions xs eps)
    (haccum : (xs.length : Real) * eps <= delta) :
    ‖1 - xs.prod‖ <= delta := by
  exact ListProductDeviationUniformUnitAssumptions.imply_norm_deviation_le_delta
    h haccum

/-
Endpoint 32: bounded-length target-error unit-norm list product bound.

This theorem is a named alias for:

  list_product_deviation_norm_le_delta_of_uniform_unit_dev_and_length_le
-/
theorem theorem_index_list_product_deviation_uniform_unit_le_delta_of_length_le
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    {eps delta : Real}
    {N : Nat}
    (heps : 0 <= eps)
    (hlen : xs.length <= N)
    (hunit : forall a, a ∈ xs -> ‖a‖ = 1)
    (hdev : forall a, a ∈ xs -> ‖1 - a‖ <= eps)
    (haccum : (N : Real) * eps <= delta) :
    ‖1 - xs.prod‖ <= delta := by
  exact list_product_deviation_norm_le_delta_of_uniform_unit_dev_and_length_le
    xs heps hlen hunit hdev haccum

/-
Endpoint 33: bounded-length target-error unit-norm list product assumptions.

This theorem is a named alias for:

  ListProductDeviationUniformUnitAssumptions.imply_norm_deviation_le_delta_of_length_le
-/
theorem theorem_index_list_product_deviation_uniform_unit_assumptions_le_delta_of_length_le
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    {eps delta : Real}
    {N : Nat}
    (h : ListProductDeviationUniformUnitAssumptions xs eps)
    (hlen : xs.length <= N)
    (haccum : (N : Real) * eps <= delta) :
    ‖1 - xs.prod‖ <= delta := by
  exact ListProductDeviationUniformUnitAssumptions.imply_norm_deviation_le_delta_of_length_le
    h hlen haccum

/-
Endpoint 34: division-form bounded-length unit-norm list product bound.

This theorem is a named alias for:

  list_product_deviation_norm_le_delta_of_uniform_unit_dev_length_le_and_eps_le_div
-/
theorem theorem_index_list_product_deviation_uniform_unit_le_delta_of_length_le_and_eps_le_div
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (xs : List R)
    {eps delta : Real}
    {N : Nat}
    (heps : 0 <= eps)
    (hNpos : 0 < N)
    (hlen : xs.length <= N)
    (hunit : forall a, a ∈ xs -> ‖a‖ = 1)
    (hdev : forall a, a ∈ xs -> ‖1 - a‖ <= eps)
    (heps_le : eps <= delta / (N : Real)) :
    ‖1 - xs.prod‖ <= delta := by
  exact list_product_deviation_norm_le_delta_of_uniform_unit_dev_length_le_and_eps_le_div
    xs heps hNpos hlen hunit hdev heps_le

/-
Endpoint 35: division-form bounded-length unit-norm list product assumptions.

This theorem is a named alias for:

  ListProductDeviationUniformUnitAssumptions.imply_norm_deviation_le_delta_of_length_le_and_eps_le_div
-/
theorem theorem_index_list_product_deviation_uniform_unit_assumptions_le_delta_of_length_le_and_eps_le_div
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {xs : List R}
    {eps delta : Real}
    {N : Nat}
    (h : ListProductDeviationUniformUnitAssumptions xs eps)
    (hNpos : 0 < N)
    (hlen : xs.length <= N)
    (heps_le : eps <= delta / (N : Real)) :
    ‖1 - xs.prod‖ <= delta := by
  exact ListProductDeviationUniformUnitAssumptions.imply_norm_deviation_le_delta_of_length_le_and_eps_le_div
    h hNpos hlen heps_le

/-
Endpoint 36: finite holonomy deviation bound.

This theorem is a named alias for:

  FiniteHolonomyEstimateAssumptions.imply_holonomy_deviation_bound
-/
theorem theorem_index_finite_holonomy_deviation_bound
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : List R}
    {eps delta : Real}
    {N : Nat}
    (h : FiniteHolonomyEstimateAssumptions links eps delta N) :
    ‖1 - links.prod‖ <= delta := by
  exact FiniteHolonomyEstimateAssumptions.imply_holonomy_deviation_bound h

/-
Endpoint 37: finite holonomy deviation from uniform unit assumptions.

This theorem is a named alias for:

  finite_holonomy_deviation_bound_from_uniform_unit_assumptions
-/
theorem theorem_index_finite_holonomy_deviation_bound_from_uniform_unit_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : List R}
    {eps delta : Real}
    {N : Nat}
    (h : ListProductDeviationUniformUnitAssumptions links eps)
    (hNpos : 0 < N)
    (hlen : links.length <= N)
    (heps_le : eps <= delta / (N : Real)) :
    ‖1 - links.prod‖ <= delta := by
  exact finite_holonomy_deviation_bound_from_uniform_unit_assumptions
    h hNpos hlen heps_le

/-
Endpoint 38: finite holonomy deviation from scaled link error.

This theorem is a named alias for:

  finite_holonomy_deviation_bound_of_scaled_link_error
-/
theorem theorem_index_finite_holonomy_deviation_bound_of_scaled_link_error
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : List R)
    {C eta delta : Real}
    {N : Nat}
    (hC : 0 <= C)
    (heta : 0 <= eta)
    (hNpos : 0 < N)
    (hlen : links.length <= N)
    (hunit : forall U, U ∈ links -> ‖U‖ = 1)
    (hlink : forall U, U ∈ links -> ‖1 - U‖ <= C * eta)
    (hbudget : C * eta <= delta / (N : Real)) :
    ‖1 - links.prod‖ <= delta := by
  exact finite_holonomy_deviation_bound_of_scaled_link_error
    links hC heta hNpos hlen hunit hlink hbudget

/-
Endpoint 39: scaled finite holonomy assumptions interface.

This theorem is a named alias for:

  FiniteHolonomyScaledEstimateAssumptions.imply_holonomy_deviation_bound
-/
theorem theorem_index_finite_holonomy_scaled_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : List R}
    {C eta delta : Real}
    {N : Nat}
    (h : FiniteHolonomyScaledEstimateAssumptions links C eta delta N) :
    ‖1 - links.prod‖ <= delta := by
  exact FiniteHolonomyScaledEstimateAssumptions.imply_holonomy_deviation_bound h

/-
Endpoint 40: finite holonomy deviation from divided local error budget.

This theorem is a named alias for:

  finite_holonomy_deviation_bound_of_scaled_link_error_eta_le_div
-/
theorem theorem_index_finite_holonomy_deviation_bound_of_scaled_link_error_eta_le_div
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : List R)
    {C eta delta : Real}
    {N : Nat}
    (hCpos : 0 < C)
    (heta : 0 <= eta)
    (hNpos : 0 < N)
    (hlen : links.length <= N)
    (hunit : forall U, U ∈ links -> ‖U‖ = 1)
    (hlink : forall U, U ∈ links -> ‖1 - U‖ <= C * eta)
    (heta_budget : eta <= delta / ((N : Real) * C)) :
    ‖1 - links.prod‖ <= delta := by
  exact finite_holonomy_deviation_bound_of_scaled_link_error_eta_le_div
    links hCpos heta hNpos hlen hunit hlink heta_budget

/-
Endpoint 41: divided-budget scaled finite holonomy assumptions interface.

This theorem is a named alias for:

  FiniteHolonomyScaledDivEstimateAssumptions.imply_holonomy_deviation_bound
-/
theorem theorem_index_finite_holonomy_scaled_div_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : List R}
    {C eta delta : Real}
    {N : Nat}
    (h : FiniteHolonomyScaledDivEstimateAssumptions links C eta delta N) :
    ‖1 - links.prod‖ <= delta := by
  exact FiniteHolonomyScaledDivEstimateAssumptions.imply_holonomy_deviation_bound h

/-
Endpoint 42: finite curvature/coercivity energy gap.

This theorem is a named alias for:

  FiniteCoercivityAssumptions.imply_positive_energy_gap
-/
theorem theorem_index_finite_coercivity_positive_energy_gap
    {Energy curvatureSq mu delta : Real}
    (h : FiniteCoercivityAssumptions Energy curvatureSq mu delta) :
    mu * delta^2 <= Energy ∧ 0 < mu * delta^2 ∧ 0 < Energy := by
  exact FiniteCoercivityAssumptions.imply_positive_energy_gap h

/-
Endpoint 43: finite curvature-norm coercivity energy gap.

This theorem is a named alias for:

  FiniteCoercivityNormAssumptions.imply_positive_energy_gap
-/
theorem theorem_index_finite_coercivity_norm_positive_energy_gap
    {Energy curvatureNorm mu delta : Real}
    (h : FiniteCoercivityNormAssumptions Energy curvatureNorm mu delta) :
    mu * delta^2 <= Energy ∧ 0 < mu * delta^2 ∧ 0 < Energy := by
  exact FiniteCoercivityNormAssumptions.imply_positive_energy_gap h

/-
Endpoint 44: finite holonomy-coercivity positive energy gap.

This theorem is a named alias for:

  FiniteHolonomyCoercivityAssumptions.imply_positive_energy_gap
-/
theorem theorem_index_finite_holonomy_coercivity_positive_energy_gap
    {Energy holDev curvatureNorm C mu delta : Real}
    (h : FiniteHolonomyCoercivityAssumptions
      Energy holDev curvatureNorm C mu delta) :
    mu * (delta / C)^2 <= Energy
      ∧ 0 < mu * (delta / C)^2
      ∧ 0 < Energy := by
  exact FiniteHolonomyCoercivityAssumptions.imply_positive_energy_gap h

/-
Endpoint 45: concrete finite holonomy-path coercivity positive energy gap.

This theorem is a named alias for:

  FiniteHolonomyPathCoercivityAssumptions.imply_positive_energy_gap
-/
theorem theorem_index_finite_holonomy_path_coercivity_positive_energy_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : List R}
    {Energy curvatureNorm C mu delta : Real}
    (h : FiniteHolonomyPathCoercivityAssumptions
      links Energy curvatureNorm C mu delta) :
    mu * (delta / C)^2 <= Energy
      ∧ 0 < mu * (delta / C)^2
      ∧ 0 < Energy := by
  exact FiniteHolonomyPathCoercivityAssumptions.imply_positive_energy_gap h

/-
Endpoint 46: finite positive gap from holonomy-coercivity.

This theorem is a named alias for:

  FiniteGapFromHolonomyAssumptions.imply_positive_finite_gap
-/
theorem theorem_index_finite_gap_from_holonomy_positive_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : List R}
    {Gap Energy curvatureNorm C mu delta : Real}
    (h : FiniteGapFromHolonomyAssumptions
      links Gap Energy curvatureNorm C mu delta) :
    mu * (delta / C)^2 <= Gap
      ∧ 0 < mu * (delta / C)^2
      ∧ 0 < Gap := by
  exact FiniteGapFromHolonomyAssumptions.imply_positive_finite_gap h

/-
Endpoint 47: uniform finite gap from holonomy-coercivity.

This theorem is a named alias for:

  UniformFiniteGapFromHolonomyAssumptions.imply_uniform_positive_gap
-/
theorem theorem_index_uniform_finite_gap_from_holonomy
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      UniformFiniteGapFromHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ 0 < mu * (delta / C)^2
      ∧ forall n, 0 < Gap n := by
  exact UniformFiniteGapFromHolonomyAssumptions.imply_uniform_positive_gap h

/-
Endpoint 48: Layer One gap from uniform holonomy-coercivity.

This theorem is a named alias for:

  LayerOneFromHolonomyAssumptions.imply_layer_one_gap
-/
theorem theorem_index_layer_one_from_holonomy_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      LayerOneFromHolonomyAssumptions
        links Gap Energy curvatureNorm
        DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine := by
  exact LayerOneFromHolonomyAssumptions.imply_layer_one_gap h

/-
Endpoint 49: Clay gap from finite holonomy-coercivity.

This theorem is a named alias for:

  ClayFromHolonomyAssumptions.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_holonomy
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact ClayFromHolonomyAssumptions.imply_clay_gap h

/-
Endpoint 50: positive continuum YM gap from finite holonomy-coercivity.

This theorem is a named alias for:

  ClayFromHolonomyAssumptions.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_holonomy
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayFromHolonomyAssumptions.imply_positive_continuum_gap h

/-
Endpoint 51: finite mixing suppression from scale separation.

This theorem is a named alias for:

  FiniteMixingSuppressionAssumptions.imply_mixing_small
-/
theorem theorem_index_finite_mixing_suppression
    {Cmix eps ell rho target : Real}
    {kappa : Nat}
    (h : FiniteMixingSuppressionAssumptions Cmix eps ell rho target kappa) :
    2 * Cmix * (eps / ell)^kappa <= target := by
  exact FiniteMixingSuppressionAssumptions.imply_mixing_small h

/-
Endpoint 52: Layer One mixing suppression.

This theorem is a named alias for:

  LayerOneMixingSuppressionAssumptions.imply_layer_one_mixing_small
-/
theorem theorem_index_layer_one_mixing_suppression
    {dBlock dUV Cmix eps ell rho : Real}
    {kappa : Nat}
    (h : LayerOneMixingSuppressionAssumptions
      dBlock dUV Cmix eps ell rho kappa) :
    2 * Cmix * (eps / ell)^kappa <= (1 / 2) * min dBlock dUV := by
  exact LayerOneMixingSuppressionAssumptions.imply_layer_one_mixing_small h

/-
Endpoint 53: Layer One gap from holonomy-coercivity and finite mixing suppression.

This theorem is a named alias for:

  LayerOneFromHolonomyWithMixingAssumptions.imply_layer_one_gap
-/
theorem theorem_index_layer_one_from_holonomy_with_mixing_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      LayerOneFromHolonomyWithMixingAssumptions
        links Gap Energy curvatureNorm
        DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine := by
  exact LayerOneFromHolonomyWithMixingAssumptions.imply_layer_one_gap h

/-
Endpoint 54: Clay gap from holonomy-coercivity and finite mixing suppression.

This theorem is a named alias for:

  ClayFromHolonomyWithMixingAssumptions.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_holonomy_with_mixing
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyWithMixingAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact ClayFromHolonomyWithMixingAssumptions.imply_clay_gap h

/-
Endpoint 55: positive continuum YM gap from holonomy-coercivity and finite
mixing suppression.

This theorem is a named alias for:

  ClayFromHolonomyWithMixingAssumptions.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_holonomy_with_mixing
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyWithMixingAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayFromHolonomyWithMixingAssumptions.imply_positive_continuum_gap h

/-
Endpoint 56: approximate continuum gap preservation.

This theorem is a named alias for:

  ApproxContinuumGapAssumptions.imply_continuum_gap
-/
theorem theorem_index_approx_continuum_gap
    {DeltaYM Delta0 : Real}
    (h : ApproxContinuumGapAssumptions DeltaYM Delta0) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact ApproxContinuumGapAssumptions.imply_continuum_gap h

/-
Endpoint 57: uniform finite-to-continuum gap preservation.

This theorem is a named alias for:

  UniformFiniteToContinuumGapAssumptions.imply_continuum_gap
-/
theorem theorem_index_uniform_finite_to_continuum_gap
    {DeltaYM Delta0 : Real}
    {Gap : Nat -> Real}
    (h : UniformFiniteToContinuumGapAssumptions DeltaYM Delta0 Gap) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact UniformFiniteToContinuumGapAssumptions.imply_continuum_gap h

/-
Endpoint 58: uniform finite-to-continuum assumptions interface.

This theorem is a named alias for:

  UniformFiniteToContinuumGapAssumptions.imply_continuum_gap_assumptions
-/
theorem theorem_index_uniform_finite_to_continuum_gap_assumptions
    {DeltaYM Delta0 : Real}
    {Gap : Nat -> Real}
    (h : UniformFiniteToContinuumGapAssumptions DeltaYM Delta0 Gap) :
    ContinuumGapAssumptions DeltaYM Delta0 := by
  exact UniformFiniteToContinuumGapAssumptions.imply_continuum_gap_assumptions h

/-
Endpoint 59: Clay gap from holonomy, mixing, and epsilon continuum preservation.

This theorem is a named alias for:

  ClayFromHolonomyWithMixingEpsilonContinuumAssumptions.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_holonomy_with_mixing_epsilon_continuum
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyWithMixingEpsilonContinuumAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact ClayFromHolonomyWithMixingEpsilonContinuumAssumptions.imply_clay_gap h

/-
Endpoint 60: positive continuum YM gap from holonomy, mixing, and epsilon
continuum preservation.

This theorem is a named alias for:

  ClayFromHolonomyWithMixingEpsilonContinuumAssumptions.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_holonomy_with_mixing_epsilon_continuum
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyWithMixingEpsilonContinuumAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayFromHolonomyWithMixingEpsilonContinuumAssumptions.imply_positive_continuum_gap h

/-
Endpoint 61: direct uniform holonomy-coercivity assumptions imply packaged
uniform finite-gap assumptions.

This theorem is a named alias for:

  UniformHolonomyCoercivityAssumptions.imply_uniform_finite_gap_assumptions
-/
theorem theorem_index_uniform_holonomy_coercivity_assumptions_to_uniform_finite_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h : UniformHolonomyCoercivityAssumptions
      links Gap Energy curvatureNorm C mu delta) :
    UniformFiniteGapFromHolonomyAssumptions
      links Gap Energy curvatureNorm C mu delta := by
  exact UniformHolonomyCoercivityAssumptions.imply_uniform_finite_gap_assumptions h

/-
Endpoint 62: direct uniform holonomy-coercivity positive finite gap.

This theorem is a named alias for:

  UniformHolonomyCoercivityAssumptions.imply_uniform_positive_gap
-/
theorem theorem_index_uniform_holonomy_coercivity_positive_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h : UniformHolonomyCoercivityAssumptions
      links Gap Energy curvatureNorm C mu delta) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ 0 < mu * (delta / C)^2
      ∧ forall n, 0 < Gap n := by
  exact UniformHolonomyCoercivityAssumptions.imply_uniform_positive_gap h

end RussoYM

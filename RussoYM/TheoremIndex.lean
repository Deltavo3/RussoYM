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
import RussoYM.UniformHolonomyRedLemmas
import RussoYM.ContinuumRedLemmas
import RussoYM.MixingRedLemmas
import RussoYM.FineLowerRedLemmas
import RussoYM.LayerOneScaleRedLemmas
import RussoYM.ClayAssumptionAudit
import RussoYM.ClayAtomicAssumptionAudit
import RussoYM.LayerOneScaleNormalization
import RussoYM.ClayPositiveScaleAudit
import RussoYM.ClayConditionalEndpoint
import RussoYM.ClayMainTheorem
import RussoYM.ContinuumFiniteLowerReduction
import RussoYM.ClayFiniteLowerAudit
import RussoYM.FiniteGapLowerFromHolonomy
import RussoYM.ClayHolonomyFiniteLowerAudit
import RussoYM.ClayPrimitiveMixingAudit
import RussoYM.ClayDelta0MixingAudit
import RussoYM.FineGapFromSchurMixing
import RussoYM.ClayDerivedFineGapAudit
import RussoYM.ClayDerivedContinuumAudit
import RussoYM.ClayStrongestConditional
import RussoYM.EpsilonContinuumSurvival
import RussoYM.ClaySurvivalAudit
import RussoYM.ClaySurvivalConsequences
import RussoYM.ClayHolonomyPacketSurvivalAudit
import RussoYM.ClayRedLemmaTheorem
import RussoYM.ClayDirectMixingRedLemmaTheorem
import RussoYM.ClayDirectRedLemmaTheorem
import RussoYM.ClayReducedScaleDirectTheorem
import RussoYM.ClayMixingParameterCriterion
import RussoYM.ClayMixingPowerCriterion
import RussoYM.ClayMixingRatioCriterion
import RussoYM.ClayMixingScaleSeparationCriterion
import RussoYM.ClayMixingDecayBudget
import RussoYM.ClayMixingKappaExistence
import RussoYM.ClayMixingSeparatedKappa
import RussoYM.ClaySeparatedKappaTheorem
import RussoYM.ClaySchurLossForm
import RussoYM.ClaySchurLossTheorem
import RussoYM.ClaySchurLossBudget
import RussoYM.ClaySchurBudgetForm
import RussoYM.ClaySchurBudgetTheorem
import RussoYM.ClayContinuumSurvivalForm
import RussoYM.ClayContinuumSurvivalTheorem
import RussoYM.ClayFinalDirectTheorem
import RussoYM.ClayFinalDirectAssumptionAudit
import RussoYM.ClayPrimitiveObligations
import RussoYM.ClayScalePrimitive
import RussoYM.ClayContinuumPrimitive
import RussoYM.ClayReducedPrimitiveObligations
import RussoYM.ClaySchurPrimitive
import RussoYM.ClayRawPrimitiveTheorem
import RussoYM.ClayRawPrimitiveAudit

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

/-
Endpoint 63: Clay gap from direct holonomy/coercivity, mixing, and epsilon continuum preservation.

This theorem is a named alias for:

  ClayFromDirectHolonomyWithMixingEpsilonContinuumAssumptions.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_direct_holonomy_with_mixing_epsilon_continuum
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromDirectHolonomyWithMixingEpsilonContinuumAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact
    ClayFromDirectHolonomyWithMixingEpsilonContinuumAssumptions.imply_clay_gap h

/-
Endpoint 64: positive continuum YM gap from direct holonomy/coercivity, mixing,
and epsilon continuum preservation.

This theorem is a named alias for:

  ClayFromDirectHolonomyWithMixingEpsilonContinuumAssumptions.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_direct_holonomy_with_mixing_epsilon_continuum
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromDirectHolonomyWithMixingEpsilonContinuumAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayFromDirectHolonomyWithMixingEpsilonContinuumAssumptions.imply_positive_continuum_gap h

/-
Endpoint 65: decomposed holonomy red lemmas imply direct uniform
holonomy-coercivity assumptions.

This theorem is a named alias for:

  UniformHolonomyRedLemmaAssumptions.imply_uniform_holonomy_coercivity
-/
theorem theorem_index_uniform_holonomy_red_lemmas_to_coercivity
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      UniformHolonomyRedLemmaAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    UniformHolonomyCoercivityAssumptions
      links Gap Energy curvatureNorm C mu delta := by
  exact UniformHolonomyRedLemmaAssumptions.imply_uniform_holonomy_coercivity h

/-
Endpoint 66: decomposed holonomy red lemmas imply uniform positive finite gap.

This theorem is a named alias for:

  UniformHolonomyRedLemmaAssumptions.imply_uniform_positive_gap
-/
theorem theorem_index_uniform_holonomy_red_lemmas_positive_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      UniformHolonomyRedLemmaAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ 0 < mu * (delta / C)^2
      ∧ forall n, 0 < Gap n := by
  exact UniformHolonomyRedLemmaAssumptions.imply_uniform_positive_gap h

/-
Endpoint 67: Clay gap from decomposed holonomy red lemmas, mixing, and epsilon
continuum preservation.

This theorem is a named alias for:

  ClayFromHolonomyRedLemmasWithMixingEpsilonContinuumAssumptions.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_holonomy_red_lemmas_with_mixing_epsilon_continuum
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyRedLemmasWithMixingEpsilonContinuumAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact
    ClayFromHolonomyRedLemmasWithMixingEpsilonContinuumAssumptions.imply_clay_gap h

/-
Endpoint 68: positive continuum YM gap from decomposed holonomy red lemmas,
mixing, and epsilon continuum preservation.

This theorem is a named alias for:

  ClayFromHolonomyRedLemmasWithMixingEpsilonContinuumAssumptions.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_holonomy_red_lemmas_with_mixing_epsilon_continuum
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyRedLemmasWithMixingEpsilonContinuumAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayFromHolonomyRedLemmasWithMixingEpsilonContinuumAssumptions.imply_positive_continuum_gap h

/-
Endpoint 69: ratio bound from multiplicative scale separation.

This theorem is a named alias for:

  ratio_le_of_eps_le_rho_mul_ell
-/
theorem theorem_index_ratio_le_of_eps_le_rho_mul_ell
    {eps ell rho : Real}
    (hell : 0 < ell)
    (hsep : eps <= rho * ell) :
    eps / ell <= rho := by
  exact ratio_le_of_eps_le_rho_mul_ell hell hsep

/-
Endpoint 70: finite mixing suppression from multiplicative scale separation.

This theorem is a named alias for:

  FiniteMixingMultiplicativeScaleAssumptions.imply_mixing_small
-/
theorem theorem_index_finite_mixing_multiplicative_scale_suppression
    {Cmix eps ell rho target : Real}
    {kappa : Nat}
    (h : FiniteMixingMultiplicativeScaleAssumptions Cmix eps ell rho target kappa) :
    2 * Cmix * (eps / ell)^kappa <= target := by
  exact FiniteMixingMultiplicativeScaleAssumptions.imply_mixing_small h

/-
Endpoint 71: Layer One mixing suppression from multiplicative scale separation.

This theorem is a named alias for:

  LayerOneMixingMultiplicativeScaleAssumptions.imply_layer_one_mixing_small
-/
theorem theorem_index_layer_one_mixing_multiplicative_scale_suppression
    {dBlock dUV Cmix eps ell rho : Real}
    {kappa : Nat}
    (h : LayerOneMixingMultiplicativeScaleAssumptions
      dBlock dUV Cmix eps ell rho kappa) :
    2 * Cmix * (eps / ell)^kappa <= (1 / 2) * min dBlock dUV := by
  exact LayerOneMixingMultiplicativeScaleAssumptions.imply_layer_one_mixing_small h

/-
Endpoint 72: Layer One gap from holonomy-coercivity and multiplicative
scale-separation mixing suppression.

This theorem is a named alias for:

  LayerOneFromHolonomyWithMultiplicativeMixingAssumptions.imply_layer_one_gap
-/
theorem theorem_index_layer_one_from_holonomy_with_multiplicative_mixing_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      LayerOneFromHolonomyWithMultiplicativeMixingAssumptions
        links Gap Energy curvatureNorm
        DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine := by
  exact LayerOneFromHolonomyWithMultiplicativeMixingAssumptions.imply_layer_one_gap h

/-
Endpoint 73: Clay gap from direct holonomy/coercivity, multiplicative mixing,
and epsilon continuum preservation.

This theorem is a named alias for:

  ClayFromDirectHolonomyWithMultiplicativeMixingEpsilonContinuumAssumptions.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_direct_holonomy_with_multiplicative_mixing_epsilon_continuum
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromDirectHolonomyWithMultiplicativeMixingEpsilonContinuumAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact
    ClayFromDirectHolonomyWithMultiplicativeMixingEpsilonContinuumAssumptions.imply_clay_gap h

/-
Endpoint 74: positive continuum YM gap from direct holonomy/coercivity,
multiplicative mixing, and epsilon continuum preservation.

This theorem is a named alias for:

  ClayFromDirectHolonomyWithMultiplicativeMixingEpsilonContinuumAssumptions.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_direct_holonomy_with_multiplicative_mixing_epsilon_continuum
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromDirectHolonomyWithMultiplicativeMixingEpsilonContinuumAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayFromDirectHolonomyWithMultiplicativeMixingEpsilonContinuumAssumptions.imply_positive_continuum_gap h

/-
Endpoint 75: Clay gap from holonomy red lemmas, multiplicative mixing, and
epsilon continuum preservation.

This theorem is a named alias for:

  ClayFromHolonomyRedLemmasWithMultiplicativeMixingEpsilonContinuumAssumptions.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_holonomy_red_lemmas_with_multiplicative_mixing_epsilon_continuum
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyRedLemmasWithMultiplicativeMixingEpsilonContinuumAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact
    ClayFromHolonomyRedLemmasWithMultiplicativeMixingEpsilonContinuumAssumptions.imply_clay_gap h

/-
Endpoint 76: positive continuum YM gap from holonomy red lemmas,
multiplicative mixing, and epsilon continuum preservation.

This theorem is a named alias for:

  ClayFromHolonomyRedLemmasWithMultiplicativeMixingEpsilonContinuumAssumptions.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_holonomy_red_lemmas_with_multiplicative_mixing_epsilon_continuum
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyRedLemmasWithMultiplicativeMixingEpsilonContinuumAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayFromHolonomyRedLemmasWithMultiplicativeMixingEpsilonContinuumAssumptions.imply_positive_continuum_gap h

/-
Endpoint 77: decomposed continuum red lemmas imply finite-to-continuum
gap-preservation assumptions.

This theorem is a named alias for:

  ContinuumRedLemmaAssumptions.imply_uniform_finite_to_continuum_gap_assumptions
-/
theorem theorem_index_continuum_red_lemmas_to_finite_to_continuum
    {DeltaYM Delta0 : Real}
    {Gap : Nat -> Real}
    (h : ContinuumRedLemmaAssumptions DeltaYM Delta0 Gap) :
    UniformFiniteToContinuumGapAssumptions DeltaYM Delta0 Gap := by
  exact ContinuumRedLemmaAssumptions.imply_uniform_finite_to_continuum_gap_assumptions h

/-
Endpoint 78: decomposed continuum red lemmas imply positive continuum gap.

This theorem is a named alias for:

  ContinuumRedLemmaAssumptions.imply_continuum_gap
-/
theorem theorem_index_continuum_red_lemmas_continuum_gap
    {DeltaYM Delta0 : Real}
    {Gap : Nat -> Real}
    (h : ContinuumRedLemmaAssumptions DeltaYM Delta0 Gap) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact ContinuumRedLemmaAssumptions.imply_continuum_gap h

/-
Endpoint 79: decomposed continuum red lemmas imply the original continuum gap
interface.

This theorem is a named alias for:

  ContinuumRedLemmaAssumptions.imply_continuum_gap_assumptions
-/
theorem theorem_index_continuum_red_lemmas_continuum_gap_assumptions
    {DeltaYM Delta0 : Real}
    {Gap : Nat -> Real}
    (h : ContinuumRedLemmaAssumptions DeltaYM Delta0 Gap) :
    ContinuumGapAssumptions DeltaYM Delta0 := by
  exact ContinuumRedLemmaAssumptions.imply_continuum_gap_assumptions h

/-
Endpoint 80: Clay gap from holonomy and continuum red lemmas.

This theorem is a named alias for:

  ClayFromHolonomyAndContinuumRedLemmasAssumptions.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_holonomy_and_continuum_red_lemmas
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyAndContinuumRedLemmasAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact
    ClayFromHolonomyAndContinuumRedLemmasAssumptions.imply_clay_gap h

/-
Endpoint 81: positive continuum YM gap from holonomy and continuum red lemmas.

This theorem is a named alias for:

  ClayFromHolonomyAndContinuumRedLemmasAssumptions.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_holonomy_and_continuum_red_lemmas
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromHolonomyAndContinuumRedLemmasAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayFromHolonomyAndContinuumRedLemmasAssumptions.imply_positive_continuum_gap h

/-
Endpoint 82: decomposed finite mixing red lemmas imply multiplicative
scale-separation assumptions.

This theorem is a named alias for:

  FiniteMixingRedLemmaAssumptions.imply_multiplicative_scale_assumptions
-/
theorem theorem_index_finite_mixing_red_lemmas_to_multiplicative_scale
    {Cmix eps ell rho target : Real}
    {kappa : Nat}
    (h : FiniteMixingRedLemmaAssumptions Cmix eps ell rho target kappa) :
    FiniteMixingMultiplicativeScaleAssumptions
      Cmix eps ell rho target kappa := by
  exact FiniteMixingRedLemmaAssumptions.imply_multiplicative_scale_assumptions h

/-
Endpoint 83: decomposed finite mixing red lemmas imply finite mixing-smallness.

This theorem is a named alias for:

  FiniteMixingRedLemmaAssumptions.imply_mixing_small
-/
theorem theorem_index_finite_mixing_red_lemmas_mixing_small
    {Cmix eps ell rho target : Real}
    {kappa : Nat}
    (h : FiniteMixingRedLemmaAssumptions Cmix eps ell rho target kappa) :
    2 * Cmix * (eps / ell)^kappa <= target := by
  exact FiniteMixingRedLemmaAssumptions.imply_mixing_small h

/-
Endpoint 84: decomposed Layer One mixing red lemmas imply multiplicative
Layer One mixing assumptions.

This theorem is a named alias for:

  LayerOneMixingRedLemmaAssumptions.imply_layer_one_multiplicative_scale_assumptions
-/
theorem theorem_index_layer_one_mixing_red_lemmas_to_multiplicative_scale
    {dBlock dUV Cmix eps ell rho : Real}
    {kappa : Nat}
    (h : LayerOneMixingRedLemmaAssumptions
      dBlock dUV Cmix eps ell rho kappa) :
    LayerOneMixingMultiplicativeScaleAssumptions
      dBlock dUV Cmix eps ell rho kappa := by
  exact LayerOneMixingRedLemmaAssumptions.imply_layer_one_multiplicative_scale_assumptions h

/-
Endpoint 85: decomposed Layer One mixing red lemmas imply Layer One
mixing-smallness.

This theorem is a named alias for:

  LayerOneMixingRedLemmaAssumptions.imply_layer_one_mixing_small
-/
theorem theorem_index_layer_one_mixing_red_lemmas_mixing_small
    {dBlock dUV Cmix eps ell rho : Real}
    {kappa : Nat}
    (h : LayerOneMixingRedLemmaAssumptions
      dBlock dUV Cmix eps ell rho kappa) :
    2 * Cmix * (eps / ell)^kappa <= (1 / 2) * min dBlock dUV := by
  exact LayerOneMixingRedLemmaAssumptions.imply_layer_one_mixing_small h

/-
Endpoint 86: Clay gap from all decomposed red lemmas.

This theorem is a named alias for:

  ClayFromAllRedLemmasAssumptions.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_all_red_lemmas
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromAllRedLemmasAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact ClayFromAllRedLemmasAssumptions.imply_clay_gap h

/-
Endpoint 87: positive continuum YM gap from all decomposed red lemmas.

This theorem is a named alias for:

  ClayFromAllRedLemmasAssumptions.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_all_red_lemmas
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromAllRedLemmasAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayFromAllRedLemmasAssumptions.imply_positive_continuum_gap h

/-
Endpoint 88: decomposed fine lower red lemmas imply the finite/fine
lower-bound inequality.

This theorem is a named alias for:

  FineLowerRedLemmaAssumptions.imply_fine_lower
-/
theorem theorem_index_fine_lower_red_lemmas_to_fine_lower
    {DeltaFine dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (h : FineLowerRedLemmaAssumptions
      DeltaFine dBlock dUV Cmix eps ell kappa) :
    min dBlock dUV - 2 * Cmix * (eps / ell)^kappa <= DeltaFine := by
  exact FineLowerRedLemmaAssumptions.imply_fine_lower h

/-
Endpoint 89: Clay gap from the complete decomposed red-lemma packet.

This theorem is a named alias for:

  ClayFromCompleteRedLemmasAssumptions.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_complete_red_lemmas
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromCompleteRedLemmasAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact ClayFromCompleteRedLemmasAssumptions.imply_clay_gap h

/-
Endpoint 90: positive continuum YM gap from the complete decomposed
red-lemma packet.

This theorem is a named alias for:

  ClayFromCompleteRedLemmasAssumptions.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_complete_red_lemmas
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromCompleteRedLemmasAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayFromCompleteRedLemmasAssumptions.imply_positive_continuum_gap h

/-
Endpoint 91: Layer-One scale red lemmas imply the scale normalization data.

This theorem is a named alias for:

  LayerOneScaleRedLemmaAssumptions.imply_scale_data
-/
theorem theorem_index_layer_one_scale_red_lemmas_to_scale_data
    {Delta0 dBlock dUV : Real}
    (h : LayerOneScaleRedLemmaAssumptions Delta0 dBlock dUV) :
    0 < dUV ∧ Delta0 = (1 / 2) * min dBlock dUV := by
  exact LayerOneScaleRedLemmaAssumptions.imply_scale_data h

/-
Endpoint 92: Clay gap from fully named red-lemma packets.

This theorem is a named alias for:

  ClayFromFullyNamedRedLemmasAssumptions.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_fully_named_red_lemmas
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromFullyNamedRedLemmasAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact ClayFromFullyNamedRedLemmasAssumptions.imply_clay_gap h

/-
Endpoint 93: positive continuum YM gap from fully named red-lemma packets.

This theorem is a named alias for:

  ClayFromFullyNamedRedLemmasAssumptions.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_fully_named_red_lemmas
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayFromFullyNamedRedLemmasAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayFromFullyNamedRedLemmasAssumptions.imply_positive_continuum_gap h

/-
Endpoint 94: the named red-lemma audit packet implies the fully named
red-lemma assumptions.

This theorem is a named alias for:

  ClayNamedRedLemmaAudit.to_fully_named_red_lemmas
-/
theorem theorem_index_named_red_lemma_audit_to_fully_named_red_lemmas
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayNamedRedLemmaAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayFromFullyNamedRedLemmasAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact ClayNamedRedLemmaAudit.to_fully_named_red_lemmas h

/-
Endpoint 95: Clay gap from the named red-lemma audit packet.

This theorem is a named alias for:

  ClayNamedRedLemmaAudit.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_named_red_lemma_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayNamedRedLemmaAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact ClayNamedRedLemmaAudit.imply_clay_gap h

/-
Endpoint 96: positive continuum YM gap from the named red-lemma audit packet.

This theorem is a named alias for:

  ClayNamedRedLemmaAudit.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_named_red_lemma_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayNamedRedLemmaAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayNamedRedLemmaAudit.imply_positive_continuum_gap h

/-
Endpoint 97: the atomic red-lemma audit implies the named red-lemma audit.

This theorem is a named alias for:

  ClayAtomicRedLemmaAudit.to_named_red_lemma_audit
-/
theorem theorem_index_atomic_red_lemma_audit_to_named_red_lemma_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayAtomicRedLemmaAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayNamedRedLemmaAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact ClayAtomicRedLemmaAudit.to_named_red_lemma_audit h

/-
Endpoint 98: Clay gap from the atomic red-lemma audit.

This theorem is a named alias for:

  ClayAtomicRedLemmaAudit.imply_clay_gap
-/
theorem theorem_index_clay_gap_from_atomic_red_lemma_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayAtomicRedLemmaAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact ClayAtomicRedLemmaAudit.imply_clay_gap h

/-
Endpoint 99: positive continuum YM gap from the atomic red-lemma audit.

This theorem is a named alias for:

  ClayAtomicRedLemmaAudit.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_atomic_red_lemma_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayAtomicRedLemmaAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayAtomicRedLemmaAudit.imply_positive_continuum_gap h

/-
Endpoint 100: primitive positive scale data implies positivity of the
Layer-One reference gap.

This theorem is a named alias for:

  LayerOnePositiveScaleAssumptions.imply_delta0_positive
-/
theorem theorem_index_positive_scale_data_to_delta0_positive
    {Delta0 dBlock dUV : Real}
    (h : LayerOnePositiveScaleAssumptions Delta0 dBlock dUV) :
    0 < Delta0 := by
  exact LayerOnePositiveScaleAssumptions.imply_delta0_positive h

/-
Endpoint 101: primitive positive scale data implies the Layer-One scale
red-lemma packet.

This theorem is a named alias for:

  LayerOnePositiveScaleAssumptions.to_scale_red_lemmas
-/
theorem theorem_index_positive_scale_data_to_scale_red_lemmas
    {Delta0 dBlock dUV : Real}
    (h : LayerOnePositiveScaleAssumptions Delta0 dBlock dUV) :
    LayerOneScaleRedLemmaAssumptions Delta0 dBlock dUV := by
  exact LayerOnePositiveScaleAssumptions.to_scale_red_lemmas h

/-
Endpoint 102: primitive positive scale data implies the full positive scale
checklist.
-/
theorem theorem_index_positive_scale_data_to_scale_checklist
    {Delta0 dBlock dUV : Real}
    (h : LayerOnePositiveScaleAssumptions Delta0 dBlock dUV) :
    0 < dBlock
      ∧ 0 < dUV
      ∧ Delta0 = (1 / 2) * min dBlock dUV
      ∧ 0 < Delta0 := by
  exact LayerOnePositiveScaleAssumptions.imply_positive_scale_data h

/-
Endpoint 103: positive-scale atomic audit implies the previous atomic audit.

This theorem is a named alias for:

  ClayPositiveScaleAtomicAudit.to_atomic_red_lemma_audit
-/
theorem theorem_index_positive_scale_atomic_audit_to_atomic_audit
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
    ClayAtomicRedLemmaAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact ClayPositiveScaleAtomicAudit.to_atomic_red_lemma_audit h

/-
Endpoint 104: positive continuum YM gap from the positive-scale atomic audit.

This theorem is a named alias for:

  ClayPositiveScaleAtomicAudit.imply_positive_continuum_gap
-/
theorem theorem_index_positive_continuum_gap_from_positive_scale_atomic_audit
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

/-
Endpoint 105: positive-scale atomic audit gives an explicit positive
finite-volume gap lower bound.

This theorem is a named alias for:

  ClayPositiveScaleAtomicAudit.exists_positive_finite_gap_bound
-/
theorem theorem_index_positive_scale_atomic_audit_to_exists_finite_gap_bound
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

/-
Endpoint 106: full conditional Clay-compatible gap data from the
positive-scale atomic audit.

This theorem is a named alias for:

  clay_conditional_gap_data
-/
theorem theorem_index_conditional_clay_gap_data
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
  exact clay_conditional_gap_data h

/-
Endpoint 107: clean conditional positive continuum Yang--Mills gap endpoint.

This theorem is a named alias for:

  clay_conditional_positive_continuum_gap
-/
theorem theorem_index_conditional_positive_continuum_gap
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

/-
Endpoint 108: formal conditional mass-gap summary.

This theorem is a named alias for:

  clay_conditional_mass_gap_summary
-/
theorem theorem_index_conditional_mass_gap_summary
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

/-
Endpoint 109: headline conditional Yang--Mills mass-gap theorem.

This theorem is a named alias for:

  conditional_yang_mills_mass_gap
-/
theorem theorem_index_conditional_yang_mills_mass_gap
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
  exact conditional_yang_mills_mass_gap h

/-
Endpoint 110: headline conditional positive continuum Yang--Mills gap theorem.

This theorem is a named alias for:

  conditional_yang_mills_positive_continuum_gap
-/
theorem theorem_index_conditional_yang_mills_positive_continuum_gap
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
  exact conditional_yang_mills_positive_continuum_gap h

/-
Endpoint 111: headline conditional positive finite-volume gap theorem.

This theorem is a named alias for:

  conditional_yang_mills_finite_gap_bound
-/
theorem theorem_index_conditional_yang_mills_finite_gap_bound
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
  exact conditional_yang_mills_finite_gap_bound h

/-
Endpoint 112: reduced finite-gap lower-only assumptions expose the finite
lower-bound estimate.
-/
theorem theorem_index_finite_gap_lower_only_to_finite_gap_lower
    {Delta0 : Real}
    {Gap : Nat -> Real}
    (h : FiniteGapLowerOnlyAssumptions Delta0 Gap) :
    forall n, Delta0 <= Gap n := by
  exact FiniteGapLowerOnlyAssumptions.imply_finite_gap_lower h

/-
Endpoint 113: reduced finite-gap lower-only assumptions plus positivity of
Delta0 recover the original uniform finite-gap lower packet.
-/
theorem theorem_index_finite_gap_lower_only_to_uniform_finite_gap_lower
    {Delta0 : Real}
    {Gap : Nat -> Real}
    (hDelta0_pos : 0 < Delta0)
    (h : FiniteGapLowerOnlyAssumptions Delta0 Gap) :
    UniformFiniteGapLowerAssumptions Delta0 Gap := by
  exact
    FiniteGapLowerOnlyAssumptions.to_uniform_finite_gap_lower
      hDelta0_pos h

/-
Endpoint 114: reduced finite-lower audit implies the positive-scale atomic
audit.
-/
theorem theorem_index_reduced_finite_lower_audit_to_positive_scale_atomic_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayReducedFiniteLowerAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayPositiveScaleAtomicAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact ClayReducedFiniteLowerAudit.to_positive_scale_atomic_audit h

/-
Endpoint 115: conditional Yang--Mills mass-gap theorem from the reduced
finite-lower audit.
-/
theorem theorem_index_conditional_mass_gap_from_reduced_finite_lower_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayReducedFiniteLowerAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayReducedFiniteLowerAudit.imply_conditional_mass_gap h

/-
Endpoint 121: primitive mixing packets imply the finite mixing red-lemma packet.
-/
theorem theorem_index_primitive_mixing_packets_to_finite_mixing_red_lemmas
    {Cmix eps ell rho target : Real}
    {kappa : Nat}
    (hPos : MixingScalePositivityAssumptions Cmix eps ell)
    (hSep : MultiplicativeScaleSeparationAssumptions eps ell rho)
    (hBudget : MixingRhoBudgetAssumptions Cmix rho target kappa) :
    FiniteMixingRedLemmaAssumptions Cmix eps ell rho target kappa := by
  exact
    finite_mixing_red_lemmas_from_primitive_packets
      hPos hSep hBudget

/-
Endpoint 122: primitive mixing audit implies the holonomy finite-lower audit.
-/
theorem theorem_index_primitive_mixing_audit_to_holonomy_finite_lower_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPrimitiveMixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayHolonomyFiniteLowerAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact ClayPrimitiveMixingAudit.to_holonomy_finite_lower_audit h

/-
Endpoint 123: conditional mass-gap theorem from the primitive mixing audit.
-/
theorem theorem_index_conditional_mass_gap_from_primitive_mixing_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPrimitiveMixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayPrimitiveMixingAudit.imply_conditional_mass_gap h

/-
Endpoint 124: positive continuum Yang--Mills gap from the primitive mixing
audit.
-/
theorem theorem_index_positive_continuum_gap_from_primitive_mixing_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayPrimitiveMixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayPrimitiveMixingAudit.imply_positive_continuum_gap h

/-
Endpoint 125: a Delta0-targeted rho budget recovers the old half-min
rho-budget target using the Layer-One scale definition.
-/
theorem theorem_index_delta0_budget_to_half_min_budget
    {Delta0 dBlock dUV Cmix rho : Real}
    {kappa : Nat}
    (hScale :
      LayerOnePositiveScaleAssumptions Delta0 dBlock dUV)
    (hBudget :
      MixingRhoBudgetAssumptions Cmix rho Delta0 kappa) :
    MixingRhoBudgetAssumptions
      Cmix rho ((1 / 2) * min dBlock dUV) kappa := by
  exact
    mixing_rho_budget_to_half_min_from_delta0
      hScale hBudget

/-
Endpoint 126: Delta0-targeted mixing audit implies the primitive mixing audit.
-/
theorem theorem_index_delta0_mixing_audit_to_primitive_mixing_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDelta0MixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayPrimitiveMixingAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact ClayDelta0MixingAudit.to_primitive_mixing_audit h

/-
Endpoint 127: conditional mass-gap theorem from the Delta0-targeted mixing audit.
-/
theorem theorem_index_conditional_mass_gap_from_delta0_mixing_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDelta0MixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayDelta0MixingAudit.imply_conditional_mass_gap h

/-
Endpoint 128: positive continuum Yang--Mills gap from the Delta0-targeted
mixing audit.
-/
theorem theorem_index_positive_continuum_gap_from_delta0_mixing_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDelta0MixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayDelta0MixingAudit.imply_positive_continuum_gap h

/-
Endpoint 129: primitive Delta0-targeted mixing packets imply mixing smallness
with target Delta0.
-/
theorem theorem_index_delta0_primitive_mixing_to_mixing_small
    {Cmix eps ell rho Delta0 : Real}
    {kappa : Nat}
    (hPos : MixingScalePositivityAssumptions Cmix eps ell)
    (hSep : MultiplicativeScaleSeparationAssumptions eps ell rho)
    (hBudget : MixingRhoBudgetAssumptions Cmix rho Delta0 kappa) :
    2 * Cmix * (eps / ell)^kappa <= Delta0 := by
  exact
    mixing_small_from_delta0_primitive_packets
      hPos hSep hBudget

/-
Endpoint 130: Schur/Feshbach fine lower bound plus Delta0-targeted primitive
mixing control implies Delta0 <= DeltaFine.
-/
theorem theorem_index_schur_mixing_to_delta0_le_deltaFine
    {DeltaFine Delta0 dBlock dUV Cmix eps ell rho : Real}
    {kappa : Nat}
    (hScale :
      LayerOnePositiveScaleAssumptions Delta0 dBlock dUV)
    (hPos : MixingScalePositivityAssumptions Cmix eps ell)
    (hSep : MultiplicativeScaleSeparationAssumptions eps ell rho)
    (hBudget : MixingRhoBudgetAssumptions Cmix rho Delta0 kappa)
    (hFine :
      FineLowerSchurComplementAssumptions
        DeltaFine dBlock dUV Cmix eps ell kappa) :
    Delta0 <= DeltaFine := by
  exact
    FineLowerSchurComplementAssumptions.imply_delta0_le_deltaFine
      hScale hPos hSep hBudget hFine

/-
Endpoint 131: Delta0-targeted Clay mixing audit implies Delta0 <= DeltaFine.
-/
theorem theorem_index_delta0_mixing_audit_to_delta0_le_deltaFine
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDelta0MixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    Delta0 <= DeltaFine := by
  exact ClayDelta0MixingAudit.imply_delta0_le_deltaFine h

/-
Endpoint 132: Delta0-targeted Clay mixing audit implies Layer-One fine gap data.
-/
theorem theorem_index_delta0_mixing_audit_to_layer_one_fine_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDelta0MixingAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact ClayDelta0MixingAudit.imply_layer_one_fine_gap_data h

/-
Endpoint 133: derived fine-gap audit implies the Delta0-targeted mixing audit.
-/
theorem theorem_index_derived_fine_gap_audit_to_delta0_mixing_audit
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
    ClayDelta0MixingAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact ClayDerivedFineGapAudit.to_delta0_mixing_audit h

/-
Endpoint 134: derived fine-gap audit implies Layer-One fine gap data.
-/
theorem theorem_index_derived_fine_gap_audit_to_layer_one_fine_gap_data
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

/-
Endpoint 135: conditional mass-gap theorem from the derived fine-gap audit.
-/
theorem theorem_index_conditional_mass_gap_from_derived_fine_gap_audit
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

/-
Endpoint 136: positive continuum Yang--Mills gap from the derived fine-gap audit.
-/
theorem theorem_index_positive_continuum_gap_from_derived_fine_gap_audit
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
  exact ClayDerivedFineGapAudit.imply_positive_continuum_gap h

/-
Endpoint 137: derived fine-gap audit implies the decomposed continuum
red-lemma packet.
-/
theorem theorem_index_derived_fine_gap_audit_to_continuum_red_lemmas
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
  exact ClayDerivedFineGapAudit.to_continuum_red_lemmas h

/-
Endpoint 138: derived fine-gap audit implies continuum gap data.
-/
theorem theorem_index_derived_fine_gap_audit_to_continuum_gap_data
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
  exact ClayDerivedFineGapAudit.imply_continuum_gap_data h

/-
Endpoint 139: derived fine-gap audit implies the positive continuum
Yang--Mills gap directly.
-/
theorem theorem_index_derived_fine_gap_audit_to_positive_continuum_gap_direct
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

/-
Endpoint 140: derived fine-gap audit implies both Layer-One fine gap data and
continuum gap data.
-/
theorem theorem_index_derived_fine_gap_audit_to_fine_and_continuum_gap_data
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
  exact ClayDerivedFineGapAudit.imply_fine_and_continuum_gap_data h

/-
Endpoint 141: strongest conditional Yang--Mills gap data from the current
audited route.
-/
theorem theorem_index_strongest_conditional_yang_mills_gap_data
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
  exact strongest_conditional_yang_mills_gap_data h

/-
Endpoint 142: strongest headline conditional Yang--Mills mass-gap theorem.
-/
theorem theorem_index_strongest_conditional_yang_mills_mass_gap
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
  exact strongest_conditional_yang_mills_mass_gap h

/-
Endpoint 143: strongest conditional positive continuum Yang--Mills gap theorem.
-/
theorem theorem_index_strongest_conditional_yang_mills_positive_continuum_gap
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
  exact strongest_conditional_yang_mills_positive_continuum_gap h

/-
Endpoint 144: strongest conditional Layer-One fine gap theorem.
-/
theorem theorem_index_strongest_conditional_yang_mills_layer_one_fine_gap
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
  exact strongest_conditional_yang_mills_layer_one_fine_gap h

/-
Endpoint 145: named epsilon-continuum survival recovers the epsilon continuum
approximation packet.
-/
theorem theorem_index_epsilon_survival_to_epsilon_continuum_approximation
    {DeltaYM : Real}
    {Gap : Nat -> Real}
    (h : EpsilonContinuumSurvivalAssumptions DeltaYM Gap) :
    EpsilonContinuumApproximationAssumptions DeltaYM Gap := by
  exact
    EpsilonContinuumSurvivalAssumptions.to_epsilon_continuum_approximation h

/-
Endpoint 146: named epsilon-continuum survival plus finite lower-bound data
recovers the decomposed continuum red-lemma packet.
-/
theorem theorem_index_epsilon_survival_to_continuum_red_lemmas
    {DeltaYM Delta0 : Real}
    {Gap : Nat -> Real}
    (hFinite : UniformFiniteGapLowerAssumptions Delta0 Gap)
    (hSurvival : EpsilonContinuumSurvivalAssumptions DeltaYM Gap) :
    ContinuumRedLemmaAssumptions DeltaYM Delta0 Gap := by
  exact
    EpsilonContinuumSurvivalAssumptions.to_continuum_red_lemmas
      hFinite hSurvival

/-
Endpoint 147: survival audit implies the derived fine-gap audit.
-/
theorem theorem_index_survival_audit_to_derived_fine_gap_audit
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
    ClayDerivedFineGapAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact ClaySurvivalAudit.to_derived_fine_gap_audit h

/-
Endpoint 148: strongest conditional Yang--Mills mass-gap theorem from the
survival audit.
-/
theorem theorem_index_strongest_conditional_mass_gap_from_survival_audit
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
      ∧ 0 < DeltaYM := by
  exact ClaySurvivalAudit.imply_strongest_conditional_mass_gap h

/-
Endpoint 149: survival audit implies Layer-One fine gap data.
-/
theorem theorem_index_survival_audit_to_layer_one_fine_gap_data
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
  exact ClaySurvivalAudit.imply_layer_one_fine_gap_data h

/-
Endpoint 150: survival audit implies continuum gap data.
-/
theorem theorem_index_survival_audit_to_continuum_gap_data
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
  exact ClaySurvivalAudit.imply_continuum_gap_data h

/-
Endpoint 151: survival audit implies both fine and continuum gap data.
-/
theorem theorem_index_survival_audit_to_fine_and_continuum_gap_data
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
  exact ClaySurvivalAudit.imply_fine_and_continuum_gap_data h

/-
Endpoint 152: survival audit implies the full strongest conditional gap data.
-/
theorem theorem_index_survival_audit_to_full_survival_gap_data
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
  exact ClaySurvivalAudit.imply_full_survival_gap_data h

/-
Endpoint 153: holonomy-packet survival audit implies the previous survival audit.
-/
theorem theorem_index_holonomy_packet_survival_audit_to_survival_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyPacketSurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClaySurvivalAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact ClayHolonomyPacketSurvivalAudit.to_survival_audit h

/-
Endpoint 154: holonomy-packet survival audit implies Layer-One fine gap data.
-/
theorem theorem_index_holonomy_packet_survival_audit_to_layer_one_fine_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyPacketSurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact ClayHolonomyPacketSurvivalAudit.imply_layer_one_fine_gap_data h

/-
Endpoint 155: holonomy-packet survival audit implies continuum gap data.
-/
theorem theorem_index_holonomy_packet_survival_audit_to_continuum_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyPacketSurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact ClayHolonomyPacketSurvivalAudit.imply_continuum_gap_data h

/-
Endpoint 156: strongest conditional mass-gap theorem from the holonomy-packet
survival audit.
-/
theorem theorem_index_strongest_conditional_mass_gap_from_holonomy_packet_survival_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyPacketSurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayHolonomyPacketSurvivalAudit.imply_strongest_conditional_mass_gap h

/-
Endpoint 157: full survival gap data from the holonomy-packet survival audit.
-/
theorem theorem_index_full_survival_gap_data_from_holonomy_packet_survival_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayHolonomyPacketSurvivalAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayHolonomyPacketSurvivalAudit.imply_full_survival_gap_data h

/-
Endpoint 158: Delta0-targeted mixing red-lemma packet implies the finite mixing
red-lemma packet with target Delta0.
-/
theorem theorem_index_delta0_targeted_mixing_packet_to_finite_mixing_red_lemmas
    {Cmix eps ell rho Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0TargetedMixingRedLemmaAssumptions
        Cmix eps ell rho Delta0 kappa) :
    FiniteMixingRedLemmaAssumptions Cmix eps ell rho Delta0 kappa := by
  exact Delta0TargetedMixingRedLemmaAssumptions.to_finite_mixing_red_lemmas h

/-
Endpoint 159: clean red-lemma theorem assumptions imply the holonomy-packet
survival audit.
-/
theorem theorem_index_red_lemma_theorem_assumptions_to_holonomy_packet_survival_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayHolonomyPacketSurvivalAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact ClayRedLemmaTheoremAssumptions.to_holonomy_packet_survival_audit h

/-
Endpoint 160: full strongest gap data from the clean red-lemma theorem
assumptions.
-/
theorem theorem_index_red_lemma_theorem_assumptions_to_strongest_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayRedLemmaTheoremAssumptions.imply_strongest_gap_data h

/-
Endpoint 161: clean red-lemma theorem implies the strongest conditional
Yang--Mills mass-gap summary.
-/
theorem theorem_index_clay_red_lemma_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact clay_red_lemma_theorem_implies_mass_gap h

/-
Endpoint 162: clean red-lemma theorem implies the positive continuum
Yang--Mills gap.
-/
theorem theorem_index_clay_red_lemma_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact clay_red_lemma_theorem_implies_positive_continuum_gap h

/-
Endpoint 163: Delta0-targeted primitive mixing packet implies direct Delta0
mixing smallness.
-/
theorem theorem_index_delta0_targeted_mixing_to_direct_mixing_smallness
    {Cmix eps ell rho Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0TargetedMixingRedLemmaAssumptions
        Cmix eps ell rho Delta0 kappa) :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
  exact Delta0TargetedMixingRedLemmaAssumptions.to_delta0_mixing_smallness h

/-
Endpoint 164: Schur/Feshbach plus direct Delta0 mixing smallness implies
Delta0 <= DeltaFine.
-/
theorem theorem_index_schur_direct_mixing_to_delta0_le_deltaFine
    {DeltaFine Delta0 dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (hScale :
      LayerOnePositiveScaleAssumptions Delta0 dBlock dUV)
    (hMix :
      Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa)
    (hFine :
      FineLowerSchurComplementAssumptions
        DeltaFine dBlock dUV Cmix eps ell kappa) :
    Delta0 <= DeltaFine := by
  exact
    FineLowerSchurComplementAssumptions.imply_delta0_le_deltaFine_of_mixing_small
      hScale hMix hFine

/-
Endpoint 165: direct-mixing Clay assumptions imply Layer-One fine gap data.
-/
theorem theorem_index_direct_mixing_clay_to_layer_one_fine_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectMixingRedLemmaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact ClayDirectMixingRedLemmaAssumptions.imply_layer_one_fine_gap_data h

/-
Endpoint 166: direct-mixing Clay assumptions imply continuum gap data.
-/
theorem theorem_index_direct_mixing_clay_to_continuum_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectMixingRedLemmaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact ClayDirectMixingRedLemmaAssumptions.imply_continuum_gap_data h

/-
Endpoint 167: direct-mixing Clay theorem implies positive continuum YM gap.
-/
theorem theorem_index_direct_mixing_clay_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectMixingRedLemmaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    0 < DeltaYM := by
  exact clay_direct_mixing_red_lemma_theorem_implies_positive_continuum_gap h

/-
Endpoint 168: direct-mixing Clay theorem implies the strongest conditional
mass-gap summary.
-/
theorem theorem_index_direct_mixing_clay_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectMixingRedLemmaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact clay_direct_mixing_red_lemma_theorem_implies_mass_gap h

/-
Endpoint 169: current clean direct red-lemma theorem implies full strongest gap
data.
-/
theorem theorem_index_direct_red_lemma_theorem_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact clay_direct_red_lemma_theorem_implies_full_gap_data h

/-
Endpoint 170: current clean direct red-lemma theorem implies the strongest
conditional Yang--Mills mass-gap summary.
-/
theorem theorem_index_direct_red_lemma_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact clay_direct_red_lemma_theorem_implies_mass_gap h

/-
Endpoint 171: current clean direct red-lemma theorem implies the positive
continuum Yang--Mills gap.
-/
theorem theorem_index_direct_red_lemma_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayDirectRedLemmaTheoremAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    0 < DeltaYM := by
  exact clay_direct_red_lemma_theorem_implies_positive_continuum_gap h

/-
Endpoint 172: reduced scale assumptions plus block positivity recover the
positive scale packet.
-/
theorem theorem_index_reduced_scale_to_positive_scale
    {Delta0 dBlock dUV : Real}
    (hBlock_pos : 0 < dBlock)
    (h :
      LayerOneReducedScaleAssumptions Delta0 dBlock dUV) :
    LayerOnePositiveScaleAssumptions Delta0 dBlock dUV := by
  exact LayerOneReducedScaleAssumptions.to_positive_scale hBlock_pos h

/-
Endpoint 173: holonomy red-lemma packet supplies positivity of the Clay block
scale.
-/
theorem theorem_index_holonomy_packet_to_block_scale_positive
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      UniformHolonomyRedLemmaAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    0 < mu * (delta / C)^2 := by
  exact UniformHolonomyRedLemmaAssumptions.imply_block_scale_positive h

/-
Endpoint 174: reduced-scale direct assumptions imply the previous direct
red-lemma assumptions.
-/
theorem theorem_index_reduced_scale_direct_to_direct_red_lemma_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayReducedScaleDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    ClayDirectRedLemmaTheoremAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa := by
  exact ClayReducedScaleDirectAssumptions.to_direct_red_lemma_assumptions h

/-
Endpoint 175: reduced-scale direct theorem implies strongest conditional
mass-gap summary.
-/
theorem theorem_index_reduced_scale_direct_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayReducedScaleDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayReducedScaleDirectAssumptions.imply_mass_gap h

/-
Endpoint 176: reduced-scale direct theorem implies positive continuum
Yang--Mills gap.
-/
theorem theorem_index_reduced_scale_direct_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayReducedScaleDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayReducedScaleDirectAssumptions.imply_positive_continuum_gap h

/-
Endpoint 177: mixing parameter criterion implies direct Delta0 mixing smallness.
-/
theorem theorem_index_mixing_parameter_criterion_to_delta0_mixing_smallness
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingParameterCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
  exact
    Delta0MixingParameterCriterionAssumptions.to_delta0_mixing_smallness h

/-
Endpoint 178: mixing-parameter Clay assumptions imply reduced-scale direct Clay
assumptions.
-/
theorem theorem_index_mixing_parameter_direct_to_reduced_scale_direct
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingParameterDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    ClayReducedScaleDirectAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa := by
  exact ClayMixingParameterDirectAssumptions.to_reduced_scale_direct_assumptions h

/-
Endpoint 179: mixing-parameter theorem implies full strongest gap data.
-/
theorem theorem_index_mixing_parameter_direct_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingParameterDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayMixingParameterDirectAssumptions.imply_full_gap_data h

/-
Endpoint 180: mixing-parameter theorem implies strongest conditional mass-gap
summary.
-/
theorem theorem_index_mixing_parameter_direct_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingParameterDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayMixingParameterDirectAssumptions.imply_mass_gap h

/-
Endpoint 181: mixing-parameter theorem implies positive continuum Yang--Mills
gap.
-/
theorem theorem_index_mixing_parameter_direct_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingParameterDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayMixingParameterDirectAssumptions.imply_positive_continuum_gap h

/-
Endpoint 182: mixing power criterion implies the mixing parameter criterion.
-/
theorem theorem_index_mixing_power_to_parameter_criterion
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingPowerCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingParameterCriterionAssumptions
      Cmix eps ell q Delta0 kappa := by
  exact Delta0MixingPowerCriterionAssumptions.to_parameter_criterion h

/-
Endpoint 183: mixing power criterion implies direct Delta0 mixing smallness.
-/
theorem theorem_index_mixing_power_to_delta0_mixing_smallness
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingPowerCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
  exact Delta0MixingPowerCriterionAssumptions.to_delta0_mixing_smallness h

/-
Endpoint 184: mixing-power Clay assumptions imply mixing-parameter Clay
assumptions.
-/
theorem theorem_index_mixing_power_direct_to_mixing_parameter_direct
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingPowerDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    ClayMixingParameterDirectAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa := by
  exact ClayMixingPowerDirectAssumptions.to_mixing_parameter_direct_assumptions h

/-
Endpoint 185: mixing-power theorem implies strongest conditional mass-gap
summary.
-/
theorem theorem_index_mixing_power_direct_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingPowerDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayMixingPowerDirectAssumptions.imply_mass_gap h

/-
Endpoint 186: mixing-power theorem implies positive continuum Yang--Mills gap.
-/
theorem theorem_index_mixing_power_direct_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingPowerDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayMixingPowerDirectAssumptions.imply_positive_continuum_gap h

/-
Endpoint 187: nonnegative base ratio control implies power control.
-/
theorem theorem_index_nonnegative_ratio_control_to_power_control
    {a b : Real}
    (ha : 0 <= a)
    (hab : a <= b)
    (n : Nat) :
    a^n <= b^n := by
  exact real_pow_le_pow_of_nonneg_le ha hab n

/-
Endpoint 188: mixing ratio criterion implies the mixing power criterion.
-/
theorem theorem_index_mixing_ratio_to_power_criterion
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingRatioCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingPowerCriterionAssumptions
      Cmix eps ell q Delta0 kappa := by
  exact Delta0MixingRatioCriterionAssumptions.to_power_criterion h

/-
Endpoint 189: mixing ratio criterion implies direct Delta0 mixing smallness.
-/
theorem theorem_index_mixing_ratio_to_delta0_mixing_smallness
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingRatioCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
  exact Delta0MixingRatioCriterionAssumptions.to_delta0_mixing_smallness h

/-
Endpoint 190: mixing-ratio Clay assumptions imply strongest conditional mass-gap
summary.
-/
theorem theorem_index_mixing_ratio_direct_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingRatioDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayMixingRatioDirectAssumptions.imply_mass_gap h

/-
Endpoint 191: mixing-ratio Clay assumptions imply positive continuum
Yang--Mills gap.
-/
theorem theorem_index_mixing_ratio_direct_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingRatioDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayMixingRatioDirectAssumptions.imply_positive_continuum_gap h

/-
Endpoint 192: mixing scale-separation criterion implies the mixing ratio
criterion.
-/
theorem theorem_index_mixing_scale_separation_to_ratio_criterion
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingScaleSeparationCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingRatioCriterionAssumptions
      Cmix eps ell q Delta0 kappa := by
  exact
    Delta0MixingScaleSeparationCriterionAssumptions.to_ratio_criterion h

/-
Endpoint 193: mixing scale-separation criterion implies direct Delta0 mixing
smallness.
-/
theorem theorem_index_mixing_scale_separation_to_delta0_mixing_smallness
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingScaleSeparationCriterionAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
  exact
    Delta0MixingScaleSeparationCriterionAssumptions.to_delta0_mixing_smallness h

/-
Endpoint 194: mixing scale-separation Clay assumptions imply mixing-ratio Clay
assumptions.
-/
theorem theorem_index_mixing_scale_separation_direct_to_mixing_ratio_direct
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingScaleSeparationDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    ClayMixingRatioDirectAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa := by
  exact
    ClayMixingScaleSeparationDirectAssumptions.to_mixing_ratio_direct_assumptions h

/-
Endpoint 195: mixing scale-separation theorem implies strongest conditional
mass-gap summary.
-/
theorem theorem_index_mixing_scale_separation_direct_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingScaleSeparationDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayMixingScaleSeparationDirectAssumptions.imply_mass_gap h

/-
Endpoint 196: mixing scale-separation theorem implies positive continuum
Yang--Mills gap.
-/
theorem theorem_index_mixing_scale_separation_direct_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingScaleSeparationDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayMixingScaleSeparationDirectAssumptions.imply_positive_continuum_gap h

/-
Endpoint 197: mixing decay-budget criterion implies the mixing scale-separation
criterion.
-/
theorem theorem_index_mixing_decay_budget_to_scale_separation_criterion
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingDecayBudgetAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingScaleSeparationCriterionAssumptions
      Cmix eps ell q Delta0 kappa := by
  exact
    Delta0MixingDecayBudgetAssumptions.to_scale_separation_criterion h

/-
Endpoint 198: mixing decay-budget criterion implies direct Delta0 mixing
smallness.
-/
theorem theorem_index_mixing_decay_budget_to_delta0_mixing_smallness
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (h :
      Delta0MixingDecayBudgetAssumptions
        Cmix eps ell q Delta0 kappa) :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa := by
  exact
    Delta0MixingDecayBudgetAssumptions.to_delta0_mixing_smallness h

/-
Endpoint 199: mixing decay-budget Clay assumptions imply mixing
scale-separation Clay assumptions.
-/
theorem theorem_index_mixing_decay_budget_direct_to_mixing_scale_separation_direct
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingDecayBudgetDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    ClayMixingScaleSeparationDirectAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa := by
  exact
    ClayMixingDecayBudgetDirectAssumptions.to_mixing_scale_separation_direct_assumptions h

/-
Endpoint 200: mixing decay-budget theorem implies strongest conditional
mass-gap summary.
-/
theorem theorem_index_mixing_decay_budget_direct_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingDecayBudgetDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayMixingDecayBudgetDirectAssumptions.imply_mass_gap h

/-
Endpoint 201: mixing decay-budget theorem implies positive continuum
Yang--Mills gap.
-/
theorem theorem_index_mixing_decay_budget_direct_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayMixingDecayBudgetDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa) :
    0 < DeltaYM := by
  exact ClayMixingDecayBudgetDirectAssumptions.imply_positive_continuum_gap h

/-
Endpoint 202: existential-kappa assumptions produce a concrete kappa satisfying
the mixing-decay direct Clay assumptions.
-/
theorem theorem_index_mixing_kappa_existence_to_decay_budget_direct_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingKappaExistenceAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    ∃ kappa : Nat,
      ClayMixingDecayBudgetDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta kappa := by
  exact
    ClayMixingKappaExistenceAssumptions.exists_decay_budget_direct_assumptions h

/-
Endpoint 203: existential-kappa theorem implies full strongest gap data.
-/
theorem theorem_index_mixing_kappa_existence_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingKappaExistenceAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayMixingKappaExistenceAssumptions.imply_full_gap_data h

/-
Endpoint 204: existential-kappa theorem implies strongest conditional mass-gap
summary.
-/
theorem theorem_index_mixing_kappa_existence_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingKappaExistenceAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayMixingKappaExistenceAssumptions.imply_mass_gap h

/-
Endpoint 205: existential-kappa theorem implies positive continuum Yang--Mills
gap.
-/
theorem theorem_index_mixing_kappa_existence_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingKappaExistenceAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    0 < DeltaYM := by
  exact ClayMixingKappaExistenceAssumptions.imply_positive_continuum_gap h

/-
Endpoint 206: mixing scale data plus kappa decay budget recover the previous
decay-budget mixing assumptions.
-/
theorem theorem_index_mixing_scale_data_with_kappa_decay_budget
    {Cmix eps ell q Delta0 : Real}
    {kappa : Nat}
    (hScale : Delta0MixingScaleData Cmix eps ell q)
    (hDecay : Delta0MixingKappaDecayBudget Cmix q Delta0 kappa) :
    Delta0MixingDecayBudgetAssumptions Cmix eps ell q Delta0 kappa := by
  exact Delta0MixingScaleData.with_kappa_decay_budget hScale hDecay

/-
Endpoint 207: separated-kappa assumptions imply the previous existential-kappa
assumptions.
-/
theorem theorem_index_separated_kappa_to_mixing_kappa_existence
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    ClayMixingKappaExistenceAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta := by
  exact ClayMixingSeparatedKappaAssumptions.to_mixing_kappa_existence_assumptions h

/-
Endpoint 208: separated-kappa theorem implies full strongest gap data.
-/
theorem theorem_index_separated_kappa_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayMixingSeparatedKappaAssumptions.imply_full_gap_data h

/-
Endpoint 209: separated-kappa theorem implies strongest conditional mass-gap
summary.
-/
theorem theorem_index_separated_kappa_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayMixingSeparatedKappaAssumptions.imply_mass_gap h

/-
Endpoint 210: separated-kappa theorem implies positive continuum Yang--Mills
gap.
-/
theorem theorem_index_separated_kappa_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    0 < DeltaYM := by
  exact ClayMixingSeparatedKappaAssumptions.imply_positive_continuum_gap h

/-
Endpoint 211: separated-kappa theorem implies full strongest gap data.
-/
theorem theorem_index_separated_kappa_theorem_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact clay_separated_kappa_theorem_implies_full_gap_data h

/-
Endpoint 212: separated-kappa theorem implies strongest conditional mass-gap
summary.
-/
theorem theorem_index_separated_kappa_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact clay_separated_kappa_theorem_implies_mass_gap h

/-
Endpoint 213: separated-kappa theorem implies positive continuum Yang--Mills gap.
-/
theorem theorem_index_separated_kappa_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClayMixingSeparatedKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    0 < DeltaYM := by
  exact clay_separated_kappa_theorem_implies_positive_continuum_gap h

/-
Endpoint 214: Schur/Feshbach loss lower bound plus concrete mixing-loss
identity recovers the previous fine-lower Schur packet.
-/
theorem theorem_index_schur_loss_lower_to_fine_lower_schur
    {DeltaFine dBlock dUV loss Cmix eps ell : Real}
    {kappa : Nat}
    (hSchur :
      SchurFeshbachLossLowerAssumptions
        DeltaFine dBlock dUV loss)
    (hLoss :
      KappaMixingLossIdentity loss Cmix eps ell kappa) :
    FineLowerSchurComplementAssumptions
      DeltaFine dBlock dUV Cmix eps ell kappa := by
  exact
    SchurFeshbachLossLowerAssumptions.to_fine_lower_schur
      hSchur hLoss

/-
Endpoint 215: Schur-loss kappa assumptions imply separated-kappa assumptions.
-/
theorem theorem_index_schur_loss_kappa_to_separated_kappa
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    ClayMixingSeparatedKappaAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta := by
  exact ClaySchurLossKappaAssumptions.to_separated_kappa_assumptions h

/-
Endpoint 216: Schur-loss theorem implies full strongest gap data.
-/
theorem theorem_index_schur_loss_kappa_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClaySchurLossKappaAssumptions.imply_full_gap_data h

/-
Endpoint 217: Schur-loss theorem implies strongest conditional mass-gap summary.
-/
theorem theorem_index_schur_loss_kappa_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClaySchurLossKappaAssumptions.imply_mass_gap h

/-
Endpoint 218: Schur-loss theorem implies positive continuum Yang--Mills gap.
-/
theorem theorem_index_schur_loss_kappa_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    0 < DeltaYM := by
  exact ClaySchurLossKappaAssumptions.imply_positive_continuum_gap h

/-
Endpoint 219: Schur-loss theorem implies full strongest gap data.
-/
theorem theorem_index_schur_loss_theorem_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact clay_schur_loss_theorem_implies_full_gap_data h

/-
Endpoint 220: Schur-loss theorem implies strongest conditional mass-gap summary.
-/
theorem theorem_index_schur_loss_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact clay_schur_loss_theorem_implies_mass_gap h

/-
Endpoint 221: Schur-loss theorem implies positive continuum Yang--Mills gap.
-/
theorem theorem_index_schur_loss_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    0 < DeltaYM := by
  exact clay_schur_loss_theorem_implies_positive_continuum_gap h

/-
Endpoint 222: mixing loss identity plus mixing scale/decay data imply the Schur
loss budget.
-/
theorem theorem_index_kappa_mixing_loss_identity_implies_loss_budget
    {Cmix eps ell q Delta0 loss : Real}
    {kappa : Nat}
    (hScale : Delta0MixingScaleData Cmix eps ell q)
    (hDecay : Delta0MixingKappaDecayBudget Cmix q Delta0 kappa)
    (hLoss : KappaMixingLossIdentity loss Cmix eps ell kappa) :
    SchurLossBudgetAssumptions loss Delta0 := by
  exact KappaMixingLossIdentity.imply_loss_budget hScale hDecay hLoss

/-
Endpoint 223: Schur/Feshbach lower bound plus loss budget implies
Delta0 <= DeltaFine.
-/
theorem theorem_index_schur_loss_budget_to_delta0_le_deltaFine
    {DeltaFine Delta0 dBlock dUV loss : Real}
    (hScale :
      LayerOneReducedScaleAssumptions Delta0 dBlock dUV)
    (hBudget :
      SchurLossBudgetAssumptions loss Delta0)
    (hSchur :
      SchurFeshbachLossLowerAssumptions DeltaFine dBlock dUV loss) :
    Delta0 <= DeltaFine := by
  exact
    SchurFeshbachLossLowerAssumptions.imply_delta0_le_deltaFine_of_loss_budget
      hScale hBudget hSchur

/-
Endpoint 224: Schur-loss kappa assumptions imply Delta0 <= DeltaFine by the
loss-budget bridge.
-/
theorem theorem_index_schur_loss_kappa_to_delta0_le_deltaFine_by_loss_budget
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    Delta0 <= DeltaFine := by
  exact ClaySchurLossKappaAssumptions.imply_delta0_le_deltaFine_by_loss_budget h

/-
Endpoint 225: Schur-loss kappa assumptions imply Layer-One fine gap data by the
loss-budget bridge.
-/
theorem theorem_index_schur_loss_kappa_to_layer_one_fine_gap_data_by_loss_budget
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta : Real}
    (h :
      ClaySchurLossKappaAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell q C mu delta) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact
    ClaySchurLossKappaAssumptions.imply_layer_one_fine_gap_data_by_loss_budget h

/-
Endpoint 226: Schur-budget assumptions imply positive scale data.
-/
theorem theorem_index_schur_budget_to_positive_scale
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    LayerOnePositiveScaleAssumptions
      Delta0 (mu * (delta / C)^2) dUV := by
  exact ClaySchurBudgetAssumptions.to_positive_scale h

/-
Endpoint 227: Schur-budget assumptions imply Layer-One fine gap data.
-/
theorem theorem_index_schur_budget_to_layer_one_fine_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact ClaySchurBudgetAssumptions.imply_layer_one_fine_gap_data h

/-
Endpoint 228: Schur-budget assumptions imply continuum gap data.
-/
theorem theorem_index_schur_budget_to_continuum_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact ClaySchurBudgetAssumptions.imply_continuum_gap_data h

/-
Endpoint 229: Schur-budget assumptions imply full strongest gap data.
-/
theorem theorem_index_schur_budget_to_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClaySchurBudgetAssumptions.imply_full_gap_data h

/-
Endpoint 230: Schur-budget assumptions imply strongest conditional mass-gap
summary.
-/
theorem theorem_index_schur_budget_to_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClaySchurBudgetAssumptions.imply_mass_gap h

/-
Endpoint 231: Schur-budget assumptions imply positive continuum Yang--Mills gap.
-/
theorem theorem_index_schur_budget_to_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact ClaySchurBudgetAssumptions.imply_positive_continuum_gap h

/-
Endpoint 232: Schur-budget theorem implies full strongest gap data.
-/
theorem theorem_index_schur_budget_theorem_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact clay_schur_budget_theorem_implies_full_gap_data h

/-
Endpoint 233: Schur-budget theorem implies strongest conditional mass-gap
summary.
-/
theorem theorem_index_schur_budget_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact clay_schur_budget_theorem_implies_mass_gap h

/-
Endpoint 234: Schur-budget theorem implies positive continuum Yang--Mills gap.
-/
theorem theorem_index_schur_budget_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClaySchurBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact clay_schur_budget_theorem_implies_positive_continuum_gap h

/-
Endpoint 235: direct continuum survival plus positivity of Delta0 gives
continuum gap data.
-/
theorem theorem_index_direct_continuum_survival_to_gap_data
    {DeltaYM Delta0 : Real}
    (hSurvival :
      ContinuumGapSurvivalAssumptions DeltaYM Delta0)
    (hDelta0_pos : 0 < Delta0) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact
    ContinuumGapSurvivalAssumptions.imply_continuum_gap_data
      hSurvival hDelta0_pos

/-
Endpoint 236: direct continuum-survival assumptions recover positive scale data.
-/
theorem theorem_index_continuum_survival_budget_to_positive_scale
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    LayerOnePositiveScaleAssumptions
      Delta0 (mu * (delta / C)^2) dUV := by
  exact ClayContinuumSurvivalBudgetAssumptions.to_positive_scale h

/-
Endpoint 237: direct continuum-survival assumptions imply Layer-One fine gap
data.
-/
theorem theorem_index_continuum_survival_budget_to_layer_one_fine_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact ClayContinuumSurvivalBudgetAssumptions.imply_layer_one_fine_gap_data h

/-
Endpoint 238: direct continuum-survival assumptions imply continuum gap data.
-/
theorem theorem_index_continuum_survival_budget_to_continuum_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact ClayContinuumSurvivalBudgetAssumptions.imply_continuum_gap_data h

/-
Endpoint 239: direct continuum-survival assumptions imply full strongest gap
data.
-/
theorem theorem_index_continuum_survival_budget_to_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayContinuumSurvivalBudgetAssumptions.imply_full_gap_data h

/-
Endpoint 240: direct continuum-survival assumptions imply strongest conditional
mass-gap summary.
-/
theorem theorem_index_continuum_survival_budget_to_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayContinuumSurvivalBudgetAssumptions.imply_mass_gap h

/-
Endpoint 241: direct continuum-survival assumptions imply positive continuum
Yang--Mills gap.
-/
theorem theorem_index_continuum_survival_budget_to_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact ClayContinuumSurvivalBudgetAssumptions.imply_positive_continuum_gap h

/-
Endpoint 242: direct-continuum-survival theorem implies full strongest gap data.
-/
theorem theorem_index_continuum_survival_theorem_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact clay_continuum_survival_theorem_implies_full_gap_data h

/-
Endpoint 243: direct-continuum-survival theorem implies strongest conditional
mass-gap summary.
-/
theorem theorem_index_continuum_survival_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact clay_continuum_survival_theorem_implies_mass_gap h

/-
Endpoint 244: direct-continuum-survival theorem implies positive continuum
Yang--Mills gap.
-/
theorem theorem_index_continuum_survival_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayContinuumSurvivalBudgetAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact clay_continuum_survival_theorem_implies_positive_continuum_gap h

/-
Endpoint 245: final direct Clay theorem implies full strongest gap data.
-/
theorem theorem_index_final_direct_theorem_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact clay_final_direct_theorem_implies_full_gap_data h

/-
Endpoint 246: final direct Clay theorem implies strongest conditional mass-gap
summary.
-/
theorem theorem_index_final_direct_theorem_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact clay_final_direct_theorem_implies_mass_gap h

/-
Endpoint 247: final direct Clay theorem implies positive continuum Yang--Mills
gap.
-/
theorem theorem_index_final_direct_theorem_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact clay_final_direct_theorem_implies_positive_continuum_gap h

/-
Endpoint 248: final direct assumptions expose the holonomy red-lemma packet.
-/
theorem theorem_index_final_direct_audit_holonomy_packet
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    UniformHolonomyRedLemmaAssumptions
      links Gap Energy curvatureNorm C mu delta := by
  exact ClayFinalDirectAssumptions.audit_holonomy_packet h

/-
Endpoint 249: final direct assumptions expose the reduced scale packet.
-/
theorem theorem_index_final_direct_audit_reduced_scale_packet
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    LayerOneReducedScaleAssumptions
      Delta0 (mu * (delta / C)^2) dUV := by
  exact ClayFinalDirectAssumptions.audit_reduced_scale_packet h

/-
Endpoint 250: final direct assumptions expose the Schur loss-budget packet.
-/
theorem theorem_index_final_direct_audit_schur_loss_budget_packet
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ∃ loss : Real,
      SchurLossBudgetAssumptions loss Delta0
        ∧ SchurFeshbachLossLowerAssumptions
          DeltaFine (mu * (delta / C)^2) dUV loss := by
  exact ClayFinalDirectAssumptions.audit_schur_loss_budget_packet h

/-
Endpoint 251: final direct assumptions expose the continuum survival packet.
-/
theorem theorem_index_final_direct_audit_continuum_survival_packet
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ContinuumGapSurvivalAssumptions DeltaYM Delta0 := by
  exact ClayFinalDirectAssumptions.audit_continuum_survival_packet h

/-
Endpoint 252: final direct assumptions expose all remaining direct packets.
-/
theorem theorem_index_final_direct_audit_remaining_direct_packets
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayFinalDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    UniformHolonomyRedLemmaAssumptions
      links Gap Energy curvatureNorm C mu delta
      ∧ LayerOneReducedScaleAssumptions
        Delta0 (mu * (delta / C)^2) dUV
      ∧ (∃ loss : Real,
          SchurLossBudgetAssumptions loss Delta0
            ∧ SchurFeshbachLossLowerAssumptions
              DeltaFine (mu * (delta / C)^2) dUV loss)
      ∧ ContinuumGapSurvivalAssumptions DeltaYM Delta0 := by
  exact ClayFinalDirectAssumptions.audit_remaining_direct_packets h

/-
Endpoint 253: primitive obligations imply final direct Clay assumptions.
-/
theorem theorem_index_primitive_obligations_to_final_direct_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ClayFinalDirectAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV C mu delta := by
  exact ClayPrimitiveObligationAssumptions.to_final_direct_assumptions h

/-
Endpoint 254: primitive-obligation theorem implies full strongest gap data.
-/
theorem theorem_index_primitive_obligations_imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayPrimitiveObligationAssumptions.imply_full_gap_data h

/-
Endpoint 255: primitive-obligation theorem implies strongest conditional
mass-gap summary.
-/
theorem theorem_index_primitive_obligations_imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayPrimitiveObligationAssumptions.imply_mass_gap h

/-
Endpoint 256: primitive-obligation theorem implies positive continuum
Yang--Mills gap.
-/
theorem theorem_index_primitive_obligations_imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact ClayPrimitiveObligationAssumptions.imply_positive_continuum_gap h

/-
Endpoint 257: UV positivity and Delta0 definition construct the primitive scale
obligation.
-/
theorem theorem_index_scale_primitive_from_uv_pos_and_delta0_def
    {Delta0 dBlock dUV : Real}
    (hUV_pos : 0 < dUV)
    (hDelta0_def : Delta0 = (1 / 2) * min dBlock dUV) :
    ClayScalePrimitiveObligation Delta0 dBlock dUV := by
  exact
    ClayScalePrimitiveObligation.of_uv_pos_and_delta0_def
      hUV_pos hDelta0_def

/-
Endpoint 258: primitive scale obligation plus block positivity recovers positive
Layer-One scale data.
-/
theorem theorem_index_scale_primitive_to_positive_scale_of_block_pos
    {Delta0 dBlock dUV : Real}
    (hBlock_pos : 0 < dBlock)
    (hScale :
      ClayScalePrimitiveObligation Delta0 dBlock dUV) :
    LayerOnePositiveScaleAssumptions Delta0 dBlock dUV := by
  exact
    ClayScalePrimitiveObligation.to_positive_scale_of_block_pos
      hBlock_pos hScale

/-
Endpoint 259: primitive scale obligation plus block positivity gives positivity
of Delta0.
-/
theorem theorem_index_scale_primitive_implies_delta0_positive_of_block_pos
    {Delta0 dBlock dUV : Real}
    (hBlock_pos : 0 < dBlock)
    (hScale :
      ClayScalePrimitiveObligation Delta0 dBlock dUV) :
    0 < Delta0 := by
  exact
    ClayScalePrimitiveObligation.imply_delta0_positive_of_block_pos
      hBlock_pos hScale

/-
Endpoint 260: holonomy plus primitive scale obligation gives positivity of
Delta0 for the concrete Clay block scale.
-/
theorem theorem_index_scale_primitive_implies_delta0_positive_from_holonomy
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {Delta0 dUV C mu delta : Real}
    (hHolonomy :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta)
    (hScale :
      ClayScalePrimitiveObligation
        Delta0 (mu * (delta / C)^2) dUV) :
    0 < Delta0 := by
  exact
    ClayScalePrimitiveObligation.imply_delta0_positive_from_holonomy
      hHolonomy hScale

/-
Endpoint 261: direct inequality Delta0 <= DeltaYM constructs the continuum
primitive obligation.
-/
theorem theorem_index_continuum_primitive_from_delta0_le_deltaYM
    {DeltaYM Delta0 : Real}
    (h : Delta0 <= DeltaYM) :
    ClayContinuumPrimitiveObligation DeltaYM Delta0 := by
  exact ClayContinuumPrimitiveObligation.of_delta0_le_deltaYM h

/-
Endpoint 262: continuum primitive obligation plus positivity of Delta0 gives
continuum gap data.
-/
theorem theorem_index_continuum_primitive_to_gap_data_of_delta0_pos
    {DeltaYM Delta0 : Real}
    (hCont :
      ClayContinuumPrimitiveObligation DeltaYM Delta0)
    (hDelta0_pos : 0 < Delta0) :
    Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
  exact
    ClayContinuumPrimitiveObligation.imply_continuum_gap_data_of_delta0_pos
      hCont hDelta0_pos

/-
Endpoint 263: continuum primitive obligation plus positivity of Delta0 gives a
positive continuum Yang--Mills gap.
-/
theorem theorem_index_continuum_primitive_to_positive_continuum_gap_of_delta0_pos
    {DeltaYM Delta0 : Real}
    (hCont :
      ClayContinuumPrimitiveObligation DeltaYM Delta0)
    (hDelta0_pos : 0 < Delta0) :
    0 < DeltaYM := by
  exact
    ClayContinuumPrimitiveObligation.imply_positive_continuum_gap_of_delta0_pos
      hCont hDelta0_pos

/-
Endpoint 264: holonomy, primitive scale, and primitive continuum survival imply
a positive continuum Yang--Mills gap.
-/
theorem theorem_index_continuum_primitive_to_positive_gap_from_holonomy_and_scale
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM Delta0 dUV C mu delta : Real}
    (hHolonomy :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta)
    (hScale :
      ClayScalePrimitiveObligation
        Delta0 (mu * (delta / C)^2) dUV)
    (hCont :
      ClayContinuumPrimitiveObligation DeltaYM Delta0) :
    0 < DeltaYM := by
  exact
    ClayContinuumPrimitiveObligation.imply_positive_continuum_gap_from_holonomy_and_scale
      hHolonomy hScale hCont
/-
Endpoint 265: reduced primitive assumptions imply the previous primitive
obligation assumption set.
-/
theorem theorem_index_reduced_primitive_to_primitive_obligations
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayReducedPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    ClayPrimitiveObligationAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV C mu delta := by
  exact ClayReducedPrimitiveObligationAssumptions.to_primitive_obligations h

/-
Endpoint 266: reduced primitive theorem implies full strongest gap data.
-/
theorem theorem_index_reduced_primitive_implies_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayReducedPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayReducedPrimitiveObligationAssumptions.imply_full_gap_data h

/-
Endpoint 267: reduced primitive theorem implies strongest conditional mass-gap
summary.
-/
theorem theorem_index_reduced_primitive_implies_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayReducedPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayReducedPrimitiveObligationAssumptions.imply_mass_gap h

/-
Endpoint 268: reduced primitive theorem implies positive continuum Yang--Mills
gap.
-/
theorem theorem_index_reduced_primitive_implies_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV C mu delta : Real}
    (h :
      ClayReducedPrimitiveObligationAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV C mu delta) :
    0 < DeltaYM := by
  exact ClayReducedPrimitiveObligationAssumptions.imply_positive_continuum_gap h

/-
Endpoint 269: raw loss inequality constructs the Schur loss-budget packet.
-/
theorem theorem_index_schur_loss_budget_from_loss_le_delta0
    {loss Delta0 : Real}
    (hLoss : loss <= Delta0) :
    SchurLossBudgetAssumptions loss Delta0 := by
  exact SchurLossBudgetAssumptions.of_loss_le_delta0 hLoss

/-
Endpoint 270: raw Schur lower inequality constructs the Schur/Feshbach lower
packet.
-/
theorem theorem_index_schur_loss_lower_from_raw_bound
    {DeltaFine dBlock dUV loss : Real}
    (hLower : min dBlock dUV - loss <= DeltaFine) :
    SchurFeshbachLossLowerAssumptions DeltaFine dBlock dUV loss := by
  exact SchurFeshbachLossLowerAssumptions.of_schur_loss_lower hLower

/-
Endpoint 271: loss budget plus Schur lower packet constructs the primitive
Schur obligation.
-/
theorem theorem_index_schur_primitive_from_loss_budget_and_schur_lower
    {DeltaFine Delta0 dBlock dUV loss : Real}
    (hLossBudget :
      SchurLossBudgetAssumptions loss Delta0)
    (hSchur :
      SchurFeshbachLossLowerAssumptions DeltaFine dBlock dUV loss) :
    ClaySchurPrimitiveObligation DeltaFine Delta0 dBlock dUV := by
  exact
    ClaySchurPrimitiveObligation.of_loss_budget_and_schur_lower
      hLossBudget hSchur

/-
Endpoint 272: raw loss bounds construct the primitive Schur obligation.
-/
theorem theorem_index_schur_primitive_from_raw_loss_bounds
    {DeltaFine Delta0 dBlock dUV loss : Real}
    (hLoss : loss <= Delta0)
    (hLower : min dBlock dUV - loss <= DeltaFine) :
    ClaySchurPrimitiveObligation DeltaFine Delta0 dBlock dUV := by
  exact
    ClaySchurPrimitiveObligation.of_raw_loss_bounds hLoss hLower

/-
Endpoint 273: primitive Schur obligation plus primitive scale data implies
Delta0 <= DeltaFine.
-/
theorem theorem_index_schur_primitive_implies_delta0_le_deltaFine
    {DeltaFine Delta0 dBlock dUV : Real}
    (hScale :
      ClayScalePrimitiveObligation Delta0 dBlock dUV)
    (hSchur :
      ClaySchurPrimitiveObligation DeltaFine Delta0 dBlock dUV) :
    Delta0 <= DeltaFine := by
  exact
    ClaySchurPrimitiveObligation.imply_delta0_le_deltaFine
      hScale hSchur

/-
Endpoint 274: holonomy + scale + Schur primitive data gives Layer-One fine gap
data.
-/
theorem theorem_index_schur_primitive_to_layer_one_fine_gap_data_from_holonomy
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaFine Delta0 dUV C mu delta : Real}
    (hHolonomy :
      ClayHolonomyPrimitiveObligation
        links Gap Energy curvatureNorm C mu delta)
    (hScale :
      ClayScalePrimitiveObligation
        Delta0 (mu * (delta / C)^2) dUV)
    (hSchur :
      ClaySchurPrimitiveObligation
        DeltaFine Delta0 (mu * (delta / C)^2) dUV) :
    Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine := by
  exact
    ClaySchurPrimitiveObligation.imply_layer_one_fine_gap_data_from_holonomy
      hHolonomy hScale hSchur

/-
Endpoint 275: raw primitive assumptions imply reduced primitive obligations.
-/
theorem theorem_index_raw_primitive_to_reduced_primitive_obligations
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
    ClayReducedPrimitiveObligationAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV C mu delta := by
  exact ClayRawPrimitiveAssumptions.to_reduced_primitive_obligations h

/-
Endpoint 276: raw primitive theorem implies full strongest gap data.
-/
theorem theorem_index_raw_primitive_implies_full_gap_data
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
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact ClayRawPrimitiveAssumptions.imply_full_gap_data h

/-
Endpoint 277: raw primitive theorem implies strongest conditional mass-gap
summary.
-/
theorem theorem_index_raw_primitive_implies_mass_gap
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
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact ClayRawPrimitiveAssumptions.imply_mass_gap h

/-
Endpoint 278: raw primitive theorem implies positive continuum Yang--Mills gap.
-/
theorem theorem_index_raw_primitive_implies_positive_continuum_gap
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
    0 < DeltaYM := by
  exact ClayRawPrimitiveAssumptions.imply_positive_continuum_gap h

/-
Endpoint 279: raw primitive assumptions expose the holonomy primitive obligation.
-/
theorem theorem_index_raw_primitive_audit_holonomy_obligation
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
  exact ClayRawPrimitiveAssumptions.audit_holonomy_obligation h

/-
Endpoint 280: raw primitive assumptions expose UV positivity.
-/
theorem theorem_index_raw_primitive_audit_uv_positive
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
  exact ClayRawPrimitiveAssumptions.audit_uv_positive h

/-
Endpoint 281: raw primitive assumptions expose the Delta0 normalization.
-/
theorem theorem_index_raw_primitive_audit_delta0_definition
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
  exact ClayRawPrimitiveAssumptions.audit_delta0_definition h

/-
Endpoint 282: raw primitive assumptions expose the raw Schur/Feshbach bounds.
-/
theorem theorem_index_raw_primitive_audit_raw_schur_bounds
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
  exact ClayRawPrimitiveAssumptions.audit_raw_schur_bounds h

/-
Endpoint 283: raw primitive assumptions expose direct continuum survival.
-/
theorem theorem_index_raw_primitive_audit_continuum_survival
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
  exact ClayRawPrimitiveAssumptions.audit_continuum_survival h

/-
Endpoint 284: raw primitive assumptions expose all current raw obligations.
-/
theorem theorem_index_raw_primitive_audit_all_raw_obligations
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
  exact ClayRawPrimitiveAssumptions.audit_all_raw_obligations h

end RussoYM

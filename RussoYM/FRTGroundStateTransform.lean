import Mathlib

/-!
# FRT ground-state transformation audit

This file checks a flat, one-dimensional, time-independent-potential model
against the Fokker-Planck equations recorded in the historical `TRF_Chat.txt`.
All derivative hypotheses are explicit. No curvature term, self-adjoint
operator domain, Wick rotation, or Yang-Mills identification is assumed proved.
The density is with respect to ordinary Lebesgue measure in this flat model.

If `p = exp(-S / hbar) * psi`, then `psi = exp(S / hbar) * p`.
The energy-normalized equation is `hbar * partial_t psi = -H psi`.
The general tilt theorem below also checks the opposite, archived sign.
-/

namespace RussoYM
namespace FRTGroundState

/-- Exponentially tilted density with a real sign/strength parameter `k`. -/
noncomputable def exponentialTilt (S psi : Real -> Real) (hbar k : Real) : Real -> Real :=
  fun x => Real.exp (k * S x / hbar) * psi x

/-- The forward Fokker-Planck differential expression for drift `-S1/mass`
and diffusion `hbar/(2*mass)`. Here `S1` is the derivative of the potential. -/
noncomputable def forwardFP (hbar mass : Real) (S1 p : Real -> Real) (x : Real) : Real :=
  (hbar / (2 * mass)) * deriv (deriv p) x +
    (1 / mass) * deriv (fun y => S1 y * p y) x

/-- Flat Schrödinger differential expression produced by the corrected transform. -/
noncomputable def flatHamiltonian (hbar mass : Real) (S1 S2 psi : Real -> Real) (x : Real) : Real :=
  -(hbar ^ 2 / (2 * mass)) * deriv (deriv psi) x +
    ((S1 x) ^ 2 / (2 * mass) - hbar * S2 x / (2 * mass)) * psi x

/-- First derivative of a general exponential tilt. -/
theorem exponentialTilt_hasDerivAt
    (S S1 psi psi1 : Real -> Real) (hbar k x : Real)
    (hS : HasDerivAt S (S1 x) x) (hPsi : HasDerivAt psi (psi1 x) x) :
    HasDerivAt (exponentialTilt S psi hbar k)
      (Real.exp (k * S x / hbar) * (psi1 x + (k * S1 x / hbar) * psi x)) x := by
  have hw := ((hS.const_mul k).div_const hbar).exp
  convert hw.mul hPsi using 1; dsimp [exponentialTilt]; ring

/-- Actual second derivative of the tilt, obtained from the product and chain rules. -/
theorem exponentialTilt_second_deriv
    (S S1 S2 psi psi1 psi2 : Real -> Real) (hbar k x : Real)
    (hS : forall y, HasDerivAt S (S1 y) y)
    (hPsi : forall y, HasDerivAt psi (psi1 y) y)
    (hS1 : HasDerivAt S1 (S2 x) x) (hPsi1 : HasDerivAt psi1 (psi2 x) x) :
    deriv (deriv (exponentialTilt S psi hbar k)) x =
      Real.exp (k * S x / hbar) *
        (psi2 x + 2 * (k * S1 x / hbar) * psi1 x +
          (k * S2 x / hbar + (k * S1 x / hbar) ^ 2) * psi x) := by
  have hfirst : deriv (exponentialTilt S psi hbar k) =
      (fun y => Real.exp (k * S y / hbar) *
        (psi1 y + (k * S1 y / hbar) * psi y)) := by
    funext y
    exact (exponentialTilt_hasDerivAt S S1 psi psi1 hbar k y (hS y) (hPsi y)).deriv
  rw [hfirst]
  have hw := (((hS x).const_mul k).div_const hbar).exp
  have hb := hPsi1.add (((hS1.const_mul k).div_const hbar).mul (hPsi x))
  have hd := (hw.mul hb).deriv
  simp only [Pi.add_apply, Pi.mul_apply] at hd
  convert hd using 1; ring

/-- General conjugation formula. `k = -1` cancels the first derivative;
`k = 1` is the density substitution implied by the archived negative-sign transform. -/
theorem forwardFP_exponentialTilt
    (S S1 S2 psi psi1 psi2 : Real -> Real) (hbar mass k x : Real)
    (hhbar : hbar ≠ 0) (hmass : mass ≠ 0)
    (hS : forall y, HasDerivAt S (S1 y) y)
    (hPsi : forall y, HasDerivAt psi (psi1 y) y)
    (hS1 : HasDerivAt S1 (S2 x) x) (hPsi1 : HasDerivAt psi1 (psi2 x) x) :
    hbar * Real.exp (-(k * S x / hbar)) *
      forwardFP hbar mass S1 (exponentialTilt S psi hbar k) x =
      (hbar ^ 2 / (2 * mass)) * psi2 x +
      ((k + 1) * hbar / mass) * S1 x * psi1 x +
      (((k / 2 + 1) * hbar / mass) * S2 x +
        ((k ^ 2 / 2 + k) / mass) * (S1 x) ^ 2) * psi x := by
  have hp := exponentialTilt_hasDerivAt S S1 psi psi1 hbar k x (hS x) (hPsi x)
  have hflux : deriv (fun y => S1 y * exponentialTilt S psi hbar k y) x =
      S2 x * exponentialTilt S psi hbar k x + S1 x *
        (Real.exp (k * S x / hbar) * (psi1 x + (k * S1 x / hbar) * psi x)) :=
    (hS1.mul hp).deriv
  unfold forwardFP
  rw [exponentialTilt_second_deriv S S1 S2 psi psi1 psi2 hbar k x hS hPsi hS1 hPsi1,
    hflux]
  dsimp [exponentialTilt]
  have hexp : Real.exp (-(k * S x / hbar)) * Real.exp (k * S x / hbar) = 1 := by
    rw [← Real.exp_add]
    simp only [neg_add_cancel, Real.exp_zero]
  calc
    _ = (Real.exp (-(k * S x / hbar)) * Real.exp (k * S x / hbar)) *
        ((hbar ^ 2 / (2 * mass)) * psi2 x +
        ((k + 1) * hbar / mass) * S1 x * psi1 x +
        (((k / 2 + 1) * hbar / mass) * S2 x +
          ((k ^ 2 / 2 + k) / mass) * (S1 x) ^ 2) * psi x) := by
      field_simp [hhbar, hmass]; ring
    _ = _ := by rw [hexp, one_mul]

/-- Corrected ground-state transformation, including the `hbar` time factor.
This checks the differential expressions rather than asserting self-adjointness. -/
theorem corrected_groundState_transform
    (S S1 S2 psi psi1 psi2 : Real -> Real) (hbar mass x : Real)
    (hhbar : hbar ≠ 0) (hmass : mass ≠ 0)
    (hS : forall y, HasDerivAt S (S1 y) y)
    (hPsi : forall y, HasDerivAt psi (psi1 y) y)
    (hS1 : HasDerivAt S1 (S2 x) x) (hPsi1 : HasDerivAt psi1 (psi2 x) x) :
    hbar * Real.exp (S x / hbar) *
      forwardFP hbar mass S1 (exponentialTilt S psi hbar (-1)) x =
      -flatHamiltonian hbar mass S1 S2 psi x := by
  have h := forwardFP_exponentialTilt S S1 S2 psi psi1 psi2 hbar mass (-1) x
    hhbar hmass hS hPsi hS1 hPsi1
  have hd : deriv (deriv psi) x = psi2 x := by
    have hfirst : deriv psi = psi1 := funext fun y => (hPsi y).deriv
    rw [hfirst]
    exact hPsi1.deriv
  simp only [neg_one_mul, neg_div, neg_neg] at h
  unfold flatHamiltonian
  rw [hd]
  linear_combination h

/-- With the archived sign, the claimed cancellation leaves this explicit
extra first-derivative and potential expression. -/
theorem archived_sign_defect
    (S S1 S2 psi psi1 psi2 : Real -> Real) (hbar mass x : Real)
    (hhbar : hbar ≠ 0) (hmass : mass ≠ 0)
    (hS : forall y, HasDerivAt S (S1 y) y)
    (hPsi : forall y, HasDerivAt psi (psi1 y) y)
    (hS1 : HasDerivAt S1 (S2 x) x) (hPsi1 : HasDerivAt psi1 (psi2 x) x) :
    hbar * Real.exp (-(S x / hbar)) *
      forwardFP hbar mass S1 (exponentialTilt S psi hbar 1) x +
      flatHamiltonian hbar mass S1 S2 psi x =
      (2 * hbar / mass) * S1 x * psi1 x +
        ((hbar / mass) * S2 x + (2 / mass) * (S1 x) ^ 2) * psi x := by
  have h := forwardFP_exponentialTilt S S1 S2 psi psi1 psi2 hbar mass 1 x
    hhbar hmass hS hPsi hS1 hPsi1
  have hd : deriv (deriv psi) x = psi2 x := by
    have hfirst : deriv psi = psi1 := funext fun y => (hPsi y).deriv
    rw [hfirst]
    exact hPsi1.deriv
  simp only [one_mul] at h
  unfold flatHamiltonian
  rw [hd]
  linear_combination h

/-- A local counterexample to the archived differential-operator identity:
`S(x)=x`, `psi(x)=1`, `hbar=mass=1`, evaluated at zero, leaves defect `2`.
Here `S''=0`, so a flat-space harmonic-potential constraint does not remove it.
This is a test of differential expressions, not a normalized probability state. -/
theorem archived_sign_linear_potential_counterexample :
    forwardFP 1 1 (fun _ => 1)
        (exponentialTilt (fun x => x) (fun _ => 1) 1 1) 0 +
      flatHamiltonian 1 1 (fun _ => 1) (fun _ => 0) (fun _ => 1) 0 = 2 := by
  have h := archived_sign_defect (fun x => x) (fun _ => 1) (fun _ => 0)
    (fun _ => 1) (fun _ => 0) (fun _ => 0) 1 1 0 (by norm_num) (by norm_num)
    (fun y => hasDerivAt_id y) (fun y => hasDerivAt_const y 1)
    (hasDerivAt_const 0 1) (hasDerivAt_const 0 0)
  norm_num at h ⊢
  exact h

/-- The exponential `exp(-2*S/hbar)` is a stationary differential solution.
Normalization, integrability, and boundary conditions are separate requirements. -/
theorem unnormalized_stationary_density
    (S S1 S2 : Real -> Real) (hbar mass x : Real)
    (hhbar : hbar ≠ 0) (hmass : mass ≠ 0)
    (hS : forall y, HasDerivAt S (S1 y) y) (hS1 : HasDerivAt S1 (S2 x) x) :
    forwardFP hbar mass S1 (exponentialTilt S (fun _ => 1) hbar (-2)) x = 0 := by
  have h := forwardFP_exponentialTilt S S1 S2 (fun _ => 1) (fun _ => 0) (fun _ => 0)
    hbar mass (-2) x hhbar hmass hS (fun y => hasDerivAt_const y 1)
    hS1 (hasDerivAt_const x 0)
  norm_num at h
  exact h.resolve_left hhbar

/-- First-order differential expression `hbar * d/dx + S'`. -/
noncomputable def groundStateOperator (hbar : Real) (S1 psi : Real -> Real) : Real -> Real :=
  fun x => hbar * deriv psi x + S1 x * psi x

/-- Formal differential adjoint. This name does not assert a Hilbert-space
adjoint identity: that requires a measure, domain, and boundary conditions. -/
noncomputable def groundStateFormalAdjoint (hbar : Real) (S1 f : Real -> Real) : Real -> Real :=
  fun x => -hbar * deriv f x + S1 x * f x

/-- Factorization `H = Q^dagger Q / (2*m)` at the level of differential expressions. -/
theorem flatHamiltonian_factorization
    (S1 S2 psi psi1 psi2 : Real -> Real) (hbar mass x : Real)
    (hPsi : forall y, HasDerivAt psi (psi1 y) y)
    (hS1 : HasDerivAt S1 (S2 x) x) (hPsi1 : HasDerivAt psi1 (psi2 x) x) :
    flatHamiltonian hbar mass S1 S2 psi x =
      groundStateFormalAdjoint hbar S1 (groundStateOperator hbar S1 psi) x / (2 * mass) := by
  have hfirst : deriv psi = psi1 := funext fun y => (hPsi y).deriv
  have hq : HasDerivAt (groundStateOperator hbar S1 psi)
      (hbar * psi2 x + (S2 x * psi x + S1 x * psi1 x)) x := by
    change HasDerivAt (fun y => hbar * deriv psi y + S1 y * psi y) _ x
    rw [hfirst]
    exact
      (hPsi1.const_mul hbar).add (hS1.mul (hPsi x))
  unfold flatHamiltonian groundStateFormalAdjoint
  rw [hq.deriv, hfirst, hPsi1.deriv]
  simp only [groundStateOperator, hfirst]
  ring

/-- The positive candidate `exp(-S/hbar)` is annihilated by `Q`.
This is a pointwise statement; no square-integrability is claimed. -/
theorem groundStateOperator_exponential
    (S S1 : Real -> Real) (hbar x : Real) (hhbar : hbar ≠ 0)
    (hS : HasDerivAt S (S1 x) x) :
    groundStateOperator hbar S1 (exponentialTilt S (fun _ => 1) hbar (-1)) x = 0 := by
  have hd := (exponentialTilt_hasDerivAt S S1 (fun _ => 1) (fun _ => 0)
    hbar (-1) x hS (hasDerivAt_const x 1)).deriv
  unfold groundStateOperator
  rw [hd]
  dsimp [exponentialTilt]
  field_simp [hhbar]
  ring

/-- The same candidate solves the zero-energy differential equation.
Calling it a Hilbert-space ground state additionally requires domain and
normalization results, and a lower bound for the operator realization. -/
theorem flatHamiltonian_exponential_zero
    (S S1 S2 : Real -> Real) (hbar mass x : Real) (hhbar : hbar ≠ 0)
    (hS : forall y, HasDerivAt S (S1 y) y) (hS1 : HasDerivAt S1 (S2 x) x) :
    flatHamiltonian hbar mass S1 S2 (exponentialTilt S (fun _ => 1) hbar (-1)) x = 0 := by
  unfold flatHamiltonian
  rw [exponentialTilt_second_deriv S S1 S2 (fun _ => 1) (fun _ => 0)
    (fun _ => 0) hbar (-1) x hS (fun y => hasDerivAt_const y 1)
    hS1 (hasDerivAt_const x 0)]
  dsimp [exponentialTilt]
  field_simp [hhbar]
  ring

/-- Local energy identity, retaining the full boundary derivative.
After justified integration, the last term becomes a boundary contribution;
positivity follows only when that contribution vanishes and `mass > 0`. -/
theorem flatHamiltonian_energy_identity
    (S1 S2 psi psi1 psi2 : Real -> Real) (hbar mass x : Real)
    (hPsi : forall y, HasDerivAt psi (psi1 y) y)
    (hS1 : HasDerivAt S1 (S2 x) x) (hPsi1 : HasDerivAt psi1 (psi2 x) x) :
    psi x * flatHamiltonian hbar mass S1 S2 psi x =
      (groundStateOperator hbar S1 psi x) ^ 2 / (2 * mass) -
      hbar / (2 * mass) * deriv (fun y => psi y * groundStateOperator hbar S1 psi y) x := by
  have hfirst : deriv psi = psi1 := funext fun y => (hPsi y).deriv
  have hq : HasDerivAt (groundStateOperator hbar S1 psi)
      (hbar * psi2 x + (S2 x * psi x + S1 x * psi1 x)) x := by
    change HasDerivAt (fun y => hbar * deriv psi y + S1 y * psi y) _ x
    rw [hfirst]
    exact
      (hPsi1.const_mul hbar).add (hS1.mul (hPsi x))
  have hprod := ((hPsi x).mul hq).deriv
  change deriv (fun y => psi y * groundStateOperator hbar S1 psi y) x = _ at hprod
  rw [hprod]
  unfold flatHamiltonian groundStateOperator
  rw [hfirst, hPsi1.deriv]
  ring

/-- Integrated energy identity on a finite interval. Integrability is explicit,
and the boundary term is retained rather than silently discarded. -/
theorem flatHamiltonian_interval_energy
    (S1 S2 psi psi1 psi2 : Real -> Real) (hbar mass a b : Real)
    (hPsi : forall y, HasDerivAt psi (psi1 y) y)
    (hS1 : forall y, HasDerivAt S1 (S2 y) y)
    (hPsi1 : forall y, HasDerivAt psi1 (psi2 y) y)
    (hsq : IntervalIntegrable (fun y => (groundStateOperator hbar S1 psi y) ^ 2)
      MeasureTheory.volume a b)
    (hboundary : IntervalIntegrable
      (deriv (fun y => psi y * groundStateOperator hbar S1 psi y))
      MeasureTheory.volume a b) :
    (∫ y in a..b, psi y * flatHamiltonian hbar mass S1 S2 psi y) =
      (1 / (2 * mass)) * (∫ y in a..b, (groundStateOperator hbar S1 psi y) ^ 2) -
      hbar / (2 * mass) *
        (psi b * groundStateOperator hbar S1 psi b -
          psi a * groundStateOperator hbar S1 psi a) := by
  have hfirst : deriv psi = psi1 := funext fun y => (hPsi y).deriv
  have hdiff : forall y, DifferentiableAt Real
      (fun z => psi z * groundStateOperator hbar S1 psi z) y := by
    intro y
    have hq : HasDerivAt (groundStateOperator hbar S1 psi)
        (hbar * psi2 y + (S2 y * psi y + S1 y * psi1 y)) y := by
      change HasDerivAt (fun z => hbar * deriv psi z + S1 z * psi z) _ y
      rw [hfirst]
      exact ((hPsi1 y).const_mul hbar).add ((hS1 y).mul (hPsi y))
    exact ((hPsi y).mul hq).differentiableAt
  have hFTC := intervalIntegral.integral_deriv_eq_sub (fun y _ => hdiff y) hboundary
  have heq : (fun y => psi y * flatHamiltonian hbar mass S1 S2 psi y) =
      (fun y => (1 / (2 * mass)) * (groundStateOperator hbar S1 psi y) ^ 2 -
        (hbar / (2 * mass)) *
          deriv (fun z => psi z * groundStateOperator hbar S1 psi z) y) := by
    funext y
    rw [flatHamiltonian_energy_identity S1 S2 psi psi1 psi2 hbar mass y
      hPsi (hS1 y) (hPsi1 y)]
    ring
  rw [heq, intervalIntegral.integral_sub (hsq.const_mul _) (hboundary.const_mul _),
    intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul, hFTC]

/-- Nonnegative integrated energy for positive mass when endpoint boundary
contributions agree. For example, vanishing endpoint values of `psi` suffice.
This is a quadratic-form bound, not a positive spectral gap. -/
theorem flatHamiltonian_interval_energy_nonneg
    (S1 S2 psi psi1 psi2 : Real -> Real) (hbar mass a b : Real)
    (hmass : 0 < mass) (hab : a ≤ b)
    (hPsi : forall y, HasDerivAt psi (psi1 y) y)
    (hS1 : forall y, HasDerivAt S1 (S2 y) y)
    (hPsi1 : forall y, HasDerivAt psi1 (psi2 y) y)
    (hsq : IntervalIntegrable (fun y => (groundStateOperator hbar S1 psi y) ^ 2)
      MeasureTheory.volume a b)
    (hboundary : IntervalIntegrable
      (deriv (fun y => psi y * groundStateOperator hbar S1 psi y))
      MeasureTheory.volume a b)
    (hend : psi b * groundStateOperator hbar S1 psi b =
      psi a * groundStateOperator hbar S1 psi a) :
    0 ≤ ∫ y in a..b, psi y * flatHamiltonian hbar mass S1 S2 psi y := by
  rw [flatHamiltonian_interval_energy S1 S2 psi psi1 psi2 hbar mass a b
    hPsi hS1 hPsi1 hsq hboundary, hend, sub_self, mul_zero, sub_zero]
  exact mul_nonneg (by positivity)
    (intervalIntegral.integral_nonneg_of_forall hab (fun y => sq_nonneg _))

/-- Multiplication by the ground-state factor removes the potential term in `Q`.
This is the first-order identity behind the weighted energy representation. -/
theorem groundStateOperator_tilt
    (S S1 f f1 : Real -> Real) (hbar x : Real) (hhbar : hbar ≠ 0)
    (hS : HasDerivAt S (S1 x) x) (hF : HasDerivAt f (f1 x) x) :
    groundStateOperator hbar S1 (exponentialTilt S f hbar (-1)) x =
      hbar * Real.exp (-S x / hbar) * f1 x := by
  unfold groundStateOperator
  rw [(exponentialTilt_hasDerivAt S S1 f f1 hbar (-1) x hS hF).deriv]
  dsimp [exponentialTilt]
  simp only [neg_one_mul]
  field_simp [hhbar]
  ring

/-- The squared ground-state multiplier is the stationary density weight. -/
theorem exponentialTilt_sq (S f : Real -> Real) (hbar x : Real) :
    (exponentialTilt S f hbar (-1) x) ^ 2 =
      Real.exp (-2 * S x / hbar) * (f x) ^ 2 := by
  have hw : Real.exp (-S x / hbar) ^ 2 = Real.exp (-2 * S x / hbar) := by
    rw [sq, ← Real.exp_add]
    congr 1
    ring
  simp only [exponentialTilt, neg_one_mul, mul_pow, hw]

/-- Ground-state orthogonality becomes a weighted mean-zero condition after
integration, provided the relevant integrals and Hilbert-space domain exist. -/
theorem exponentialTilt_groundState_product (S f : Real -> Real) (hbar x : Real) :
    exponentialTilt S (fun _ => 1) hbar (-1) x * exponentialTilt S f hbar (-1) x =
      Real.exp (-2 * S x / hbar) * f x := by
  dsimp [exponentialTilt]
  simp only [neg_one_mul, mul_one]
  rw [← mul_assoc, ← Real.exp_add]
  congr 2
  ring

/-- The square in the energy factorization is a weighted derivative square. -/
theorem groundStateOperator_tilt_sq
    (S S1 f f1 : Real -> Real) (hbar x : Real) (hhbar : hbar ≠ 0)
    (hS : HasDerivAt S (S1 x) x) (hF : HasDerivAt f (f1 x) x) :
    (groundStateOperator hbar S1 (exponentialTilt S f hbar (-1)) x) ^ 2 =
      hbar ^ 2 * (Real.exp (-2 * S x / hbar) * (f1 x) ^ 2) := by
  rw [groundStateOperator_tilt S S1 f f1 hbar x hhbar hS hF]
  have hw := exponentialTilt_sq S f1 hbar x
  simp only [exponentialTilt, neg_one_mul, mul_pow] at hw
  calc
    _ = hbar ^ 2 * (Real.exp (-S x / hbar) ^ 2 * (f1 x) ^ 2) := by ring
    _ = _ := by rw [hw]

/-- Weighted energy identity on a finite interval, with the boundary flux retained.
The derivatives of the transformed function and all integrability requirements
are explicit. This does not supply a weighted Poincare inequality. -/
theorem flatHamiltonian_weighted_interval_energy
    (S S1 S2 f f1 psi1 psi2 : Real -> Real) (hbar mass a b : Real)
    (hhbar : hbar ≠ 0)
    (hS : forall y, HasDerivAt S (S1 y) y)
    (hF : forall y, HasDerivAt f (f1 y) y)
    (hPsi : forall y, HasDerivAt (exponentialTilt S f hbar (-1)) (psi1 y) y)
    (hS1 : forall y, HasDerivAt S1 (S2 y) y)
    (hPsi1 : forall y, HasDerivAt psi1 (psi2 y) y)
    (hw : IntervalIntegrable (fun y => Real.exp (-2 * S y / hbar) * (f1 y) ^ 2)
      MeasureTheory.volume a b)
    (hboundary : IntervalIntegrable
      (deriv (fun y => exponentialTilt S f hbar (-1) y *
        groundStateOperator hbar S1 (exponentialTilt S f hbar (-1)) y))
      MeasureTheory.volume a b) :
    (∫ y in a..b, exponentialTilt S f hbar (-1) y *
      flatHamiltonian hbar mass S1 S2 (exponentialTilt S f hbar (-1)) y) =
      hbar ^ 2 / (2 * mass) *
        (∫ y in a..b, Real.exp (-2 * S y / hbar) * (f1 y) ^ 2) -
      hbar / (2 * mass) *
        (exponentialTilt S f hbar (-1) b *
            groundStateOperator hbar S1 (exponentialTilt S f hbar (-1)) b -
          exponentialTilt S f hbar (-1) a *
            groundStateOperator hbar S1 (exponentialTilt S f hbar (-1)) a) := by
  have heq : (fun y => (groundStateOperator hbar S1 (exponentialTilt S f hbar (-1)) y) ^ 2) =
      (fun y => hbar ^ 2 * (Real.exp (-2 * S y / hbar) * (f1 y) ^ 2)) := by
    funext y
    exact groundStateOperator_tilt_sq S S1 f f1 hbar y hhbar (hS y) (hF y)
  have hsq : IntervalIntegrable
      (fun y => (groundStateOperator hbar S1 (exponentialTilt S f hbar (-1)) y) ^ 2)
      MeasureTheory.volume a b := by
    rw [heq]
    exact hw.const_mul _
  rw [flatHamiltonian_interval_energy S1 S2 (exponentialTilt S f hbar (-1)) psi1 psi2
    hbar mass a b hPsi hS1 hPsi1 hsq hboundary, heq,
    intervalIntegral.integral_const_mul]
  ring

/-- Elementary integral Cauchy-Schwarz estimate for a continuous real function. -/
theorem interval_integral_sq_le (g : Real -> Real) (a b : Real)
    (hg : Continuous g) (hab : a ≤ b) :
    (∫ x in a..b, g x) ^ 2 ≤ (b - a) * (∫ x in a..b, (g x) ^ 2) := by
  rcases eq_or_lt_of_le hab with rfl | hab
  · simp
  let L := b - a
  let I := ∫ x in a..b, g x
  have hL : 0 < L := sub_pos.mpr hab
  have heq : (fun x => (L * g x - I) ^ 2) =
      (fun x => L ^ 2 * (g x) ^ 2 - (2 * L * I) * g x + I ^ 2) := by
    funext x
    ring
  have hquad := intervalIntegral.integral_nonneg_of_forall (μ := MeasureTheory.volume) hab.le
    (fun x => sq_nonneg (L * g x - I))
  rw [heq, intervalIntegral.integral_add
      (((hg.pow 2).intervalIntegrable a b).const_mul _ |>.sub
        ((hg.intervalIntegrable a b).const_mul _)) (continuous_const.intervalIntegrable a b),
    intervalIntegral.integral_sub ((hg.pow 2).intervalIntegrable a b |>.const_mul _)
      ((hg.intervalIntegrable a b).const_mul _),
    intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul,
    intervalIntegral.integral_const, smul_eq_mul] at hquad
  have hnonneg : 0 ≤ L * (L * (∫ x in a..b, (g x) ^ 2) - I ^ 2) := by
    change 0 ≤ L ^ 2 * (∫ x in a..b, (g x) ^ 2) - 2 * L * I * I + L * I ^ 2 at hquad
    nlinarith [hquad]
  have h := nonneg_of_mul_nonneg_right hnonneg hL
  change I ^ 2 ≤ L * (∫ x in a..b, (g x) ^ 2)
  linarith

/-- A nonsharp interval estimate obtained from the fundamental theorem of calculus.
No boundary condition is needed: the function is anchored at its left endpoint. -/
theorem interval_anchored_poincare
    (f f1 : Real -> Real) (a b : Real) (hab : a ≤ b)
    (hF : forall x, HasDerivAt f (f1 x) x) (hf1 : Continuous f1) :
    (∫ x in a..b, (f x - f a) ^ 2) ≤
      (b - a) ^ 2 * (∫ x in a..b, (f1 x) ^ 2) := by
  have hf : Continuous f :=
    (show Differentiable Real f from fun x => (hF x).differentiableAt).continuous
  have hE : 0 ≤ ∫ x in a..b, (f1 x) ^ 2 :=
    intervalIntegral.integral_nonneg_of_forall hab (fun x => sq_nonneg _)
  have hpoint : ∀ x ∈ Set.Icc a b,
      (f x - f a) ^ 2 ≤ (b - a) * (∫ y in a..b, (f1 y) ^ 2) := by
    intro x hx
    have hFTC : (∫ y in a..x, f1 y) = f x - f a :=
      intervalIntegral.integral_eq_sub_of_hasDerivAt (fun y _ => hF y)
        (hf1.intervalIntegrable a x)
    have hCS := interval_integral_sq_le f1 a x hf1 hx.1
    rw [hFTC] at hCS
    have hmono : (∫ y in a..x, (f1 y) ^ 2) ≤ ∫ y in a..b, (f1 y) ^ 2 :=
      intervalIntegral.integral_mono_interval le_rfl hx.1 hx.2
        (Filter.Eventually.of_forall (fun y => sq_nonneg _)) ((hf1.pow 2).intervalIntegrable a b)
    calc
      _ ≤ (x - a) * (∫ y in a..x, (f1 y) ^ 2) := hCS
      _ ≤ (x - a) * (∫ y in a..b, (f1 y) ^ 2) :=
        mul_le_mul_of_nonneg_left hmono (sub_nonneg.mpr hx.1)
      _ ≤ _ := mul_le_mul_of_nonneg_right (sub_le_sub_right hx.2 a) hE
  have hi := intervalIntegral.integral_mono_on (μ := MeasureTheory.volume) hab
    (((hf.sub continuous_const).pow 2).intervalIntegrable a b)
    (continuous_const.intervalIntegrable a b) hpoint
  rw [intervalIntegral.integral_const, smul_eq_mul] at hi
  nlinarith [hi]

/-- A weighted mean-zero function minimizes its squared norm under constant shifts. -/
theorem weighted_mean_zero_minimizes
    (w f : Real -> Real) (a b c : Real) (hab : a ≤ b)
    (hw : Continuous w) (hf : Continuous f)
    (hw0 : ∀ x ∈ Set.Icc a b, 0 ≤ w x)
    (hmean : (∫ x in a..b, w x * f x) = 0) :
    (∫ x in a..b, w x * (f x) ^ 2) ≤ ∫ x in a..b, w x * (f x - c) ^ 2 := by
  have heq : (fun x => w x * (f x - c) ^ 2) =
      (fun x => w x * (f x) ^ 2 - (2 * c) * (w x * f x) + c ^ 2 * w x) := by
    funext x
    ring
  have hA : IntervalIntegrable (fun x => w x * (f x) ^ 2) MeasureTheory.volume a b :=
    (hw.mul (hf.pow 2)).intervalIntegrable a b
  have hB : IntervalIntegrable (fun x => w x * f x) MeasureTheory.volume a b :=
    (hw.mul hf).intervalIntegrable a b
  rw [heq, intervalIntegral.integral_add (hA.sub (hB.const_mul _))
      ((hw.intervalIntegrable a b).const_mul _),
    intervalIntegral.integral_sub hA (hB.const_mul _),
    intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul,
    hmean, mul_zero, sub_zero]
  exact le_add_of_nonneg_right
    (mul_nonneg (sq_nonneg c) (intervalIntegral.integral_nonneg hab hw0))

/-- Concrete weighted Poincare bound on a finite interval. The constant depends
on interval length and the ratio of upper/lower density bounds. No uniform
infinite-volume or Yang-Mills estimate is asserted. -/
theorem weighted_interval_poincare
    (w f f1 : Real -> Real) (a b lo hi : Real)
    (hab : a ≤ b) (hlo : 0 < lo)
    (hw : Continuous w) (hF : forall x, HasDerivAt f (f1 x) x)
    (hf1 : Continuous f1)
    (hbounds : ∀ x ∈ Set.Icc a b, lo ≤ w x ∧ w x ≤ hi)
    (hmean : (∫ x in a..b, w x * f x) = 0) :
    (∫ x in a..b, w x * (f x) ^ 2) ≤
      (hi / lo) * (b - a) ^ 2 * (∫ x in a..b, w x * (f1 x) ^ 2) := by
  have hf : Continuous f :=
    (show Differentiable Real f from fun x => (hF x).differentiableAt).continuous
  have hhi : 0 ≤ hi := hlo.le.trans
    ((hbounds a ⟨le_rfl, hab⟩).1.trans (hbounds a ⟨le_rfl, hab⟩).2)
  have hcenter := weighted_mean_zero_minimizes w f a b (f a) hab hw hf
    (fun x hx => hlo.le.trans (hbounds x hx).1) hmean
  have hupper := intervalIntegral.integral_mono_on (μ := MeasureTheory.volume) hab
    ((hw.mul ((hf.sub continuous_const).pow 2)).intervalIntegrable a b)
    ((((hf.sub continuous_const).pow 2).intervalIntegrable a b).const_mul hi)
    (fun x hx => mul_le_mul_of_nonneg_right (hbounds x hx).2 (sq_nonneg (f x - f a)))
  rw [intervalIntegral.integral_const_mul] at hupper
  have hlower := intervalIntegral.integral_mono_on (μ := MeasureTheory.volume) hab
    (((hf1.pow 2).intervalIntegrable a b).const_mul lo)
    ((hw.mul (hf1.pow 2)).intervalIntegrable a b)
    (fun x hx => mul_le_mul_of_nonneg_right (hbounds x hx).1 (sq_nonneg (f1 x)))
  rw [intervalIntegral.integral_const_mul] at hlower
  have hbase := interval_anchored_poincare f f1 a b hab hF hf1
  have hN : (∫ x in a..b, w x * (f x) ^ 2) ≤
      hi * ((b - a) ^ 2 * (∫ x in a..b, (f1 x) ^ 2)) :=
    hcenter.trans (hupper.trans (mul_le_mul_of_nonneg_left hbase hhi))
  have hbound : lo * (∫ x in a..b, w x * (f x) ^ 2) ≤
      hi * (b - a) ^ 2 * (∫ x in a..b, w x * (f1 x) ^ 2) := by
    calc
      _ ≤ lo * (hi * ((b - a) ^ 2 * (∫ x in a..b, (f1 x) ^ 2))) :=
        mul_le_mul_of_nonneg_left hN hlo.le
      _ = (hi * (b - a) ^ 2) * (lo * (∫ x in a..b, (f1 x) ^ 2)) := by ring
      _ ≤ _ := mul_le_mul_of_nonneg_left hlower (mul_nonneg hhi (sq_nonneg _))
  calc
    _ ≤ (hi * (b - a) ^ 2 * (∫ x in a..b, w x * (f1 x) ^ 2)) / lo :=
      (le_div_iff₀ hlo).2 (by simpa only [mul_comm lo] using hbound)
    _ = _ := by ring

/-- A concrete finite-interval quadratic-form gap for the flat transformed model.
Orthogonality is to the ground-state factor, endpoint fluxes must agree, and
regularity is explicit. The coefficient depends on the interval and weight
bounds: this is not a uniform continuum Yang-Mills mass-gap theorem. -/
theorem flatHamiltonian_weighted_interval_gap
    (S S1 S2 f f1 psi1 psi2 : Real -> Real) (hbar mass a b lo hi : Real)
    (hhbar : 0 < hbar) (hmass : 0 < mass) (hab : a < b) (hlo : 0 < lo)
    (hS : forall y, HasDerivAt S (S1 y) y)
    (hF : forall y, HasDerivAt f (f1 y) y) (hf1 : Continuous f1)
    (hPsi : forall y, HasDerivAt (exponentialTilt S f hbar (-1)) (psi1 y) y)
    (hS1 : forall y, HasDerivAt S1 (S2 y) y)
    (hPsi1 : forall y, HasDerivAt psi1 (psi2 y) y)
    (hbounds : ∀ x ∈ Set.Icc a b,
      lo ≤ Real.exp (-2 * S x / hbar) ∧ Real.exp (-2 * S x / hbar) ≤ hi)
    (horth : (∫ x in a..b, exponentialTilt S (fun _ => 1) hbar (-1) x *
      exponentialTilt S f hbar (-1) x) = 0)
    (hboundary : IntervalIntegrable
      (deriv (fun y => exponentialTilt S f hbar (-1) y *
        groundStateOperator hbar S1 (exponentialTilt S f hbar (-1)) y))
      MeasureTheory.volume a b)
    (hend : exponentialTilt S f hbar (-1) b *
        groundStateOperator hbar S1 (exponentialTilt S f hbar (-1)) b =
      exponentialTilt S f hbar (-1) a *
        groundStateOperator hbar S1 (exponentialTilt S f hbar (-1)) a) :
    (hbar ^ 2 / (2 * mass) / ((hi / lo) * (b - a) ^ 2)) *
        (∫ x in a..b, (exponentialTilt S f hbar (-1) x) ^ 2) ≤
      ∫ x in a..b, exponentialTilt S f hbar (-1) x *
        flatHamiltonian hbar mass S1 S2 (exponentialTilt S f hbar (-1)) x := by
  have hSc : Continuous S :=
    (show Differentiable Real S from fun x => (hS x).differentiableAt).continuous
  have hw : Continuous (fun x => Real.exp (-2 * S x / hbar)) :=
    Real.continuous_exp.comp ((hSc.const_mul (-2)).div_const hbar)
  have hmean : (∫ x in a..b, Real.exp (-2 * S x / hbar) * f x) = 0 := by
    simpa only [exponentialTilt_groundState_product] using horth
  have hP := weighted_interval_poincare (fun x => Real.exp (-2 * S x / hbar))
    f f1 a b lo hi hab.le hlo hw hF hf1 hbounds hmean
  have hwi : IntervalIntegrable
      (fun x => Real.exp (-2 * S x / hbar) * (f1 x) ^ 2) MeasureTheory.volume a b :=
    (hw.mul (hf1.pow 2)).intervalIntegrable a b
  rw [flatHamiltonian_weighted_interval_energy S S1 S2 f f1 psi1 psi2
    hbar mass a b (ne_of_gt hhbar) hS hF hPsi hS1 hPsi1 hwi hboundary,
    hend, sub_self, mul_zero, sub_zero]
  simp only [exponentialTilt_sq]
  have hhi : 0 < hi := hlo.trans_le
    ((hbounds a ⟨le_rfl, hab.le⟩).1.trans (hbounds a ⟨le_rfl, hab.le⟩).2)
  have hC : 0 < (hi / lo) * (b - a) ^ 2 :=
    mul_pos (div_pos hhi hlo) (sq_pos_of_pos (sub_pos.mpr hab))
  have hk : 0 ≤ hbar ^ 2 / (2 * mass) := by positivity
  rw [div_mul_eq_mul_div]
  apply (div_le_iff₀ hC).2
  nlinarith [mul_le_mul_of_nonneg_left hP hk]

/-- The coefficient in the preceding finite-interval bound is strictly positive
when all parameters and the interval length are positive. -/
theorem weighted_interval_gap_coefficient_pos (hbar mass a b lo hi : Real)
    (hhbar : 0 < hbar) (hmass : 0 < mass) (hab : a < b)
    (hlo : 0 < lo) (hhi : 0 < hi) :
    0 < hbar ^ 2 / (2 * mass) / ((hi / lo) * (b - a) ^ 2) := by
  exact div_pos (div_pos (sq_pos_of_pos hhbar) (mul_pos (by norm_num) hmass))
    (mul_pos (div_pos hhi hlo) (sq_pos_of_pos (sub_pos.mpr hab)))

end FRTGroundState
end RussoYM

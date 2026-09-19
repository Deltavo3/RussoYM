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

end FRTGroundState
end RussoYM

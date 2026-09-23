import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Probability.Kernel.MeasurableLIntegral
import Mathlib.MeasureTheory.Measure.Haar.Unique
import Mathlib.MeasureTheory.Integral.Prod
import Mathlib.Probability.Kernel.Defs
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Normed.Operator.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Abel
import Mathlib.Tactic.NormNum
import Mathlib.Logic.Function.DependsOn
import Mathlib.LinearAlgebra.UnitaryGroup
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic.Group
import Mathlib.Topology.Instances.Matrix
import Mathlib.Topology.Algebra.Star.Unitary
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Tactic.FunProp
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Measure.WithDensity
import Mathlib.MeasureTheory.Measure.Haar.Basic
import Mathlib.Analysis.SpecialFunctions.Exp

/-!
# Block / Hamiltonian comparison: actual operator estimates

This file develops estimates for a retained/discarded orthogonal decomposition.
The projection, operator, lower bounds, and cross-term bound are explicit.
These are standard operator estimates being formalized as infrastructure, not
claimed as a new Yang-Mills theorem. The gauge-specific construction and estimates
remain to be supplied. Everywhere-defined real linear maps are used here; an
unbounded physical Hamiltonian additionally requires a suitable domain treatment.
-/

namespace RussoYM
namespace BlockHamiltonian

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace Real E]

/-- Symmetric idempotent projections give an orthogonal decomposition. -/
theorem projection_orthogonal (Q : E →ₗ[Real] E)
    (hSym : ∀ u v, inner (𝕜 := Real) (Q u) v = inner (𝕜 := Real) u (Q v))
    (hIdem : ∀ u, Q (Q u) = Q u) (x : E) :
    inner (𝕜 := Real) (Q x) (x - Q x) = 0 := by
  have h := hSym (Q x) x
  rw [hIdem] at h
  rw [inner_sub_right, h, sub_self]

/-- Both retained and discarded squared norms contribute to the full norm. -/
theorem projection_norm_split (Q : E →ₗ[Real] E)
    (hSym : ∀ u v, inner (𝕜 := Real) (Q u) v = inner (𝕜 := Real) u (Q v))
    (hIdem : ∀ u, Q (Q u) = Q u) (x : E) :
    ‖x‖ ^ 2 = ‖Q x‖ ^ 2 + ‖x - Q x‖ ^ 2 := by
  have h := norm_add_sq_real (Q x) (x - Q x)
  have hx : Q x + (x - Q x) = x := by abel
  rw [hx, projection_orthogonal Q hSym hIdem, mul_zero, add_zero] at h
  exact h

/-- Actual quadratic-form comparison for two orthogonal components.
The mixing bound controls the cross term, rather than assuming the final gap. -/
theorem orthogonal_energy_lower (H : E →ₗ[Real] E)
    (hSym : ∀ u v, inner (𝕜 := Real) (H u) v = inner (𝕜 := Real) u (H v))
    (u v : E) (a b eta : Real) (heta : 0 ≤ eta)
    (hOrth : inner (𝕜 := Real) u v = 0)
    (hU : a * ‖u‖ ^ 2 ≤ inner (𝕜 := Real) u (H u))
    (hV : b * ‖v‖ ^ 2 ≤ inner (𝕜 := Real) v (H v))
    (hMix : |inner (𝕜 := Real) u (H v)| ≤ eta * ‖u‖ * ‖v‖) :
    (min a b - eta) * ‖u + v‖ ^ 2 ≤ inner (𝕜 := Real) (u + v) (H (u + v)) := by
  have hcross : inner (𝕜 := Real) v (H u) = inner (𝕜 := Real) u (H v) := by
    rw [← hSym v u, real_inner_comm u (H v)]
  have he : inner (𝕜 := Real) (u + v) (H (u + v)) =
      inner (𝕜 := Real) u (H u) + 2 * inner (𝕜 := Real) u (H v) +
        inner (𝕜 := Real) v (H v) := by
    rw [map_add, inner_add_left, inner_add_right, inner_add_right, hcross]
    ring
  rw [he, norm_add_sq_real, hOrth, mul_zero, add_zero]
  have hminU := mul_le_mul_of_nonneg_right (min_le_left a b) (sq_nonneg ‖u‖)
  have hminV := mul_le_mul_of_nonneg_right (min_le_right a b) (sq_nonneg ‖v‖)
  have hYoung := mul_nonneg heta (sq_nonneg (‖u‖ - ‖v‖))
  have hCrossLower := (abs_le.mp hMix).1
  nlinarith

/-- Retained/discarded operator comparison on a specified real inner-product space.
For a physical gap, this space must correctly represent the vacuum-orthogonal
sector and the bounds must be proved for the physical operator. -/
theorem projected_energy_lower (H Q : E →ₗ[Real] E)
    (hH : ∀ u v, inner (𝕜 := Real) (H u) v = inner (𝕜 := Real) u (H v))
    (hQ : ∀ u v, inner (𝕜 := Real) (Q u) v = inner (𝕜 := Real) u (Q v))
    (hIdem : ∀ u, Q (Q u) = Q u)
    (a b eta : Real) (heta : 0 ≤ eta)
    (hRetained : ∀ u, Q u = u → a * ‖u‖ ^ 2 ≤ inner (𝕜 := Real) u (H u))
    (hDiscarded : ∀ v, Q v = 0 → b * ‖v‖ ^ 2 ≤ inner (𝕜 := Real) v (H v))
    (hMix : ∀ u v, Q u = u → Q v = 0 →
      |inner (𝕜 := Real) u (H v)| ≤ eta * ‖u‖ * ‖v‖) (x : E) :
    (min a b - eta) * ‖x‖ ^ 2 ≤ inner (𝕜 := Real) x (H x) := by
  have hv : Q (x - Q x) = 0 := by rw [map_sub, hIdem, sub_self]
  have h := orthogonal_energy_lower H hH (Q x) (x - Q x) a b eta heta
    (projection_orthogonal Q hQ hIdem x)
    (hRetained (Q x) (hIdem x)) (hDiscarded (x - Q x) hv)
    (hMix (Q x) (x - Q x) (hIdem x) hv)
  have hx : Q x + (x - Q x) = x := by abel
  rwa [hx] at h

/-- The commutator measures failure of the proposed retained projection to
commute with the bounded operator. This definition is restricted to bounded
operators; applying it to an unbounded Hamiltonian requires additional work. -/
def blockCommutator (H Q : E →L[Real] E) : E →L[Real] E :=
  Q.comp H - H.comp Q

/-- On retained/discarded vectors, the cross term is exactly a commutator pairing. -/
theorem cross_term_eq_commutator (H Q : E →L[Real] E)
    (hQ : ∀ u v, inner (𝕜 := Real) (Q u) v = inner (𝕜 := Real) u (Q v))
    (u v : E) (hu : Q u = u) (hv : Q v = 0) :
    inner (𝕜 := Real) u (H v) = inner (𝕜 := Real) u (blockCommutator H Q v) := by
  change inner (𝕜 := Real) u (H v) = inner (𝕜 := Real) u (Q (H v) - H (Q v))
  rw [hv, map_zero, sub_zero, ← hQ u (H v), hu]

/-- The mixing estimate is derived from the actual commutator's operator norm. -/
theorem cross_term_le_commutator_norm (H Q : E →L[Real] E)
    (hQ : ∀ u v, inner (𝕜 := Real) (Q u) v = inner (𝕜 := Real) u (Q v))
    (u v : E) (hu : Q u = u) (hv : Q v = 0) :
    |inner (𝕜 := Real) u (H v)| ≤ ‖blockCommutator H Q‖ * ‖u‖ * ‖v‖ := by
  rw [cross_term_eq_commutator H Q hQ u v hu hv]
  calc
    _ ≤ ‖u‖ * ‖blockCommutator H Q v‖ := abs_real_inner_le_norm _ _
    _ ≤ ‖u‖ * (‖blockCommutator H Q‖ * ‖v‖) :=
      mul_le_mul_of_nonneg_left ((blockCommutator H Q).le_opNorm v) (norm_nonneg u)
    _ = _ := by ring

/-- Bounded-operator comparison with no separately postulated mixing constant.
The sector lower bounds and the physical interpretation are still explicit inputs. -/
theorem projected_energy_lower_of_commutator (H Q : E →L[Real] E)
    (hH : ∀ u v, inner (𝕜 := Real) (H u) v = inner (𝕜 := Real) u (H v))
    (hQ : ∀ u v, inner (𝕜 := Real) (Q u) v = inner (𝕜 := Real) u (Q v))
    (hIdem : ∀ u, Q (Q u) = Q u) (a b : Real)
    (hRetained : ∀ u, Q u = u → a * ‖u‖ ^ 2 ≤ inner (𝕜 := Real) u (H u))
    (hDiscarded : ∀ v, Q v = 0 → b * ‖v‖ ^ 2 ≤ inner (𝕜 := Real) v (H v))
    (x : E) :
    (min a b - ‖blockCommutator H Q‖) * ‖x‖ ^ 2 ≤ inner (𝕜 := Real) x (H x) := by
  exact projected_energy_lower H.toLinearMap Q.toLinearMap hH hQ hIdem
    a b ‖blockCommutator H Q‖ (norm_nonneg _) hRetained hDiscarded
    (fun u v hu hv => cross_term_le_commutator_norm H Q hQ u v hu hv) x

/-- If the projection commutes with the operator, this comparison has no mixing loss. -/
theorem projected_energy_lower_of_commuting (H Q : E →L[Real] E)
    (hH : ∀ u v, inner (𝕜 := Real) (H u) v = inner (𝕜 := Real) u (H v))
    (hQ : ∀ u v, inner (𝕜 := Real) (Q u) v = inner (𝕜 := Real) u (Q v))
    (hIdem : ∀ u, Q (Q u) = Q u) (a b : Real)
    (hRetained : ∀ u, Q u = u → a * ‖u‖ ^ 2 ≤ inner (𝕜 := Real) u (H u))
    (hDiscarded : ∀ v, Q v = 0 → b * ‖v‖ ^ 2 ≤ inner (𝕜 := Real) v (H v))
    (hComm : blockCommutator H Q = 0) (x : E) :
    min a b * ‖x‖ ^ 2 ≤ inner (𝕜 := Real) x (H x) := by
  have h := projected_energy_lower_of_commutator H Q hH hQ hIdem a b hRetained hDiscarded x
  simpa only [hComm, norm_zero, sub_zero] using h

/-- If the reference operator commutes with the projection, only the interaction
contributes to a retained/discarded cross term. -/
theorem cross_term_eq_interaction (H0 V Q : E →L[Real] E)
    (hQ : ∀ u v, inner (𝕜 := Real) (Q u) v = inner (𝕜 := Real) u (Q v))
    (hComm : blockCommutator H0 Q = 0)
    (u v : E) (hu : Q u = u) (hv : Q v = 0) :
    inner (𝕜 := Real) u ((H0 + V) v) = inner (𝕜 := Real) u (V v) := by
  have hc := congrArg (fun A : E →L[Real] E => A v) hComm
  change Q (H0 v) - H0 (Q v) = 0 at hc
  rw [hv, map_zero, sub_zero] at hc
  have hz : inner (𝕜 := Real) u (H0 v) = 0 := by
    calc
      _ = inner (𝕜 := Real) (Q u) (H0 v) := by rw [hu]
      _ = inner (𝕜 := Real) u (Q (H0 v)) := hQ u (H0 v)
      _ = 0 := by rw [hc, inner_zero_right]
  change inner (𝕜 := Real) u (H0 v + V v) = _
  rw [inner_add_right, hz, zero_add]

/-- Mixing is bounded by the interaction norm, without a factor from a
commutator triangle inequality. The reference operator contributes no cross term. -/
theorem cross_term_le_interaction_norm (H0 V Q : E →L[Real] E)
    (hQ : ∀ u v, inner (𝕜 := Real) (Q u) v = inner (𝕜 := Real) u (Q v))
    (hComm : blockCommutator H0 Q = 0)
    (u v : E) (hu : Q u = u) (hv : Q v = 0) :
    |inner (𝕜 := Real) u ((H0 + V) v)| ≤ ‖V‖ * ‖u‖ * ‖v‖ := by
  rw [cross_term_eq_interaction H0 V Q hQ hComm u v hu hv]
  calc
    _ ≤ ‖u‖ * ‖V v‖ := abs_real_inner_le_norm _ _
    _ ≤ ‖u‖ * (‖V‖ * ‖v‖) :=
      mul_le_mul_of_nonneg_left (V.le_opNorm v) (norm_nonneg u)
    _ = _ := by ring

/-- Interaction-controlled comparison. The sector bounds here concern the full
operator `H0 + V`, not just `H0`. Boundedness and commutation remain explicit;
no smallness or regulator-uniform estimate for a gauge interaction is assumed proved. -/
theorem projected_energy_lower_of_interaction (H0 V Q : E →L[Real] E)
    (hH : ∀ u v, inner (𝕜 := Real) ((H0 + V) u) v =
      inner (𝕜 := Real) u ((H0 + V) v))
    (hQ : ∀ u v, inner (𝕜 := Real) (Q u) v = inner (𝕜 := Real) u (Q v))
    (hIdem : ∀ u, Q (Q u) = Q u) (hComm : blockCommutator H0 Q = 0)
    (a b : Real)
    (hRetained : ∀ u, Q u = u → a * ‖u‖ ^ 2 ≤ inner (𝕜 := Real) u ((H0 + V) u))
    (hDiscarded : ∀ v, Q v = 0 → b * ‖v‖ ^ 2 ≤ inner (𝕜 := Real) v ((H0 + V) v))
    (x : E) :
    (min a b - ‖V‖) * ‖x‖ ^ 2 ≤ inner (𝕜 := Real) x ((H0 + V) x) := by
  exact projected_energy_lower (H0 + V).toLinearMap Q.toLinearMap hH hQ hIdem
    a b ‖V‖ (norm_nonneg _) hRetained hDiscarded
    (fun u v hu hv => cross_term_le_interaction_norm H0 V Q hQ hComm u v hu hv) x


/-! Explicit finite conditional averaging. These algebraic identities do not
identify this model with a gauge Hamiltonian or supply a Hilbert-space norm bound. -/
section ConditionalAverage
variable {X Y : Type*} [Fintype Y]

/-- Average the discarded coordinate, keeping the retained coordinate fixed. -/
def conditionalBlockAverage (p : X → Y → Real) (f : X × Y → Real)
    (q : X × Y) : Real :=
  ∑ z, p q.1 z * f (q.1, z)

/-- A normalized conditional average is a projection. -/
theorem conditionalBlockAverage_idempotent (p : X → Y → Real)
    (hp : ∀ x, ∑ z, p x z = 1) (f : X × Y → Real) :
    conditionalBlockAverage p (conditionalBlockAverage p f) =
      conditionalBlockAverage p f := by
  funext q
  simp only [conditionalBlockAverage]
  rw [← Finset.sum_mul, hp q.1, one_mul]

/-- The commutator with multiplication depends only on potential differences
within each conditional fiber. -/
theorem conditionalBlockAverage_commutator (p : X → Y → Real)
    (W f : X × Y → Real) (q : X × Y) :
    conditionalBlockAverage p (fun r => W r * f r) q -
      W q * conditionalBlockAverage p f q =
      ∑ z, p q.1 z * (W (q.1, z) - W q) * f (q.1, z) := by
  simp only [conditionalBlockAverage, Finset.mul_sum, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro z _
  ring

/-- Retained-coordinate potentials commute exactly with the conditional average. -/
theorem conditionalBlockAverage_retained_potential (p : X → Y → Real)
    (c : X → Real) (f : X × Y → Real) (q : X × Y) :
    conditionalBlockAverage p (fun r => c r.1 * f r) q =
      c q.1 * conditionalBlockAverage p f q := by
  simp only [conditionalBlockAverage, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro z _
  ring

/-- Arbitrarily large retained-only terms cancel before any mixing estimate. -/
theorem conditionalBlockAverage_commutator_add_retained (p : X → Y → Real)
    (W f : X × Y → Real) (c : X → Real) (q : X × Y) :
    conditionalBlockAverage p (fun r => (W r + c r.1) * f r) q -
      (W q + c q.1) * conditionalBlockAverage p f q =
    conditionalBlockAverage p (fun r => W r * f r) q -
      W q * conditionalBlockAverage p f q := by
  rw [conditionalBlockAverage_commutator, conditionalBlockAverage_commutator]
  apply Finset.sum_congr rfl
  intro z _
  simp only
  ring

/-- A pointwise oscillation bound, with normalized nonnegative conditional weights.
This is a pointwise estimate, not an asserted physical operator norm estimate. -/
theorem conditionalBlockAverage_commutator_bound (p : X → Y → Real)
    (hp : ∀ x z, 0 ≤ p x z) (hpn : ∀ x, ∑ z, p x z = 1)
    (W f : X × Y → Real) (q : X × Y) (d F : Real) (hd : 0 ≤ d)
    (hW : ∀ z, |W (q.1, z) - W q| ≤ d)
    (hf : ∀ z, |f (q.1, z)| ≤ F) :
    |conditionalBlockAverage p (fun r => W r * f r) q -
      W q * conditionalBlockAverage p f q| ≤ d * F := by
  rw [conditionalBlockAverage_commutator]
  calc
    _ ≤ ∑ z, |p q.1 z * (W (q.1, z) - W q) * f (q.1, z)| :=
      Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ z, p q.1 z * (d * F) := by
      apply Finset.sum_le_sum
      intro z _
      rw [abs_mul, abs_mul, abs_of_nonneg (hp q.1 z), mul_assoc]
      exact mul_le_mul_of_nonneg_left
        (mul_le_mul (hW z) (hf z) (abs_nonneg _) hd) (hp q.1 z)
    _ = d * F := by rw [← Finset.sum_mul, hpn q.1, one_mul]

/-- Weighted square Jensen inequality for a normalized finite conditional row. -/
theorem conditionalBlockAverage_sq_le (p : X → Y → Real)
    (hp : ∀ x z, 0 ≤ p x z) (hpn : ∀ x, ∑ z, p x z = 1)
    (f : X × Y → Real) (q : X × Y) :
    (conditionalBlockAverage p f q) ^ 2 ≤
      conditionalBlockAverage p (fun r => f r ^ 2) q := by
  have h : (∑ z, p q.1 z * f (q.1, z)) ^ 2 ≤
      (∑ z, p q.1 z) * ∑ z, p q.1 z * f (q.1, z) ^ 2 :=
    Finset.sum_sq_le_sum_mul_sum_of_sq_eq_mul Finset.univ
      (fun z _ => hp q.1 z)
      (fun z _ => mul_nonneg (hp q.1 z) (sq_nonneg _))
      (fun z _ => by ring)
  simpa [conditionalBlockAverage, hpn] using h

/-- Squared commutator control by a weighted second moment, without requiring
a uniform bound on the input function. -/
theorem conditionalBlockAverage_commutator_sq_bound (p : X → Y → Real)
    (hp : ∀ x z, 0 ≤ p x z) (hpn : ∀ x, ∑ z, p x z = 1)
    (W f : X × Y → Real) (q : X × Y) (d : Real) (hd : 0 ≤ d)
    (hW : ∀ z, |W (q.1, z) - W q| ≤ d) :
    (conditionalBlockAverage p (fun r => W r * f r) q -
      W q * conditionalBlockAverage p f q) ^ 2 ≤
      d ^ 2 * conditionalBlockAverage p (fun r => f r ^ 2) q := by
  rw [conditionalBlockAverage_commutator]
  have hj := conditionalBlockAverage_sq_le p hp hpn
    (fun r => (W r - W q) * f r) q
  simp only [conditionalBlockAverage] at hj ⊢
  calc
    _ = (∑ z, p q.1 z * ((W (q.1, z) - W q) * f (q.1, z))) ^ 2 := by
      simp only [mul_assoc]
    _ ≤ ∑ z, p q.1 z * ((W (q.1, z) - W q) * f (q.1, z)) ^ 2 := hj
    _ ≤ ∑ z, p q.1 z * (d ^ 2 * f (q.1, z) ^ 2) := by
      apply Finset.sum_le_sum
      intro z _
      apply mul_le_mul_of_nonneg_left _ (hp q.1 z)
      rw [mul_pow]
      have hs : (W (q.1, z) - W q) ^ 2 ≤ d ^ 2 := by
        have ha := hW z
        have hab := abs_nonneg (W (q.1, z) - W q)
        nlinarith [sq_abs (W (q.1, z) - W q)]
      exact mul_le_mul_of_nonneg_right hs (sq_nonneg _)
    _ = _ := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro z _
      ring

/-- Weighted squared-norm control on each conditional fiber. The same
conditional probability weights appear in both norms. This remains a finite
model estimate, not an identification with the physical Yang-Mills operator. -/
theorem conditionalBlockAverage_commutator_fiber_energy_bound
    (p : X → Y → Real)
    (hp : ∀ x z, 0 ≤ p x z) (hpn : ∀ x, ∑ z, p x z = 1)
    (W f : X × Y → Real) (x : X) (d : Real) (hd : 0 ≤ d)
    (hW : ∀ y z, |W (x, z) - W (x, y)| ≤ d) :
    (∑ y, p x y * (conditionalBlockAverage p (fun r => W r * f r) (x, y) -
      W (x, y) * conditionalBlockAverage p f (x, y)) ^ 2) ≤
      d ^ 2 * ∑ z, p x z * f (x, z) ^ 2 := by
  calc
    _ ≤ ∑ y, p x y * (d ^ 2 * ∑ z, p x z * f (x, z) ^ 2) := by
      apply Finset.sum_le_sum
      intro y _
      exact mul_le_mul_of_nonneg_left
        (conditionalBlockAverage_commutator_sq_bound p hp hpn W f (x, y) d hd
          (hW y)) (hp x y)
    _ = _ := by rw [← Finset.sum_mul, hpn x, one_mul]

/-- Conditional averaging is symmetric for its own fiber weights. -/
theorem conditionalBlockAverage_weighted_symmetry (p : X → Y → Real)
    (u v : X × Y → Real) (x : X) :
    (∑ y, p x y * conditionalBlockAverage p u (x, y) * v (x, y)) =
      ∑ y, p x y * u (x, y) * conditionalBlockAverage p v (x, y) := by
  simp only [conditionalBlockAverage]
  calc
    _ = (∑ z, p x z * u (x, z)) * ∑ y, p x y * v (x, y) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro y _
      ring
    _ = _ := by rw [Finset.sum_mul]

/-- The retained/discarded interaction cross term equals the weighted pairing
with the explicit conditional commutator. -/
theorem conditionalBlockAverage_cross_eq_commutator (p : X → Y → Real)
    (W u v : X × Y → Real) (x : X)
    (hu : ∀ y, conditionalBlockAverage p u (x, y) = u (x, y))
    (hv : ∀ y, conditionalBlockAverage p v (x, y) = 0) :
    (∑ y, p x y * u (x, y) * (W (x, y) * v (x, y))) =
      ∑ y, p x y * u (x, y) *
        (conditionalBlockAverage p (fun r => W r * v r) (x, y) -
          W (x, y) * conditionalBlockAverage p v (x, y)) := by
  simp only [hv, mul_zero, sub_zero]
  have h := conditionalBlockAverage_weighted_symmetry p u (fun r => W r * v r) x
  simpa only [hu] using h

/-- Squared weighted cross-term bound for retained and discarded functions.
The mixing constant uses only within-fiber potential oscillation. -/
theorem conditionalBlockAverage_cross_sq_bound (p : X → Y → Real)
    (hp : ∀ x z, 0 ≤ p x z) (hpn : ∀ x, ∑ z, p x z = 1)
    (W u v : X × Y → Real) (x : X) (d : Real) (hd : 0 ≤ d)
    (hW : ∀ y z, |W (x, z) - W (x, y)| ≤ d)
    (hu : ∀ y, conditionalBlockAverage p u (x, y) = u (x, y))
    (hv : ∀ y, conditionalBlockAverage p v (x, y) = 0) :
    (∑ y, p x y * u (x, y) * (W (x, y) * v (x, y))) ^ 2 ≤
      d ^ 2 * (∑ y, p x y * u (x, y) ^ 2) *
        (∑ y, p x y * v (x, y) ^ 2) := by
  rw [conditionalBlockAverage_cross_eq_commutator p W u v x hu hv]
  let c : Y → Real := fun y =>
    conditionalBlockAverage p (fun r => W r * v r) (x, y) -
      W (x, y) * conditionalBlockAverage p v (x, y)
  have hcs : (∑ y, p x y * u (x, y) * c y) ^ 2 ≤
      (∑ y, p x y * u (x, y) ^ 2) * ∑ y, p x y * c y ^ 2 :=
    Finset.sum_sq_le_sum_mul_sum_of_sq_eq_mul Finset.univ
      (fun y _ => mul_nonneg (hp x y) (sq_nonneg _))
      (fun y _ => mul_nonneg (hp x y) (sq_nonneg _))
      (fun y _ => by ring)
  have hb := conditionalBlockAverage_commutator_fiber_energy_bound p hp hpn W v x d hd hW
  have hn : 0 ≤ ∑ y, p x y * u (x, y) ^ 2 :=
    Finset.sum_nonneg fun y _ => mul_nonneg (hp x y) (sq_nonneg _)
  calc
    _ ≤ (∑ y, p x y * u (x, y) ^ 2) * ∑ y, p x y * c y ^ 2 := hcs
    _ ≤ (∑ y, p x y * u (x, y) ^ 2) *
        (d ^ 2 * ∑ y, p x y * v (x, y) ^ 2) :=
      mul_le_mul_of_nonneg_left hb hn
    _ = _ := by ring
/-- The explicit cross term costs at most the oscillation times the sum of
sector squared norms, in the form needed for quadratic energy comparison. -/
theorem conditionalBlockAverage_cross_energy_loss (p : X → Y → Real)
    (hp : ∀ x z, 0 ≤ p x z) (hpn : ∀ x, ∑ z, p x z = 1)
    (W u v : X × Y → Real) (x : X) (d : Real) (hd : 0 ≤ d)
    (hW : ∀ y z, |W (x, z) - W (x, y)| ≤ d)
    (hu : ∀ y, conditionalBlockAverage p u (x, y) = u (x, y))
    (hv : ∀ y, conditionalBlockAverage p v (x, y) = 0) :
    2 * |∑ y, p x y * u (x, y) * (W (x, y) * v (x, y))| ≤
      d * ((∑ y, p x y * u (x, y) ^ 2) +
        ∑ y, p x y * v (x, y) ^ 2) := by
  let A := ∑ y, p x y * u (x, y) ^ 2
  let B := ∑ y, p x y * v (x, y) ^ 2
  let t := ∑ y, p x y * u (x, y) * (W (x, y) * v (x, y))
  have hA : 0 ≤ A :=
    Finset.sum_nonneg fun y _ => mul_nonneg (hp x y) (sq_nonneg _)
  have hB : 0 ≤ B :=
    Finset.sum_nonneg fun y _ => mul_nonneg (hp x y) (sq_nonneg _)
  have ht : t ^ 2 ≤ d ^ 2 * A * B :=
    conditionalBlockAverage_cross_sq_bound p hp hpn W u v x d hd hW hu hv
  have hsq : (2 * |t|) ^ 2 ≤ (d * (A + B)) ^ 2 := by
    nlinarith only [ht, sq_abs t, mul_nonneg (sq_nonneg d) (sq_nonneg (A - B))]
  have hn : 0 ≤ d * (A + B) := mul_nonneg hd (add_nonneg hA hB)
  change 2 * |t| ≤ d * (A + B)
  nlinarith only [hsq, hn, abs_nonneg t]

/-- Retained and discarded functions are orthogonal in the fiber weights. -/
theorem conditionalBlockAverage_weighted_orthogonal (p : X → Y → Real)
    (u v : X × Y → Real) (x : X)
    (hu : ∀ y, conditionalBlockAverage p u (x, y) = u (x, y))
    (hv : ∀ y, conditionalBlockAverage p v (x, y) = 0) :
    (∑ y, p x y * u (x, y) * v (x, y)) = 0 := by
  have h := conditionalBlockAverage_weighted_symmetry p u v x
  simpa only [hu, hv, mul_zero, Finset.sum_const_zero] using h

/-- Pythagoras for the explicit retained/discarded fiber decomposition. -/
theorem conditionalBlockAverage_weighted_norm_split (p : X → Y → Real)
    (u v : X × Y → Real) (x : X)
    (hu : ∀ y, conditionalBlockAverage p u (x, y) = u (x, y))
    (hv : ∀ y, conditionalBlockAverage p v (x, y) = 0) :
    (∑ y, p x y * (u (x, y) + v (x, y)) ^ 2) =
      (∑ y, p x y * u (x, y) ^ 2) + ∑ y, p x y * v (x, y) ^ 2 := by
  have ho := conditionalBlockAverage_weighted_orthogonal p u v x hu hv
  calc
    _ = (∑ y, p x y * u (x, y) ^ 2) + (∑ y, p x y * v (x, y) ^ 2) +
        2 * ∑ y, p x y * u (x, y) * v (x, y) := by
      simp only [Finset.mul_sum, ← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro y _
      ring
    _ = _ := by rw [ho]; ring

/-- A reference operator commuting with the conditional average has no
retained/discarded cross term. The discarded condition is global because the
reference operator may couple different fibers. -/
theorem conditionalBlockAverage_reference_cross_zero (p : X → Y → Real)
    (R : (X × Y → Real) →ₗ[Real] (X × Y → Real))
    (hComm : ∀ f, conditionalBlockAverage p (R f) = R (conditionalBlockAverage p f))
    (u v : X × Y → Real) (x : X)
    (hu : ∀ y, conditionalBlockAverage p u (x, y) = u (x, y))
    (hv : conditionalBlockAverage p v = 0) :
    (∑ y, p x y * u (x, y) * R v (x, y)) = 0 := by
  have hz : conditionalBlockAverage p (R v) = 0 := by
    rw [hComm v, hv, map_zero]
  have hs := conditionalBlockAverage_weighted_symmetry p u (R v) x
  simpa only [hu, hz, Pi.zero_apply, mul_zero, Finset.sum_const_zero] using hs

/-- For a reference operator plus a multiplication potential, commutation
derives the cross-term identification required by the energy comparison. -/
theorem conditionalBlockAverage_operator_cross_eq_potential (p : X → Y → Real)
    (H R : (X × Y → Real) →ₗ[Real] (X × Y → Real))
    (hComm : ∀ f, conditionalBlockAverage p (R f) = R (conditionalBlockAverage p f))
    (W u v : X × Y → Real) (x : X)
    (hu : ∀ y, conditionalBlockAverage p u (x, y) = u (x, y))
    (hv : conditionalBlockAverage p v = 0)
    (hSplit : ∀ y, H v (x, y) = R v (x, y) + W (x, y) * v (x, y)) :
    (∑ y, p x y * u (x, y) * H v (x, y)) =
      ∑ y, p x y * u (x, y) * (W (x, y) * v (x, y)) := by
  simp only [hSplit, mul_add, Finset.sum_add_distrib]
  rw [conditionalBlockAverage_reference_cross_zero p R hComm u v x hu hv, zero_add]
/-- Conditional finite-model operator energy comparison. Sector estimates and
identification of the operator cross term with the multiplication interaction
are hypotheses. In particular, this theorem does not establish that
identification or these sector estimates for a physical gauge Hamiltonian. -/
theorem conditionalBlockAverage_operator_energy_lower (p : X → Y → Real)
    (hp : ∀ x z, 0 ≤ p x z) (hpn : ∀ x, ∑ z, p x z = 1)
    (H : (X × Y → Real) →ₗ[Real] (X × Y → Real))
    (W u v : X × Y → Real) (x : X) (a b d : Real) (hd : 0 ≤ d)
    (hW : ∀ y z, |W (x, z) - W (x, y)| ≤ d)
    (hu : ∀ y, conditionalBlockAverage p u (x, y) = u (x, y))
    (hv : ∀ y, conditionalBlockAverage p v (x, y) = 0)
    (hSym : (∑ y, p x y * v (x, y) * H u (x, y)) =
      ∑ y, p x y * u (x, y) * H v (x, y))
    (hCross : (∑ y, p x y * u (x, y) * H v (x, y)) =
      ∑ y, p x y * u (x, y) * (W (x, y) * v (x, y)))
    (hU : a * (∑ y, p x y * u (x, y) ^ 2) ≤
      ∑ y, p x y * u (x, y) * H u (x, y))
    (hV : b * (∑ y, p x y * v (x, y) ^ 2) ≤
      ∑ y, p x y * v (x, y) * H v (x, y)) :
    (min a b - d) * (∑ y, p x y * (u (x, y) + v (x, y)) ^ 2) ≤
      ∑ y, p x y * (u (x, y) + v (x, y)) * H (u + v) (x, y) := by
  have hn := conditionalBlockAverage_weighted_norm_split p u v x hu hv
  have hl := conditionalBlockAverage_cross_energy_loss p hp hpn W u v x d hd hW hu hv
  have hA : 0 ≤ ∑ y, p x y * u (x, y) ^ 2 :=
    Finset.sum_nonneg fun y _ => mul_nonneg (hp x y) (sq_nonneg _)
  have hB : 0 ≤ ∑ y, p x y * v (x, y) ^ 2 :=
    Finset.sum_nonneg fun y _ => mul_nonneg (hp x y) (sq_nonneg _)
  have ha := mul_le_mul_of_nonneg_right (min_le_left a b) hA
  have hb := mul_le_mul_of_nonneg_right (min_le_right a b) hB
  have he :
      (∑ y, p x y * (u (x, y) + v (x, y)) * H (u + v) (x, y)) =
      (∑ y, p x y * u (x, y) * H u (x, y)) +
      (∑ y, p x y * v (x, y) * H v (x, y)) +
      2 * ∑ y, p x y * u (x, y) * (W (x, y) * v (x, y)) := by
    rw [map_add]
    calc
      _ = (∑ y, p x y * u (x, y) * H u (x, y)) +
          (∑ y, p x y * v (x, y) * H v (x, y)) +
          (∑ y, p x y * u (x, y) * H v (x, y)) +
          (∑ y, p x y * v (x, y) * H u (x, y)) := by
        simp only [Pi.add_apply, ← Finset.sum_add_distrib]
        apply Finset.sum_congr rfl
        intro y _
        ring
      _ = _ := by rw [hSym, hCross]; ring
  rw [hn, he]
  have hab := neg_abs_le (∑ y, p x y * u (x, y) * (W (x, y) * v (x, y)))
  nlinarith only [hU, hV, ha, hb, hl, hab]

/-! Local interaction support. An interaction outside the selected active set
must be constant along the discarded coordinate. No lattice geometry or
volume-independent bound on the active set is supplied by these lemmas. -/
section LocalInteractions
variable {I : Type*} [Fintype I]

omit [Fintype Y] in
/-- Only active interactions contribute to a within-fiber potential difference. -/
theorem interaction_sum_difference_eq_active (V : I → X × Y → Real)
    (active : Finset I) (x : X)
    (hInactive : ∀ i, i ∉ active → ∀ y z, V i (x, z) = V i (x, y))
    (y z : Y) :
    (∑ i, V i (x, z)) - (∑ i, V i (x, y)) =
      ∑ i ∈ active, (V i (x, z) - V i (x, y)) := by
  rw [← Finset.sum_sub_distrib]
  symm
  apply Finset.sum_subset (Finset.subset_univ active)
  intro i _ hi
  exact sub_eq_zero.mpr (hInactive i hi y z)

omit [Fintype Y] in
/-- Total oscillation is bounded by the sum of active interaction oscillations;
the number and size of inactive terms do not enter this estimate. -/
theorem interaction_sum_oscillation_le_active (V : I → X × Y → Real)
    (active : Finset I) (x : X) (d : I → Real)
    (hInactive : ∀ i, i ∉ active → ∀ y z, V i (x, z) = V i (x, y))
    (hActive : ∀ i ∈ active, ∀ y z, |V i (x, z) - V i (x, y)| ≤ d i)
    (y z : Y) :
    |(∑ i, V i (x, z)) - (∑ i, V i (x, y))| ≤ ∑ i ∈ active, d i := by
  rw [interaction_sum_difference_eq_active V active x hInactive y z]
  exact (Finset.abs_sum_le_sum_abs _ _).trans
    (Finset.sum_le_sum fun i hi => hActive i hi y z)

/-- Local-support version of the cross-energy loss bound. A regulator-uniform
conclusion still requires a uniform bound on the active oscillation sum. -/
theorem conditionalBlockAverage_local_interaction_energy_loss
    (p : X → Y → Real) (hp : ∀ x z, 0 ≤ p x z)
    (hpn : ∀ x, ∑ z, p x z = 1)
    (V : I → X × Y → Real) (active : Finset I) (d : I → Real)
    (u v : X × Y → Real) (x : X)
    (hd : ∀ i ∈ active, 0 ≤ d i)
    (hInactive : ∀ i, i ∉ active → ∀ y z, V i (x, z) = V i (x, y))
    (hActive : ∀ i ∈ active, ∀ y z, |V i (x, z) - V i (x, y)| ≤ d i)
    (hu : ∀ y, conditionalBlockAverage p u (x, y) = u (x, y))
    (hv : ∀ y, conditionalBlockAverage p v (x, y) = 0) :
    2 * |∑ y, p x y * u (x, y) * ((∑ i, V i (x, y)) * v (x, y))| ≤
      (∑ i ∈ active, d i) * ((∑ y, p x y * u (x, y) ^ 2) +
        ∑ y, p x y * v (x, y) ^ 2) := by
  exact conditionalBlockAverage_cross_energy_loss p hp hpn
    (fun q => ∑ i, V i q) u v x (∑ i ∈ active, d i)
    (Finset.sum_nonneg hd)
    (interaction_sum_oscillation_le_active V active x d hInactive hActive) hu hv


omit [Fintype Y] in
/-- Bounded local incidence gives a block-size oscillation bound. The union
contains each affected interaction once, even if it touches several coordinates.
Uniformity in total system size requires the displayed constants to be uniform. -/
theorem interaction_sum_oscillation_le_local_degree
    {J : Type*} [DecidableEq I]
    (V : I → X × Y → Real) (block : Finset J) (touch : J → Finset I)
    (D : Nat) (hDegree : ∀ j ∈ block, (touch j).card ≤ D)
    (x : X) (delta : Real) (hdelta : 0 ≤ delta)
    (hInactive : ∀ i, i ∉ block.biUnion touch →
      ∀ y z, V i (x, z) = V i (x, y))
    (hActive : ∀ i ∈ block.biUnion touch,
      ∀ y z, |V i (x, z) - V i (x, y)| ≤ delta)
    (y z : Y) :
    |(∑ i, V i (x, z)) - (∑ i, V i (x, y))| ≤
      (block.card : Real) * D * delta := by
  have hc : ((block.biUnion touch).card : Real) ≤ (block.card : Real) * D := by
    exact_mod_cast Finset.card_biUnion_le_card_mul block touch D hDegree
  calc
    _ ≤ ∑ i ∈ block.biUnion touch, delta :=
      interaction_sum_oscillation_le_active V (block.biUnion touch) x
        (fun _ => delta) hInactive hActive y z
    _ = ((block.biUnion touch).card : Real) * delta := by
      simp only [Finset.sum_const, nsmul_eq_mul]
    _ ≤ _ := mul_le_mul_of_nonneg_right hc hdelta

/-- Conditional energy mixing bounded by block size, local interaction degree,
and single-interaction oscillation. Locality and all three uniform bounds
remain hypotheses, not assertions about an unconstructed gauge model. -/
theorem conditionalBlockAverage_local_degree_energy_loss
    {J : Type*} [DecidableEq I]
    (p : X → Y → Real) (hp : ∀ x z, 0 ≤ p x z)
    (hpn : ∀ x, ∑ z, p x z = 1)
    (V : I → X × Y → Real) (block : Finset J) (touch : J → Finset I)
    (D : Nat) (hDegree : ∀ j ∈ block, (touch j).card ≤ D)
    (u v : X × Y → Real) (x : X) (delta : Real) (hdelta : 0 ≤ delta)
    (hInactive : ∀ i, i ∉ block.biUnion touch →
      ∀ y z, V i (x, z) = V i (x, y))
    (hActive : ∀ i ∈ block.biUnion touch,
      ∀ y z, |V i (x, z) - V i (x, y)| ≤ delta)
    (hu : ∀ y, conditionalBlockAverage p u (x, y) = u (x, y))
    (hv : ∀ y, conditionalBlockAverage p v (x, y) = 0) :
    2 * |∑ y, p x y * u (x, y) * ((∑ i, V i (x, y)) * v (x, y))| ≤
      ((block.card : Real) * D * delta) *
        ((∑ y, p x y * u (x, y) ^ 2) + ∑ y, p x y * v (x, y) ^ 2) := by
  exact conditionalBlockAverage_cross_energy_loss p hp hpn
    (fun q => ∑ i, V i q) u v x ((block.card : Real) * D * delta)
    (mul_nonneg (mul_nonneg (Nat.cast_nonneg _) (Nat.cast_nonneg _)) hdelta)
    (interaction_sum_oscillation_le_local_degree V block touch D hDegree x
      delta hdelta hInactive hActive) hu hv
end LocalInteractions

/-- Moving a retained coordinate also changes its conditional weights. This is
the exact reference-dynamics commutator, separate from potential oscillation. -/
theorem conditionalBlockAverage_reference_shift_commutator
    (p : X → Y → Real) (sigma : X → X) (f : X × Y → Real) (x : X) (y : Y) :
    conditionalBlockAverage p (fun r => f (sigma r.1, r.2)) (x, y) -
      conditionalBlockAverage p f (sigma x, y) =
      ∑ z, (p x z - p (sigma x) z) * f (sigma x, z) := by
  simp only [conditionalBlockAverage, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro z _
  ring

/-- Commutation with all retained-coordinate shifts of this form is equivalent
to invariance of the conditional rows along that shift. Positivity and row
normalization alone do not provide this condition. -/
theorem conditionalBlockAverage_reference_shift_commutes_iff
    (p : X → Y → Real) (sigma : X → X) :
    (∀ f : X × Y → Real, ∀ x y,
      conditionalBlockAverage p (fun r => f (sigma r.1, r.2)) (x, y) =
        conditionalBlockAverage p f (sigma x, y)) ↔
      ∀ x z, p x z = p (sigma x) z := by
  classical
  constructor
  · intro h x z
    have hz := h (fun r => if r.2 = z then 1 else 0) x z
    simpa [conditionalBlockAverage] using hz
  · intro h f x y
    simp only [conditionalBlockAverage]
    apply Finset.sum_congr rfl
    intro z _
    rw [h x z]

/-- Strictly positive conditional rows with genuine retained-coordinate dependence. -/
noncomputable def dependentBoolRows (x y : Bool) : Real := if x = y then 3 / 4 else 1 / 4

theorem dependentBoolRows_positive (x y : Bool) : 0 < dependentBoolRows x y := by
  cases x <;> cases y <;> norm_num [dependentBoolRows]

theorem dependentBoolRows_normalized (x : Bool) :
    (∑ y, dependentBoolRows x y) = 1 := by
  cases x <;> norm_num [dependentBoolRows, Fintype.sum_bool]

/-- Explicit positive, normalized counterexample to automatic reference
commutation. It does not assert failure for a particular Yang-Mills model;
it rules out inferring commutation merely from stochastic conditional averaging. -/
theorem dependentBoolRows_reference_not_commuting :
    ¬ (∀ f : Bool × Bool → Real, ∀ x y,
      conditionalBlockAverage dependentBoolRows (fun r => f (!r.1, r.2)) (x, y) =
        conditionalBlockAverage dependentBoolRows f (!x, y)) := by
  intro h
  have hr := (conditionalBlockAverage_reference_shift_commutes_iff
    dependentBoolRows (fun x => !x)).mp h false false
  norm_num [dependentBoolRows] at hr
end ConditionalAverage

section CoordinateLocality
variable {J G K : Type*} [DecidableEq J]

/-- Replace the coordinates in a block, leaving the exterior configuration fixed. -/
def blockConfiguration (block : Finset J) (outside inside : J → G) : J → G :=
  fun j => if j ∈ block then inside j else outside j

/-- An interaction supported outside the block is unchanged by block replacement. -/
theorem blockConfiguration_interaction_unchanged (block support : Finset J)
    (V : (J → G) → Real) (hLocal : DependsOn V (support : Set J))
    (hAway : ∀ j ∈ support, j ∉ block) (outside inside₁ inside₂ : J → G) :
    V (blockConfiguration block outside inside₁) =
      V (blockConfiguration block outside inside₂) := by
  apply hLocal
  intro j hj
  simp only [blockConfiguration, if_neg (hAway j hj)]

variable [Fintype K] [DecidableEq K]

/-- Interaction indices incident to at least one coordinate in the block. -/
def blockTouchingInteractions (block : Finset J) (support : K → Finset J) : Finset K :=
  block.biUnion (fun j => Finset.univ.filter (fun i => j ∈ support i))

/-- Locality derives the inactive-interaction hypothesis used in the block bounds. -/
theorem blockConfiguration_inactive_interaction (block : Finset J)
    (support : K → Finset J) (V : K → (J → G) → Real)
    (hLocal : ∀ i, DependsOn (V i) (support i : Set J))
    (i : K) (hi : i ∉ blockTouchingInteractions block support)
    (outside inside₁ inside₂ : J → G) :
    V i (blockConfiguration block outside inside₁) =
      V i (blockConfiguration block outside inside₂) := by
  apply blockConfiguration_interaction_unchanged block (support i) (V i) (hLocal i)
  intro j hj hjb
  apply hi
  exact Finset.mem_biUnion.mpr
    ⟨j, hjb, Finset.mem_filter.mpr ⟨Finset.mem_univ i, hj⟩⟩

/-- Local coordinate dependence and bounded incidence imply the previously
used block-size oscillation estimate for the explicitly assembled potential.
This does not assert locality or bounded incidence for a renormalized model. -/
theorem interaction_oscillation_from_coordinate_support (block : Finset J)
    (support : K → Finset J) (V : K → (J → G) → Real)
    (hLocal : ∀ i, DependsOn (V i) (support i : Set J))
    (D : Nat)
    (hDegree : ∀ j ∈ block, (Finset.univ.filter (fun i => j ∈ support i)).card ≤ D)
    (outside : J → G) (delta : Real) (hdelta : 0 ≤ delta)
    (hActive : ∀ i ∈ blockTouchingInteractions block support, ∀ y z : J → G,
      |V i (blockConfiguration block outside z) -
        V i (blockConfiguration block outside y)| ≤ delta)
    (y z : J → G) :
    |(∑ i, V i (blockConfiguration block outside z)) -
      (∑ i, V i (blockConfiguration block outside y))| ≤
      (block.card : Real) * D * delta := by
  exact interaction_sum_oscillation_le_local_degree
    (fun i (q : (J → G) × (J → G)) => V i (blockConfiguration block q.1 q.2))
    block (fun j => Finset.univ.filter (fun i => j ∈ support i)) D hDegree
    outside delta hdelta
    (fun i hi y z => blockConfiguration_inactive_interaction block support V hLocal
      i hi outside z y) hActive y z

end CoordinateLocality

/-! Concrete magnetic interaction for special-unitary link variables.
The coefficient beta below is the coefficient of the normalized Wilson term.
This constructs the magnetic potential only: the electric operator, its domain,
physical gauge-invariant Hilbert space, and blocked transition kernel remain open.
Reference: D'Andrea et al., Phys. Rev. D 109 (2024), 074501, section II. -/
section WilsonPlaquette
variable {N L P : Type*} [Fintype N] [DecidableEq N]

/-- Oriented square holonomy: edges run 0→1, 1→2, 3→2, and 0→3. -/
def squareHolonomy {G : Type*} [Group G] (a b c d : G) : G :=
  a * b * c⁻¹ * d⁻¹

/-- The four vertex gauge factors cancel except for conjugation at the base vertex. -/
theorem squareHolonomy_gauge_covariant {G : Type*} [Group G]
    (a b c d g0 g1 g2 g3 : G) :
    squareHolonomy (g0 * a * g1⁻¹) (g1 * b * g2⁻¹)
      (g3 * c * g2⁻¹) (g0 * d * g3⁻¹) =
      g0 * squareHolonomy a b c d * g0⁻¹ := by
  unfold squareHolonomy
  group

/-- Normalized Wilson magnetic term on an actual special-unitary matrix.
Use nonempty N for the usual physical normalization. -/
noncomputable def wilsonMagneticTerm (beta : Real)
    (U : Matrix.specialUnitaryGroup N Complex) : Real :=
  beta * (1 - (Matrix.trace U.val).re / Fintype.card N)

theorem specialUnitary_trace_conjugate
    (g U : Matrix.specialUnitaryGroup N Complex) :
    Matrix.trace (g * U * g⁻¹).val = Matrix.trace U.val := by
  have hi : (g⁻¹).val * g.val = (1 : Matrix N N Complex) :=
    congrArg Subtype.val (inv_mul_cancel g)
  change Matrix.trace (g.val * U.val * (g⁻¹).val) = _
  rw [Matrix.trace_mul_cycle, hi, one_mul]

/-- Gauge invariance of the concrete Wilson plaquette term. -/
theorem wilsonMagneticTerm_square_gauge_invariant (beta : Real)
    (a b c d g0 g1 g2 g3 : Matrix.specialUnitaryGroup N Complex) :
    wilsonMagneticTerm beta
      (squareHolonomy (g0 * a * g1⁻¹) (g1 * b * g2⁻¹)
        (g3 * c * g2⁻¹) (g0 * d * g3⁻¹)) =
      wilsonMagneticTerm beta (squareHolonomy a b c d) := by
  rw [squareHolonomy_gauge_covariant]
  unfold wilsonMagneticTerm
  rw [specialUnitary_trace_conjugate]

/-- The four specified links determine the plaquette interaction. -/
noncomputable def wilsonPlaquette (beta : Real) (edges : Fin 4 → L)
    (U : L → Matrix.specialUnitaryGroup N Complex) : Real :=
  wilsonMagneticTerm beta
    (squareHolonomy (U (edges 0)) (U (edges 1)) (U (edges 2)) (U (edges 3)))

/-- Coordinate support of a Wilson plaquette is derived from its formula. -/
theorem wilsonPlaquette_dependsOn (beta : Real) (edges : Fin 4 → L) :
    DependsOn (wilsonPlaquette (N := N) beta edges) (Set.range edges) := by
  intro U V h
  unfold wilsonPlaquette squareHolonomy
  rw [h (edges 0) ⟨0, rfl⟩, h (edges 1) ⟨1, rfl⟩,
    h (edges 2) ⟨2, rfl⟩, h (edges 3) ⟨3, rfl⟩]

/-- Exact cancellation of a concrete Wilson plaquette under replacement of
a block disjoint from all four links. No finiteness of the gauge group is used. -/
theorem wilsonPlaquette_block_unchanged [DecidableEq L]
    (beta : Real) (edges : Fin 4 → L) (block : Finset L)
    (hAway : ∀ k, edges k ∉ block)
    (outside inside₁ inside₂ : L → Matrix.specialUnitaryGroup N Complex) :
    wilsonPlaquette beta edges (blockConfiguration block outside inside₁) =
      wilsonPlaquette beta edges (blockConfiguration block outside inside₂) := by
  apply wilsonPlaquette_dependsOn beta edges
  rintro _ ⟨k, rfl⟩
  simp only [blockConfiguration, if_neg (hAway k)]
/-- Explicit finite sum of normalized Wilson magnetic plaquette terms.
This is not, by itself, the full Yang-Mills Hamiltonian. -/
noncomputable def finiteWilsonMagneticPotential [Fintype P]
    (beta : Real) (plaquettes : P → Fin 4 → L)
    (U : L → Matrix.specialUnitaryGroup N Complex) : Real :=
  ∑ p, wilsonPlaquette beta (plaquettes p) U

/-- Unitarity fixes the squared length of every row. -/
theorem specialUnitary_row_normSq_sum
    (U : Matrix.specialUnitaryGroup N Complex) (i : N) :
    (∑ j, Complex.normSq (U.val i j)) = 1 := by
  have hm : U.val * star U.val = (1 : Matrix N N Complex) := U.property.1.2
  have hr := congrArg (fun M : Matrix N N Complex => (M i i).re) hm
  simpa [Matrix.mul_apply, Matrix.star_apply, Complex.mul_re,
    Complex.normSq_apply] using hr

/-- Every diagonal real part lies in the unit interval in absolute value. -/
theorem specialUnitary_diagonal_re_abs_le_one
    (U : Matrix.specialUnitaryGroup N Complex) (i : N) :
    |(U.val i i).re| ≤ 1 := by
  have hn := Finset.single_le_sum
    (fun j (_ : j ∈ Finset.univ) => Complex.normSq_nonneg (U.val i j))
    (Finset.mem_univ i)
  rw [specialUnitary_row_normSq_sum U i] at hn
  rw [Complex.normSq_apply] at hn
  apply abs_le.mpr
  constructor <;> nlinarith only [hn, sq_nonneg (U.val i i).im]

/-- Explicit trace bound, derived from unitarity rather than assumed. -/
theorem specialUnitary_trace_re_abs_le_card
    (U : Matrix.specialUnitaryGroup N Complex) :
    |(Matrix.trace U.val).re| ≤ (Fintype.card N : Real) := by
  change |Complex.reAddGroupHom (∑ i, U.val i i)| ≤ _
  rw [map_sum]
  calc
    _ ≤ ∑ i, |(U.val i i).re| := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ _i : N, (1 : Real) :=
      Finset.sum_le_sum fun i _ => specialUnitary_diagonal_re_abs_le_one U i
    _ = _ := by simp

/-- For nonnegative coefficient beta, the normalized Wilson term lies in [0,2 beta]. -/
theorem wilsonMagneticTerm_bounds [Nonempty N] (beta : Real) (hbeta : 0 ≤ beta)
    (U : Matrix.specialUnitaryGroup N Complex) :
    0 ≤ wilsonMagneticTerm beta U ∧ wilsonMagneticTerm beta U ≤ 2 * beta := by
  have hN : (0 : Real) < Fintype.card N := by exact_mod_cast Fintype.card_pos
  have ht := abs_le.mp (specialUnitary_trace_re_abs_le_card U)
  have hlo : -1 ≤ (Matrix.trace U.val).re / Fintype.card N :=
    (le_div_iff₀ hN).mpr (by simpa using ht.1)
  have hhi : (Matrix.trace U.val).re / Fintype.card N ≤ 1 :=
    (div_le_iff₀ hN).mpr (by simpa using ht.2)
  unfold wilsonMagneticTerm
  constructor
  · exact mul_nonneg hbeta (sub_nonneg.mpr hhi)
  · nlinarith only [mul_le_mul_of_nonneg_left (show
      1 - (Matrix.trace U.val).re / Fintype.card N ≤ 2 by linarith only [hlo]) hbeta]

/-- An explicit oscillation constant for each normalized Wilson plaquette. -/
theorem wilsonMagneticTerm_oscillation [Nonempty N] (beta : Real) (hbeta : 0 ≤ beta)
    (U V : Matrix.specialUnitaryGroup N Complex) :
    |wilsonMagneticTerm beta U - wilsonMagneticTerm beta V| ≤ 2 * beta := by
  obtain ⟨hU0, hU1⟩ := wilsonMagneticTerm_bounds beta hbeta U
  obtain ⟨hV0, hV1⟩ := wilsonMagneticTerm_bounds beta hbeta V
  exact abs_le.mpr ⟨by linarith only [hU0, hV1], by linarith only [hV0, hU1]⟩
/-- Explicit magnetic block oscillation bound for special-unitary Wilson links.
For beta >= 0 it is 2 beta times block size times the supplied plaquette
incidence bound. No finite-state approximation to the compact gauge group is used. -/
theorem finiteWilsonMagneticPotential_block_oscillation
    [Nonempty N] [Fintype P] [DecidableEq L]
    (beta : Real) (hbeta : 0 ≤ beta) (plaquettes : P → Fin 4 → L)
    (block : Finset L) (D : Nat)
    (hDegree : ∀ j ∈ block,
      (Finset.univ.filter (fun p => j ∈ Finset.univ.image (plaquettes p))).card ≤ D)
    (outside inside₁ inside₂ : L → Matrix.specialUnitaryGroup N Complex) :
    |finiteWilsonMagneticPotential beta plaquettes
        (blockConfiguration block outside inside₂) -
      finiteWilsonMagneticPotential beta plaquettes
        (blockConfiguration block outside inside₁)| ≤
      (block.card : Real) * D * (2 * beta) := by
  classical
  apply interaction_oscillation_from_coordinate_support block
    (fun p => Finset.univ.image (plaquettes p))
    (fun p => wilsonPlaquette beta (plaquettes p))
  · intro p
    simpa only [Finset.coe_image, Finset.coe_univ, Set.image_univ] using
      wilsonPlaquette_dependsOn (N := N) beta (plaquettes p)
  · exact hDegree
  · exact mul_nonneg (by norm_num) hbeta
  · intro p _ y z
    exact wilsonMagneticTerm_oscillation beta hbeta _ _
end WilsonPlaquette

section GibbsNormalization
open MeasureTheory
variable {A : Type*} [MeasurableSpace A]
variable (mu : Measure A) [IsProbabilityMeasure mu]

/-- Gibbs partition function relative to a probability reference measure.
For compact link groups the intended reference is normalized product Haar. -/
noncomputable def gibbsPartition (W : A → Real) : Real :=
  ∫ z, Real.exp (-W z) ∂mu

noncomputable def gibbsDensity (W : A → Real) (z : A) : Real :=
  Real.exp (-W z) / gibbsPartition mu W

/-- Actual measure defined by the normalized Boltzmann density. -/
noncomputable def gibbsMeasure (W : A → Real) : Measure A :=
  mu.withDensity (fun z => ENNReal.ofReal (gibbsDensity mu W z))

theorem gibbsPartition_pos (W : A → Real)
    (hW : Integrable (fun z => Real.exp (-W z)) mu) :
    0 < gibbsPartition mu W :=
  integral_exp_pos hW

theorem gibbsDensity_positive (W : A → Real)
    (hW : Integrable (fun z => Real.exp (-W z)) mu) (z : A) :
    0 < gibbsDensity mu W z :=
  div_pos (Real.exp_pos _) (gibbsPartition_pos mu W hW)

theorem gibbsDensity_integral_one (W : A → Real)
    (hW : Integrable (fun z => Real.exp (-W z)) mu) :
    (∫ z, gibbsDensity mu W z ∂mu) = 1 := by
  simp only [gibbsDensity, integral_div]
  exact div_self (ne_of_gt (gibbsPartition_pos mu W hW))

theorem gibbsMeasure_isProbability (W : A → Real)
    (hW : Integrable (fun z => Real.exp (-W z)) mu) :
    IsProbabilityMeasure (gibbsMeasure mu W) := by
  constructor
  rw [gibbsMeasure, withDensity_apply _ MeasurableSet.univ, Measure.restrict_univ]
  have hi : Integrable (gibbsDensity mu W) mu := hW.div_const (gibbsPartition mu W)
  rw [← ofReal_integral_eq_lintegral_ofReal
    hi
    (Filter.Eventually.of_forall (fun z => (gibbsDensity_positive mu W hW z).le))]
  rw [gibbsDensity_integral_one mu W hW]
  simp

/-- Oscillation controls normalized Gibbs density with the sharp elementary
factor exp(C), with no assumed spectral or Hamiltonian comparison. -/
theorem gibbsDensity_bounds_of_oscillation (W : A → Real)
    (hW : Integrable (fun z => Real.exp (-W z)) mu)
    (C : Real) (hOsc : ∀ y z, |W y - W z| ≤ C) (x : A) :
    Real.exp (-C) ≤ gibbsDensity mu W x ∧
      gibbsDensity mu W x ≤ Real.exp C := by
  have hupper : gibbsPartition mu W ≤ Real.exp (C - W x) := by
    have h := integral_mono hW (integrable_const (Real.exp (C - W x))) (fun y => by
      apply Real.exp_le_exp.mpr
      have hy := (abs_le.mp (hOsc x y)).2
      linarith only [hy])
    simpa [gibbsPartition] using h
  have hlower : Real.exp (-C - W x) ≤ gibbsPartition mu W := by
    have h := integral_mono (integrable_const (Real.exp (-C - W x))) hW (fun y => by
      apply Real.exp_le_exp.mpr
      have hy := (abs_le.mp (hOsc y x)).2
      linarith only [hy])
    simpa [gibbsPartition] using h
  have hZ := gibbsPartition_pos mu W hW
  constructor
  · apply (le_div_iff₀ hZ).mpr
    calc
      _ ≤ Real.exp (-C) * Real.exp (C - W x) :=
        mul_le_mul_of_nonneg_left hupper (Real.exp_pos _).le
      _ = Real.exp (-W x) := by rw [← Real.exp_add]; congr 1; ring
  · apply (div_le_iff₀ hZ).mpr
    calc
      Real.exp (-W x) = Real.exp C * Real.exp (-C - W x) := by
        rw [← Real.exp_add]; congr 1; ring
      _ ≤ _ := mul_le_mul_of_nonneg_left hlower (Real.exp_pos _).le

/-- A measurable nonnegative action has an integrable Boltzmann weight on a
probability reference space, since that weight is bounded by one. -/
theorem gibbsWeight_integrable_of_nonneg (W : A → Real)
    (hMeas : Measurable W) (hNonneg : ∀ z, 0 ≤ W z) :
    Integrable (fun z => Real.exp (-W z)) mu := by
  apply (integrable_const (1 : Real)).mono' hMeas.neg.exp.aestronglyMeasurable
  apply Filter.Eventually.of_forall
  intro z
  rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
  exact Real.exp_le_one_iff.mpr (neg_nonpos.mpr (hNonneg z))
end GibbsNormalization



section SpecialUnitaryTopology
variable {N : Type*} [Fintype N] [DecidableEq N]

/-- The special-unitary matrix set is closed by its defining equations. -/
theorem specialUnitary_isClosed :
    IsClosed (Matrix.specialUnitaryGroup N Complex : Set (Matrix N N Complex)) := by
  change IsClosed ((unitary (Matrix N N Complex) : Set (Matrix N N Complex)) ∩
    {M | Matrix.det M = 1})
  exact isClosed_unitary.inter (isClosed_eq continuous_id.matrix_det continuous_const)

open scoped Matrix.Norms.Elementwise in
/-- Compactness of the actual special-unitary group, from closedness and the
unitary entry bounds in finite-dimensional matrix space. -/
theorem specialUnitary_compactSpace :
    CompactSpace (Matrix.specialUnitaryGroup N Complex) := by
  letI : ProperSpace (Matrix N N Complex) := FiniteDimensional.proper Complex _
  apply isCompact_iff_compactSpace.mp
  apply (isCompact_closedBall (0 : Matrix N N Complex) 1).of_isClosed_subset
    specialUnitary_isClosed
  intro U hU
  rw [Metric.mem_closedBall, dist_zero_right]
  exact entrywise_sup_norm_bound_of_unitary hU.1

/-- Matrix multiplication and conjugate-transpose inversion give the required
topological group structure for Haar measure. -/
theorem specialUnitary_isTopologicalGroup :
    IsTopologicalGroup (Matrix.specialUnitaryGroup N Complex) := by
  letI : ContinuousInv (Matrix.specialUnitaryGroup N Complex) :=
    ⟨continuous_induced_rng.mpr continuous_subtype_val.star⟩
  exact { }

end SpecialUnitaryTopology
section WilsonContinuity
variable {N L P : Type*} [Fintype N] [DecidableEq N]

/-- Continuity follows from the explicit matrix product and trace formula;
inverse special-unitary matrices are conjugate transposes. -/
theorem wilsonPlaquette_continuous (beta : Real) (edges : Fin 4 → L) :
    Continuous (wilsonPlaquette (N := N) beta edges) := by
  change Continuous (fun U : L → Matrix.specialUnitaryGroup N Complex =>
    beta * (1 - (Matrix.trace
      ((U (edges 0)).val * (U (edges 1)).val *
        star (U (edges 2)).val * star (U (edges 3)).val)).re / Fintype.card N))
  fun_prop

theorem finiteWilsonMagneticPotential_continuous [Fintype P]
    (beta : Real) (plaquettes : P → Fin 4 → L) :
    Continuous (finiteWilsonMagneticPotential (N := N) beta plaquettes) := by
  exact continuous_finset_sum _ (fun p _ => wilsonPlaquette_continuous beta (plaquettes p))

/-- Block replacement is jointly continuous in exterior and interior link data. -/
theorem blockConfiguration_joint_continuous [DecidableEq L] (block : Finset L) :
    Continuous (fun q : (L → Matrix.specialUnitaryGroup N Complex) ×
      (L → Matrix.specialUnitaryGroup N Complex) =>
      blockConfiguration block q.1 q.2) := by
  apply continuous_pi
  intro j
  by_cases hj : j ∈ block
  · simpa only [blockConfiguration, if_pos hj] using (continuous_apply j).comp continuous_snd
  · simpa only [blockConfiguration, if_neg hj] using (continuous_apply j).comp continuous_fst

/-- The concrete block action is jointly continuous, including its dependence
on the exterior configuration that parametrizes conditional resampling. -/
theorem wilsonBlockAction_joint_continuous [Fintype P] [DecidableEq L]
    (beta : Real) (plaquettes : P → Fin 4 → L) (block : Finset L) :
    Continuous (fun q : (L → Matrix.specialUnitaryGroup N Complex) ×
      (L → Matrix.specialUnitaryGroup N Complex) =>
      finiteWilsonMagneticPotential beta plaquettes (blockConfiguration block q.1 q.2)) :=
  (finiteWilsonMagneticPotential_continuous beta plaquettes).comp
    (blockConfiguration_joint_continuous block)

theorem wilsonBlockAction_measurable [Fintype P] [DecidableEq L]
    [MeasurableSpace (L → Matrix.specialUnitaryGroup N Complex)]
    [BorelSpace (L → Matrix.specialUnitaryGroup N Complex)]
    (beta : Real) (plaquettes : P → Fin 4 → L) (block : Finset L)
    (outside : L → Matrix.specialUnitaryGroup N Complex) :
    Measurable (fun inside => finiteWilsonMagneticPotential beta plaquettes
      (blockConfiguration block outside inside)) :=
  ((wilsonBlockAction_joint_continuous beta plaquettes block).comp
    (continuous_const.prodMk continuous_id)).measurable

end WilsonContinuity
section WilsonGibbs
open MeasureTheory
variable {N L P : Type*} [Fintype N] [DecidableEq N] [Nonempty N]
  [Fintype P] [DecidableEq L]
variable [MeasurableSpace (L → Matrix.specialUnitaryGroup N Complex)]
variable (mu : Measure (L → Matrix.specialUnitaryGroup N Complex)) [IsProbabilityMeasure mu]

/-- Conditional Wilson Gibbs measure for a fixed exterior configuration.
Measurability of the action and the probability reference measure are explicit;
the intended Haar reference has not been constructed by this definition. -/
noncomputable def wilsonBlockGibbsMeasure (beta : Real) (plaquettes : P → Fin 4 → L)
    (block : Finset L) (outside : L → Matrix.specialUnitaryGroup N Complex) :=
  gibbsMeasure mu (fun inside => finiteWilsonMagneticPotential beta plaquettes
    (blockConfiguration block outside inside))

theorem wilsonBlockGibbs_integrable (beta : Real) (hbeta : 0 ≤ beta)
    (plaquettes : P → Fin 4 → L) (block : Finset L)
    (outside : L → Matrix.specialUnitaryGroup N Complex)
    (hMeas : Measurable (fun inside => finiteWilsonMagneticPotential beta plaquettes
      (blockConfiguration block outside inside))) :
    Integrable (fun inside => Real.exp (-finiteWilsonMagneticPotential beta plaquettes
      (blockConfiguration block outside inside))) mu := by
  apply gibbsWeight_integrable_of_nonneg mu _ hMeas
  intro inside
  exact Finset.sum_nonneg fun p _ => (wilsonMagneticTerm_bounds beta hbeta _).1

theorem wilsonBlockGibbs_isProbability (beta : Real) (hbeta : 0 ≤ beta)
    (plaquettes : P → Fin 4 → L) (block : Finset L)
    (outside : L → Matrix.specialUnitaryGroup N Complex)
    (hMeas : Measurable (fun inside => finiteWilsonMagneticPotential beta plaquettes
      (blockConfiguration block outside inside))) :
    IsProbabilityMeasure (wilsonBlockGibbsMeasure mu beta plaquettes block outside) :=
  gibbsMeasure_isProbability mu _
    (wilsonBlockGibbs_integrable mu beta hbeta plaquettes block outside hMeas)

/-- Explicit density minorization/majorization for the constructed Wilson
conditional measure, with C = 2 beta * block size * plaquette incidence bound.
This is an equilibrium resampling density, not yet physical-time evolution. -/
theorem wilsonBlockGibbs_density_bounds (beta : Real) (hbeta : 0 ≤ beta)
    (plaquettes : P → Fin 4 → L) (block : Finset L) (D : Nat)
    (hDegree : ∀ j ∈ block,
      (Finset.univ.filter (fun p => j ∈ Finset.univ.image (plaquettes p))).card ≤ D)
    (outside inside : L → Matrix.specialUnitaryGroup N Complex)
    (hMeas : Measurable (fun z => finiteWilsonMagneticPotential beta plaquettes
      (blockConfiguration block outside z))) :
    Real.exp (-((block.card : Real) * D * (2 * beta))) ≤
      gibbsDensity mu (fun z => finiteWilsonMagneticPotential beta plaquettes
        (blockConfiguration block outside z)) inside ∧
    gibbsDensity mu (fun z => finiteWilsonMagneticPotential beta plaquettes
      (blockConfiguration block outside z)) inside ≤
      Real.exp ((block.card : Real) * D * (2 * beta)) := by
  apply gibbsDensity_bounds_of_oscillation mu _
    (wilsonBlockGibbs_integrable mu beta hbeta plaquettes block outside hMeas)
  intro y z
  exact finiteWilsonMagneticPotential_block_oscillation beta hbeta plaquettes
    block D hDegree outside z y

/-- Under the standard Borel measurable structure, the previously explicit
measurability premise is discharged for the actual Wilson block formula. -/
theorem wilsonBlockGibbs_isProbability_borel
    [BorelSpace (L → Matrix.specialUnitaryGroup N Complex)]
    (beta : Real) (hbeta : 0 ≤ beta) (plaquettes : P → Fin 4 → L)
    (block : Finset L) (outside : L → Matrix.specialUnitaryGroup N Complex) :
    IsProbabilityMeasure (wilsonBlockGibbsMeasure mu beta plaquettes block outside) :=
  wilsonBlockGibbs_isProbability mu beta hbeta plaquettes block outside
    (wilsonBlockAction_measurable beta plaquettes block outside)
end WilsonGibbs

section WilsonHaar
open MeasureTheory TopologicalSpace
variable {N L P : Type*} [Fintype N] [DecidableEq N]
variable [MeasurableSpace (L → Matrix.specialUnitaryGroup N Complex)]
  [BorelSpace (L → Matrix.specialUnitaryGroup N Complex)]

/-- Normalized Haar reference on the actual finite-link special-unitary
configuration group, constructed using its proved compact group structure. -/
noncomputable def wilsonHaarReference : Measure (L → Matrix.specialUnitaryGroup N Complex) := by
  letI := specialUnitary_compactSpace (N := N)
  letI := specialUnitary_isTopologicalGroup (N := N)
  exact Measure.haarMeasure
    (⟨⟨Set.univ, isCompact_univ⟩, by simp⟩ :
      PositiveCompacts (L → Matrix.specialUnitaryGroup N Complex))

theorem wilsonHaarReference_isProbability :
    IsProbabilityMeasure (wilsonHaarReference (N := N) (L := L)) := by
  letI := specialUnitary_compactSpace (N := N)
  letI := specialUnitary_isTopologicalGroup (N := N)
  constructor
  exact Measure.haarMeasure_self

theorem wilsonHaarReference_isHaar :
    Measure.IsHaarMeasure (wilsonHaarReference (N := N) (L := L)) := by
  letI := specialUnitary_compactSpace (N := N)
  letI := specialUnitary_isTopologicalGroup (N := N)
  unfold wilsonHaarReference
  infer_instance

/-- Wilson conditional resampling is now a probability measure for the
constructed Haar reference, with no measurability or normalization assumptions
on the action supplied by the caller. This is not a physical-time kernel. -/
theorem wilsonBlockGibbs_haar_isProbability [Nonempty N] [Fintype P] [DecidableEq L]
    (beta : Real) (hbeta : 0 ≤ beta) (plaquettes : P → Fin 4 → L)
    (block : Finset L) (outside : L → Matrix.specialUnitaryGroup N Complex) :
    IsProbabilityMeasure (wilsonBlockGibbsMeasure wilsonHaarReference
      beta plaquettes block outside) := by
  letI := wilsonHaarReference_isProbability (N := N) (L := L)
  exact wilsonBlockGibbs_isProbability_borel wilsonHaarReference beta hbeta
    plaquettes block outside


/-- Actual block update: sample the Wilson conditional measure, then replace
only the selected links. Measurability in the exterior parameter, needed to
bundle this family as a Markov kernel, is not asserted here. -/
noncomputable def wilsonBlockUpdateMeasure [Fintype P] [DecidableEq L]
    (beta : Real) (plaquettes : P → Fin 4 → L) (block : Finset L)
    (outside : L → Matrix.specialUnitaryGroup N Complex) :
    Measure (L → Matrix.specialUnitaryGroup N Complex) :=
  (wilsonBlockGibbsMeasure wilsonHaarReference beta plaquettes block outside).map
    (blockConfiguration block outside)

theorem wilsonBlockUpdate_isProbability [Nonempty N] [Fintype P] [DecidableEq L]
    (beta : Real) (hbeta : 0 ≤ beta) (plaquettes : P → Fin 4 → L)
    (block : Finset L) (outside : L → Matrix.specialUnitaryGroup N Complex) :
    IsProbabilityMeasure (wilsonBlockUpdateMeasure beta plaquettes block outside) := by
  letI := wilsonBlockGibbs_haar_isProbability beta hbeta plaquettes block outside
  have hm : Measurable (blockConfiguration block outside) :=
    ((blockConfiguration_joint_continuous block).comp
      (continuous_const.prodMk continuous_id)).measurable
  constructor
  rw [wilsonBlockUpdateMeasure, Measure.map_apply hm MeasurableSet.univ]
  simp

/-- Every link outside the updated block equals its original value with
probability one under the constructed update measure. -/
theorem wilsonBlockUpdate_preserves_exterior [Nonempty N] [Fintype P] [DecidableEq L]
    (beta : Real) (hbeta : 0 ≤ beta) (plaquettes : P → Fin 4 → L)
    (block : Finset L) (outside : L → Matrix.specialUnitaryGroup N Complex)
    (j : L) (hj : j ∉ block) :
    wilsonBlockUpdateMeasure beta plaquettes block outside {U | U j = outside j} = 1 := by
  letI := wilsonBlockGibbs_haar_isProbability beta hbeta plaquettes block outside
  have hm : Measurable (blockConfiguration block outside) :=
    ((blockConfiguration_joint_continuous block).comp
      (continuous_const.prodMk continuous_id)).measurable
  have hs : MeasurableSet {U : L → Matrix.specialUnitaryGroup N Complex | U j = outside j} :=
    (isClosed_eq (continuous_apply j) continuous_const).measurableSet
  rw [wilsonBlockUpdateMeasure, Measure.map_apply hm hs]
  have he : (blockConfiguration block outside) ⁻¹' {U | U j = outside j} = Set.univ := by
    ext U
    simp [blockConfiguration, hj]
  rw [he, measure_univ]

/-- Joint measurability of the normalized conditional density, including
the dependence of its partition function on the exterior configuration. -/
theorem wilsonBlockDensity_joint_measurable [Nonempty N] [Finite L]
    [Fintype P] [DecidableEq L] (beta : Real)
    (plaquettes : P → Fin 4 → L) (block : Finset L) :
    Measurable (fun q : (L → Matrix.specialUnitaryGroup N Complex) ×
      (L → Matrix.specialUnitaryGroup N Complex) =>
      gibbsDensity wilsonHaarReference
        (fun z => finiteWilsonMagneticPotential beta plaquettes
          (blockConfiguration block q.1 z)) q.2) := by
  letI : SecondCountableTopology (Matrix N N Complex) := by
    change SecondCountableTopology (N → N → Complex)
    infer_instance
  letI : SecondCountableTopology (Matrix.specialUnitaryGroup N Complex) :=
    TopologicalSpace.Subtype.secondCountableTopology
      (Matrix.specialUnitaryGroup N Complex : Set (Matrix N N Complex))
  letI := wilsonHaarReference_isProbability (N := N) (L := L)
  have hw := (wilsonBlockAction_joint_continuous (N := N) beta plaquettes block).measurable.neg.exp
  have hz := hw.stronglyMeasurable.integral_prod_right'
    (ν := wilsonHaarReference (N := N) (L := L))
  exact hw.div (hz.measurable.comp measurable_fst)

/-- The concrete update probabilities vary measurably with the starting
configuration. Finite link sets supply the standard product Borel structure. -/
theorem wilsonBlockUpdate_measurable [Nonempty N] [Finite L]
    [Fintype P] [DecidableEq L] (beta : Real)
    (plaquettes : P → Fin 4 → L) (block : Finset L) :
    Measurable (wilsonBlockUpdateMeasure (N := N) beta plaquettes block) := by
  letI : SecondCountableTopology (Matrix N N Complex) := by
    change SecondCountableTopology (N → N → Complex)
    infer_instance
  letI : SecondCountableTopology (Matrix.specialUnitaryGroup N Complex) :=
    TopologicalSpace.Subtype.secondCountableTopology
      (Matrix.specialUnitaryGroup N Complex : Set (Matrix N N Complex))
  letI := wilsonHaarReference_isProbability (N := N) (L := L)
  apply Measure.measurable_of_measurable_coe
  intro s hs
  have hm := (blockConfiguration_joint_continuous (N := N)
    block).measurable
  have hd := (wilsonBlockDensity_joint_measurable (N := N) beta plaquettes block).ennreal_ofReal
  have hi := (hd.indicator (hm hs)).lintegral_prod_right'
    (ν := wilsonHaarReference (N := N) (L := L))
  convert hi using 1
  ext outside
  have ho : Measurable (blockConfiguration block outside) :=
    hm.comp (measurable_const.prodMk measurable_id)
  rw [wilsonBlockUpdateMeasure, Measure.map_apply ho hs]
  change (wilsonHaarReference.withDensity _) _ = _
  rw [withDensity_apply _ (ho hs), ← lintegral_indicator (ho hs)]
  rfl

/-- Wilson equilibrium block resampling as an actual measurable kernel.
Identification with physical Hamiltonian evolution is a separate obligation. -/
noncomputable def wilsonBlockKernel [Nonempty N] [Finite L]
    [Fintype P] [DecidableEq L] (beta : Real)
    (plaquettes : P → Fin 4 → L) (block : Finset L) :
    ProbabilityTheory.Kernel (L → Matrix.specialUnitaryGroup N Complex)
      (L → Matrix.specialUnitaryGroup N Complex) where
  toFun := wilsonBlockUpdateMeasure beta plaquettes block
  measurable' := wilsonBlockUpdate_measurable beta plaquettes block

theorem wilsonBlockKernel_isMarkov [Nonempty N] [Finite L]
    [Fintype P] [DecidableEq L] (beta : Real) (hbeta : 0 ≤ beta)
    (plaquettes : P → Fin 4 → L) (block : Finset L) :
    ProbabilityTheory.IsMarkovKernel (wilsonBlockKernel (N := N) beta plaquettes block) :=
  ⟨fun outside => wilsonBlockUpdate_isProbability beta hbeta plaquettes block outside⟩

/-- Exchange the selected links between two configurations. This involution
is the change of variables underlying conditional Gibbs detailed balance. -/
def blockExchange {J G : Type*} [DecidableEq J] (block : Finset J)
    (q : (J → G) × (J → G)) : (J → G) × (J → G) :=
  (blockConfiguration block q.1 q.2, blockConfiguration block q.2 q.1)

theorem blockExchange_involutive {J G : Type*} [DecidableEq J] (block : Finset J) :
    Function.Involutive (blockExchange (G := G) block) := by
  intro q
  apply Prod.ext <;> funext j <;>
    by_cases hj : j ∈ block <;> simp [blockExchange, blockConfiguration, hj]

def blockExchangeHom {J G : Type*} [DecidableEq J] [Group G] (block : Finset J) :
    ((J → G) × (J → G)) →* ((J → G) × (J → G)) where
  toFun := blockExchange block
  map_one' := by
    apply Prod.ext <;> funext j <;>
      by_cases hj : j ∈ block <;> simp [blockExchange, blockConfiguration, hj]
  map_mul' q r := by
    apply Prod.ext <;> funext j <;>
      by_cases hj : j ∈ block <;> simp [blockExchange, blockConfiguration, hj]

/-- Exchanging a block between two independent Haar configurations preserves
their joint reference measure; no product-coordinate independence is assumed. -/
theorem wilsonBlockExchange_measurePreserving [Finite L] [DecidableEq L]
    (block : Finset L) :
    MeasurePreserving (blockExchange block)
      ((wilsonHaarReference (N := N) (L := L)).prod wilsonHaarReference)
      (wilsonHaarReference.prod wilsonHaarReference) := by
  letI : SecondCountableTopology (Matrix N N Complex) := by
    change SecondCountableTopology (N → N → Complex)
    infer_instance
  letI : SecondCountableTopology (Matrix.specialUnitaryGroup N Complex) :=
    TopologicalSpace.Subtype.secondCountableTopology
      (Matrix.specialUnitaryGroup N Complex : Set (Matrix N N Complex))
  letI := specialUnitary_compactSpace (N := N)
  letI := specialUnitary_isTopologicalGroup (N := N)
  letI := wilsonHaarReference_isProbability (N := N) (L := L)
  letI := wilsonHaarReference_isHaar (N := N) (L := L)
  letI : MeasurableMul (L → Matrix.specialUnitaryGroup N Complex) :=
    ⟨fun c => (continuous_const_mul c).measurable,
      fun c => (continuous_mul_const c).measurable⟩
  have hc : Continuous (blockExchangeHom (G := Matrix.specialUnitaryGroup N Complex) block) :=
    (blockConfiguration_joint_continuous block).prodMk
      ((blockConfiguration_joint_continuous block).comp continuous_swap)
  exact MonoidHom.measurePreserving hc (blockExchange_involutive block).surjective rfl

/-- Replacing links in the block leaves every subsequent block replacement
unchanged. Thus the conditional action depends only on exterior links. -/
theorem blockConfiguration_replace_twice {J G : Type*} [DecidableEq J]
    (block : Finset J) (outside inside z : J → G) :
    blockConfiguration block (blockConfiguration block outside inside) z =
      blockConfiguration block outside z := by
  funext j
  by_cases hj : j ∈ block <;> simp [blockConfiguration, hj]

theorem wilsonBlockPartition_replace [Nonempty N] [Fintype P] [DecidableEq L]
    (beta : Real) (plaquettes : P → Fin 4 → L) (block : Finset L)
    (outside inside : L → Matrix.specialUnitaryGroup N Complex) :
    gibbsPartition wilsonHaarReference (fun z => finiteWilsonMagneticPotential beta plaquettes
      (blockConfiguration block (blockConfiguration block outside inside) z)) =
    gibbsPartition wilsonHaarReference (fun z => finiteWilsonMagneticPotential beta plaquettes
      (blockConfiguration block outside z)) := by
  simp only [blockConfiguration_replace_twice]

/-- The equilibrium two-configuration weight is invariant under block
exchange. Together with Haar exchange invariance this supplies the concrete
change of variables for detailed balance, rather than assuming reversibility. -/
theorem wilsonBlockExchange_weight [Nonempty N] [Fintype P] [DecidableEq L]
    (beta : Real) (plaquettes : P → Fin 4 → L) (block : Finset L)
    (q : (L → Matrix.specialUnitaryGroup N Complex) ×
      (L → Matrix.specialUnitaryGroup N Complex)) :
    Real.exp (-finiteWilsonMagneticPotential beta plaquettes (blockExchange block q).1) *
      gibbsDensity wilsonHaarReference
        (fun z => finiteWilsonMagneticPotential beta plaquettes
          (blockConfiguration block (blockExchange block q).1 z)) (blockExchange block q).2 =
    Real.exp (-finiteWilsonMagneticPotential beta plaquettes q.1) *
      gibbsDensity wilsonHaarReference
        (fun z => finiteWilsonMagneticPotential beta plaquettes
          (blockConfiguration block q.1 z)) q.2 := by
  have hswap := congrArg Prod.fst (blockExchange_involutive block q)
  change blockConfiguration block (blockExchange block q).1 (blockExchange block q).2 = q.1
    at hswap
  unfold gibbsDensity
  dsimp only
  rw [hswap]
  change _ * (_ / gibbsPartition wilsonHaarReference
    (fun z => finiteWilsonMagneticPotential beta plaquettes
      (blockConfiguration block (blockConfiguration block q.1 q.2) z))) = _
  rw [wilsonBlockPartition_replace]
  dsimp only [blockExchange]
  ring

/-- Integrated exchange identity for arbitrary nonnegative measurable
observables of the old and updated configurations. This is the unnormalized
detailed-balance identity obtained from the explicit Wilson density. -/
theorem wilsonBlockExchange_integral [Nonempty N] [Finite L]
    [Fintype P] [DecidableEq L] (beta : Real)
    (plaquettes : P → Fin 4 → L) (block : Finset L)
    (F : ((L → Matrix.specialUnitaryGroup N Complex) ×
      (L → Matrix.specialUnitaryGroup N Complex)) → ENNReal)
    (hF : Measurable F) :
    (∫⁻ q, ENNReal.ofReal
      (Real.exp (-finiteWilsonMagneticPotential beta plaquettes q.1) *
        gibbsDensity wilsonHaarReference
          (fun z => finiteWilsonMagneticPotential beta plaquettes
            (blockConfiguration block q.1 z)) q.2) *
      F (q.1, blockConfiguration block q.1 q.2)
      ∂((wilsonHaarReference (N := N) (L := L)).prod wilsonHaarReference)) =
    ∫⁻ q, ENNReal.ofReal
      (Real.exp (-finiteWilsonMagneticPotential beta plaquettes q.1) *
        gibbsDensity wilsonHaarReference
          (fun z => finiteWilsonMagneticPotential beta plaquettes
            (blockConfiguration block q.1 z)) q.2) *
      F (blockConfiguration block q.1 q.2, q.1)
      ∂((wilsonHaarReference (N := N) (L := L)).prod wilsonHaarReference) := by
  letI : SecondCountableTopology (Matrix N N Complex) := by
    change SecondCountableTopology (N → N → Complex)
    infer_instance
  letI : SecondCountableTopology (Matrix.specialUnitaryGroup N Complex) :=
    TopologicalSpace.Subtype.secondCountableTopology
      (Matrix.specialUnitaryGroup N Complex : Set (Matrix N N Complex))
  have ha := (finiteWilsonMagneticPotential_continuous (N := N) beta plaquettes).measurable
  have hw := (ha.comp measurable_fst).neg.exp.mul
      (wilsonBlockDensity_joint_measurable (N := N) beta plaquettes block)
  have hf := hF.comp (measurable_fst.prodMk
    (blockConfiguration_joint_continuous (N := N) block).measurable)
  have he := (wilsonBlockExchange_measurePreserving (N := N) block).lintegral_comp
    (hw.ennreal_ofReal.mul hf)
  simp only [Function.comp_apply] at he
  rw [← he]
  apply lintegral_congr
  intro q
  rw [wilsonBlockExchange_weight]
  have hswap := congrArg Prod.fst (blockExchange_involutive block q)
  change blockConfiguration block (blockExchange block q).1 (blockExchange block q).2 = q.1
    at hswap
  rw [hswap]
  rfl

/-- Integrating the concrete block update is exactly conditional-density
integration followed by replacement of the selected coordinates. -/
theorem wilsonBlockUpdate_lintegral [Nonempty N] [Finite L]
    [Fintype P] [DecidableEq L] (beta : Real)
    (plaquettes : P → Fin 4 → L) (block : Finset L)
    (outside : L → Matrix.specialUnitaryGroup N Complex)
    (f : (L → Matrix.specialUnitaryGroup N Complex) → ENNReal) (hf : Measurable f) :
    (∫⁻ U, f U ∂wilsonBlockUpdateMeasure beta plaquettes block outside) =
    ∫⁻ z, ENNReal.ofReal (gibbsDensity wilsonHaarReference
      (fun z => finiteWilsonMagneticPotential beta plaquettes
        (blockConfiguration block outside z)) z) *
      f (blockConfiguration block outside z) ∂wilsonHaarReference := by
  have hm : Measurable (blockConfiguration block outside) :=
    ((blockConfiguration_joint_continuous block).comp
      (continuous_const.prodMk continuous_id)).measurable
  have hd : Measurable (gibbsDensity wilsonHaarReference
      (fun z => finiteWilsonMagneticPotential beta plaquettes
        (blockConfiguration block outside z))) :=
    (wilsonBlockAction_measurable beta plaquettes block outside).neg.exp.div_const _
  rw [wilsonBlockUpdateMeasure, lintegral_map hf hm]
  unfold wilsonBlockGibbsMeasure gibbsMeasure
  exact lintegral_withDensity_eq_lintegral_mul _ hd.ennreal_ofReal (hf.comp hm)

/-- The joint equilibrium/update expectation has the explicit product-Haar
density. This connects the change-of-variables proof to the bundled kernel
and the normalized full Wilson Gibbs measure. -/
theorem wilsonBlockKernel_equilibrium_pair_integral [Nonempty N] [Finite L]
    [Fintype P] [DecidableEq L] (beta : Real) (hbeta : 0 ≤ beta)
    (plaquettes : P → Fin 4 → L) (block : Finset L)
    (F : ((L → Matrix.specialUnitaryGroup N Complex) ×
      (L → Matrix.specialUnitaryGroup N Complex)) → ENNReal)
    (hF : Measurable F) :
    (∫⁻ x, ∫⁻ y, F (x, y) ∂wilsonBlockKernel beta plaquettes block x
      ∂gibbsMeasure wilsonHaarReference (finiteWilsonMagneticPotential beta plaquettes)) =
    ∫⁻ q, ENNReal.ofReal
      (gibbsDensity wilsonHaarReference (finiteWilsonMagneticPotential beta plaquettes) q.1) *
      (ENNReal.ofReal (gibbsDensity wilsonHaarReference
        (fun z => finiteWilsonMagneticPotential beta plaquettes
          (blockConfiguration block q.1 z)) q.2) *
        F (q.1, blockConfiguration block q.1 q.2))
      ∂((wilsonHaarReference (N := N) (L := L)).prod wilsonHaarReference) := by
  letI : SecondCountableTopology (Matrix N N Complex) := by
    change SecondCountableTopology (N → N → Complex)
    infer_instance
  letI : SecondCountableTopology (Matrix.specialUnitaryGroup N Complex) :=
    TopologicalSpace.Subtype.secondCountableTopology
      (Matrix.specialUnitaryGroup N Complex : Set (Matrix N N Complex))
  letI := wilsonHaarReference_isProbability (N := N) (L := L)
  letI := wilsonBlockKernel_isMarkov (N := N) beta hbeta plaquettes block
  have hd : Measurable (gibbsDensity wilsonHaarReference
      (finiteWilsonMagneticPotential (N := N) beta plaquettes)) :=
    (finiteWilsonMagneticPotential_continuous beta plaquettes).measurable.neg.exp.div_const _
  have hi := hF.lintegral_kernel_prod_right'
    (κ := wilsonBlockKernel (N := N) beta plaquettes block)
  have hj := (wilsonBlockDensity_joint_measurable (N := N) beta plaquettes block).ennreal_ofReal.mul
    (hF.comp (measurable_fst.prodMk
      (blockConfiguration_joint_continuous (N := N) block).measurable))
  rw [gibbsMeasure, lintegral_withDensity_eq_lintegral_mul _ hd.ennreal_ofReal hi]
  have hp := lintegral_prod _ ((hd.ennreal_ofReal.comp measurable_fst).mul hj).aemeasurable
    (μ := wilsonHaarReference) (ν := wilsonHaarReference)
  simp only [Function.comp_apply] at hp
  rw [hp]
  apply lintegral_congr
  intro x
  change ENNReal.ofReal (gibbsDensity _ _ x) *
    (∫⁻ y, F (x, y) ∂wilsonBlockUpdateMeasure beta plaquettes block x) = _
  rw [wilsonBlockUpdate_lintegral beta plaquettes block x (fun y => F (x, y))
    (hF.comp (measurable_const.prodMk measurable_id))]
  exact (lintegral_const_mul _ (hj.comp (measurable_const.prodMk measurable_id))).symm

/-- Normalizing the full Gibbs density preserves the block-exchange identity. -/
theorem wilsonBlockExchange_normalized_weight [Nonempty N] [Fintype P] [DecidableEq L]
    (beta : Real) (plaquettes : P → Fin 4 → L) (block : Finset L)
    (q : (L → Matrix.specialUnitaryGroup N Complex) ×
      (L → Matrix.specialUnitaryGroup N Complex)) :
    gibbsDensity wilsonHaarReference (finiteWilsonMagneticPotential beta plaquettes)
        (blockExchange block q).1 *
      gibbsDensity wilsonHaarReference
        (fun z => finiteWilsonMagneticPotential beta plaquettes
          (blockConfiguration block (blockExchange block q).1 z)) (blockExchange block q).2 =
    gibbsDensity wilsonHaarReference (finiteWilsonMagneticPotential beta plaquettes) q.1 *
      gibbsDensity wilsonHaarReference
        (fun z => finiteWilsonMagneticPotential beta plaquettes
          (blockConfiguration block q.1 z)) q.2 := by
  have h := congrArg
    (fun t : Real => t / gibbsPartition (wilsonHaarReference (N := N))
      (finiteWilsonMagneticPotential beta plaquettes))
    (wilsonBlockExchange_weight beta plaquettes block q)
  simp only [gibbsDensity] at *
  simpa only [div_mul_eq_mul_div] using h

/-- Detailed balance for the constructed kernel and normalized full Wilson
Gibbs measure, tested against every nonnegative measurable pair observable. -/
theorem wilsonBlockKernel_detailedBalance [Nonempty N] [Finite L]
    [Fintype P] [DecidableEq L] (beta : Real) (hbeta : 0 ≤ beta)
    (plaquettes : P → Fin 4 → L) (block : Finset L)
    (F : ((L → Matrix.specialUnitaryGroup N Complex) ×
      (L → Matrix.specialUnitaryGroup N Complex)) → ENNReal)
    (hF : Measurable F) :
    (∫⁻ x, ∫⁻ y, F (x, y) ∂wilsonBlockKernel beta plaquettes block x
      ∂gibbsMeasure wilsonHaarReference (finiteWilsonMagneticPotential beta plaquettes)) =
    ∫⁻ x, ∫⁻ y, F (y, x) ∂wilsonBlockKernel beta plaquettes block x
      ∂gibbsMeasure wilsonHaarReference (finiteWilsonMagneticPotential beta plaquettes) := by
  letI : SecondCountableTopology (Matrix N N Complex) := by
    change SecondCountableTopology (N → N → Complex)
    infer_instance
  letI : SecondCountableTopology (Matrix.specialUnitaryGroup N Complex) :=
    TopologicalSpace.Subtype.secondCountableTopology
      (Matrix.specialUnitaryGroup N Complex : Set (Matrix N N Complex))
  rw [wilsonBlockKernel_equilibrium_pair_integral beta hbeta plaquettes block F hF]
  have hs := wilsonBlockKernel_equilibrium_pair_integral beta hbeta plaquettes block
    (fun q => F q.swap) (hF.comp measurable_swap)
  simp only [Prod.swap_prod_mk] at hs
  rw [hs]
  have hg : Measurable (gibbsDensity wilsonHaarReference
      (finiteWilsonMagneticPotential (N := N) beta plaquettes)) :=
    (finiteWilsonMagneticPotential_continuous beta plaquettes).measurable.neg.exp.div_const _
  have hd := (wilsonBlockDensity_joint_measurable (N := N) beta plaquettes block).ennreal_ofReal
  have hf := hF.comp (measurable_fst.prodMk
    (blockConfiguration_joint_continuous (N := N) block).measurable)
  have hm := (hg.ennreal_ofReal.comp measurable_fst).mul (hd.mul hf)
  have he := (wilsonBlockExchange_measurePreserving (N := N) block).lintegral_comp hm
  simp only [Function.comp_apply] at he
  rw [← he]
  apply lintegral_congr
  intro q
  have hnonneg (x : L → Matrix.specialUnitaryGroup N Complex) :
      0 ≤ gibbsDensity wilsonHaarReference (finiteWilsonMagneticPotential beta plaquettes) x :=
    div_nonneg (Real.exp_pos _).le (integral_nonneg fun _ => (Real.exp_pos _).le)
  rw [← mul_assoc, ← ENNReal.ofReal_mul (hnonneg _),
    wilsonBlockExchange_normalized_weight, ENNReal.ofReal_mul (hnonneg _), mul_assoc]
  have hswap := congrArg Prod.fst (blockExchange_involutive block q)
  change blockConfiguration block (blockExchange block q).1 (blockExchange block q).2 = q.1
    at hswap
  rw [hswap]
  rfl

/-- The normalized full Wilson Gibbs measure is invariant under the actual
block-update kernel, expressed for all nonnegative measurable observables. -/
theorem wilsonBlockKernel_gibbs_invariant [Nonempty N] [Finite L]
    [Fintype P] [DecidableEq L] (beta : Real) (hbeta : 0 ≤ beta)
    (plaquettes : P → Fin 4 → L) (block : Finset L)
    (f : (L → Matrix.specialUnitaryGroup N Complex) → ENNReal) (hf : Measurable f) :
    (∫⁻ x, ∫⁻ y, f y ∂wilsonBlockKernel beta plaquettes block x
      ∂gibbsMeasure wilsonHaarReference (finiteWilsonMagneticPotential beta plaquettes)) =
    ∫⁻ x, f x
      ∂gibbsMeasure wilsonHaarReference (finiteWilsonMagneticPotential beta plaquettes) := by
  letI := wilsonBlockKernel_isMarkov (N := N) beta hbeta plaquettes block
  have h := wilsonBlockKernel_detailedBalance beta hbeta plaquettes block
    (fun q => f q.2) (hf.comp measurable_snd)
  simpa using h

/-- Explicit comparison of Wilson block resampling against Haar block
resampling for every nonnegative observable. The constant depends on block
size and local plaquette incidence, not total lattice volume. -/
theorem wilsonBlockUpdate_haar_comparison [Nonempty N] [Finite L]
    [Fintype P] [DecidableEq L] (beta : Real) (hbeta : 0 ≤ beta)
    (plaquettes : P → Fin 4 → L) (block : Finset L) (D : Nat)
    (hDegree : ∀ j ∈ block,
      (Finset.univ.filter (fun p => j ∈ Finset.univ.image (plaquettes p))).card ≤ D)
    (outside : L → Matrix.specialUnitaryGroup N Complex)
    (f : (L → Matrix.specialUnitaryGroup N Complex) → ENNReal) (hf : Measurable f) :
    ENNReal.ofReal (Real.exp (-((block.card : Real) * D * (2 * beta)))) *
        (∫⁻ z, f (blockConfiguration block outside z) ∂wilsonHaarReference) ≤
      (∫⁻ y, f y ∂wilsonBlockUpdateMeasure beta plaquettes block outside) ∧
    (∫⁻ y, f y ∂wilsonBlockUpdateMeasure beta plaquettes block outside) ≤
      ENNReal.ofReal (Real.exp ((block.card : Real) * D * (2 * beta))) *
        (∫⁻ z, f (blockConfiguration block outside z) ∂wilsonHaarReference) := by
  letI := wilsonHaarReference_isProbability (N := N) (L := L)
  have hm : Measurable (blockConfiguration block outside) :=
    ((blockConfiguration_joint_continuous block).comp
      (continuous_const.prodMk continuous_id)).measurable
  have hfm : Measurable (fun z => f (blockConfiguration block outside z)) := hf.comp hm
  have hb := wilsonBlockGibbs_density_bounds wilsonHaarReference beta hbeta plaquettes
    block D hDegree outside
  rw [wilsonBlockUpdate_lintegral beta plaquettes block outside f hf]
  constructor
  · rw [← lintegral_const_mul _ hfm]
    apply lintegral_mono
    intro z
    exact mul_le_mul_left (ENNReal.ofReal_le_ofReal
      (hb z (wilsonBlockAction_measurable beta plaquettes block outside)).1) _
  · rw [← lintegral_const_mul _ hfm]
    apply lintegral_mono
    intro z
    exact mul_le_mul_left (ENNReal.ofReal_le_ofReal
      (hb z (wilsonBlockAction_measurable beta plaquettes block outside)).2) _

/-- The same local constants compare squared jumps of an observable, the
integrand entering the reversible block-resampling Dirichlet form.
This is not yet a comparison with the differential electric Casimir energy. -/
theorem wilsonBlockUpdate_squared_jump_comparison [Nonempty N] [Finite L]
    [Fintype P] [DecidableEq L] (beta : Real) (hbeta : 0 ≤ beta)
    (plaquettes : P → Fin 4 → L) (block : Finset L) (D : Nat)
    (hDegree : ∀ j ∈ block,
      (Finset.univ.filter (fun p => j ∈ Finset.univ.image (plaquettes p))).card ≤ D)
    (outside : L → Matrix.specialUnitaryGroup N Complex)
    (f : (L → Matrix.specialUnitaryGroup N Complex) → Real) (hf : Measurable f) :
    ENNReal.ofReal (Real.exp (-((block.card : Real) * D * (2 * beta)))) *
        (∫⁻ z, ENNReal.ofReal ((f outside - f (blockConfiguration block outside z)) ^ 2)
          ∂wilsonHaarReference) ≤
      (∫⁻ y, ENNReal.ofReal ((f outside - f y) ^ 2)
        ∂wilsonBlockUpdateMeasure beta plaquettes block outside) ∧
    (∫⁻ y, ENNReal.ofReal ((f outside - f y) ^ 2)
        ∂wilsonBlockUpdateMeasure beta plaquettes block outside) ≤
      ENNReal.ofReal (Real.exp ((block.card : Real) * D * (2 * beta))) *
        (∫⁻ z, ENNReal.ofReal ((f outside - f (blockConfiguration block outside z)) ^ 2)
          ∂wilsonHaarReference) :=
  wilsonBlockUpdate_haar_comparison beta hbeta plaquettes block D hDegree outside
    (fun y => ENNReal.ofReal ((f outside - f y) ^ 2))
    ((measurable_const.sub hf).pow_const 2).ennreal_ofReal

/-- Radial differential expression in the trace coordinate x = cos(omega/2):
-kappa ((1-x^2) f'' - 3 x f') + beta (1-x) f.
This is the class-function expression suggested by Eq. (79) of
https://doi.org/10.1103/PhysRevD.109.074501, absorbing the positive electric
prefactor into kappa. Its geometric identification with the SU(2) Casimir
and the self-adjoint domain are NOT formalized by this definition. -/
noncomputable def wilsonRadialExpression (kappa beta : Real) (f : Real → Real) (x : Real) :
    Real :=
  -kappa * ((1 - x ^ 2) * deriv (deriv f) x - 3 * x * deriv f x) +
    beta * (1 - x) * f x

/-- Exact residual on an exponential trial amplitude. The square root of
the Wilson density is proportional to exp((beta/2) x). The residual must be
controlled in any ground-state-transform comparison with physical energy. -/
theorem wilsonRadialExpression_exp (kappa beta a x : Real) :
    wilsonRadialExpression kappa beta (fun t => Real.exp (a * t)) x =
      (beta + (3 * kappa * a - beta) * x - kappa * a ^ 2 * (1 - x ^ 2)) *
        Real.exp (a * x) := by
  have hd (t : Real) :
      HasDerivAt (fun u => Real.exp (a * u)) (a * Real.exp (a * t)) t := by
    convert ((hasDerivAt_id t).const_mul a).exp using 1; simp [mul_comm]
  have h1 : deriv (fun t => Real.exp (a * t)) = fun t => a * Real.exp (a * t) :=
    funext fun t => (hd t).deriv
  have h2 : deriv (deriv (fun t => Real.exp (a * t))) x = a ^ 2 * Real.exp (a * x) := by
    rw [h1]
    convert ((hd x).const_mul a).deriv using 1; ring
  unfold wilsonRadialExpression
  rw [h2, h1]
  ring

/-- With positive electric coefficient, a nonconstant exponential amplitude
is not an eigenfunction of this radial expression, even in the interior.
This checks the differential expression only, not its geometric realization. -/
theorem wilsonRadialExpression_exp_not_eigen (kappa beta a : Real)
    (hk : 0 < kappa) (ha : a ≠ 0) :
    ¬ ∃ E : Real, ∀ x ∈ Set.Ioo (-1 : Real) 1,
      wilsonRadialExpression kappa beta (fun t => Real.exp (a * t)) x =
        E * Real.exp (a * x) := by
  rintro ⟨E, hE⟩
  have hp (x : Real) (hx : x ∈ Set.Ioo (-1 : Real) 1) :
      beta + (3 * kappa * a - beta) * x - kappa * a ^ 2 * (1 - x ^ 2) = E := by
    have h := hE x hx
    rw [wilsonRadialExpression_exp] at h
    exact mul_right_cancel₀ (ne_of_gt (Real.exp_pos _)) h
  have h0 := hp 0 (by constructor <;> norm_num)
  have hplus := hp (1 / 2) (by constructor <;> norm_num)
  have hminus := hp (-1 / 2) (by constructor <;> norm_num)
  have hpos := mul_pos hk (sq_pos_of_ne_zero ha)
  nlinarith only [h0, hplus, hminus, hpos]

/-- Exact exponential transformation of the radial differential expression.
The derivative premises specify ordinary C2 test data; no energy comparison,
eigenfunction identity, or spectral gap is assumed. The residual potential
remains explicit and must be included in a later quadratic-form comparison. -/
theorem wilsonRadialExpression_exp_transform (kappa beta a x : Real)
    (f f1 f2 : Real → Real)
    (hf : ∀ t, HasDerivAt f (f1 t) t)
    (hf1 : HasDerivAt f1 (f2 x) x) :
    wilsonRadialExpression kappa beta (fun t => Real.exp (a * t) * f t) x =
      Real.exp (a * x) *
        (-kappa * ((1 - x ^ 2) * f2 x +
            (2 * a * (1 - x ^ 2) - 3 * x) * f1 x) +
          (beta + (3 * kappa * a - beta) * x -
            kappa * a ^ 2 * (1 - x ^ 2)) * f x) := by
  have he (t : Real) :
      HasDerivAt (fun u => Real.exp (a * u)) (a * Real.exp (a * t)) t := by
    convert ((hasDerivAt_id t).const_mul a).exp using 1; simp [mul_comm]
  have hd : deriv (fun t => Real.exp (a * t) * f t) =
      fun t => a * Real.exp (a * t) * f t + Real.exp (a * t) * f1 t :=
    funext fun t => ((he t).mul (hf t)).deriv
  have hdd : deriv (deriv (fun t => Real.exp (a * t) * f t)) x =
      a ^ 2 * Real.exp (a * x) * f x +
        2 * a * Real.exp (a * x) * f1 x + Real.exp (a * x) * f2 x := by
    rw [hd]
    convert ((((he x).const_mul a).mul (hf x)).add ((he x).mul hf1)).deriv using 1
    ring
  unfold wilsonRadialExpression
  rw [hdd, hd]
  ring

/-- Explicit lower and upper bounds for the residual potential on the trace
coordinate interval. The electric coefficient is nonnegative; no restriction
on the magnetic coefficient or exponential tilt is needed for this estimate. -/
theorem wilsonRadial_residual_bounds (kappa beta a x : Real)
    (hk : 0 ≤ kappa) (hx : x ∈ Set.Icc (-1 : Real) 1) :
    beta - |3 * kappa * a - beta| - kappa * a ^ 2 ≤
      beta + (3 * kappa * a - beta) * x - kappa * a ^ 2 * (1 - x ^ 2) ∧
    beta + (3 * kappa * a - beta) * x - kappa * a ^ 2 * (1 - x ^ 2) ≤
      beta + |3 * kappa * a - beta| := by
  have hxabs : |x| ≤ 1 := abs_le.mpr hx
  have hlin : |(3 * kappa * a - beta) * x| ≤ |3 * kappa * a - beta| := by
    rw [abs_mul]
    nlinarith only [hxabs, abs_nonneg (3 * kappa * a - beta)]
  have hlinlo := (abs_le.mp hlin).1
  have hlinhi := (abs_le.mp hlin).2
  have hx2 : x ^ 2 ≤ 1 := by nlinarith [hx.1, hx.2]
  have hka : 0 ≤ kappa * a ^ 2 := mul_nonneg hk (sq_nonneg a)
  constructor <;> nlinarith [sq_nonneg x]

/-- Unnormalized radial Haar density after the exponential tilt. -/
noncomputable def wilsonRadialWeight (a x : Real) : Real :=
  Real.exp (2 * a * x) * Real.sqrt (1 - x ^ 2)

/-- Diffusion coefficient times the tilted radial Haar density. -/
noncomputable def wilsonRadialFluxWeight (a x : Real) : Real :=
  (1 - x ^ 2) * wilsonRadialWeight a x

/-- The derivative of the explicit Haar-weighted flux supplies precisely
the first-order coefficient of the transformed radial expression. -/
theorem wilsonRadialFluxWeight_hasDerivAt (a x : Real)
    (hx : x ∈ Set.Ioo (-1 : Real) 1) :
    HasDerivAt (wilsonRadialFluxWeight a)
      (wilsonRadialWeight a x * (2 * a * (1 - x ^ 2) - 3 * x)) x := by
  have hqpos : 0 < 1 - x ^ 2 := by nlinarith [hx.1, hx.2]
  have hq : HasDerivAt (fun t : Real => 1 - t ^ 2) (-2 * x) x := by
    convert (hasDerivAt_const x (1 : Real)).sub ((hasDerivAt_id x).pow 2) using 1; simp
  have hs := hq.sqrt (ne_of_gt hqpos)
  have he : HasDerivAt (fun t : Real => Real.exp (2 * a * t))
      (2 * a * Real.exp (2 * a * x)) x := by
    convert ((hasDerivAt_id x).const_mul (2 * a)).exp using 1; simp [mul_comm]
  have hp := hq.mul (he.mul hs)
  have hspos := Real.sqrt_pos.mpr hqpos
  have hsq := Real.sq_sqrt (le_of_lt hqpos)
  convert hp using 1
  dsimp [wilsonRadialWeight]
  field_simp [ne_of_gt hspos]
  rw [hsq]
  ring

/-- Local quadratic-form identity with the full Haar-weighted boundary flux.
Integration and endpoint/domain conditions remain separate obligations. -/
theorem wilsonRadial_weighted_energy_identity (kappa beta a x : Real)
    (f f1 f2 : Real → Real) (hx : x ∈ Set.Ioo (-1 : Real) 1)
    (hf : ∀ t, HasDerivAt f (f1 t) t) (hf1 : HasDerivAt f1 (f2 x) x) :
    Real.sqrt (1 - x ^ 2) * (Real.exp (a * x) * f x) *
        wilsonRadialExpression kappa beta (fun t => Real.exp (a * t) * f t) x =
      kappa * wilsonRadialFluxWeight a x * (f1 x) ^ 2 +
        (beta + (3 * kappa * a - beta) * x - kappa * a ^ 2 * (1 - x ^ 2)) *
          wilsonRadialWeight a x * (f x) ^ 2 -
        kappa * deriv (fun t => wilsonRadialFluxWeight a t * f t * f1 t) x := by
  have hb := (((wilsonRadialFluxWeight_hasDerivAt a x hx).mul (hf x)).mul hf1).deriv
  change deriv (fun t => wilsonRadialFluxWeight a t * f t * f1 t) x = _ at hb
  simp only [Pi.mul_apply] at hb
  rw [hb, wilsonRadialExpression_exp_transform kappa beta a x f f1 f2 hf hf1]
  have he : Real.exp (a * x) ^ 2 = Real.exp (2 * a * x) := by
    rw [pow_two, ← Real.exp_add]
    congr 1
    ring
  unfold wilsonRadialFluxWeight wilsonRadialWeight
  rw [← he]
  ring

/-- Integrated radial energy identity on an interior interval. Integrability
and the interval's inclusion in (-1,1) are explicit. No boundary condition
is imposed: the complete endpoint flux appears in the conclusion. -/
theorem wilsonRadial_interval_energy (kappa beta a l r : Real)
    (f f1 f2 : Real → Real)
    (hinterval : Set.uIcc l r ⊆ Set.Ioo (-1 : Real) 1)
    (hf : ∀ t, HasDerivAt f (f1 t) t)
    (hf1 : ∀ t ∈ Set.uIcc l r, HasDerivAt f1 (f2 t) t)
    (hkin : IntervalIntegrable (fun t => wilsonRadialFluxWeight a t * (f1 t) ^ 2)
      volume l r)
    (hpot : IntervalIntegrable (fun t =>
      (beta + (3 * kappa * a - beta) * t - kappa * a ^ 2 * (1 - t ^ 2)) *
        wilsonRadialWeight a t * (f t) ^ 2) volume l r)
    (hboundary : IntervalIntegrable
      (deriv (fun t => wilsonRadialFluxWeight a t * f t * f1 t)) volume l r) :
    (∫ t in l..r, Real.sqrt (1 - t ^ 2) * (Real.exp (a * t) * f t) *
      wilsonRadialExpression kappa beta (fun x => Real.exp (a * x) * f x) t) =
      kappa * (∫ t in l..r, wilsonRadialFluxWeight a t * (f1 t) ^ 2) +
        (∫ t in l..r,
          (beta + (3 * kappa * a - beta) * t - kappa * a ^ 2 * (1 - t ^ 2)) *
            wilsonRadialWeight a t * (f t) ^ 2) -
        kappa * (wilsonRadialFluxWeight a r * f r * f1 r -
          wilsonRadialFluxWeight a l * f l * f1 l) := by
  have hdiff : ∀ t ∈ Set.uIcc l r,
      DifferentiableAt Real (fun x => wilsonRadialFluxWeight a x * f x * f1 x) t := by
    intro t ht
    exact (((wilsonRadialFluxWeight_hasDerivAt a t (hinterval ht)).mul (hf t)).mul
      (hf1 t ht)).differentiableAt
  have hFTC := intervalIntegral.integral_deriv_eq_sub hdiff hboundary
  have hEq := intervalIntegral.integral_congr (μ := volume) (a := l) (b := r)
    (fun t ht => wilsonRadial_weighted_energy_identity kappa beta a t f f1 f2
      (hinterval ht) hf (hf1 t ht))
  rw [hEq]
  have hkint : IntervalIntegrable
      (fun t => kappa * wilsonRadialFluxWeight a t * (f1 t) ^ 2) volume l r := by
    simpa only [mul_assoc] using hkin.const_mul kappa
  rw [intervalIntegral.integral_sub (hkint.add hpot) (hboundary.const_mul kappa),
    intervalIntegral.integral_add hkint hpot]
  simp_rw [mul_assoc kappa, intervalIntegral.integral_const_mul, hFTC]

/-- Explicit lower bound for the radial energy on an interior interval.
The residual is bounded from its formula, rather than assumed coercive.
The endpoint flux remains present; no physical ground state is identified. -/
theorem wilsonRadial_interval_energy_lower (kappa beta a l r : Real)
    (f f1 f2 : Real → Real) (hk : 0 ≤ kappa) (hlr : l ≤ r)
    (hinterval : Set.uIcc l r ⊆ Set.Ioo (-1 : Real) 1)
    (hf : ∀ t, HasDerivAt f (f1 t) t)
    (hf1 : ∀ t ∈ Set.uIcc l r, HasDerivAt f1 (f2 t) t)
    (hkin : IntervalIntegrable (fun t => wilsonRadialFluxWeight a t * (f1 t) ^ 2)
      volume l r)
    (hnorm : IntervalIntegrable (fun t => wilsonRadialWeight a t * (f t) ^ 2)
      volume l r)
    (hpot : IntervalIntegrable (fun t =>
      (beta + (3 * kappa * a - beta) * t - kappa * a ^ 2 * (1 - t ^ 2)) *
        wilsonRadialWeight a t * (f t) ^ 2) volume l r)
    (hboundary : IntervalIntegrable
      (deriv (fun t => wilsonRadialFluxWeight a t * f t * f1 t)) volume l r) :
    kappa * (∫ t in l..r, wilsonRadialFluxWeight a t * (f1 t) ^ 2) +
        (beta - |3 * kappa * a - beta| - kappa * a ^ 2) *
          (∫ t in l..r, wilsonRadialWeight a t * (f t) ^ 2) -
        kappa * (wilsonRadialFluxWeight a r * f r * f1 r -
          wilsonRadialFluxWeight a l * f l * f1 l) ≤
      (∫ t in l..r, Real.sqrt (1 - t ^ 2) * (Real.exp (a * t) * f t) *
        wilsonRadialExpression kappa beta (fun x => Real.exp (a * x) * f x) t) := by
  rw [wilsonRadial_interval_energy kappa beta a l r f f1 f2
    hinterval hf hf1 hkin hpot hboundary]
  apply sub_le_sub_right
  apply add_le_add_right
  rw [← intervalIntegral.integral_const_mul]
  apply intervalIntegral.integral_mono_on hlr
    (hnorm.const_mul (beta - |3 * kappa * a - beta| - kappa * a ^ 2)) hpot
  intro t ht
  have ht' : t ∈ Set.uIcc l r := by
    simpa only [Set.uIcc_of_le hlr] using ht
  have htinner := hinterval ht'
  have hres := (wilsonRadial_residual_bounds kappa beta a t hk
    ⟨le_of_lt htinner.1, le_of_lt htinner.2⟩).1
  have hw : 0 ≤ wilsonRadialWeight a t * (f t) ^ 2 :=
    mul_nonneg (mul_nonneg (le_of_lt (Real.exp_pos _)) (Real.sqrt_nonneg _))
      (sq_nonneg _)
  simpa only [mul_assoc] using mul_le_mul_of_nonneg_right hres hw
end WilsonHaar
end BlockHamiltonian
end RussoYM

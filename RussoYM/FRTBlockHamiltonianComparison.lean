import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Normed.Operator.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Abel
import Mathlib.Logic.Function.DependsOn

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
end BlockHamiltonian
end RussoYM

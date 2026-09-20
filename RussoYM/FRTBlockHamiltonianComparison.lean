import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Normed.Operator.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Abel

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

end BlockHamiltonian
end RussoYM

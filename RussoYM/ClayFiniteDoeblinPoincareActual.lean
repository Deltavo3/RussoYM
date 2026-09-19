import Mathlib
import RussoYM.ClayFiniteSumProbabilityTarget

/-!
# Clay Finite Doeblin-Poincare Actual Target

This file begins Monster 1 of the Clay reduction.

Previous files were target/architecture layers.  This file starts replacing the
finite Markov placeholder language with actual finite-state probability data:

* a concrete finite state space using `Fintype`;
* rational probability vectors;
* rational stochastic kernels;
* finite sums using `Finset.univ.sum`;
* invariant-measure condition;
* Doeblin minorization inequality;
* Markov operator;
* variance;
* variance contraction;
* finite Poincare inequality.

Status note:

This file proves finite rational Doeblin variance contraction with factor
`(1 - alpha)^2` and the squared-residual Poincare inequality with gap
`alpha^2`, assuming the stated invariant probability and minorization.
See `concreteVarianceContraction_of_doeblin` and
`concreteFinitePoincare_of_doeblin`. The original target package is retained,
and `concreteFiniteDoeblinPoincareTarget_of_doeblin` constructs it from those
hypotheses. This does not yet construct a Yang-Mills kernel, prove a
regulator-uniform minorization constant, or establish a continuum limit.
-/

namespace RussoYM
namespace Clay

universe u

/--
A concrete finite state space.

This replaces the earlier marker-only finite-state placeholder with actual
`Fintype` and decidable equality data.
-/
structure ConcreteFiniteStateSpace where
  State : Type u
  fintype : Fintype State
  decidableEq : DecidableEq State

instance (S : ConcreteFiniteStateSpace.{u}) : Fintype S.State := S.fintype
instance (S : ConcreteFiniteStateSpace.{u}) : DecidableEq S.State := S.decidableEq

/--
Finite rational sum over the concrete finite state space.
-/
def finiteSumRat
    (S : ConcreteFiniteStateSpace.{u})
    (w : S.State -> Rat) : Rat :=
  Finset.univ.sum w

/--
A concrete rational probability vector on a finite state space.
-/
structure ConcreteProbabilityVectorOn
    (S : ConcreteFiniteStateSpace.{u}) where
  weight : S.State -> Rat
  nonnegative : forall x : S.State, 0 <= weight x
  normalized : finiteSumRat S weight = 1

/--
A concrete rational Markov kernel on a finite state space.

Rows are stochastic: for each source state `x`, the row sum over target states
is one.
-/
structure ConcreteMarkovKernelOn
    (S : ConcreteFiniteStateSpace.{u}) where
  transition : S.State -> S.State -> Rat
  nonnegative : forall x y : S.State, 0 <= transition x y
  row_stochastic :
    forall x : S.State, finiteSumRat S (fun y => transition x y) = 1

/--
The finite-state Markov operator associated to a kernel.
-/
def markovApply
    {S : ConcreteFiniteStateSpace.{u}}
    (K : ConcreteMarkovKernelOn S)
    (f : S.State -> Rat)
    (x : S.State) : Rat :=
  finiteSumRat S (fun y => K.transition x y * f y)

/--
A probability vector is invariant under the Markov kernel when `pi P = pi`.
-/
def ConcreteInvariantMeasure
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) : Prop :=
  forall y : S.State,
    finiteSumRat S (fun x => pi.weight x * K.transition x y) = pi.weight y

/--
Concrete finite Doeblin minorization:

P(x,y) >= alpha * pi(y)

for every pair of states, with 0 < alpha <= 1.
-/
def ConcreteDoeblinMinorization
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S)
    (alpha : Rat) : Prop :=
  0 < alpha
  /\ alpha <= 1
  /\ forall x y : S.State, alpha * pi.weight y <= K.transition x y

/--
Mean of a function with respect to a finite probability vector.
-/
def concreteMean
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) : Rat :=
  finiteSumRat S (fun x => pi.weight x * f x)

/--
Variance of a function with respect to a finite probability vector.
-/
def concreteVariance
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) : Rat :=
  finiteSumRat S
    (fun x => pi.weight x * (f x - concreteMean pi f) ^ 2)

/--
A simple finite Dirichlet-type form for the Markov kernel.

This is a first concrete target.  It may later be replaced by the symmetric
reversible-chain form.
-/
def concreteDirichlet
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S)
    (f : S.State -> Rat) : Rat :=
  finiteSumRat S
    (fun x => pi.weight x * (f x - markovApply K f x) ^ 2)

/--
Concrete variance contraction target.

Proved below from minorization and invariance by
`concreteVarianceContraction_of_doeblin`.
-/
def ConcreteVarianceContraction
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S)
    (c : Rat) : Prop :=
  0 <= c
  /\ c < 1
  /\ forall f : S.State -> Rat,
      concreteVariance pi (fun x => markovApply K f x)
        <= c * concreteVariance pi f

/--
Concrete finite Poincare target.

Derived below by `concreteFinitePoincare_of_varianceContraction`;
the direct Doeblin theorem gives the stronger explicit gap `alpha^2`.
-/
def ConcreteFinitePoincareInequality
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S)
    (gap : Rat) : Prop :=
  0 < gap
  /\ forall f : S.State -> Rat,
      gap * concreteVariance pi f <= concreteDirichlet pi K f

/--
The full actual finite Doeblin-Poincare target package.

This packages the finite-state theorem chain proved below:

Doeblin minorization
=>
variance contraction
=>
finite Poincare.

The explicit fields remain for compatibility. The constructor
`concreteFiniteDoeblinPoincareTarget_of_doeblin` supplies the final two fields
using proved theorems rather than additional hypotheses.
-/
structure ConcreteFiniteDoeblinPoincareTarget where
  state_space : ConcreteFiniteStateSpace.{u}
  invariant_probability : ConcreteProbabilityVectorOn state_space
  kernel : ConcreteMarkovKernelOn state_space
  invariant_measure :
    ConcreteInvariantMeasure invariant_probability kernel
  alpha : Rat
  doeblin :
    ConcreteDoeblinMinorization invariant_probability kernel alpha
  contraction_constant : Rat
  variance_contraction :
    ConcreteVarianceContraction
      invariant_probability
      kernel
      contraction_constant
  poincare_gap : Rat
  finite_poincare :
    ConcreteFinitePoincareInequality
      invariant_probability
      kernel
      poincare_gap

/--
Extract the concrete finite Poincare inequality from the target package.

This is intentionally not the hard theorem.  It is a checkpoint showing that the
new actual finite-state language composes.
-/
theorem concreteFinitePoincare_of_target
    (T : ConcreteFiniteDoeblinPoincareTarget.{u}) :
    ConcreteFinitePoincareInequality
      T.invariant_probability
      T.kernel
      T.poincare_gap := by
  exact T.finite_poincare


/-! ## Basic concrete finite-state lemmas -/

/--
A concrete probability vector has total mass one.
-/
theorem concreteProbability_totalMass
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S) :
    finiteSumRat S pi.weight = 1 :=
  pi.normalized

/--
A concrete probability vector has nonnegative weights.
-/
theorem concreteProbability_nonnegative
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (x : S.State) :
    0 <= pi.weight x :=
  pi.nonnegative x

/--
A concrete Markov kernel has row sums equal to one.
-/
theorem concreteMarkov_rowStochastic
    {S : ConcreteFiniteStateSpace.{u}}
    (K : ConcreteMarkovKernelOn S)
    (x : S.State) :
    finiteSumRat S (fun y => K.transition x y) = 1 :=
  K.row_stochastic x

/--
A concrete Markov kernel has nonnegative transition weights.
-/
theorem concreteMarkov_nonnegative
    {S : ConcreteFiniteStateSpace.{u}}
    (K : ConcreteMarkovKernelOn S)
    (x y : S.State) :
    0 <= K.transition x y :=
  K.nonnegative x y

/--
The Markov operator sends the constant-one function to the constant-one
function.
-/
theorem markovApply_const_one
    {S : ConcreteFiniteStateSpace.{u}}
    (K : ConcreteMarkovKernelOn S)
    (x : S.State) :
    markovApply K (fun _ : S.State => (1 : Rat)) x = 1 := by
  simpa [markovApply, finiteSumRat] using K.row_stochastic x

/--
The mean of the constant-one function is one.
-/
theorem concreteMean_const_one
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S) :
    concreteMean pi (fun _ : S.State => (1 : Rat)) = 1 := by
  simpa [concreteMean, finiteSumRat] using pi.normalized

/--
Extract positivity of the Doeblin constant.
-/
theorem concreteDoeblin_alpha_pos
    {S : ConcreteFiniteStateSpace.{u}}
    {pi : ConcreteProbabilityVectorOn S}
    {K : ConcreteMarkovKernelOn S}
    {alpha : Rat}
    (h : ConcreteDoeblinMinorization pi K alpha) :
    0 < alpha :=
  h.1

/--
Extract the upper bound alpha <= 1 from the Doeblin condition.
-/
theorem concreteDoeblin_alpha_le_one
    {S : ConcreteFiniteStateSpace.{u}}
    {pi : ConcreteProbabilityVectorOn S}
    {K : ConcreteMarkovKernelOn S}
    {alpha : Rat}
    (h : ConcreteDoeblinMinorization pi K alpha) :
    alpha <= 1 :=
  h.2.1

/--
Extract the pointwise Doeblin lower bound.
-/
theorem concreteDoeblin_lower_bound
    {S : ConcreteFiniteStateSpace.{u}}
    {pi : ConcreteProbabilityVectorOn S}
    {K : ConcreteMarkovKernelOn S}
    {alpha : Rat}
    (h : ConcreteDoeblinMinorization pi K alpha)
    (x y : S.State) :
    alpha * pi.weight y <= K.transition x y :=
  h.2.2 x y

/--
Extract nonnegativity of the variance contraction constant.
-/
theorem concreteVarianceContraction_constant_nonnegative
    {S : ConcreteFiniteStateSpace.{u}}
    {pi : ConcreteProbabilityVectorOn S}
    {K : ConcreteMarkovKernelOn S}
    {c : Rat}
    (h : ConcreteVarianceContraction pi K c) :
    0 <= c :=
  h.1

/--
Extract strict subunitarity of the variance contraction constant.
-/
theorem concreteVarianceContraction_constant_lt_one
    {S : ConcreteFiniteStateSpace.{u}}
    {pi : ConcreteProbabilityVectorOn S}
    {K : ConcreteMarkovKernelOn S}
    {c : Rat}
    (h : ConcreteVarianceContraction pi K c) :
    c < 1 :=
  h.2.1

/--
Extract the variance contraction inequality.
-/
theorem concreteVarianceContraction_bound
    {S : ConcreteFiniteStateSpace.{u}}
    {pi : ConcreteProbabilityVectorOn S}
    {K : ConcreteMarkovKernelOn S}
    {c : Rat}
    (h : ConcreteVarianceContraction pi K c)
    (f : S.State -> Rat) :
    concreteVariance pi (fun x => markovApply K f x)
      <= c * concreteVariance pi f :=
  h.2.2 f

/--
Extract positivity of the Poincare gap.
-/
theorem concreteFinitePoincare_gap_pos
    {S : ConcreteFiniteStateSpace.{u}}
    {pi : ConcreteProbabilityVectorOn S}
    {K : ConcreteMarkovKernelOn S}
    {gap : Rat}
    (h : ConcreteFinitePoincareInequality pi K gap) :
    0 < gap :=
  h.1

/--
Extract the finite Poincare inequality.
-/
theorem concreteFinitePoincare_bound
    {S : ConcreteFiniteStateSpace.{u}}
    {pi : ConcreteProbabilityVectorOn S}
    {K : ConcreteMarkovKernelOn S}
    {gap : Rat}
    (h : ConcreteFinitePoincareInequality pi K gap)
    (f : S.State -> Rat) :
    gap * concreteVariance pi f <= concreteDirichlet pi K f :=
  h.2 f
/-! ## Constant-function concrete lemmas -/

/--
The Markov operator sends any constant function to the same constant.
-/
theorem markovApply_const
    {S : ConcreteFiniteStateSpace.{u}}
    (K : ConcreteMarkovKernelOn S)
    (a : Rat)
    (x : S.State) :
    markovApply K (fun _ : S.State => a) x = a := by
  calc
    markovApply K (fun _ : S.State => a) x
        = finiteSumRat S (fun y => K.transition x y * a) := rfl
    _ = finiteSumRat S (fun y => K.transition x y) * a := by
        simp [finiteSumRat, Finset.sum_mul]
    _ = 1 * a := by
        rw [K.row_stochastic x]
    _ = a := by
        ring

/--
The mean of any constant function is that constant.
-/
theorem concreteMean_const
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (a : Rat) :
    concreteMean pi (fun _ : S.State => a) = a := by
  calc
    concreteMean pi (fun _ : S.State => a)
        = finiteSumRat S (fun x => pi.weight x * a) := rfl
    _ = finiteSumRat S (fun x => pi.weight x) * a := by
        simp [finiteSumRat, Finset.sum_mul]
    _ = 1 * a := by
        rw [pi.normalized]
    _ = a := by
        ring

/--
The variance of a constant function is zero.
-/
theorem concreteVariance_const
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (a : Rat) :
    concreteVariance pi (fun _ : S.State => a) = 0 := by
  simp [concreteVariance, concreteMean_const pi a, finiteSumRat]

/--
The Dirichlet form of a constant function is zero for this concrete target.
-/
theorem concreteDirichlet_const
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S)
    (a : Rat) :
    concreteDirichlet pi K (fun _ : S.State => a) = 0 := by
  simp [concreteDirichlet, markovApply_const K a, finiteSumRat]

/-! ## Concrete linearity lemmas -/

/--
The Markov operator sends the zero function to zero.
-/
theorem markovApply_zero
    {S : ConcreteFiniteStateSpace.{u}}
    (K : ConcreteMarkovKernelOn S)
    (x : S.State) :
    markovApply K (fun _ : S.State => (0 : Rat)) x = 0 := by
  simp [markovApply, finiteSumRat]

/--
The Markov operator preserves addition.
-/
theorem markovApply_add
    {S : ConcreteFiniteStateSpace.{u}}
    (K : ConcreteMarkovKernelOn S)
    (f g : S.State -> Rat)
    (x : S.State) :
    markovApply K (fun y => f y + g y) x
      = markovApply K f x + markovApply K g x := by
  simp [markovApply, finiteSumRat, mul_add, Finset.sum_add_distrib]

/--
The Markov operator commutes with scalar multiplication.
-/
theorem markovApply_smul
    {S : ConcreteFiniteStateSpace.{u}}
    (K : ConcreteMarkovKernelOn S)
    (a : Rat)
    (f : S.State -> Rat)
    (x : S.State) :
    markovApply K (fun y => a * f y) x
      = a * markovApply K f x := by
  calc
    markovApply K (fun y => a * f y) x
        = finiteSumRat S (fun y => a * (K.transition x y * f y)) := by
            simp [markovApply, finiteSumRat]
            apply Finset.sum_congr rfl
            intro y _
            ring
    _ = a * markovApply K f x := by
            simp [markovApply, finiteSumRat, Finset.mul_sum]

/--
The mean of the zero function is zero.
-/
theorem concreteMean_zero
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S) :
    concreteMean pi (fun _ : S.State => (0 : Rat)) = 0 := by
  simp [concreteMean, finiteSumRat]

/--
The mean preserves addition.
-/
theorem concreteMean_add
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (f g : S.State -> Rat) :
    concreteMean pi (fun x => f x + g x)
      = concreteMean pi f + concreteMean pi g := by
  simp [concreteMean, finiteSumRat, mul_add, Finset.sum_add_distrib]

/--
The mean commutes with scalar multiplication.
-/
theorem concreteMean_smul
    {S : ConcreteFiniteStateSpace.{u}}
    (pi : ConcreteProbabilityVectorOn S)
    (a : Rat)
    (f : S.State -> Rat) :
    concreteMean pi (fun x => a * f x)
      = a * concreteMean pi f := by
  calc
    concreteMean pi (fun x => a * f x)
        = finiteSumRat S (fun x => a * (pi.weight x * f x)) := by
            simp [concreteMean, finiteSumRat]
            apply Finset.sum_congr rfl
            intro x _
            ring
    _ = a * concreteMean pi f := by
            simp [concreteMean, finiteSumRat, Finset.mul_sum]

/-! ## Centering and variance identities -/

/-- The Markov operator preserves subtraction. -/
theorem markovApply_sub
    {S : ConcreteFiniteStateSpace.{u}} (K : ConcreteMarkovKernelOn S)
    (f g : S.State -> Rat) (x : S.State) :
    markovApply K (fun y => f y - g y) x =
      markovApply K f x - markovApply K g x := by
  simp [markovApply, finiteSumRat, mul_sub, Finset.sum_sub_distrib]

/-- The mean preserves subtraction. -/
theorem concreteMean_sub
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f g : S.State -> Rat) :
    concreteMean pi (fun x => f x - g x) =
      concreteMean pi f - concreteMean pi g := by
  simp [concreteMean, finiteSumRat, mul_sub, Finset.sum_sub_distrib]

/-- Subtracting the mean produces a function of mean zero. -/
theorem concreteMean_center
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) :
    concreteMean pi (fun x => f x - concreteMean pi f) = 0 := by
  rw [concreteMean_sub, concreteMean_const, sub_self]

/-- A stochastic kernel commutes with subtraction of the original mean. -/
theorem markovApply_center
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (f : S.State -> Rat) (x : S.State) :
    markovApply K (fun y => f y - concreteMean pi f) x =
      markovApply K f x - concreteMean pi f := by
  rw [markovApply_sub, markovApply_const]

/-- Invariance of the probability vector makes the Markov operator preserve means. -/
theorem concreteMean_markovApply
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    (f : S.State -> Rat) :
    concreteMean pi (fun x => markovApply K f x) = concreteMean pi f := by
  unfold concreteMean markovApply finiteSumRat
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro y _
  simp_rw [← mul_assoc]
  rw [← Finset.sum_mul]
  rw [show (∑ x : S.State, pi.weight x * K.transition x y) = pi.weight y from hInv y]

/-- Variance is nonnegative because each probability weight and square is nonnegative. -/
theorem concreteVariance_nonneg
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) : 0 <= concreteVariance pi f := by
  unfold concreteVariance finiteSumRat
  exact Finset.sum_nonneg fun x _ => mul_nonneg (pi.nonnegative x) (sq_nonneg _)

/-- Subtracting any constant leaves the variance unchanged. -/
theorem concreteVariance_sub_const
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) (a : Rat) :
    concreteVariance pi (fun x => f x - a) = concreteVariance pi f := by
  unfold concreteVariance
  rw [concreteMean_sub, concreteMean_const]
  unfold finiteSumRat
  apply Finset.sum_congr rfl
  intro x _
  ring

/-- Centering leaves the variance unchanged. -/
theorem concreteVariance_center
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) :
    concreteVariance pi (fun x => f x - concreteMean pi f) = concreteVariance pi f :=
  concreteVariance_sub_const pi f (concreteMean pi f)

/-- For a mean-zero function, variance is its weighted square sum. -/
theorem concreteVariance_of_mean_zero
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) (hMean : concreteMean pi f = 0) :
    concreteVariance pi f = finiteSumRat S (fun x => pi.weight x * (f x) ^ 2) := by
  simp only [concreteVariance, hMean, sub_zero]

/-- Variance scales quadratically under multiplication by a rational scalar. -/
theorem concreteVariance_smul
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) (a : Rat) :
    concreteVariance pi (fun x => a * f x) = a ^ 2 * concreteVariance pi f := by
  unfold concreteVariance
  rw [concreteMean_smul]
  unfold finiteSumRat
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro x _
  ring

/-- The squared-residual energy is nonnegative. -/
theorem concreteDirichlet_nonneg
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (f : S.State -> Rat) :
    0 <= concreteDirichlet pi K f := by
  unfold concreteDirichlet finiteSumRat
  exact Finset.sum_nonneg fun x _ => mul_nonneg (pi.nonnegative x) (sq_nonneg _)

/-- Centering does not change the squared-residual energy. -/
theorem concreteDirichlet_center
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (f : S.State -> Rat) :
    concreteDirichlet pi K (fun x => f x - concreteMean pi f) =
      concreteDirichlet pi K f := by
  unfold concreteDirichlet
  simp_rw [markovApply_center]
  unfold finiteSumRat
  apply Finset.sum_congr rfl
  intro x _
  ring

/-- Probability-weighted means preserve pointwise inequalities. -/
theorem concreteMean_mono
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    {f g : S.State -> Rat} (h : forall x, f x <= g x) :
    concreteMean pi f <= concreteMean pi g := by
  unfold concreteMean finiteSumRat
  exact Finset.sum_le_sum fun x _ => mul_le_mul_of_nonneg_left (h x) (pi.nonnegative x)

/-- Variance equals the second moment minus the square of the mean. -/
theorem concreteVariance_eq_second_moment_sub
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) :
    concreteVariance pi f =
      concreteMean pi (fun x => (f x) ^ 2) - (concreteMean pi f) ^ 2 := by
  change concreteMean pi (fun x => (f x - concreteMean pi f) ^ 2) = _
  have hfun : (fun x => (f x - concreteMean pi f) ^ 2) =
      (fun x => (f x) ^ 2 - (2 * concreteMean pi f) * f x + (concreteMean pi f) ^ 2) := by
    funext x
    ring
  rw [hfun, concreteMean_add, concreteMean_sub, concreteMean_smul, concreteMean_const]
  ring

/-- Finite weighted Jensen inequality for the square function. -/
theorem concreteMean_sq_le
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) :
    (concreteMean pi f) ^ 2 <= concreteMean pi (fun x => (f x) ^ 2) := by
  have h := concreteVariance_nonneg pi f
  rw [concreteVariance_eq_second_moment_sub] at h
  exact sub_nonneg.mp h

/-- Each stochastic row satisfies the square-function Jensen inequality. -/
theorem markovApply_sq_le
    {S : ConcreteFiniteStateSpace.{u}} (K : ConcreteMarkovKernelOn S)
    (f : S.State -> Rat) (x : S.State) :
    (markovApply K f x) ^ 2 <= markovApply K (fun y => (f y) ^ 2) x := by
  let row : ConcreteProbabilityVectorOn S := {
    weight := K.transition x
    nonnegative := K.nonnegative x
    normalized := K.row_stochastic x
  }
  exact concreteMean_sq_le row f

/-- An invariant stochastic kernel cannot increase variance.
This does not yet give the strict contraction supplied by Doeblin minorization. -/
theorem concreteVariance_markovApply_le
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    (f : S.State -> Rat) :
    concreteVariance pi (fun x => markovApply K f x) <= concreteVariance pi f := by
  rw [concreteVariance_eq_second_moment_sub, concreteVariance_eq_second_moment_sub,
    concreteMean_markovApply pi K hInv]
  apply sub_le_sub_right
  calc
    concreteMean pi (fun x => (markovApply K f x) ^ 2)
        <= concreteMean pi (fun x => markovApply K (fun y => (f y) ^ 2) x) :=
      concreteMean_mono pi (markovApply_sq_le K f)
    _ = concreteMean pi (fun y => (f y) ^ 2) :=
      concreteMean_markovApply pi K hInv (fun y => (f y) ^ 2)

/-! ## Doeblin variance contraction -/

/-- Weighted Cauchy-Schwarz, allowing weights of arbitrary total mass. -/
theorem finiteSumRat_weighted_sq_le
    {S : ConcreteFiniteStateSpace.{u}} (w f : S.State -> Rat)
    (hw : forall x, 0 <= w x) :
    (finiteSumRat S (fun x => w x * f x)) ^ 2 <=
      finiteSumRat S w * finiteSumRat S (fun x => w x * (f x) ^ 2) := by
  unfold finiteSumRat
  exact Finset.sum_sq_le_sum_mul_sum_of_sq_eq_mul Finset.univ
    (fun x _ => hw x)
    (fun x _ => mul_nonneg (hw x) (sq_nonneg (f x)))
    (fun x _ => by ring)

/-- For a mean-zero function, subtract the minorizing probability component
before applying weighted Cauchy-Schwarz. No division by `1 - alpha` is needed. -/
theorem markovApply_sq_le_of_doeblin_of_mean_zero
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) {alpha : Rat}
    (hD : ConcreteDoeblinMinorization pi K alpha)
    (f : S.State -> Rat) (hMean : concreteMean pi f = 0) (x : S.State) :
    (markovApply K f x) ^ 2 <=
      (1 - alpha) *
        (markovApply K (fun y => (f y) ^ 2) x -
          alpha * concreteMean pi (fun y => (f y) ^ 2)) := by
  have hmass : finiteSumRat S (fun y => K.transition x y - alpha * pi.weight y) =
      1 - alpha := by
    simp only [finiteSumRat, Finset.sum_sub_distrib, ← Finset.mul_sum]
    change finiteSumRat S (K.transition x) - alpha * finiteSumRat S pi.weight = _
    rw [K.row_stochastic x, pi.normalized, mul_one]
  have happly (g : S.State -> Rat) :
      finiteSumRat S (fun y => (K.transition x y - alpha * pi.weight y) * g y) =
        markovApply K g x - alpha * concreteMean pi g := by
    simp only [finiteSumRat, sub_mul, Finset.sum_sub_distrib, mul_assoc, ← Finset.mul_sum]
    rfl
  have hCS := finiteSumRat_weighted_sq_le
    (fun y => K.transition x y - alpha * pi.weight y) f
    (fun y => sub_nonneg.mpr (hD.2.2 x y))
  rw [hmass, happly f, happly (fun y => (f y) ^ 2), hMean, mul_zero, sub_zero] at hCS
  exact hCS

/-- Invariance and Doeblin minorization give the explicit squared contraction
factor `(1 - alpha)^2`, also when `alpha = 1`. -/
theorem concreteVariance_doeblin_bound
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (f : S.State -> Rat) :
    concreteVariance pi (fun x => markovApply K f x) <=
      (1 - alpha) ^ 2 * concreteVariance pi f := by
  let g : S.State -> Rat := fun x => f x - concreteMean pi f
  have hg : concreteMean pi g = 0 := concreteMean_center pi f
  have hPg : concreteMean pi (fun x => markovApply K g x) = 0 := by
    rw [concreteMean_markovApply pi K hInv, hg]
  have hbound := concreteMean_mono pi
    (markovApply_sq_le_of_doeblin_of_mean_zero pi K hD g hg)
  rw [concreteMean_smul, concreteMean_sub, concreteMean_markovApply pi K hInv,
    concreteMean_const] at hbound
  have hvar : concreteVariance pi (fun x => markovApply K g x) <=
      (1 - alpha) ^ 2 * concreteVariance pi g := by
    rw [concreteVariance_of_mean_zero pi _ hPg, concreteVariance_of_mean_zero pi g hg]
    change concreteMean pi (fun x => (markovApply K g x) ^ 2) <=
      (1 - alpha) ^ 2 * concreteMean pi (fun x => (g x) ^ 2)
    nlinarith [hbound]
  simpa only [g, markovApply_center, concreteVariance_sub_const] using hvar

/-- The explicit Doeblin bound is a strict variance-contraction certificate. -/
theorem concreteVarianceContraction_of_doeblin
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha : Rat} (hD : ConcreteDoeblinMinorization pi K alpha) :
    ConcreteVarianceContraction pi K ((1 - alpha) ^ 2) := by
  refine ⟨sq_nonneg _, ?_, concreteVariance_doeblin_bound pi K hInv hD⟩
  have hpos := hD.1
  have hle := hD.2.1
  nlinarith [mul_nonneg (le_of_lt hpos) (sub_nonneg.mpr hle)]

/-! ## Poincare inequality for the existing squared-residual energy -/

/-- A variance bound with factor `r^2`, for `0 <= r < 1`, gives the
squared-residual Poincare gap `(1-r)^2`. Invariance supplies the centering step. -/
theorem concreteFinitePoincare_of_squared_contraction
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {r : Rat} (hr0 : 0 <= r) (hr1 : r < 1)
    (hBound : forall f : S.State -> Rat,
      concreteVariance pi (fun x => markovApply K f x) <= r ^ 2 * concreteVariance pi f) :
    ConcreteFinitePoincareInequality pi K ((1 - r) ^ 2) := by
  refine ⟨sq_pos_of_pos (sub_pos.mpr hr1), ?_⟩
  intro f
  let g : S.State -> Rat := fun x => f x - concreteMean pi f
  have hg : concreteMean pi g = 0 := concreteMean_center pi f
  have hPg : concreteMean pi (fun x => markovApply K g x) = 0 := by
    rw [concreteMean_markovApply pi K hInv, hg]
  have hV : concreteMean pi (fun x => (g x) ^ 2) = concreteVariance pi f := by
    change finiteSumRat S (fun x => pi.weight x * (g x) ^ 2) = _
    rw [← concreteVariance_of_mean_zero pi g hg]
    exact concreteVariance_center pi f
  have hP : concreteMean pi (fun x => (markovApply K g x) ^ 2) =
      concreteVariance pi (fun x => markovApply K g x) :=
    (concreteVariance_of_mean_zero pi _ hPg).symm
  have hE : concreteMean pi (fun x => (g x - markovApply K g x) ^ 2) =
      concreteDirichlet pi K f := concreteDirichlet_center pi K f
  have hB : concreteVariance pi (fun x => markovApply K g x) <=
      r ^ 2 * concreteVariance pi f := by
    simpa only [g, concreteVariance_sub_const] using hBound g
  by_cases hrzero : r = 0
  · have hPzero : concreteVariance pi (fun x => markovApply K g x) = 0 :=
      le_antisymm (by simpa only [hrzero, zero_pow (by decide : 2 ≠ 0), zero_mul] using hB)
        (concreteVariance_nonneg pi _)
    have hsum : (∑ x : S.State, pi.weight x * (markovApply K g x) ^ 2) = 0 :=
      hP.trans hPzero
    have hterms := (Finset.sum_eq_zero_iff_of_nonneg
      (fun x (_ : x ∈ (Finset.univ : Finset S.State)) =>
        mul_nonneg (pi.nonnegative x) (sq_nonneg (markovApply K g x)))).mp hsum
    have hEq : concreteMean pi (fun x => (g x - markovApply K g x) ^ 2) =
        concreteMean pi (fun x => (g x) ^ 2) := by
      unfold concreteMean finiteSumRat
      apply Finset.sum_congr rfl
      intro x _
      rcases mul_eq_zero.mp (hterms x (Finset.mem_univ x)) with hw | hp
      · simp only [hw, zero_mul]
      · have hpzero : markovApply K g x = 0 := sq_eq_zero_iff.mp hp
        simp only [hpzero, sub_zero]
    rw [hE, hV] at hEq
    simpa only [hrzero, sub_zero, one_pow, one_mul] using le_of_eq hEq.symm
  · have hrpos : 0 < r := lt_of_le_of_ne hr0 (Ne.symm hrzero)
    have hYoung := concreteMean_mono pi (fun x =>
      show r * (1 - r) * (g x) ^ 2 <=
        r * (g x - markovApply K g x) ^ 2 + (1 - r) * (markovApply K g x) ^ 2 by
        nlinarith [sq_nonneg (r * g x - markovApply K g x)])
    rw [concreteMean_smul, concreteMean_add, concreteMean_smul,
      concreteMean_smul, hV, hE, hP] at hYoung
    have hBmul := mul_le_mul_of_nonneg_left hB (sub_nonneg.mpr hr1.le)
    have hfinal : r * ((1 - r) ^ 2 * concreteVariance pi f) <=
        r * concreteDirichlet pi K f := by
      nlinarith [hYoung, hBmul]
    exact (mul_le_mul_iff_right₀ hrpos).mp hfinal

/-- Any strict variance contraction yields a positive rational Poincare gap.
The coefficient `(1-c)^2/4` avoids adjoining a square root to `Rat`; it is not
claimed to be optimal. -/
theorem concreteFinitePoincare_of_varianceContraction
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {c : Rat} (hC : ConcreteVarianceContraction pi K c) :
    ConcreteFinitePoincareInequality pi K ((1 - c) ^ 2 / 4) := by
  have hc0 := hC.1
  have hc1 := hC.2.1
  have hr0 : 0 <= (1 + c) / 2 := by linarith
  have hr1 : (1 + c) / 2 < 1 := by linarith
  have hcr : c <= ((1 + c) / 2) ^ 2 := by nlinarith [sq_nonneg (1 - c)]
  have h := concreteFinitePoincare_of_squared_contraction pi K hInv hr0 hr1
    (fun f => le_trans (hC.2.2 f)
      (mul_le_mul_of_nonneg_right hcr (concreteVariance_nonneg pi f)))
  convert h using 1; ring

/-- Doeblin minorization and invariance prove the existing finite Poincare
target with gap `alpha^2`, without assuming contraction or Poincare separately. -/
theorem concreteFinitePoincare_of_doeblin
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha : Rat} (hD : ConcreteDoeblinMinorization pi K alpha) :
    ConcreteFinitePoincareInequality pi K (alpha ^ 2) := by
  have hr0 : 0 <= 1 - alpha := sub_nonneg.mpr hD.2.1
  have hr1 : 1 - alpha < 1 := by linarith [hD.1]
  have h := concreteFinitePoincare_of_squared_contraction pi K hInv hr0 hr1
    (concreteVariance_doeblin_bound pi K hInv hD)
  simpa only [sub_sub_cancel] using h

/-- Build the original target package using the proved finite-state chain.
Its contraction and Poincare fields are now supplied by theorems. -/
def concreteFiniteDoeblinPoincareTarget_of_doeblin
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    (alpha : Rat) (hD : ConcreteDoeblinMinorization pi K alpha) :
    ConcreteFiniteDoeblinPoincareTarget.{u} where
  state_space := S
  invariant_probability := pi
  kernel := K
  invariant_measure := hInv
  alpha := alpha
  doeblin := hD
  contraction_constant := (1 - alpha) ^ 2
  variance_contraction := concreteVarianceContraction_of_doeblin pi K hInv hD
  poincare_gap := alpha ^ 2
  finite_poincare := concreteFinitePoincare_of_doeblin pi K hInv hD

/-! ## Standard Markov Dirichlet energy

The existing `concreteDirichlet` remains the squared-residual energy.
The new energy below is the usual quadratic form `<f, (I-P)f>`.
Under invariance it equals half the weighted squared-difference sum.
-/

/-- The usual Markov Dirichlet quadratic form, distinct from the original
squared-residual energy `concreteDirichlet`. -/
def concreteMarkovDirichlet
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (f : S.State -> Rat) : Rat :=
  concreteMean pi (fun x => f x * (f x - markovApply K f x))

/-- Expand a squared difference under a probability-weighted mean. -/
theorem concreteMean_sq_sub
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) (a : Rat) :
    concreteMean pi (fun y => (a - f y) ^ 2) =
      a ^ 2 - 2 * a * concreteMean pi f + concreteMean pi (fun y => (f y) ^ 2) := by
  have hfun : (fun y => (a - f y) ^ 2) =
      (fun y => a ^ 2 - (2 * a) * f y + (f y) ^ 2) := by
    funext y
    ring
  rw [hfun, concreteMean_add, concreteMean_sub, concreteMean_const, concreteMean_smul]

/-- Variance is half the independent-pair squared-difference mean. -/
theorem concreteVariance_pairwise_identity
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) :
    concreteMean pi (fun x => concreteMean pi (fun y => (f x - f y) ^ 2)) =
      2 * concreteVariance pi f := by
  simp_rw [concreteMean_sq_sub]
  have hfun : (fun x => (f x) ^ 2 - 2 * f x * concreteMean pi f +
      concreteMean pi (fun y => (f y) ^ 2)) =
      (fun x => (f x) ^ 2 - (2 * concreteMean pi f) * f x +
        concreteMean pi (fun y => (f y) ^ 2)) := by
    funext x
    ring
  rw [hfun, concreteMean_add, concreteMean_sub, concreteMean_smul, concreteMean_const,
    concreteVariance_eq_second_moment_sub]
  ring

/-- Expand a squared difference under a stochastic row. -/
theorem markovApply_sq_sub
    {S : ConcreteFiniteStateSpace.{u}} (K : ConcreteMarkovKernelOn S)
    (f : S.State -> Rat) (a : Rat) (x : S.State) :
    markovApply K (fun y => (a - f y) ^ 2) x =
      a ^ 2 - 2 * a * markovApply K f x + markovApply K (fun y => (f y) ^ 2) x := by
  have hfun : (fun y => (a - f y) ^ 2) =
      (fun y => a ^ 2 - (2 * a) * f y + (f y) ^ 2) := by
    funext y
    ring
  rw [hfun, markovApply_add, markovApply_sub, markovApply_const, markovApply_smul]

/-- Expand the standard energy into a second moment and a mixed moment. -/
theorem concreteMarkovDirichlet_eq_moments
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (f : S.State -> Rat) :
    concreteMarkovDirichlet pi K f = concreteMean pi (fun x => (f x) ^ 2) -
      concreteMean pi (fun x => f x * markovApply K f x) := by
  unfold concreteMarkovDirichlet
  have hfun : (fun x => f x * (f x - markovApply K f x)) =
      (fun x => (f x) ^ 2 - f x * markovApply K f x) := by
    funext x
    ring
  rw [hfun, concreteMean_sub]

/-- For an invariant probability, the standard energy equals half the
weighted squared-difference sum. Reversibility is not needed for this identity. -/
theorem concreteMarkovDirichlet_pairwise_identity
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    (f : S.State -> Rat) :
    concreteMean pi (fun x => markovApply K (fun y => (f x - f y) ^ 2) x) =
      2 * concreteMarkovDirichlet pi K f := by
  simp_rw [markovApply_sq_sub]
  have hfun : (fun x => (f x) ^ 2 - 2 * f x * markovApply K f x +
      markovApply K (fun y => (f y) ^ 2) x) =
      (fun x => (f x) ^ 2 - 2 * (f x * markovApply K f x) +
        markovApply K (fun y => (f y) ^ 2) x) := by
    funext x
    ring
  rw [hfun, concreteMean_add, concreteMean_sub, concreteMean_smul,
    concreteMean_markovApply pi K hInv, concreteMarkovDirichlet_eq_moments]
  ring

/-- The standard Markov energy is nonnegative under invariance. -/
theorem concreteMarkovDirichlet_nonneg
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    (f : S.State -> Rat) : 0 <= concreteMarkovDirichlet pi K f := by
  have hsum : 0 <= concreteMean pi
      (fun x => markovApply K (fun y => (f x - f y) ^ 2) x) := by
    unfold concreteMean markovApply finiteSumRat
    exact Finset.sum_nonneg fun x _ => mul_nonneg (pi.nonnegative x)
      (Finset.sum_nonneg fun y _ => mul_nonneg (K.nonnegative x y) (sq_nonneg _))
  rw [concreteMarkovDirichlet_pairwise_identity pi K hInv] at hsum
  linarith

/-- Doeblin minorization gives the standard Markov Poincare bound with
coefficient `alpha`, rather than the squared-residual coefficient `alpha^2`. -/
theorem concreteMarkovDirichlet_doeblin_bound
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (f : S.State -> Rat) :
    alpha * concreteVariance pi f <= concreteMarkovDirichlet pi K f := by
  have hrow (x : S.State) :
      alpha * concreteMean pi (fun y => (f x - f y) ^ 2) <=
        markovApply K (fun y => (f x - f y) ^ 2) x := by
    unfold concreteMean markovApply finiteSumRat
    rw [Finset.mul_sum]
    apply Finset.sum_le_sum
    intro y _
    have h := mul_le_mul_of_nonneg_right (hD.2.2 x y) (sq_nonneg (f x - f y))
    simpa only [mul_assoc] using h
  have h := concreteMean_mono pi hrow
  rw [concreteMean_smul, concreteVariance_pairwise_identity,
    concreteMarkovDirichlet_pairwise_identity pi K hInv] at h
  linarith

/-- Poincare target for the standard Markov quadratic form. -/
def ConcreteMarkovPoincareInequality
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (gap : Rat) : Prop :=
  0 < gap /\ forall f : S.State -> Rat,
    gap * concreteVariance pi f <= concreteMarkovDirichlet pi K f

/-- The standard finite Markov Poincare target follows from invariance and
Doeblin minorization alone. -/
theorem concreteMarkovPoincare_of_doeblin
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha : Rat} (hD : ConcreteDoeblinMinorization pi K alpha) :
    ConcreteMarkovPoincareInequality pi K alpha :=
  ⟨hD.1, concreteMarkovDirichlet_doeblin_bound pi K hInv hD⟩

/-- The old squared-residual energy is bounded by twice the standard Markov
energy under invariance. This explicitly relates the two retained definitions. -/
theorem concreteDirichlet_le_two_markovDirichlet
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    (f : S.State -> Rat) :
    concreteDirichlet pi K f <= 2 * concreteMarkovDirichlet pi K f := by
  have hrow (x : S.State) : (f x - markovApply K f x) ^ 2 <=
      markovApply K (fun y => (f x - f y) ^ 2) x := by
    have h := markovApply_sq_le K (fun y => f x - f y) x
    rw [markovApply_sub, markovApply_const] at h
    exact h
  have h := concreteMean_mono pi hrow
  rw [concreteMarkovDirichlet_pairwise_identity pi K hInv] at h
  exact h

/-! ## Finite-state rigidity and eigenfunction consequences

These statements concern the existing rational finite-state model. They do not
assert existence of a Yang-Mills operator or a continuum spectral theorem.
-/

/-- Variance vanishes exactly when the function equals its mean on every
state with positive probability. Zero-weight states need not satisfy this. -/
theorem concreteVariance_eq_zero_iff_on_support
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) :
    concreteVariance pi f = 0 ↔
      forall x : S.State, 0 < pi.weight x -> f x = concreteMean pi f := by
  constructor
  · intro h x hx
    have hsum : (∑ y : S.State, pi.weight y * (f y - concreteMean pi f) ^ 2) = 0 := h
    have hterms := (Finset.sum_eq_zero_iff_of_nonneg
      (fun y (_ : y ∈ (Finset.univ : Finset S.State)) =>
        mul_nonneg (pi.nonnegative y) (sq_nonneg (f y - concreteMean pi f)))).mp hsum
    have hsq : (f x - concreteMean pi f) ^ 2 = 0 :=
      (mul_eq_zero.mp (hterms x (Finset.mem_univ x))).resolve_left (ne_of_gt hx)
    exact sub_eq_zero.mp (sq_eq_zero_iff.mp hsq)
  · intro h
    unfold concreteVariance finiteSumRat
    apply Finset.sum_eq_zero
    intro x _
    by_cases hx : pi.weight x = 0
    · simp only [hx, zero_mul]
    · have hxpos : 0 < pi.weight x := lt_of_le_of_ne (pi.nonnegative x) (Ne.symm hx)
      rw [h x hxpos, sub_self, zero_pow (by decide : 2 ≠ 0), mul_zero]

/-- Two positive-probability states with different values force positive variance. -/
theorem concreteVariance_pos_of_nonconstant_on_support
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat)
    (hNonconstant : ∃ x y : S.State,
      0 < pi.weight x ∧ 0 < pi.weight y ∧ f x ≠ f y) :
    0 < concreteVariance pi f := by
  have hne : concreteVariance pi f ≠ 0 := by
    intro hz
    obtain ⟨x, y, hx, hy, hxy⟩ := hNonconstant
    have h := (concreteVariance_eq_zero_iff_on_support pi f).mp hz
    exact hxy ((h x hx).trans (h y hy).symm)
  exact lt_of_le_of_ne (concreteVariance_nonneg pi f) (Ne.symm hne)

/-- Zero standard energy forces zero variance under the Doeblin hypotheses. -/
theorem concreteVariance_eq_zero_of_markovDirichlet_eq_zero
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (f : S.State -> Rat) (hEnergy : concreteMarkovDirichlet pi K f = 0) :
    concreteVariance pi f = 0 := by
  have h := concreteMarkovDirichlet_doeblin_bound pi K hInv hD f
  rw [hEnergy] at h
  have hle : concreteVariance pi f <= 0 :=
    (mul_le_mul_iff_right₀ hD.1).mp (by simpa only [mul_zero] using h)
  exact le_antisymm hle (concreteVariance_nonneg pi f)

/-- Zero energy implies constancy on the probability support. -/
theorem concreteMarkovDirichlet_zero_rigidity
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (f : S.State -> Rat) (hEnergy : concreteMarkovDirichlet pi K f = 0) :
    forall x : S.State, 0 < pi.weight x -> f x = concreteMean pi f :=
  (concreteVariance_eq_zero_iff_on_support pi f).mp
    (concreteVariance_eq_zero_of_markovDirichlet_eq_zero pi K hInv hD f hEnergy)

/-- With strictly positive weights, zero energy implies constancy everywhere. -/
theorem concreteMarkovDirichlet_zero_rigidity_of_positive_weights
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (hWeights : forall x : S.State, 0 < pi.weight x)
    (f : S.State -> Rat) (hEnergy : concreteMarkovDirichlet pi K f = 0) :
    forall x : S.State, f x = concreteMean pi f :=
  fun x => concreteMarkovDirichlet_zero_rigidity pi K hInv hD f hEnergy x (hWeights x)

/-- Fixed functions of the kernel are constant on the probability support. -/
theorem concreteMarkov_fixed_function_rigidity
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (f : S.State -> Rat) (hFixed : forall x, markovApply K f x = f x) :
    forall x : S.State, 0 < pi.weight x -> f x = concreteMean pi f := by
  apply concreteMarkovDirichlet_zero_rigidity pi K hInv hD f
  simp only [concreteMarkovDirichlet, hFixed, sub_self, mul_zero]
  exact concreteMean_zero pi

/-- Every rational eigenvalue carried by a positive-variance eigenfunction
has absolute value at most `1-alpha`. This is an eigenfunction consequence,
not a claim to construct or classify the full complex spectrum. -/
theorem concreteMarkov_eigenvalue_abs_bound
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (f : S.State -> Rat) {eigenvalue : Rat}
    (hEigen : forall x, markovApply K f x = eigenvalue * f x)
    (hVariance : 0 < concreteVariance pi f) :
    |eigenvalue| <= 1 - alpha := by
  have h := concreteVariance_doeblin_bound pi K hInv hD f
  simp only [hEigen, concreteVariance_smul] at h
  have hsq : eigenvalue ^ 2 <= (1 - alpha) ^ 2 :=
    (mul_le_mul_iff_left₀ hVariance).mp h
  exact abs_le_of_sq_le_sq hsq (sub_nonneg.mpr hD.2.1)

/-- For a nonconstant-on-support rational eigenfunction of `P`, the associated
`I-P` eigenvalue is at least the positive Doeblin constant. -/
theorem concreteMarkov_generator_eigenvalue_gap
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (f : S.State -> Rat) {eigenvalue : Rat}
    (hEigen : forall x, markovApply K f x = eigenvalue * f x)
    (hNonconstant : ∃ x y : S.State,
      0 < pi.weight x ∧ 0 < pi.weight y ∧ f x ≠ f y) :
    alpha <= 1 - eigenvalue ∧ 0 < 1 - eigenvalue := by
  have h := concreteMarkov_eigenvalue_abs_bound pi K hInv hD f hEigen
    (concreteVariance_pos_of_nonconstant_on_support pi f hNonconstant)
  have hupper := (abs_le.mp h).2
  constructor <;> linarith [hD.1]

/-! ## Reference-measure conversion for the block-kernel roadmap

Finite rational counterpart of section 2 of
`docs/ClayBlockRGConditionalMasterTheorem.md`:
`K(x,y) >= a * reference(y)` and `pi(y) <= M * reference(y)` imply
equilibrium minorization with coefficient `a / M`.
No invariance of the reference probability is required. Invariance of `pi`
is an explicit hypothesis of the Poincare consequences.
-/

/-- Normalization forces an upper density-comparison constant to be at least one. -/
theorem concreteProbability_density_upper_ge_one
    {S : ConcreteFiniteStateSpace.{u}} (pi reference : ConcreteProbabilityVectorOn S)
    {M : Rat} (hDensity : forall y, pi.weight y <= M * reference.weight y) :
    1 <= M := by
  have hsum := Finset.sum_le_sum
    (fun y (_ : y ∈ (Finset.univ : Finset S.State)) => hDensity y)
  rw [← Finset.mul_sum] at hsum
  change finiteSumRat S pi.weight <= M * finiteSumRat S reference.weight at hsum
  simpa only [pi.normalized, reference.normalized, mul_one] using hsum

/-- Reference minorization converts to equilibrium minorization using only
an upper density bound. Positivity of `M` follows from normalization. -/
theorem concreteDoeblin_of_reference_minorization
    {S : ConcreteFiniteStateSpace.{u}} (pi reference : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) {a M : Rat}
    (hReference : ConcreteDoeblinMinorization reference K a)
    (hDensity : forall y, pi.weight y <= M * reference.weight y) :
    ConcreteDoeblinMinorization pi K (a / M) := by
  have hM := concreteProbability_density_upper_ge_one pi reference hDensity
  have hMpos : 0 < M := lt_of_lt_of_le (by norm_num) hM
  have hpos : 0 < a / M := div_pos hReference.1 hMpos
  refine ⟨hpos, (div_le_one hMpos).mpr (le_trans hReference.2.1 hM), ?_⟩
  intro x y
  calc
    (a / M) * pi.weight y <= (a / M) * (M * reference.weight y) :=
      mul_le_mul_of_nonneg_left (hDensity y) hpos.le
    _ = a * reference.weight y := by
      rw [← mul_assoc, div_mul_cancel₀ _ (ne_of_gt hMpos)]
    _ <= K.transition x y := hReference.2.2 x y

/-- The finite block-reference hypotheses supply all three proved estimates:
variance contraction, standard Markov Poincare, and squared-residual Poincare. -/
theorem concreteBlock_bounds_of_reference_minorization
    {S : ConcreteFiniteStateSpace.{u}} (pi reference : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {a M : Rat} (hReference : ConcreteDoeblinMinorization reference K a)
    (hDensity : forall y, pi.weight y <= M * reference.weight y) :
    ConcreteVarianceContraction pi K ((1 - a / M) ^ 2) ∧
      ConcreteMarkovPoincareInequality pi K (a / M) ∧
      ConcreteFinitePoincareInequality pi K ((a / M) ^ 2) := by
  have hD := concreteDoeblin_of_reference_minorization pi reference K hReference hDensity
  exact ⟨concreteVarianceContraction_of_doeblin pi K hInv hD,
    concreteMarkovPoincare_of_doeblin pi K hInv hD,
    concreteFinitePoincare_of_doeblin pi K hInv hD⟩

/-- Shared reference and density constants give one positive standard-energy
Poincare constant for a whole family, even when the finite state spaces vary.
Uniformity of the input constants is assumed explicitly, not proved here. -/
theorem concreteUniformBlockPoincare_of_reference_minorization
    (S : Nat -> ConcreteFiniteStateSpace.{u})
    (pi reference : (n : Nat) -> ConcreteProbabilityVectorOn (S n))
    (K : (n : Nat) -> ConcreteMarkovKernelOn (S n))
    (hInv : forall n, ConcreteInvariantMeasure (pi n) (K n))
    {a M : Rat}
    (hReference : forall n, ConcreteDoeblinMinorization (reference n) (K n) a)
    (hDensity : forall n y, (pi n).weight y <= M * (reference n).weight y) :
    0 < a / M ∧ forall n (f : (S n).State -> Rat),
      (a / M) * concreteVariance (pi n) f <= concreteMarkovDirichlet (pi n) (K n) f := by
  have hD (n : Nat) := concreteDoeblin_of_reference_minorization
    (pi n) (reference n) (K n) (hReference n) (hDensity n)
  exact ⟨(hD 0).1, fun n f =>
    concreteMarkovDirichlet_doeblin_bound (pi n) (K n) (hInv n) (hD n) f⟩

/-- Transfer a standard Markov bound to another energy only after an explicit
comparison is supplied. This does not identify that energy with a YM Hamiltonian. -/
theorem concreteBlockPoincare_of_energy_comparison
    {S : ConcreteFiniteStateSpace.{u}} (pi reference : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {a M scale : Rat} (hReference : ConcreteDoeblinMinorization reference K a)
    (hDensity : forall y, pi.weight y <= M * reference.weight y)
    (hScale : 0 < scale) (energy : (S.State -> Rat) -> Rat)
    (hEnergy : forall f, concreteMarkovDirichlet pi K f <= scale * energy f) :
    0 < (a / M) / scale ∧ forall f,
      ((a / M) / scale) * concreteVariance pi f <= energy f := by
  have hD := concreteDoeblin_of_reference_minorization pi reference K hReference hDensity
  refine ⟨div_pos hD.1 hScale, ?_⟩
  intro f
  have h := le_trans (concreteMarkovDirichlet_doeblin_bound pi K hInv hD f) (hEnergy f)
  rw [div_mul_eq_mul_div]
  exact (div_le_iff₀ hScale).mpr (by simpa only [mul_comm scale] using h)

/-! ## Explicit finite linear-operator bridge for the FRT/YM route

The kernel, equilibrium weights, uniform constants, and physical energy
comparison must ultimately come from the proposed FRT/YM construction.
This section gives their finite rational operator interface. The scaled
operator `(I-P)/tau` is defined here; no identification with a Yang-Mills
Hamiltonian or with `-log(P)/tau` is asserted.
-/

/-- Weighted rational pairing. It can be degenerate when some weights vanish;
we do not install an inner-product-space instance without positive weights. -/
def concreteWeightedInner
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f g : S.State -> Rat) : Rat :=
  concreteMean pi (fun x => f x * g x)

/-- Orthogonality to the constant-one function is precisely the mean-zero condition. -/
theorem concreteWeightedInner_one_left
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) :
    concreteWeightedInner pi (fun _ => 1) f = concreteMean pi f := by
  simp only [concreteWeightedInner, one_mul]

/-- On mean-zero functions the weighted square norm equals variance. -/
theorem concreteWeightedInner_self_of_mean_zero
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) (hMean : concreteMean pi f = 0) :
    concreteWeightedInner pi f f = concreteVariance pi f := by
  simp only [concreteWeightedInner, ← pow_two]
  exact (concreteVariance_of_mean_zero pi f hMean).symm

/-- The stochastic kernel acts as an actual rational linear map on functions. -/
def concreteMarkovLinearMap
    {S : ConcreteFiniteStateSpace.{u}} (K : ConcreteMarkovKernelOn S) :
    (S.State -> Rat) →ₗ[Rat] (S.State -> Rat) where
  toFun := markovApply K
  map_add' f g := by
    funext x
    exact markovApply_add K f g x
  map_smul' a f := by
    funext x
    simpa only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply] using markovApply_smul K a f x

/-- The scaled finite Markov generator `(I-P)/tau`. Positivity statements
below require `tau > 0`. This is not defined as the physical YM Hamiltonian. -/
def concreteScaledMarkovGenerator
    {S : ConcreteFiniteStateSpace.{u}} (K : ConcreteMarkovKernelOn S) (tau : Rat) :
    (S.State -> Rat) →ₗ[Rat] (S.State -> Rat) :=
  (1 / tau) • (LinearMap.id - concreteMarkovLinearMap K)

/-- Pointwise formula for the scaled generator. -/
theorem concreteScaledMarkovGenerator_apply
    {S : ConcreteFiniteStateSpace.{u}} (K : ConcreteMarkovKernelOn S)
    (tau : Rat) (f : S.State -> Rat) (x : S.State) :
    concreteScaledMarkovGenerator K tau f x =
      (1 / tau) * (f x - markovApply K f x) := rfl

/-- Constant functions lie in the kernel of the scaled generator. -/
theorem concreteScaledMarkovGenerator_const
    {S : ConcreteFiniteStateSpace.{u}} (K : ConcreteMarkovKernelOn S)
    (tau a : Rat) :
    concreteScaledMarkovGenerator K tau (fun _ => a) = (fun _ => 0) := by
  funext x
  simp only [concreteScaledMarkovGenerator_apply, markovApply_const, sub_self, mul_zero]

/-- The quadratic form of the scaled generator is the standard Markov energy
scaled by the inverse time parameter. -/
theorem concreteWeightedInner_scaledGenerator
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (tau : Rat) (f : S.State -> Rat) :
    concreteWeightedInner pi f (concreteScaledMarkovGenerator K tau f) =
      (1 / tau) * concreteMarkovDirichlet pi K f := by
  unfold concreteWeightedInner concreteMarkovDirichlet
  simp only [concreteScaledMarkovGenerator_apply]
  have hfun : (fun x => f x * ((1 / tau) * (f x - markovApply K f x))) =
      (fun x => (1 / tau) * (f x * (f x - markovApply K f x))) := by
    funext x
    ring
  rw [hfun, concreteMean_smul]

/-- A proved finite generator-form gap on the constant-orthogonal sector.
This is an inequality of weighted quadratic forms, without a self-adjointness
or continuum identification claim. -/
theorem concreteScaledMarkovGenerator_gap
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha tau : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (hTau : 0 < tau) :
    0 < alpha / tau ∧ forall f : S.State -> Rat, concreteMean pi f = 0 ->
      (alpha / tau) * concreteWeightedInner pi f f <=
        concreteWeightedInner pi f (concreteScaledMarkovGenerator K tau f) := by
  refine ⟨div_pos hD.1 hTau, ?_⟩
  intro f hMean
  rw [concreteWeightedInner_self_of_mean_zero pi f hMean, concreteWeightedInner_scaledGenerator]
  have h := mul_le_mul_of_nonneg_left
    (concreteMarkovDirichlet_doeblin_bound pi K hInv hD f)
    (le_of_lt (one_div_pos.mpr hTau))
  convert h using 1; ring

/-- Conditional finite operator bridge: reference minorization and an explicit
quadratic-form comparison imply a gap on the mean-zero sector of a candidate
linear operator `H`. The comparison is required only on that sector.
Identifying `H` with an FRT/YM Hamiltonian is a remaining construction task. -/
theorem concreteOperatorGap_of_reference_comparison
    {S : ConcreteFiniteStateSpace.{u}} (pi reference : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    (H : (S.State -> Rat) →ₗ[Rat] (S.State -> Rat))
    {a M scale : Rat} (hReference : ConcreteDoeblinMinorization reference K a)
    (hDensity : forall y, pi.weight y <= M * reference.weight y)
    (hScale : 0 < scale)
    (hForm : forall f : S.State -> Rat, concreteMean pi f = 0 ->
      concreteMarkovDirichlet pi K f <= scale * concreteWeightedInner pi f (H f)) :
    0 < (a / M) / scale ∧ forall f : S.State -> Rat, concreteMean pi f = 0 ->
      ((a / M) / scale) * concreteWeightedInner pi f f <=
        concreteWeightedInner pi f (H f) := by
  have hD := concreteDoeblin_of_reference_minorization pi reference K hReference hDensity
  refine ⟨div_pos hD.1 hScale, ?_⟩
  intro f hMean
  have h := le_trans (concreteMarkovDirichlet_doeblin_bound pi K hInv hD f) (hForm f hMean)
  rw [← concreteWeightedInner_self_of_mean_zero pi f hMean] at h
  rw [div_mul_eq_mul_div]
  exact (div_le_iff₀ hScale).mpr (by simpa only [mul_comm scale] using h)

/-- Detailed balance is an explicit equality of weighted transition probabilities.
It is additional data to verify for a proposed FRT/YM kernel, not an axiom. -/
def ConcreteDetailedBalance
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) : Prop :=
  forall x y, pi.weight x * K.transition x y = pi.weight y * K.transition y x

/-- Detailed balance and stochastic rows imply invariance of the probability vector. -/
theorem concreteInvariantMeasure_of_detailedBalance
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hB : ConcreteDetailedBalance pi K) :
    ConcreteInvariantMeasure pi K := by
  intro y
  unfold finiteSumRat
  rw [show (∑ x : S.State, pi.weight x * K.transition x y) =
      ∑ x : S.State, pi.weight y * K.transition y x from
    Finset.sum_congr rfl (fun x _ => hB x y)]
  rw [← Finset.mul_sum]
  have hr : (∑ x : S.State, K.transition y x) = 1 := K.row_stochastic y
  rw [hr, mul_one]

/-- Symmetry of the rational weighted pairing, even when some weights vanish. -/
theorem concreteWeightedInner_symm
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f g : S.State -> Rat) : concreteWeightedInner pi f g = concreteWeightedInner pi g f := by
  unfold concreteWeightedInner
  congr 1
  funext x
  ring

/-- Detailed balance makes the actual finite Markov operator symmetric in the
weighted pairing. This does not assert an identification with the YM Hamiltonian. -/
theorem concreteMarkov_weighted_symmetry
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hB : ConcreteDetailedBalance pi K)
    (f g : S.State -> Rat) :
    concreteWeightedInner pi f (markovApply K g) =
      concreteWeightedInner pi (markovApply K f) g := by
  unfold concreteWeightedInner concreteMean markovApply finiteSumRat
  simp_rw [Finset.mul_sum, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro y _
  simp_rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro x _
  calc
    pi.weight x * (f x * (K.transition x y * g y)) =
        (pi.weight x * K.transition x y) * (f x * g y) := by ring
    _ = (pi.weight y * K.transition y x) * (f x * g y) := by rw [hB x y]
    _ = _ := by ring

/-- Bilinear form of the scaled generator on two possibly different functions. -/
theorem concreteWeightedInner_scaledGenerator_bilinear
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (tau : Rat) (f g : S.State -> Rat) :
    concreteWeightedInner pi f (concreteScaledMarkovGenerator K tau g) =
      (1 / tau) * (concreteWeightedInner pi f g -
        concreteWeightedInner pi f (markovApply K g)) := by
  unfold concreteWeightedInner
  simp only [concreteScaledMarkovGenerator_apply]
  have heq : (fun x => f x * ((1 / tau) * (g x - markovApply K g x))) =
      (fun x => (1 / tau) * (f x * g x - f x * markovApply K g x)) := by
    funext x
    ring
  rw [heq, concreteMean_smul, concreteMean_sub]

/-- The scaled generator inherits weighted symmetry from detailed balance.
For strictly positive weights this pairing is nondegenerate; zero weights
require a support restriction or quotient before calling it an inner product. -/
theorem concreteScaledMarkovGenerator_weighted_symmetry
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hB : ConcreteDetailedBalance pi K)
    (tau : Rat) (f g : S.State -> Rat) :
    concreteWeightedInner pi f (concreteScaledMarkovGenerator K tau g) =
      concreteWeightedInner pi (concreteScaledMarkovGenerator K tau f) g := by
  rw [concreteWeightedInner_symm pi (concreteScaledMarkovGenerator K tau f) g]
  rw [concreteWeightedInner_scaledGenerator_bilinear,
    concreteWeightedInner_scaledGenerator_bilinear]
  rw [concreteMarkov_weighted_symmetry pi K hB f g,
    concreteWeightedInner_symm pi (markovApply K f) g, concreteWeightedInner_symm pi f g]

/-- Projection onto the constant functions using the invariant probability mean.
This is an actual linear map, not a placeholder vacuum projection. Identifying
it with a physical vacuum projection is a separate construction problem. -/
def concreteConstantProjection
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S) :
    (S.State -> Rat) →ₗ[Rat] (S.State -> Rat) where
  toFun f := fun _ => concreteMean pi f
  map_add' f g := by
    funext x
    exact concreteMean_add pi f g
  map_smul' a f := by
    funext x
    simpa only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply] using concreteMean_smul pi a f

/-- Applying the constant projection twice has the same effect as applying it once. -/
theorem concreteConstantProjection_idempotent
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) :
    concreteConstantProjection pi (concreteConstantProjection pi f) =
      concreteConstantProjection pi f := by
  funext x
  exact concreteMean_const pi (concreteMean pi f)

/-- The centered component is orthogonal to every projected function in the
weighted pairing; no positivity of individual weights is needed for this identity. -/
theorem concreteConstantProjection_orthogonal
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f g : S.State -> Rat) :
    concreteWeightedInner pi (f - concreteConstantProjection pi f)
      (concreteConstantProjection pi g) = 0 := by
  change concreteMean pi (fun x => (f x - concreteMean pi f) * concreteMean pi g) = 0
  have heq : (fun x => (f x - concreteMean pi f) * concreteMean pi g) =
      (fun x => concreteMean pi g * (f x - concreteMean pi f)) := by
    funext x
    ring
  rw [heq, concreteMean_smul, concreteMean_center, mul_zero]

/-- The generator annihilates the projected component. -/
theorem concreteScaledMarkovGenerator_constantProjection
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (tau : Rat) (f : S.State -> Rat) :
    concreteScaledMarkovGenerator K tau (concreteConstantProjection pi f) = 0 :=
  concreteScaledMarkovGenerator_const K tau (concreteMean pi f)

/-- Invariance puts the generator's image in the mean-zero sector. -/
theorem concreteConstantProjection_scaledMarkovGenerator
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    (tau : Rat) (f : S.State -> Rat) :
    concreteConstantProjection pi (concreteScaledMarkovGenerator K tau f) = 0 := by
  funext x
  change concreteMean pi (fun y => (1 / tau) * (f y - markovApply K f y)) = 0
  rw [concreteMean_smul, concreteMean_sub, concreteMean_markovApply pi K hInv,
    sub_self, mul_zero]

/-- Under positive weights and Doeblin minorization, the generator kernel is
exactly the range of the constant projection. -/
theorem concreteScaledMarkovGenerator_zero_iff_projected
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha tau : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (hTau : 0 < tau) (hWeights : forall x, 0 < pi.weight x)
    (f : S.State -> Rat) :
    concreteScaledMarkovGenerator K tau f = 0 ↔ f = concreteConstantProjection pi f := by
  constructor
  · intro hz
    have hFixed : forall x, markovApply K f x = f x := by
      intro x
      have hx := congrFun hz x
      change (1 / tau) * (f x - markovApply K f x) = 0 at hx
      have hd := (mul_eq_zero.mp hx).resolve_left (one_div_ne_zero (ne_of_gt hTau))
      exact (sub_eq_zero.mp hd).symm
    funext x
    exact concreteMarkov_fixed_function_rigidity pi K hInv hD f hFixed x (hWeights x)
  · intro hf
    calc
      _ = concreteScaledMarkovGenerator K tau (concreteConstantProjection pi f) :=
        congrArg (concreteScaledMarkovGenerator K tau) hf
      _ = 0 := concreteScaledMarkovGenerator_constantProjection pi K tau f

/-- The finite gap on all functions, with the constant projection explicitly
removed. It holds as a weighted quadratic-form inequality even with zero weights;
positive weights are required to identify the full function-space kernel above. -/
theorem concreteScaledMarkovGenerator_projected_gap
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha tau : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (hTau : 0 < tau) (f : S.State -> Rat) :
    (alpha / tau) * concreteWeightedInner pi
        (f - concreteConstantProjection pi f) (f - concreteConstantProjection pi f) ≤
      concreteWeightedInner pi f (concreteScaledMarkovGenerator K tau f) := by
  have hnorm : concreteWeightedInner pi
      (f - concreteConstantProjection pi f) (f - concreteConstantProjection pi f) =
      concreteVariance pi f := by
    change concreteWeightedInner pi (fun x => f x - concreteMean pi f)
      (fun x => f x - concreteMean pi f) = concreteVariance pi f
    rw [concreteWeightedInner_self_of_mean_zero pi _ (concreteMean_center pi f),
      concreteVariance_center]
  rw [hnorm, concreteWeightedInner_scaledGenerator]
  have h := mul_le_mul_of_nonneg_left
    (concreteMarkovDirichlet_doeblin_bound pi K hInv hD f)
    (le_of_lt (one_div_pos.mpr hTau))
  convert h using 1
  ring

/-- Under the same full-support Doeblin assumptions, zero quadratic energy is
equivalent to membership in the generator kernel. No continuum claim is involved. -/
theorem concreteScaledMarkovGenerator_energy_zero_iff
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha tau : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (hTau : 0 < tau) (hWeights : forall x, 0 < pi.weight x)
    (f : S.State -> Rat) :
    concreteWeightedInner pi f (concreteScaledMarkovGenerator K tau f) = 0 ↔
      concreteScaledMarkovGenerator K tau f = 0 := by
  constructor
  · intro he
    rw [concreteWeightedInner_scaledGenerator] at he
    have hDzero : concreteMarkovDirichlet pi K f = 0 :=
      (mul_eq_zero.mp he).resolve_left (one_div_ne_zero (ne_of_gt hTau))
    apply (concreteScaledMarkovGenerator_zero_iff_projected pi K hInv hD hTau hWeights f).2
    funext x
    exact concreteMarkovDirichlet_zero_rigidity_of_positive_weights
      pi K hInv hD hWeights f hDzero x
  · intro hz
    rw [hz]
    change concreteMean pi (fun x => f x * 0) = 0
    simp only [mul_zero]
    exact concreteMean_zero pi

/-- The explicit constant projection vanishes exactly on mean-zero functions. -/
theorem concreteConstantProjection_eq_zero_iff
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (f : S.State -> Rat) :
    concreteConstantProjection pi f = 0 ↔ concreteMean pi f = 0 := by
  constructor
  · intro h
    have hm := congrArg (concreteMean pi) h
    change concreteMean pi (fun _ => concreteMean pi f) = concreteMean pi (fun _ => 0) at hm
    simpa only [concreteMean_const] using hm
  · intro h
    funext x
    exact h

/-- Adding the constant projection removes the generator's constant kernel.
This is an auxiliary finite linear map, not a physical Hamiltonian definition. -/
def concreteAugmentedGenerator
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (tau : Rat) :
    (S.State -> Rat) →ₗ[Rat] (S.State -> Rat) :=
  concreteScaledMarkovGenerator K tau + concreteConstantProjection pi

/-- The augmented generator preserves the constant projection. -/
theorem concreteConstantProjection_augmentedGenerator
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    (tau : Rat) (f : S.State -> Rat) :
    concreteConstantProjection pi (concreteAugmentedGenerator pi K tau f) =
      concreteConstantProjection pi f := by
  change concreteConstantProjection pi
    (concreteScaledMarkovGenerator K tau f + concreteConstantProjection pi f) = _
  rw [map_add, concreteConstantProjection_scaledMarkovGenerator pi K hInv,
    concreteConstantProjection_idempotent, zero_add]

/-- Full-support Doeblin minorization makes the augmented finite generator bijective.
Surjectivity uses finite-dimensional linear algebra, not an assumed inverse. -/
theorem concreteAugmentedGenerator_bijective
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha tau : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (hTau : 0 < tau) (hWeights : forall x, 0 < pi.weight x) :
    Function.Bijective (concreteAugmentedGenerator pi K tau) := by
  have hinj : Function.Injective (concreteAugmentedGenerator pi K tau) := by
    apply LinearMap.ker_eq_bot.mp
    apply LinearMap.ker_eq_bot'.mpr
    intro f hf
    have hP : concreteConstantProjection pi f = 0 := by
      rw [← concreteConstantProjection_augmentedGenerator pi K hInv tau f, hf, map_zero]
    have hG : concreteScaledMarkovGenerator K tau f = 0 := by
      change concreteScaledMarkovGenerator K tau f + concreteConstantProjection pi f = 0 at hf
      simpa only [hP, add_zero] using hf
    exact ((concreteScaledMarkovGenerator_zero_iff_projected pi K hInv hD hTau hWeights f).1
      hG).trans hP
  exact ⟨hinj, LinearMap.surjective_of_injective hinj⟩

/-- Every mean-zero forcing has a unique mean-zero solution of the finite Poisson
 equation `((I-P)/tau) f = g`. All hypotheses concern the actual finite kernel. -/
theorem concretePoisson_exists_unique_mean_zero
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha tau : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (hTau : 0 < tau) (hWeights : forall x, 0 < pi.weight x)
    (g : S.State -> Rat) (hg : concreteMean pi g = 0) :
    ∃! f : S.State -> Rat,
      concreteMean pi f = 0 ∧ concreteScaledMarkovGenerator K tau f = g := by
  have hbij := concreteAugmentedGenerator_bijective pi K hInv hD hTau hWeights
  obtain ⟨f, hf⟩ := hbij.2 g
  have hP : concreteConstantProjection pi f = 0 := by
    rw [← concreteConstantProjection_augmentedGenerator pi K hInv tau f, hf]
    exact (concreteConstantProjection_eq_zero_iff pi g).2 hg
  have hG : concreteScaledMarkovGenerator K tau f = g := by
    change concreteScaledMarkovGenerator K tau f + concreteConstantProjection pi f = g at hf
    simpa only [hP, add_zero] using hf
  refine ⟨f, ⟨(concreteConstantProjection_eq_zero_iff pi f).1 hP, hG⟩, ?_⟩
  intro u hu
  apply hbij.1
  rw [hf]
  change concreteScaledMarkovGenerator K tau u + concreteConstantProjection pi u = g
  rw [hu.2, (concreteConstantProjection_eq_zero_iff pi u).2 hu.1, add_zero]

/-- Exact solvability criterion: the finite Poisson equation has a solution if
and only if its forcing has zero invariant mean. Uniqueness requires fixing
the additive constant, as in the preceding theorem. -/
theorem concretePoisson_solvable_iff_mean_zero
    {S : ConcreteFiniteStateSpace.{u}} (pi : ConcreteProbabilityVectorOn S)
    (K : ConcreteMarkovKernelOn S) (hInv : ConcreteInvariantMeasure pi K)
    {alpha tau : Rat} (hD : ConcreteDoeblinMinorization pi K alpha)
    (hTau : 0 < tau) (hWeights : forall x, 0 < pi.weight x)
    (g : S.State -> Rat) :
    (∃ f : S.State -> Rat, concreteScaledMarkovGenerator K tau f = g) ↔
      concreteMean pi g = 0 := by
  constructor
  · rintro ⟨f, hf⟩
    apply (concreteConstantProjection_eq_zero_iff pi g).1
    rw [← hf]
    exact concreteConstantProjection_scaledMarkovGenerator pi K hInv tau f
  · intro hg
    obtain ⟨f, hf, _⟩ := concretePoisson_exists_unique_mean_zero pi K hInv hD hTau hWeights g hg
    exact ⟨f, hf.2⟩

end Clay
end RussoYM

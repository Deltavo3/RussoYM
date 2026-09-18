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

end Clay
end RussoYM

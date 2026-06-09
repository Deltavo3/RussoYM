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

This file is not yet the proof that Doeblin minorization implies Poincare.
It is the first real mathematical target language for that theorem.
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

Eventually this should be proved from the Doeblin minorization condition.
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

Eventually this should be derived from variance contraction.
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

This packages the real theorem we need to prove next:

Doeblin minorization
=>
variance contraction
=>
finite Poincare.

For now the implication is represented by explicit fields.  Future work should
replace the final two fields with actual theorems.
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

end Clay
end RussoYM

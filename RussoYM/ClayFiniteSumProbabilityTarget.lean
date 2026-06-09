import RussoYM.ClayFiniteProbabilityWeightTarget

/-!
# Clay Finite Sum Probability Target

This file refines the probability-weight target by replacing vague normalization
markers with named finite-sum predicates.

The previous probability-weight target had fields such as:

normalized_marker : Prop
row_normalized_marker : Prop

This file introduces explicit finite-sum predicates:

sum numerators = denominator
row sum numerators = row denominator

Status note:

This is still not full measure theory and not the real Doeblin theorem.  It is a
light finite-sum target layer.  The finite-sum operator is still abstract, but
the normalization condition is no longer just an unnamed marker.
-/

namespace RussoYM
namespace Clay

universe u

/--
Finite-sum data for a finite state space.

Future replacement: define this from an actual finite type using `Fintype` and
finite sums.
-/
structure FiniteSumDataOn (S : FiniteStateSpaceData.{u}) where
  sum_weight : (S.State -> Nat) -> Nat

/--
A probability vector is normalized when the finite sum of its numerators equals
its denominator.
-/
def ProbabilityVectorNormalized
    {S : FiniteStateSpaceData.{u}}
    (Sum : FiniteSumDataOn S)
    (v : FiniteProbabilityVectorOn S) : Prop :=
  Sum.sum_weight v.numerator = v.denominator

/--
A transition-probability target is row-normalized when each row's finite sum
equals that row's denominator.
-/
def TransitionRowsNormalized
    {S : FiniteStateSpaceData.{u}}
    (Sum : FiniteSumDataOn S)
    (P : FiniteTransitionProbabilityOn S) : Prop :=
  forall x : S.State, Sum.sum_weight (fun y => P.numerator x y) = P.denominator x

/--
Probability-vector data with an explicit finite-sum normalization predicate.
-/
structure FiniteSumProbabilityVectorOn
    (S : FiniteStateSpaceData.{u}) where
  vector : FiniteProbabilityVectorOn S
  sum_data : FiniteSumDataOn S
  normalized_by_sum : ProbabilityVectorNormalized sum_data vector

/--
Transition-probability data with an explicit finite-sum row-normalization
predicate.
-/
structure FiniteSumTransitionProbabilityOn
    (S : FiniteStateSpaceData.{u}) where
  transition : FiniteTransitionProbabilityOn S
  sum_data : FiniteSumDataOn S
  rows_normalized_by_sum : TransitionRowsNormalized sum_data transition

/--
Build the older probability-vector target from finite-sum-normalized data.

This returns data, so it is a `def`.

Important: the older `normalized_marker` field has type `Prop`, so we pass the
normalization proposition itself, not the proof of that proposition.
-/
def probabilityVector_of_finiteSumProbabilityVector
    {S : FiniteStateSpaceData.{u}}
    (v : FiniteSumProbabilityVectorOn S) :
    FiniteProbabilityVectorOn S := {
  numerator := v.vector.numerator
  denominator := v.vector.denominator
  denominator_positive_marker := v.vector.denominator_positive_marker
  normalized_marker := ProbabilityVectorNormalized v.sum_data v.vector
}

/--
Build the older transition-probability target from finite-sum-normalized data.

This returns data, so it is a `def`.

Important: the older `row_normalized_marker` field has type `Prop`, so we pass
the row-normalization proposition itself, not the proof of that proposition.
-/
def transitionProbability_of_finiteSumTransitionProbability
    {S : FiniteStateSpaceData.{u}}
    (P : FiniteSumTransitionProbabilityOn S) :
    FiniteTransitionProbabilityOn S := {
  numerator := P.transition.numerator
  denominator := P.transition.denominator
  row_denominator_positive_marker :=
    P.transition.row_denominator_positive_marker
  row_normalized_marker := TransitionRowsNormalized P.sum_data P.transition
}

/--
Finite Markov probability-kernel data with explicit finite-sum normalization
conditions.
-/
structure FiniteSumMarkovProbabilityKernelData where
  state_space : FiniteStateSpaceData.{u}
  transition_probability : FiniteSumTransitionProbabilityOn state_space
  invariant_probability : FiniteSumProbabilityVectorOn state_space
  invariant_under_kernel_marker : Prop

/--
Convert finite-sum probability-kernel data into the previous probability-weight
kernel target.

This returns data, so it is a `def`.
-/
def probabilityKernelData_of_finiteSumKernelData
    (K : FiniteSumMarkovProbabilityKernelData.{u}) :
    FiniteMarkovProbabilityKernelData.{u} := {
  state_space := K.state_space
  transition_probability :=
    transitionProbability_of_finiteSumTransitionProbability
      K.transition_probability
  invariant_probability :=
    probabilityVector_of_finiteSumProbabilityVector
      K.invariant_probability
  invariant_under_kernel_marker := K.invariant_under_kernel_marker
}

/--
Variance data attached to the finite-sum kernel target.
-/
structure FiniteSumVarianceData
    (K : FiniteSumMarkovProbabilityKernelData.{u}) where
  variance_functional_marker : Prop

/--
Doeblin data attached to the finite-sum kernel target.
-/
structure FiniteSumDoeblinData
    (K : FiniteSumMarkovProbabilityKernelData.{u}) where
  reference_probability : FiniteSumProbabilityVectorOn K.state_space
  alpha_numerator : Nat
  alpha_denominator : Nat
  alpha_positive_marker : Prop
  minorization_statement_marker : Prop
  minorization : DoeblinMinorization
  positive_alpha : PositiveDoeblinConstant

/--
Variance-contraction data attached to the finite-sum kernel target.
-/
structure FiniteSumVarianceContractionData
    (K : FiniteSumMarkovProbabilityKernelData.{u})
    (V : FiniteSumVarianceData K)
    (D : FiniteSumDoeblinData K) where
  contraction : BlockVarianceContraction
  contraction_statement_marker : Prop

/--
The finite-sum probability package for the Doeblin variance step.
-/
structure FiniteSumProbabilityMarkovDoeblinVariancePackage where
  finite_sum_kernel : FiniteSumMarkovProbabilityKernelData.{u}
  variance_data : FiniteSumVarianceData finite_sum_kernel
  doeblin_data : FiniteSumDoeblinData finite_sum_kernel
  contraction_data :
    FiniteSumVarianceContractionData
      finite_sum_kernel
      variance_data
      doeblin_data

/--
Convert the finite-sum package into the previous probability-weight package.

This returns data, so it is a `def`.
-/
def probabilityPackage_of_finiteSumPackage
    (h : FiniteSumProbabilityMarkovDoeblinVariancePackage.{u}) :
    FiniteProbabilityMarkovDoeblinVariancePackage.{u} :=
  let K : FiniteMarkovProbabilityKernelData.{u} :=
    probabilityKernelData_of_finiteSumKernelData h.finite_sum_kernel
  let V : FiniteProbabilityVarianceData K := {
    variance_functional_marker :=
      h.variance_data.variance_functional_marker
  }
  let D : FiniteProbabilityDoeblinData K := {
    reference_probability :=
      probabilityVector_of_finiteSumProbabilityVector
        h.doeblin_data.reference_probability
    alpha_numerator := h.doeblin_data.alpha_numerator
    alpha_denominator := h.doeblin_data.alpha_denominator
    alpha_positive_marker := h.doeblin_data.alpha_positive_marker
    minorization_statement_marker :=
      h.doeblin_data.minorization_statement_marker
    minorization := h.doeblin_data.minorization
    positive_alpha := h.doeblin_data.positive_alpha
  }
  let C : FiniteProbabilityVarianceContractionData K V D := {
    contraction := h.contraction_data.contraction
    contraction_statement_marker :=
      h.contraction_data.contraction_statement_marker
  }
  {
    probability_kernel := K
    variance_data := V
    doeblin_data := D
    contraction_data := C
  }

/--
The finite-sum probability package implies block Poincare through the current
target chain.
-/
theorem blockPoincare_of_finiteSumProbabilityPackage
    (h : FiniteSumProbabilityMarkovDoeblinVariancePackage.{u}) :
    BlockPoincare := by
  have hProb : FiniteProbabilityMarkovDoeblinVariancePackage.{u} :=
    probabilityPackage_of_finiteSumPackage h
  exact blockPoincare_of_probabilityPackage hProb

end Clay
end RussoYM
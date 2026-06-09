import RussoYM.ClayFiniteMarkovKernelTarget

/-!
# Clay Finite Probability Weight Target

This file refines the finite Markov-kernel target by separating raw transition
weights from probability-weight style data.

The previous target introduced:

FiniteMarkovDoeblinVariancePackage
=>
FiniteDoeblinVarianceTarget
=>
BlockPoincare

but its transition and invariant weights were still plain `Nat` fields.

This file introduces a light probability-weight abstraction:

* probability vectors with numerators and a denominator;
* transition probability rows with numerators and row denominators;
* invariant probability-vector data;
* Doeblin reference probability-vector data.

Status note:

This is still not measure theory and not real probability analysis. It is a
finite-dimensional data target that can later be upgraded to rational or
nonnegative-real probabilities.
-/

namespace RussoYM
namespace Clay

universe u

/--
A finite probability-vector target on a finite state space.

The values are represented as numerator / denominator data for now.

Future replacement: use rational, nonnegative rational, or nonnegative real
weights and prove normalization by finite sums.
-/
structure FiniteProbabilityVectorOn (S : FiniteStateSpaceData.{u}) where
  numerator : S.State -> Nat
  denominator : Nat
  denominator_positive_marker : Prop
  normalized_marker : Prop

/--
Finite transition-probability data on a finite state space.

For each source state, this stores a row of numerator data and a row
denominator.

Future replacement: use actual probabilities and prove each row sums to one.
-/
structure FiniteTransitionProbabilityOn (S : FiniteStateSpaceData.{u}) where
  numerator : S.State -> S.State -> Nat
  denominator : S.State -> Nat
  row_denominator_positive_marker : Prop
  row_normalized_marker : Prop

/--
Convert transition-probability target data into the older raw finite Markov
kernel data.

This returns data, so it is a `def`, not a theorem.
-/
def finiteMarkovKernelOn_of_transitionProbability
    {S : FiniteStateSpaceData.{u}}
    (P : FiniteTransitionProbabilityOn S) :
    FiniteMarkovKernelOn S := {
  transition_weight := P.numerator
  row_stochastic_marker := P.row_normalized_marker
}

/--
Convert finite probability-vector data into the older invariant-measure target
data.

This returns data, so it is a `def`, not a theorem.
-/
def finiteInvariantMeasureOn_of_probabilityVector
    {S : FiniteStateSpaceData.{u}}
    (mu : FiniteProbabilityVectorOn S)
    (hInvariant : Prop) :
    FiniteInvariantMeasureOn S := {
  measure_weight := mu.numerator
  probability_marker := mu.normalized_marker
  invariant_marker := hInvariant
}

/--
A probability-weight version of finite Markov-kernel data.
-/
structure FiniteMarkovProbabilityKernelData where
  state_space : FiniteStateSpaceData.{u}
  transition_probability : FiniteTransitionProbabilityOn state_space
  invariant_probability : FiniteProbabilityVectorOn state_space
  invariant_under_kernel_marker : Prop

/--
Convert probability-weight Markov-kernel data into the older finite Markov-kernel
target data.

This returns data, so it is a `def`, not a theorem.
-/
def finiteMarkovKernelData_of_probabilityKernelData
    (K : FiniteMarkovProbabilityKernelData.{u}) :
    FiniteMarkovKernelData.{u} := {
  state_space := K.state_space
  kernel :=
    finiteMarkovKernelOn_of_transitionProbability
      K.transition_probability
  invariant_measure :=
    finiteInvariantMeasureOn_of_probabilityVector
      K.invariant_probability
      K.invariant_under_kernel_marker
}

/--
Variance-functional data attached to the probability-weight kernel target.
-/
structure FiniteProbabilityVarianceData
    (K : FiniteMarkovProbabilityKernelData.{u}) where
  variance_functional_marker : Prop

/--
Doeblin minorization data attached to the probability-weight kernel target.

The reference measure is also represented as a probability vector target.
-/
structure FiniteProbabilityDoeblinData
    (K : FiniteMarkovProbabilityKernelData.{u}) where
  reference_probability : FiniteProbabilityVectorOn K.state_space
  alpha_numerator : Nat
  alpha_denominator : Nat
  alpha_positive_marker : Prop
  minorization_statement_marker : Prop
  minorization : DoeblinMinorization
  positive_alpha : PositiveDoeblinConstant

/--
Variance-contraction data attached to the probability-weight kernel target.
-/
structure FiniteProbabilityVarianceContractionData
    (K : FiniteMarkovProbabilityKernelData.{u})
    (V : FiniteProbabilityVarianceData K)
    (D : FiniteProbabilityDoeblinData K) where
  contraction : BlockVarianceContraction
  contraction_statement_marker : Prop

/--
The probability-weight finite Markov package for the Doeblin variance step.
-/
structure FiniteProbabilityMarkovDoeblinVariancePackage where
  probability_kernel : FiniteMarkovProbabilityKernelData.{u}
  variance_data : FiniteProbabilityVarianceData probability_kernel
  doeblin_data : FiniteProbabilityDoeblinData probability_kernel
  contraction_data :
    FiniteProbabilityVarianceContractionData
      probability_kernel
      variance_data
      doeblin_data

/--
Convert the probability-weight package into the previous finite Markov-kernel
package.

This returns data, so it is a `def`, not a theorem.
-/
def finiteMarkovPackage_of_probabilityPackage
    (h : FiniteProbabilityMarkovDoeblinVariancePackage.{u}) :
    FiniteMarkovDoeblinVariancePackage.{u} :=
  let K : FiniteMarkovKernelData.{u} :=
    finiteMarkovKernelData_of_probabilityKernelData h.probability_kernel
  let V : FiniteVarianceFunctionalData K := {
    variance_functional_marker :=
      h.variance_data.variance_functional_marker
  }
  let D : FiniteDoeblinMinorizationData K := {
    minorization := h.doeblin_data.minorization
    positive_alpha := h.doeblin_data.positive_alpha
    minorization_statement_marker :=
      h.doeblin_data.minorization_statement_marker
  }
  let C : FiniteVarianceContractionData K V D := {
    contraction := h.contraction_data.contraction
    contraction_statement_marker :=
      h.contraction_data.contraction_statement_marker
  }
  {
    kernel_data := K
    variance_data := V
    doeblin_data := D
    contraction_data := C
  }

/--
The probability-weight package implies block Poincare through the current target
chain.
-/
theorem blockPoincare_of_probabilityPackage
    (h : FiniteProbabilityMarkovDoeblinVariancePackage.{u}) :
    BlockPoincare := by
  have hFinite : FiniteMarkovDoeblinVariancePackage.{u} :=
    finiteMarkovPackage_of_probabilityPackage h
  exact blockPoincare_of_finiteMarkovPackage hFinite

end Clay
end RussoYM
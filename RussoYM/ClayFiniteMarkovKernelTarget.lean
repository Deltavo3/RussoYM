import RussoYM.ClayDoeblinVarianceTarget

/-!
# Clay Finite Markov Kernel Target

This file makes the Doeblin variance replacement target less abstract.

The previous target was:

FiniteDoeblinVarianceTarget
=>
BlockPoincare

but it still described "finite Markov kernel data" only in prose.

This file introduces named Lean data structures for:

* finite state space data;
* finite Markov kernel data;
* invariant measure data;
* variance functional data;
* Doeblin minorization data;
* variance contraction data.

Status note:

This file still does not prove the real finite-dimensional Markov-kernel theorem.
It only names the data that the future theorem must use.
-/

namespace RussoYM
namespace Clay

universe u

/--
Finite state-space data.

Future replacement: use an actual finite type, probably with `[Fintype State]`
and `[DecidableEq State]` once we import the needed Mathlib infrastructure.
-/
structure FiniteStateSpaceData where
  State : Type u
  finite_state_marker : Prop

/--
Finite Markov kernel data on a finite state-space.

The transition weights are currently represented abstractly by a function into
`Nat` to avoid introducing measure theory too early.

Future replacement: use nonnegative real transition probabilities and prove the
row-stochastic condition.
-/
structure FiniteMarkovKernelOn (S : FiniteStateSpaceData.{u}) where
  transition_weight : S.State -> S.State -> Nat
  row_stochastic_marker : Prop

/--
Invariant measure data for a finite Markov kernel.

Future replacement: use a probability vector and prove invariance under the
kernel.
-/
structure FiniteInvariantMeasureOn (S : FiniteStateSpaceData.{u}) where
  measure_weight : S.State -> Nat
  probability_marker : Prop
  invariant_marker : Prop

/--
Packaged finite Markov kernel data.
-/
structure FiniteMarkovKernelData where
  state_space : FiniteStateSpaceData.{u}
  kernel : FiniteMarkovKernelOn state_space
  invariant_measure : FiniteInvariantMeasureOn state_space

/--
Variance functional data attached to a finite Markov kernel.

Future replacement: define the actual variance functional

Var_mu(f) = int (f - int f dmu)^2 dmu

in finite-sum form.
-/
structure FiniteVarianceFunctionalData (K : FiniteMarkovKernelData.{u}) where
  variance_functional_marker : Prop

/--
Doeblin minorization data attached to a finite Markov kernel.

Future replacement: state the actual minorization inequality

K(x, y) >= alpha * nu(y)

for all states x,y, with alpha > 0.
-/
structure FiniteDoeblinMinorizationData (K : FiniteMarkovKernelData.{u}) where
  minorization : DoeblinMinorization
  positive_alpha : PositiveDoeblinConstant
  minorization_statement_marker : Prop

/--
Variance contraction data attached to a finite Markov kernel.

Future replacement: prove the real estimate from the Doeblin minorization.
-/
structure FiniteVarianceContractionData
    (K : FiniteMarkovKernelData.{u})
    (V : FiniteVarianceFunctionalData K)
    (D : FiniteDoeblinMinorizationData K) where
  contraction : BlockVarianceContraction
  contraction_statement_marker : Prop

/--
The finite Markov-kernel proof package for the Doeblin variance step.

This is the first named object that contains the future concrete data needed to
replace the pure placeholder.
-/
structure FiniteMarkovDoeblinVariancePackage where
  kernel_data : FiniteMarkovKernelData.{u}
  variance_data : FiniteVarianceFunctionalData kernel_data
  doeblin_data : FiniteDoeblinMinorizationData kernel_data
  contraction_data :
    FiniteVarianceContractionData
      kernel_data
      variance_data
      doeblin_data

/--
Convert the finite Markov-kernel package into the previous replacement target.
-/
theorem finiteDoeblinVarianceTarget_of_finiteMarkovPackage
    (h : FiniteMarkovDoeblinVariancePackage.{u}) :
    FiniteDoeblinVarianceTarget := by
  exact {
    doeblin_minorization := h.doeblin_data.minorization
    positive_alpha := h.doeblin_data.positive_alpha
    variance_contraction := h.contraction_data.contraction
  }

/--
The finite Markov-kernel package implies block Poincare through the current
target layer.
-/
theorem blockPoincare_of_finiteMarkovPackage
    (h : FiniteMarkovDoeblinVariancePackage.{u}) :
    BlockPoincare := by
  have hTarget : FiniteDoeblinVarianceTarget :=
    finiteDoeblinVarianceTarget_of_finiteMarkovPackage h
  exact blockPoincare_of_finiteDoeblinVarianceTarget hTarget

end Clay
end RussoYM
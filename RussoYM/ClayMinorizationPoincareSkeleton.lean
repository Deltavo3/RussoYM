import RussoYM.ClayKernelPositivitySkeleton

/-!
# Clay Minorization to Block Poincare Skeleton

This file refines the finite-dimensional step:

finite-regulator block minorization
=>
block Poincare.

Mathematically, this is the Doeblin/minorization route:

K(x,dy) >= alpha nu(dy)
=>
variance contraction for the block Markov kernel
=>
positive block spectral gap
=>
block Poincare inequality.

This file keeps the actual Markov-kernel analytic content as named assumptions,
but makes the dependency chain explicit and compiled.
-/

namespace RussoYM
namespace Clay

/-- A block kernel satisfies a Doeblin/reference-measure minorization. -/
structure DoeblinMinorization : Prop where
  doeblin_minorization : True

/-- The Doeblin minorization has a positive minorization constant. -/
structure PositiveDoeblinConstant : Prop where
  positive_alpha : True

/-- The block Markov kernel contracts variance after one block step. -/
structure BlockVarianceContraction : Prop where
  variance_contracts : True

/-- The block semigroup has a positive spectral gap. -/
structure PositiveBlockSpectralGap : Prop where
  positive_block_gap : True

/--
The refined finite-dimensional minorization package.

This is the skeleton version of the route:

minorization + positive alpha
=>
variance contraction
=>
positive block spectral gap
=>
block Poincare.
-/
structure MinorizationPoincareSkeleton : Prop where
  doeblin_minorization : DoeblinMinorization
  positive_alpha : PositiveDoeblinConstant

/-- Doeblin minorization plus positive alpha gives variance contraction. -/
axiom varianceContraction_of_doeblin :
  DoeblinMinorization ->
  PositiveDoeblinConstant ->
  BlockVarianceContraction

/-- Variance contraction gives a positive block spectral gap. -/
axiom positiveBlockGap_of_varianceContraction :
  BlockVarianceContraction ->
  PositiveBlockSpectralGap

/-- Positive block spectral gap gives block Poincare. -/
axiom blockPoincare_of_positiveBlockGap :
  PositiveBlockSpectralGap ->
  BlockPoincare

/-- The refined minorization skeleton gives block Poincare. -/
theorem blockPoincare_of_minorizationPoincareSkeleton
    (h : MinorizationPoincareSkeleton) :
    BlockPoincare := by
  have hVar : BlockVarianceContraction :=
    varianceContraction_of_doeblin h.doeblin_minorization h.positive_alpha
  have hGap : PositiveBlockSpectralGap :=
    positiveBlockGap_of_varianceContraction hVar
  exact blockPoincare_of_positiveBlockGap hGap

/--
Connect the kernel positivity skeleton to the minorization/Poincare route.

The kernel positivity skeleton already gives finite-regulator kernel minorization.
This theorem records the next named step needed to turn that into block Poincare.
-/
structure KernelToBlockPoincareSkeleton : Prop where
  kernel_skeleton : KernelPositivitySkeleton
  doeblin_from_kernel_minorization : DoeblinMinorization
  positive_doeblin_constant : PositiveDoeblinConstant

/-- Kernel positivity plus Doeblin data gives block Poincare. -/
theorem blockPoincare_of_kernelToBlockPoincareSkeleton
    (h : KernelToBlockPoincareSkeleton) :
    BlockPoincare := by
  have hMinor : FiniteRegulatorKernelMinorization :=
    finiteMinorization_of_kernelPositivitySkeleton h.kernel_skeleton
  have hDoeblin : DoeblinMinorization := h.doeblin_from_kernel_minorization
  have hAlpha : PositiveDoeblinConstant := h.positive_doeblin_constant
  exact blockPoincare_of_minorizationPoincareSkeleton {
    doeblin_minorization := hDoeblin
    positive_alpha := hAlpha
  }

/--
A version of obligation B that also carries the block Poincare consequence.

This does not replace the global endpoint yet. It records the local implication:

kernel positivity skeleton
+
Doeblin conversion data
=>
BlockKernelConvergencePositivity and BlockPoincare.
-/
structure KernelPositivityWithBlockPoincare : Prop where
  kernel_to_poincare : KernelToBlockPoincareSkeleton

/-- Extract obligation B from the refined package. -/
theorem blockKernelConvergencePositivity_of_kernelPoincarePackage
    (h : KernelPositivityWithBlockPoincare) :
    BlockKernelConvergencePositivity := by
  exact blockKernelConvergencePositivity_of_kernelPositivitySkeleton
    h.kernel_to_poincare.kernel_skeleton

/-- Extract block Poincare from the refined package. -/
theorem blockPoincare_of_kernelPoincarePackage
    (h : KernelPositivityWithBlockPoincare) :
    BlockPoincare := by
  exact blockPoincare_of_kernelToBlockPoincareSkeleton h.kernel_to_poincare

end Clay
end RussoYM
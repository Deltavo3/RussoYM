import RussoYM.ClayEightObligations

/-!
# Clay Kernel Positivity Skeleton

This file begins refining obligation B:

B: block kernel convergence and positivity.

The purpose is to split B into smaller finite-dimensional/probability pieces:

1. compact block sector;
2. C1 kernel convergence;
3. strict positivity of the limiting kernel;
4. compactness plus strict positivity gives a positive lower bound;
5. C1 convergence plus positive lower bound gives finite-regulator minorization.

This is still a skeleton.  The analytic/topological content is represented by
named propositions and axioms, but the dependency structure is now explicit.
-/

namespace RussoYM
namespace Clay

/-- The relevant block sector is compact and connected. -/
structure CompactConnectedBlockSector : Prop where
  compact_sector : True
  connected_sector : True

/-- The finite-regulator block kernels converge in C1 to the limiting kernel. -/
structure C1KernelConvergence : Prop where
  c1_kernel_convergence : True

/-- The limiting block kernel is strictly positive on the connected sector. -/
structure StrictPositiveLimitKernel : Prop where
  strict_positive_limit_kernel : True

/-- The limiting kernel has a positive uniform lower bound on the compact sector. -/
structure PositiveKernelLowerBound : Prop where
  positive_lower_bound : True

/-- The finite-regulator kernels satisfy a reference-measure minorization. -/
structure FiniteRegulatorKernelMinorization : Prop where
  finite_regulator_minorization : True

/--
Compactness plus strict positivity gives a positive lower bound.

Mathematically, this is the compactness step:

continuous positive function on compact space
=>
positive minimum.
-/
axiom positiveLowerBound_of_compact_strictPositive :
  CompactConnectedBlockSector ->
  StrictPositiveLimitKernel ->
  PositiveKernelLowerBound

/--
C1 convergence plus a positive limiting lower bound gives finite-regulator
minorization for all sufficiently large regulators.
-/
axiom finiteMinorization_of_c1_lowerBound :
  C1KernelConvergence ->
  PositiveKernelLowerBound ->
  FiniteRegulatorKernelMinorization

/-- The refined kernel-positivity package for obligation B. -/
structure KernelPositivitySkeleton : Prop where
  compact_connected_sector : CompactConnectedBlockSector
  c1_convergence : C1KernelConvergence
  strict_positive_limit : StrictPositiveLimitKernel

/-- The refined kernel-positivity package gives finite-regulator minorization. -/
theorem finiteMinorization_of_kernelPositivitySkeleton
    (h : KernelPositivitySkeleton) :
    FiniteRegulatorKernelMinorization := by
  have hLower : PositiveKernelLowerBound :=
    positiveLowerBound_of_compact_strictPositive
      h.compact_connected_sector
      h.strict_positive_limit
  exact finiteMinorization_of_c1_lowerBound h.c1_convergence hLower

/--
The refined kernel-positivity package assembles into obligation B from the
eight-obligation endpoint.
-/
theorem blockKernelConvergencePositivity_of_kernelPositivitySkeleton
    (h : KernelPositivitySkeleton) :
    BlockKernelConvergencePositivity := by
  have hMinor : FiniteRegulatorKernelMinorization :=
    finiteMinorization_of_kernelPositivitySkeleton h
  exact {
    c1_kernel_convergence := h.c1_convergence.c1_kernel_convergence
    strict_limit_kernel_positivity :=
      h.strict_positive_limit.strict_positive_limit_kernel
    finite_regulator_minorization := hMinor.finite_regulator_minorization
  }

/--
A version of the eight obligations where obligation B is replaced by the
more detailed kernel-positivity skeleton.
-/
structure ClayEightObligationsWithKernelSkeleton : Prop where
  A_fixed_scale_limits : FixedScaleWilsonBlockLimits
  B_kernel_skeleton : KernelPositivitySkeleton
  C_potential_regular : RenormalizedBlockPotentialRegularity
  D_irrelevant_remainder : CTwoIrrelevantRemainderControl
  E_quasi_local_boundary : QuasiLocalBoundaryInfluence
  F1_liminf : MoscoLiminfInput
  F2_recovery : MoscoRecoveryInput
  F3_vacuum : VacuumProjectionConvergenceInput

/--
Convert the refined eight-obligation package into the previous eight-obligation
package.
-/
theorem eightObligations_of_kernelSkeleton
    (h : ClayEightObligationsWithKernelSkeleton) :
    ClayEightObligations := by
  have hB : BlockKernelConvergencePositivity :=
    blockKernelConvergencePositivity_of_kernelPositivitySkeleton h.B_kernel_skeleton
  exact {
    A_fixed_scale_limits := h.A_fixed_scale_limits
    B_kernel_convergence_positive := hB
    C_potential_regular := h.C_potential_regular
    D_irrelevant_remainder := h.D_irrelevant_remainder
    E_quasi_local_boundary := h.E_quasi_local_boundary
    F1_liminf := h.F1_liminf
    F2_recovery := h.F2_recovery
    F3_vacuum := h.F3_vacuum
  }

/--
The refined kernel skeleton plus the other seven obligations imply the continuum
mass gap endpoint.
-/
theorem continuumMassGap_of_kernelSkeletonObligations
    (C : BlockRGConstants)
    (h : ClayEightObligationsWithKernelSkeleton) :
    ContinuumMassGap C := by
  have hEight : ClayEightObligations :=
    eightObligations_of_kernelSkeleton h
  exact continuumMassGap_of_eightObligations C hEight

/--
The refined kernel skeleton plus the other seven obligations imply strict
positivity of the final gap constant.
-/
theorem continuumGapPositive_of_kernelSkeletonObligations
    (C : BlockRGConstants)
    (h : ClayEightObligationsWithKernelSkeleton) :
    0 < C.massGapConstant := by
  have hGap : ContinuumMassGap C :=
    continuumMassGap_of_kernelSkeletonObligations C h
  exact hGap.positive_gap

end Clay
end RussoYM
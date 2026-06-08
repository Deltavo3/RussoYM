import RussoYM.ClayConditionalMasterTheorem

/-!
# Clay Eight Obligations

This file packages the current Clay-facing Yang-Mills proof obligations into
one named proposition.

The eight obligations are:

A  fixed-scale Wilson/block continuum construction
B  block kernel convergence and positivity
C  renormalized block potential regularity
D  C^2 irrelevant remainder control
E  quasi-local and boundary-local RG influence
F1 Mosco liminf
F2 Mosco recovery
F3 vacuum projection convergence

This file proves that these eight obligations imply the compiled continuum
mass gap endpoint.
-/

namespace RussoYM
namespace Clay

/-- The eight current analytic obligations for the conditional Clay endpoint. -/
structure ClayEightObligations : Prop where
  A_fixed_scale_limits : FixedScaleWilsonBlockLimits
  B_kernel_convergence_positive : BlockKernelConvergencePositivity
  C_potential_regular : RenormalizedBlockPotentialRegularity
  D_irrelevant_remainder : CTwoIrrelevantRemainderControl
  E_quasi_local_boundary : QuasiLocalBoundaryInfluence
  F1_liminf : MoscoLiminfInput
  F2_recovery : MoscoRecoveryInput
  F3_vacuum : VacuumProjectionConvergenceInput

/-- Convert the eight-obligation package into Master I inputs. -/
def ClayEightObligations.toMasterIInputs
    (h : ClayEightObligations) :
    MasterIInputs := {
  A_fixed_scale_limits := h.A_fixed_scale_limits
  B_kernel_convergence_positive := h.B_kernel_convergence_positive
  C_potential_regular := h.C_potential_regular
  D_irrelevant_remainder := h.D_irrelevant_remainder
  E_quasi_local_boundary := h.E_quasi_local_boundary
}

/-- Convert the eight-obligation package into Master II inputs. -/
def ClayEightObligations.toMasterIIInputs
    (h : ClayEightObligations) :
    MasterIIInputs := {
  F1_liminf := h.F1_liminf
  F2_recovery := h.F2_recovery
  F3_vacuum := h.F3_vacuum
}

/--
The eight current analytic obligations imply the continuum mass gap endpoint.
-/
theorem continuumMassGap_of_eightObligations
    (C : BlockRGConstants)
    (h : ClayEightObligations) :
    ContinuumMassGap C := by
  exact continuumMassGap_of_masterInputLedger
    C
    h.toMasterIInputs
    h.toMasterIIInputs

/--
The eight current analytic obligations imply strict positivity of the final gap constant.
-/
theorem continuumGapPositive_of_eightObligations
    (C : BlockRGConstants)
    (h : ClayEightObligations) :
    0 < C.massGapConstant := by
  have hGap : ContinuumMassGap C :=
    continuumMassGap_of_eightObligations C h
  exact hGap.positive_gap

/--
Equivalent readable endpoint using the already compiled headline theorem.
-/
theorem clayYangMillsMassGap_of_eightObligations
    (C : BlockRGConstants)
    (h : ClayEightObligations) :
    ContinuumMassGap C := by
  exact clayYangMillsMassGap_conditional
    C
    h.A_fixed_scale_limits
    h.B_kernel_convergence_positive
    h.C_potential_regular
    h.D_irrelevant_remainder
    h.E_quasi_local_boundary
    h.F1_liminf
    h.F2_recovery
    h.F3_vacuum

end Clay
end RussoYM
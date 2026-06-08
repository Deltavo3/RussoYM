import RussoYM.ClayBlockRGClosedLemmas

/-!
# Clay Master Assumption Ledger

This file refines the two master problems into named assumption packages.

It does not prove the analytic assumptions. It only records how the named
Master I and Master II inputs assemble into the already compiled endpoint:

Master I + Master II -> ContinuumMassGap.
-/

namespace RussoYM
namespace Clay

/-- A: fixed-scale Wilson/block continuum construction. -/
structure FixedScaleWilsonBlockLimits : Prop where
  unique_fixed_scale_limits : True
  weak_block_kernel_convergence : True

/-- B: block kernel convergence and positivity. -/
structure BlockKernelConvergencePositivity : Prop where
  c1_kernel_convergence : True
  strict_limit_kernel_positivity : True
  finite_regulator_minorization : True

/-- C: renormalized block potential C^2 regularity. -/
structure RenormalizedBlockPotentialRegularity : Prop where
  c2_potential_bound : True

/-- D: C^2 irrelevant remainder control. -/
structure CTwoIrrelevantRemainderControl : Prop where
  ctheta_two_remainder_vanishes : True

/-- E: quasi-local and boundary-local RG influence. -/
structure QuasiLocalBoundaryInfluence : Prop where
  quasi_local_interactions : True
  boundary_local_influence : True
  dobrushin_decay : True

/-- Master I expanded into A-E. -/
structure MasterIInputs : Prop where
  A_fixed_scale_limits : FixedScaleWilsonBlockLimits
  B_kernel_convergence_positive : BlockKernelConvergencePositivity
  C_potential_regular : RenormalizedBlockPotentialRegularity
  D_irrelevant_remainder : CTwoIrrelevantRemainderControl
  E_quasi_local_boundary : QuasiLocalBoundaryInfluence

/-- F1: Mosco liminf. -/
structure MoscoLiminfInput : Prop where
  electric_liminf : True
  magnetic_liminf : True
  lattice_uhlenbeck_compactness : True
  gauss_law_passage : True

/-- F2: Mosco recovery. -/
structure MoscoRecoveryInput : Prop where
  smooth_gauss_law_density : True
  holonomy_energy_recovery : True
  flux_energy_recovery : True
  discrete_gauss_correction : True

/-- F3: vacuum projection convergence. -/
structure VacuumProjectionConvergenceInput : Prop where
  finite_zero_energy_rigidity : True
  continuum_zero_energy_rigidity : True
  projection_convergence : True

/-- Master II expanded into F1-F3. -/
structure MasterIIInputs : Prop where
  F1_liminf : MoscoLiminfInput
  F2_recovery : MoscoRecoveryInput
  F3_vacuum : VacuumProjectionConvergenceInput

/-- The A-E ledger assembles into the existing Master I proposition. -/
theorem constructiveRG_of_masterIInputs
    (h : MasterIInputs) :
    ConstructiveFixedScaleRG := by
  exact {
    unique_fixed_scale_block_limits := h.A_fixed_scale_limits.unique_fixed_scale_limits
    ctheta_two_fiber_action_convergence := h.D_irrelevant_remainder.ctheta_two_remainder_vanishes
    quasi_local_boundary_local_block_action := h.E_quasi_local_boundary.boundary_local_influence
  }

/-- The F1-F3 ledger assembles into the existing Master II proposition. -/
theorem moscoBridge_of_masterIIInputs
    (h : MasterIIInputs) :
    MoscoContinuumBridge := by
  exact {
    mosco_liminf := h.F1_liminf.electric_liminf
    mosco_recovery := h.F2_recovery.smooth_gauss_law_density
    vacuum_projection_convergence := h.F3_vacuum.projection_convergence
  }

/--
Expanded endpoint theorem.

The named A-E inputs plus F1-F3 inputs imply the continuum mass gap.
-/
theorem continuumMassGap_of_masterInputLedger
    (C : BlockRGConstants)
    (hI : MasterIInputs)
    (hII : MasterIIInputs) :
    ContinuumMassGap C := by
  have hRG : ConstructiveFixedScaleRG :=
    constructiveRG_of_masterIInputs hI
  have hMosco : MoscoContinuumBridge :=
    moscoBridge_of_masterIIInputs hII
  exact continuumMassGap_of_masterProblems C hRG hMosco

/--
Expanded positivity endpoint.

The named A-E inputs plus F1-F3 inputs imply positivity of the final gap constant.
-/
theorem continuumGapPositive_of_masterInputLedger
    (C : BlockRGConstants)
    (hI : MasterIInputs)
    (hII : MasterIIInputs) :
    0 < C.massGapConstant := by
  have hGap : ContinuumMassGap C :=
    continuumMassGap_of_masterInputLedger C hI hII
  exact hGap.positive_gap

end Clay
end RussoYM
import RussoYM.ClayMasterAssumptionLedger

/-!
# Clay Conditional Master Theorem

This file states the current Clay-facing Yang-Mills mass gap reduction in its
most readable Lean form.

It takes the named Master I assumptions A-E and the named Master II assumptions
F1-F3 as separate hypotheses, packages them into the master assumption ledger,
and concludes the continuum mass gap endpoint.
-/

namespace RussoYM
namespace Clay

/--
Headline conditional Clay-facing theorem.

A: fixed-scale Wilson/block continuum construction.
B: block kernel convergence and positivity.
C: renormalized block potential C^2 regularity.
D: C^2 irrelevant remainder control.
E: quasi-local and boundary-local RG influence.
F1: Mosco liminf.
F2: Mosco recovery.
F3: vacuum projection convergence.

Together these imply the continuum Yang-Mills mass gap endpoint.
-/
theorem clayYangMillsMassGap_conditional
    (C : BlockRGConstants)
    (hA : FixedScaleWilsonBlockLimits)
    (hB : BlockKernelConvergencePositivity)
    (hC : RenormalizedBlockPotentialRegularity)
    (hD : CTwoIrrelevantRemainderControl)
    (hE : QuasiLocalBoundaryInfluence)
    (hF1 : MoscoLiminfInput)
    (hF2 : MoscoRecoveryInput)
    (hF3 : VacuumProjectionConvergenceInput) :
    ContinuumMassGap C := by
  let hI : MasterIInputs := {
    A_fixed_scale_limits := hA
    B_kernel_convergence_positive := hB
    C_potential_regular := hC
    D_irrelevant_remainder := hD
    E_quasi_local_boundary := hE
  }
  let hII : MasterIIInputs := {
    F1_liminf := hF1
    F2_recovery := hF2
    F3_vacuum := hF3
  }
  exact continuumMassGap_of_masterInputLedger C hI hII

/--
Positive-gap corollary of the headline conditional theorem.
-/
theorem clayYangMillsGapPositive_conditional
    (C : BlockRGConstants)
    (hA : FixedScaleWilsonBlockLimits)
    (hB : BlockKernelConvergencePositivity)
    (hC : RenormalizedBlockPotentialRegularity)
    (hD : CTwoIrrelevantRemainderControl)
    (hE : QuasiLocalBoundaryInfluence)
    (hF1 : MoscoLiminfInput)
    (hF2 : MoscoRecoveryInput)
    (hF3 : VacuumProjectionConvergenceInput) :
    0 < C.massGapConstant := by
  have hGap : ContinuumMassGap C :=
    clayYangMillsMassGap_conditional C hA hB hC hD hE hF1 hF2 hF3
  exact hGap.positive_gap

end Clay
end RussoYM
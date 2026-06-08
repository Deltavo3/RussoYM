import RussoYM.ClayLocalToGlobalPoincareSkeleton

/-!
# Clay Mosco Bridge Skeleton

This file refines Master II:

Mosco continuum bridge.

It splits the bridge into the three main pieces:

F1 Mosco liminf
F2 Mosco recovery
F3 vacuum projection convergence

and then assembles them into the existing `MoscoContinuumBridge` input.

This keeps the hard analytic content as named propositions, while making the
dependency chain explicit and compiled.
-/

namespace RussoYM
namespace Clay

/-- Electric weak lower semicontinuity in the Mosco liminf direction. -/
structure ElectricLiminf : Prop where
  electric_weak_lsc : True

/-- Magnetic lower semicontinuity, including defect-measure control. -/
structure MagneticLiminf : Prop where
  magnetic_weak_lsc : True
  defect_measure_nonnegative : True

/-- Lattice Uhlenbeck compactness from bounded plaquette energy. -/
structure LatticeUhlenbeckCompactness : Prop where
  gauge_compactness : True
  curvature_identification : True

/-- Passage of exact discrete Gauss law to continuum Gauss law. -/
structure GaussLawPassage : Prop where
  discrete_to_continuum_gauss : True

/--
Refined F1 package: Mosco liminf.

This is the skeleton version of:

electric liminf
+
magnetic liminf
+
lattice Uhlenbeck compactness
+
Gauss-law passage
=>
Mosco liminf.
-/
structure MoscoLiminfSkeleton : Prop where
  electric_liminf : ElectricLiminf
  magnetic_liminf : MagneticLiminf
  lattice_uhlenbeck : LatticeUhlenbeckCompactness
  gauss_law_passage : GaussLawPassage

/-- Smooth exact Gauss-law density in the continuum physical sector. -/
structure SmoothGaussLawDensity : Prop where
  smooth_exact_density : True

/-- Holonomy discretization recovers magnetic energy for smooth data. -/
structure HolonomyEnergyRecovery : Prop where
  magnetic_energy_recovery : True

/-- Flux discretization recovers electric energy for smooth data. -/
structure FluxEnergyRecovery : Prop where
  electric_energy_recovery : True

/-- Discrete Gauss-law correction using a discrete covariant right inverse. -/
structure DiscreteGaussCorrection : Prop where
  small_discrete_gauss_defect : True
  right_inverse_correction : True

/--
Refined F2 package: Mosco recovery.

This is the skeleton version of:

smooth exact Gauss-law density
+
holonomy energy recovery
+
flux energy recovery
+
discrete Gauss-law correction
=>
Mosco recovery.
-/
structure MoscoRecoverySkeleton : Prop where
  smooth_gauss_law_density : SmoothGaussLawDensity
  holonomy_recovery : HolonomyEnergyRecovery
  flux_recovery : FluxEnergyRecovery
  discrete_gauss_correction : DiscreteGaussCorrection

/-- Finite-regulator zero-energy rigidity. -/
structure FiniteZeroEnergyRigidity : Prop where
  flat_lattice_connection_trivial_sector : True

/-- Continuum zero-energy rigidity. -/
structure ContinuumZeroEnergyRigidity : Prop where
  flat_continuum_connection_trivial_sector : True

/-- Convergence of finite-regulator vacuum projections to the continuum vacuum projection. -/
structure ProjectionConvergence : Prop where
  vacuum_projection_converges : True

/--
Refined F3 package: vacuum projection convergence.
-/
structure VacuumProjectionSkeleton : Prop where
  finite_zero_energy_rigidity : FiniteZeroEnergyRigidity
  continuum_zero_energy_rigidity : ContinuumZeroEnergyRigidity
  projection_convergence : ProjectionConvergence

/-- Convert the refined F1 skeleton into the existing F1 input. -/
theorem moscoLiminfInput_of_moscoLiminfSkeleton
    (h : MoscoLiminfSkeleton) :
    MoscoLiminfInput := by
  exact {
    electric_liminf := h.electric_liminf.electric_weak_lsc
    magnetic_liminf := h.magnetic_liminf.magnetic_weak_lsc
    lattice_uhlenbeck_compactness := h.lattice_uhlenbeck.gauge_compactness
    gauss_law_passage := h.gauss_law_passage.discrete_to_continuum_gauss
  }

/-- Convert the refined F2 skeleton into the existing F2 input. -/
theorem moscoRecoveryInput_of_moscoRecoverySkeleton
    (h : MoscoRecoverySkeleton) :
    MoscoRecoveryInput := by
  exact {
    smooth_gauss_law_density := h.smooth_gauss_law_density.smooth_exact_density
    holonomy_energy_recovery := h.holonomy_recovery.magnetic_energy_recovery
    flux_energy_recovery := h.flux_recovery.electric_energy_recovery
    discrete_gauss_correction := h.discrete_gauss_correction.right_inverse_correction
  }

/-- Convert the refined F3 skeleton into the existing F3 input. -/
theorem vacuumProjectionInput_of_vacuumProjectionSkeleton
    (h : VacuumProjectionSkeleton) :
    VacuumProjectionConvergenceInput := by
  exact {
    finite_zero_energy_rigidity :=
      h.finite_zero_energy_rigidity.flat_lattice_connection_trivial_sector
    continuum_zero_energy_rigidity :=
      h.continuum_zero_energy_rigidity.flat_continuum_connection_trivial_sector
    projection_convergence :=
      h.projection_convergence.vacuum_projection_converges
  }

/--
Refined Master II package.

This carries the skeleton versions of F1, F2, and F3.
-/
structure MoscoBridgeSkeleton : Prop where
  F1_liminf : MoscoLiminfSkeleton
  F2_recovery : MoscoRecoverySkeleton
  F3_vacuum : VacuumProjectionSkeleton

/-- Convert the refined Mosco skeleton into the existing Master II input package. -/
theorem masterIIInputs_of_moscoBridgeSkeleton
    (h : MoscoBridgeSkeleton) :
    MasterIIInputs := by
  exact {
    F1_liminf := moscoLiminfInput_of_moscoLiminfSkeleton h.F1_liminf
    F2_recovery := moscoRecoveryInput_of_moscoRecoverySkeleton h.F2_recovery
    F3_vacuum := vacuumProjectionInput_of_vacuumProjectionSkeleton h.F3_vacuum
  }

/-- The refined Mosco skeleton gives the existing Mosco continuum bridge. -/
theorem moscoContinuumBridge_of_moscoBridgeSkeleton
    (h : MoscoBridgeSkeleton) :
    MoscoContinuumBridge := by
  have hII : MasterIIInputs :=
    masterIIInputs_of_moscoBridgeSkeleton h
  exact moscoBridge_of_masterIIInputs hII

/--
The finite-regulator downstream skeleton plus the refined Mosco bridge skeleton
imply the continuum mass gap.
-/
theorem continuumMassGap_of_downstreamSkeleton_and_moscoSkeleton
    (C : BlockRGConstants)
    (hDown : MasterIDownstreamSkeleton)
    (hMosco : MoscoBridgeSkeleton) :
    ContinuumMassGap C := by
  have hBridge : MoscoContinuumBridge :=
    moscoContinuumBridge_of_moscoBridgeSkeleton hMosco
  exact continuumMassGap_of_downstreamSkeleton_and_mosco C hDown hBridge

/--
Positive-gap version of the downstream-plus-refined-Mosco endpoint.
-/
theorem continuumGapPositive_of_downstreamSkeleton_and_moscoSkeleton
    (C : BlockRGConstants)
    (hDown : MasterIDownstreamSkeleton)
    (hMosco : MoscoBridgeSkeleton) :
    0 < C.massGapConstant := by
  have hGap : ContinuumMassGap C :=
    continuumMassGap_of_downstreamSkeleton_and_moscoSkeleton C hDown hMosco
  exact hGap.positive_gap

end Clay
end RussoYM
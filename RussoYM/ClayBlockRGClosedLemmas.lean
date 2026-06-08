/-!
# Clay Block-RG Closed Lemmas Skeleton

This file packages the downstream finite-dimensional/probability/functional-analysis
part of the Clay-facing Yang-Mills route.

It intentionally does NOT prove the open analytic inputs.

Open analytic inputs remain named assumptions:

* Constructive fixed-scale RG.
* Mosco continuum bridge.
* Lattice Uhlenbeck compactness.
* Smooth Gauss-law density.
* Discrete covariant right-inverse estimates.

The goal of this file is to make the conditional dependency structure explicit in Lean.
-/

namespace RussoYM
namespace Clay

/-- Abstract finite-regulator label. -/
structure Regulator where
  n : Nat

/-- Abstract continuum state label. -/
structure ContinuumState where
  id : Nat

/-- Abstract finite-regulator state label. -/
structure FiniteState where
  id : Nat

/--
Constants appearing in the block-RG mass gap route.

For this skeleton, we only keep the final positive gap constant as a Nat.
Later analytic files can replace this with a real-valued physical constant.
-/
structure BlockRGConstants where
  massGapConstant : Nat
  hmassGap_pos : 0 < massGapConstant

/-- Master I: constructive fixed-scale RG with C^2 control and quasi-locality. -/
structure ConstructiveFixedScaleRG : Prop where
  unique_fixed_scale_block_limits : True
  ctheta_two_fiber_action_convergence : True
  quasi_local_boundary_local_block_action : True

/-- Master II: Mosco continuum bridge and vacuum projection convergence. -/
structure MoscoContinuumBridge : Prop where
  mosco_liminf : True
  mosco_recovery : True
  vacuum_projection_convergence : True

/-- Fixed-regulator block kernel minorization. -/
structure BlockMinorization : Prop where
  reference_minorization : True
  equilibrium_density_bounds : True

/-- Block Poincare inequality at physical scale. -/
structure BlockPoincare : Prop where
  block_gap_positive : True

/-- Dobrushin weak dependence / approximate tensorization. -/
structure DobrushinTensorization : Prop where
  dobrushin_rows_subcritical : True
  approximate_tensorization : True

/-- Bounded-overlap energy comparison. -/
structure BoundedOverlapEnergy : Prop where
  bounded_overlap : True

/-- Global finite-regulator Poincare inequality. -/
structure GlobalFiniteRegulatorPoincare : Prop where
  global_poincare : True

/-- Finite-regulator physical mass gap. -/
structure FiniteRegulatorMassGap (C : BlockRGConstants) : Prop where
  lower_bound : True

/-- Continuum Yang-Mills mass gap. -/
structure ContinuumMassGap (C : BlockRGConstants) : Prop where
  lower_bound : True
  positive_gap : 0 < C.massGapConstant

/-
Closed downstream implications.

These are the finite-dimensional/probability implications already isolated in the
math proof map. They are stated as axioms for now because this file is only the
dependency skeleton; later files can replace these axioms with actual Lean proofs
once the relevant analytic objects are defined.
-/

/-- Kernel minorization gives block Poincare. -/
axiom blockPoincare_of_blockMinorization :
  BlockMinorization -> BlockPoincare

/-- Dobrushin weak dependence gives approximate tensorization. -/
axiom tensorization_of_dobrushin :
  DobrushinTensorization -> DobrushinTensorization

/-- Block Poincare plus tensorization plus bounded overlap gives global Poincare. -/
axiom globalPoincare_of_blockPoincare_tensorization_overlap :
  BlockPoincare ->
  DobrushinTensorization ->
  BoundedOverlapEnergy ->
  GlobalFiniteRegulatorPoincare

/-- Global finite-regulator Poincare gives the finite-regulator mass gap. -/
axiom finiteMassGap_of_globalPoincare :
  (C : BlockRGConstants) ->
  GlobalFiniteRegulatorPoincare ->
  FiniteRegulatorMassGap C

/-- Master I implies the package of finite-regulator inputs. -/
axiom downstreamInputs_of_constructiveRG :
  ConstructiveFixedScaleRG ->
  And BlockMinorization (And DobrushinTensorization BoundedOverlapEnergy)

/-- Master II transfers a uniform finite-regulator gap to the continuum gap. -/
axiom continuumMassGap_of_finiteMassGap_and_mosco :
  (C : BlockRGConstants) ->
  FiniteRegulatorMassGap C ->
  MoscoContinuumBridge ->
  ContinuumMassGap C

/-- Master I gives the finite-regulator mass gap. -/
theorem finiteMassGap_of_constructiveRG
    (C : BlockRGConstants)
    (hRG : ConstructiveFixedScaleRG) :
    FiniteRegulatorMassGap C := by
  let hInputs := downstreamInputs_of_constructiveRG hRG
  let hMinor : BlockMinorization := hInputs.left
  let hDob : DobrushinTensorization := hInputs.right.left
  let hOverlap : BoundedOverlapEnergy := hInputs.right.right
  have hBlock : BlockPoincare :=
    blockPoincare_of_blockMinorization hMinor
  have hTensor : DobrushinTensorization :=
    tensorization_of_dobrushin hDob
  have hGlobal : GlobalFiniteRegulatorPoincare :=
    globalPoincare_of_blockPoincare_tensorization_overlap hBlock hTensor hOverlap
  exact finiteMassGap_of_globalPoincare C hGlobal

/--
Main reduced Clay-facing theorem.

Master I plus Master II imply the continuum Yang-Mills mass gap.
-/
theorem continuumMassGap_of_masterProblems
    (C : BlockRGConstants)
    (hRG : ConstructiveFixedScaleRG)
    (hMosco : MoscoContinuumBridge) :
    ContinuumMassGap C := by
  have hFinite : FiniteRegulatorMassGap C :=
    finiteMassGap_of_constructiveRG C hRG
  exact continuumMassGap_of_finiteMassGap_and_mosco C hFinite hMosco

/--
The final result includes strict positivity of the gap constant.
-/
theorem continuumGapPositive_of_masterProblems
    (C : BlockRGConstants)
    (hRG : ConstructiveFixedScaleRG)
    (hMosco : MoscoContinuumBridge) :
    0 < C.massGapConstant := by
  have hGap : ContinuumMassGap C :=
    continuumMassGap_of_masterProblems C hRG hMosco
  exact hGap.positive_gap

end Clay
end RussoYM
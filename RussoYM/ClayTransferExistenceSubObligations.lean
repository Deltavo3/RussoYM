import RussoYM.ClayHolonomyExistenceSubObligations

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Transfer Existence Sub-Obligations

This file splits the raw transfer existence obligation into three natural
analytic sub-obligations:

1. scale data existence:
   produce `Delta0` and `dUV`;

2. Schur/Feshbach loss existence:
   produce `DeltaFine` and `loss`;

3. continuum transfer:
   prove `Delta0 <= DeltaYM`.

Together these imply `ClayRawTransferExistenceAssumptions`.
-/

/--
Scale transfer data existence.

For fixed `C`, `mu`, and `delta`, produce `Delta0` and `dUV` satisfying the
raw scale normalization.
-/
structure ClayScaleTransferExistenceAssumptions
    (C mu delta : Real) : Prop where
  exists_scale_data :
    ∃ Delta0 dUV : Real,
      0 < dUV
        ∧ Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV

/--
Schur/Feshbach loss transfer existence.

For fixed `C`, `mu`, `delta`, `Delta0`, and `dUV`, produce `DeltaFine` and
`loss` satisfying the raw Schur/Feshbach loss bounds.
-/
structure ClaySchurLossTransferExistenceAssumptions
    (C mu delta Delta0 dUV : Real) : Prop where
  exists_schur_data :
    ∃ DeltaFine loss : Real,
      loss <= Delta0
        ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine

/--
Continuum transfer assumption.

For the scale witness `Delta0`, prove it survives into the continuum gap.
-/
structure ClayContinuumTransferAssumptions
    (DeltaYM Delta0 : Real) : Prop where
  transfer :
    Delta0 <= DeltaYM

/--
Scale transfer existence exposes scale witness data.
-/
theorem ClayScaleTransferExistenceAssumptions.exists_scale_witness_data
    {C mu delta : Real}
    (h :
      ClayScaleTransferExistenceAssumptions C mu delta) :
    ∃ Delta0 dUV : Real,
      0 < dUV
        ∧ Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV := by
  exact h.exists_scale_data

/--
Schur/Feshbach loss transfer existence exposes Schur witness data.
-/
theorem ClaySchurLossTransferExistenceAssumptions.exists_schur_witness_data
    {C mu delta Delta0 dUV : Real}
    (h :
      ClaySchurLossTransferExistenceAssumptions
        C mu delta Delta0 dUV) :
    ∃ DeltaFine loss : Real,
      loss <= Delta0
        ∧ min (mu * (delta / C)^2) dUV - loss <= DeltaFine := by
  exact h.exists_schur_data

/--
Continuum transfer exposes the transfer inequality.
-/
theorem ClayContinuumTransferAssumptions.expose_transfer
    {DeltaYM Delta0 : Real}
    (h :
      ClayContinuumTransferAssumptions DeltaYM Delta0) :
    Delta0 <= DeltaYM := by
  exact h.transfer

/--
The three transfer sub-obligations imply raw transfer existence.
-/
theorem clay_transfer_sub_obligations_to_raw_transfer_existence
    {DeltaYM C mu delta : Real}
    (hScale :
      ClayScaleTransferExistenceAssumptions C mu delta)
    (hSchurForScale :
      forall Delta0 dUV : Real,
        0 < dUV ->
        Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
        ClaySchurLossTransferExistenceAssumptions
          C mu delta Delta0 dUV)
    (hContinuumForScale :
      forall Delta0 dUV : Real,
        0 < dUV ->
        Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
        ClayContinuumTransferAssumptions DeltaYM Delta0) :
    ClayRawTransferExistenceAssumptions DeltaYM C mu delta := by
  rcases hScale.exists_scale_data with
    ⟨Delta0, dUV, hUV_pos, hDelta0_def⟩
  rcases
    (hSchurForScale Delta0 dUV hUV_pos hDelta0_def).exists_schur_data
    with ⟨DeltaFine, loss, hLoss, hLower⟩
  exact
    ClayRawTransferExistenceAssumptions.of_witnesses
      hUV_pos
      hDelta0_def
      hLoss
      hLower
      ((hContinuumForScale Delta0 dUV hUV_pos hDelta0_def).transfer)

/--
The three transfer sub-obligations plus block positivity imply all transfer gap
data.
-/
theorem clay_transfer_sub_obligations_imply_transfer_gap_data_of_block_pos
    {DeltaYM C mu delta : Real}
    (hBlock_pos :
      0 < mu * (delta / C)^2)
    (hScale :
      ClayScaleTransferExistenceAssumptions C mu delta)
    (hSchurForScale :
      forall Delta0 dUV : Real,
        0 < dUV ->
        Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
        ClaySchurLossTransferExistenceAssumptions
          C mu delta Delta0 dUV)
    (hContinuumForScale :
      forall Delta0 dUV : Real,
        0 < dUV ->
        Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
        ClayContinuumTransferAssumptions DeltaYM Delta0) :
    ∃ DeltaFine Delta0 : Real,
      Delta0 <= DeltaFine
        ∧ 0 < Delta0
        ∧ 0 < DeltaFine
        ∧ Delta0 <= DeltaYM
        ∧ 0 < DeltaYM := by
  exact
    ClayRawTransferExistenceAssumptions.imply_exists_transfer_gap_data_of_block_pos
      hBlock_pos
      (clay_transfer_sub_obligations_to_raw_transfer_existence
        hScale hSchurForScale hContinuumForScale)

/--
The four holonomy/coercivity sub-obligations plus the three transfer
sub-obligations imply positive continuum Yang--Mills gap.
-/
theorem clay_all_sub_obligations_conditional_yang_mills_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hSep :
      ClayHolonomySeparationExistenceAssumptions links)
    (hControl :
      ClayHolonomyCurvatureControlExistenceAssumptions
        links curvatureNorm)
    (hCoercive :
      ClayCurvatureCoercivityExistenceAssumptions
        Energy curvatureNorm)
    (hGap :
      ClayFiniteGapLowerComparisonAssumptions Gap Energy)
    (hScaleForWitness :
      forall C mu delta : Real,
        0 < delta ->
        (forall n, delta <= ‖1 - (links n).prod‖) ->
        0 < C ->
        (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
        0 < mu ->
        (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
        (forall n, Energy n <= Gap n) ->
        ClayScaleTransferExistenceAssumptions C mu delta)
    (hSchurForWitness :
      forall C mu delta : Real,
        0 < delta ->
        (forall n, delta <= ‖1 - (links n).prod‖) ->
        0 < C ->
        (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
        0 < mu ->
        (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
        (forall n, Energy n <= Gap n) ->
        forall Delta0 dUV : Real,
          0 < dUV ->
          Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
          ClaySchurLossTransferExistenceAssumptions
            C mu delta Delta0 dUV)
    (hContinuumForWitness :
      forall C mu delta : Real,
        0 < delta ->
        (forall n, delta <= ‖1 - (links n).prod‖) ->
        0 < C ->
        (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
        0 < mu ->
        (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
        (forall n, Energy n <= Gap n) ->
        forall Delta0 dUV : Real,
          0 < dUV ->
          Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
          ClayContinuumTransferAssumptions DeltaYM Delta0) :
    0 < DeltaYM := by
  apply
    clay_holonomy_sub_obligations_with_transfer_imply_mass_gap
      hSep hControl hCoercive hGap
  intro C mu delta hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound
  exact
    clay_transfer_sub_obligations_to_raw_transfer_existence
      (hScaleForWitness
        C mu delta
        hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound)
      (hSchurForWitness
        C mu delta
        hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound)
      (hContinuumForWitness
        C mu delta
        hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound)

/--
The four holonomy/coercivity sub-obligations plus the three transfer
sub-obligations imply the mass-gap summary.
-/
theorem clay_all_sub_obligations_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hSep :
      ClayHolonomySeparationExistenceAssumptions links)
    (hControl :
      ClayHolonomyCurvatureControlExistenceAssumptions
        links curvatureNorm)
    (hCoercive :
      ClayCurvatureCoercivityExistenceAssumptions
        Energy curvatureNorm)
    (hGap :
      ClayFiniteGapLowerComparisonAssumptions Gap Energy)
    (hScaleForWitness :
      forall C mu delta : Real,
        0 < delta ->
        (forall n, delta <= ‖1 - (links n).prod‖) ->
        0 < C ->
        (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
        0 < mu ->
        (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
        (forall n, Energy n <= Gap n) ->
        ClayScaleTransferExistenceAssumptions C mu delta)
    (hSchurForWitness :
      forall C mu delta : Real,
        0 < delta ->
        (forall n, delta <= ‖1 - (links n).prod‖) ->
        0 < C ->
        (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
        0 < mu ->
        (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
        (forall n, Energy n <= Gap n) ->
        forall Delta0 dUV : Real,
          0 < dUV ->
          Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
          ClaySchurLossTransferExistenceAssumptions
            C mu delta Delta0 dUV)
    (hContinuumForWitness :
      forall C mu delta : Real,
        0 < delta ->
        (forall n, delta <= ‖1 - (links n).prod‖) ->
        0 < C ->
        (forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n) ->
        0 < mu ->
        (forall n, mu * (curvatureNorm n)^2 <= Energy n) ->
        (forall n, Energy n <= Gap n) ->
        forall Delta0 dUV : Real,
          0 < dUV ->
          Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
          ClayContinuumTransferAssumptions DeltaYM Delta0) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  apply
    clay_holonomy_sub_obligations_with_transfer_imply_mass_gap_summary
      hSep hControl hCoercive hGap
  intro C mu delta hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound
  exact
    clay_transfer_sub_obligations_to_raw_transfer_existence
      (hScaleForWitness
        C mu delta
        hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound)
      (hSchurForWitness
        C mu delta
        hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound)
      (hContinuumForWitness
        C mu delta
        hDelta_pos hSepBound hC_pos hControlBound hMu_pos hEnergyBound hGapBound)

end RussoYM

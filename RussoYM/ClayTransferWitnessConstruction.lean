import RussoYM.ClayCompactSectorSeparation

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Transfer Witness Construction

This file starts proving part of the transfer side instead of merely naming it.

For fixed `C`, `mu`, and `delta`, if the concrete block

  mu * (delta / C)^2

is positive, then we can explicitly choose scale and Schur/Feshbach witnesses.

The remaining nontrivial transfer issue is continuum survival:

  Delta0 <= DeltaYM.
-/

/--
If the concrete block is positive, then scale transfer data exists.

We choose

  dUV = mu * (delta / C)^2,
  Delta0 = (1 / 2) * (mu * (delta / C)^2).
-/
theorem ClayScaleTransferExistenceAssumptions.of_block_positive
    {C mu delta : Real}
    (hBlock_pos :
      0 < mu * (delta / C)^2) :
    ClayScaleTransferExistenceAssumptions C mu delta := by
  exact
    { exists_scale_data :=
        ⟨(1 / 2) * (mu * (delta / C)^2),
          mu * (delta / C)^2,
          hBlock_pos,
          by simp⟩ }

/--
For scale data with positive block and positive `dUV`, the scale witness
`Delta0` is positive.
-/
theorem scale_delta0_positive_of_block_pos
    {C mu delta Delta0 dUV : Real}
    (hBlock_pos :
      0 < mu * (delta / C)^2)
    (hUV_pos :
      0 < dUV)
    (hDelta0_def :
      Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV) :
    0 < Delta0 := by
  have hmin_pos :
      0 < min (mu * (delta / C)^2) dUV := by
    exact lt_min hBlock_pos hUV_pos
  have hhalf_pos : (0 : Real) < 1 / 2 := by
    norm_num
  rw [hDelta0_def]
  exact mul_pos hhalf_pos hmin_pos

/--
Schur/Feshbach loss data can be constructed with zero loss once `Delta0` is
nonnegative.

We choose

  loss = 0,
  DeltaFine = min (mu * (delta / C)^2) dUV.
-/
theorem ClaySchurLossTransferExistenceAssumptions.of_zero_loss
    {C mu delta Delta0 dUV : Real}
    (hDelta0_nonneg :
      0 <= Delta0) :
    ClaySchurLossTransferExistenceAssumptions
      C mu delta Delta0 dUV := by
  exact
    { exists_schur_data :=
        ⟨min (mu * (delta / C)^2) dUV,
          0,
          hDelta0_nonneg,
          by simp⟩ }

/--
Positive block plus scale data gives Schur/Feshbach loss transfer existence.

This proves the Schur transfer obligation constructively, using zero loss.
-/
theorem ClaySchurLossTransferExistenceAssumptions.of_scale_data_and_block_positive
    {C mu delta Delta0 dUV : Real}
    (hBlock_pos :
      0 < mu * (delta / C)^2)
    (hUV_pos :
      0 < dUV)
    (hDelta0_def :
      Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV) :
    ClaySchurLossTransferExistenceAssumptions
      C mu delta Delta0 dUV := by
  have hDelta0_pos :
      0 < Delta0 := by
    exact
      scale_delta0_positive_of_block_pos
        hBlock_pos hUV_pos hDelta0_def
  exact
    ClaySchurLossTransferExistenceAssumptions.of_zero_loss
      (le_of_lt hDelta0_pos)

/--
Continuum transfer can be built directly from the transfer inequality.
-/
theorem ClayContinuumTransferAssumptions.of_delta0_le_deltaYM
    {DeltaYM Delta0 : Real}
    (hTransfer :
      Delta0 <= DeltaYM) :
    ClayContinuumTransferAssumptions DeltaYM Delta0 := by
  exact { transfer := hTransfer }

/--
If the concrete block is positive and every scale witness survives into
`DeltaYM`, then raw transfer existence follows.

Thus scale and Schur transfer are now constructive; continuum survival remains
the real transfer-side analytic obligation.
-/
theorem ClayRawTransferExistenceAssumptions.of_block_positive_and_continuum_transfer
    {DeltaYM C mu delta : Real}
    (hBlock_pos :
      0 < mu * (delta / C)^2)
    (hContinuumForScale :
      forall Delta0 dUV : Real,
        0 < dUV ->
        Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
        Delta0 <= DeltaYM) :
    ClayRawTransferExistenceAssumptions DeltaYM C mu delta := by
  exact
    clay_transfer_sub_obligations_to_raw_transfer_existence
      (ClayScaleTransferExistenceAssumptions.of_block_positive hBlock_pos)
      (fun Delta0 dUV hUV_pos hDelta0_def =>
        ClaySchurLossTransferExistenceAssumptions.of_scale_data_and_block_positive
          hBlock_pos hUV_pos hDelta0_def)
      (fun Delta0 dUV hUV_pos hDelta0_def =>
        ClayContinuumTransferAssumptions.of_delta0_le_deltaYM
          (hContinuumForScale Delta0 dUV hUV_pos hDelta0_def))

/--
Transfer gap data follows from positive block and continuum survival for scale
witnesses.
-/
theorem transfer_gap_data_of_block_positive_and_continuum_transfer
    {DeltaYM C mu delta : Real}
    (hBlock_pos :
      0 < mu * (delta / C)^2)
    (hContinuumForScale :
      forall Delta0 dUV : Real,
        0 < dUV ->
        Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV ->
        Delta0 <= DeltaYM) :
    ∃ DeltaFine Delta0 : Real,
      Delta0 <= DeltaFine
        ∧ 0 < Delta0
        ∧ 0 < DeltaFine
        ∧ Delta0 <= DeltaYM
        ∧ 0 < DeltaYM := by
  exact
    ClayRawTransferExistenceAssumptions.imply_exists_transfer_gap_data_of_block_pos
      hBlock_pos
      (ClayRawTransferExistenceAssumptions.of_block_positive_and_continuum_transfer
        hBlock_pos hContinuumForScale)

end RussoYM

import RussoYM.ClayAnalyticExistenceProgram

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Raw Transfer Existence

This file isolates the second major analytic existence obligation.

For fixed holonomy/coercivity constants `C`, `mu`, and `delta`, the transfer
obligation is to produce constants

  DeltaFine, Delta0, dUV, loss

such that:

1. `0 < dUV`,
2. `Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV`,
3. `loss <= Delta0`,
4. `min (mu * (delta / C)^2) dUV - loss <= DeltaFine`,
5. `Delta0 <= DeltaYM`.

This is the scale + Schur/Feshbach + continuum-survival obligation.
-/

/--
Construct raw transfer existence from explicit transfer witnesses.
-/
theorem ClayRawTransferExistenceAssumptions.of_witnesses
    {DeltaYM C mu delta DeltaFine Delta0 dUV loss : Real}
    (hUV_pos :
      0 < dUV)
    (hDelta0_def :
      Delta0 = (1 / 2) * min (mu * (delta / C)^2) dUV)
    (hLoss :
      loss <= Delta0)
    (hLower :
      min (mu * (delta / C)^2) dUV - loss <= DeltaFine)
    (hCont :
      Delta0 <= DeltaYM) :
    ClayRawTransferExistenceAssumptions DeltaYM C mu delta := by
  exact
    { exists_transfer_data :=
        ⟨DeltaFine, Delta0, dUV, loss,
          hUV_pos,
          hDelta0_def,
          hLoss,
          hLower,
          hCont⟩ }

/--
Raw transfer existence gives scale, Schur, and continuum primitive obligations.
-/
theorem ClayRawTransferExistenceAssumptions.imply_exists_transfer_primitives
    {DeltaYM C mu delta : Real}
    (h :
      ClayRawTransferExistenceAssumptions DeltaYM C mu delta) :
    ∃ DeltaFine Delta0 dUV : Real,
      ClayScalePrimitiveObligation
        Delta0 (mu * (delta / C)^2) dUV
        ∧ ClaySchurPrimitiveObligation
            DeltaFine Delta0 (mu * (delta / C)^2) dUV
        ∧ ClayContinuumPrimitiveObligation DeltaYM Delta0 := by
  rcases h.exists_transfer_data with
    ⟨DeltaFine, Delta0, dUV, _loss,
      hUV_pos,
      hDelta0_def,
      hLoss,
      hLower,
      hCont⟩
  exact
    ⟨DeltaFine, Delta0, dUV,
      ClayScalePrimitiveObligation.of_uv_pos_and_delta0_def
        hUV_pos hDelta0_def,
      ClaySchurPrimitiveObligation.of_raw_loss_bounds
        hLoss hLower,
      ClayContinuumPrimitiveObligation.of_delta0_le_deltaYM
        hCont⟩

/--
Raw transfer existence exposes the scale primitive obligation.
-/
theorem ClayRawTransferExistenceAssumptions.imply_exists_scale_primitive
    {DeltaYM C mu delta : Real}
    (h :
      ClayRawTransferExistenceAssumptions DeltaYM C mu delta) :
    ∃ Delta0 dUV : Real,
      ClayScalePrimitiveObligation
        Delta0 (mu * (delta / C)^2) dUV := by
  rcases
    ClayRawTransferExistenceAssumptions.imply_exists_transfer_primitives h
    with ⟨_DeltaFine, Delta0, dUV, hScale, _hSchur, _hCont⟩
  exact ⟨Delta0, dUV, hScale⟩

/--
Raw transfer existence exposes the Schur primitive obligation.
-/
theorem ClayRawTransferExistenceAssumptions.imply_exists_schur_primitive
    {DeltaYM C mu delta : Real}
    (h :
      ClayRawTransferExistenceAssumptions DeltaYM C mu delta) :
    ∃ DeltaFine Delta0 dUV : Real,
      ClaySchurPrimitiveObligation
        DeltaFine Delta0 (mu * (delta / C)^2) dUV := by
  rcases
    ClayRawTransferExistenceAssumptions.imply_exists_transfer_primitives h
    with ⟨DeltaFine, Delta0, dUV, _hScale, hSchur, _hCont⟩
  exact ⟨DeltaFine, Delta0, dUV, hSchur⟩

/--
Raw transfer existence exposes the continuum primitive obligation.
-/
theorem ClayRawTransferExistenceAssumptions.imply_exists_continuum_primitive
    {DeltaYM C mu delta : Real}
    (h :
      ClayRawTransferExistenceAssumptions DeltaYM C mu delta) :
    ∃ Delta0 : Real,
      ClayContinuumPrimitiveObligation DeltaYM Delta0 := by
  rcases
    ClayRawTransferExistenceAssumptions.imply_exists_transfer_primitives h
    with ⟨_DeltaFine, Delta0, _dUV, _hScale, _hSchur, hCont⟩
  exact ⟨Delta0, hCont⟩

/--
Raw transfer existence plus positivity of the block scale gives all transfer
gap data.
-/
theorem ClayRawTransferExistenceAssumptions.imply_exists_transfer_gap_data_of_block_pos
    {DeltaYM C mu delta : Real}
    (hBlock_pos :
      0 < mu * (delta / C)^2)
    (h :
      ClayRawTransferExistenceAssumptions DeltaYM C mu delta) :
    ∃ DeltaFine Delta0 : Real,
      Delta0 <= DeltaFine
        ∧ 0 < Delta0
        ∧ 0 < DeltaFine
        ∧ Delta0 <= DeltaYM
        ∧ 0 < DeltaYM := by
  rcases
    ClayRawTransferExistenceAssumptions.imply_exists_transfer_primitives h
    with ⟨DeltaFine, Delta0, _dUV, hScale, hSchur, hCont⟩
  have hDelta0_pos :
      0 < Delta0 := by
    exact
      ClayScalePrimitiveObligation.imply_delta0_positive_of_block_pos
        hBlock_pos hScale
  have hDelta0_le_DeltaFine :
      Delta0 <= DeltaFine := by
    exact ClaySchurPrimitiveObligation.imply_delta0_le_deltaFine hScale hSchur
  have hDeltaFine_pos :
      0 < DeltaFine := by
    exact lt_of_lt_of_le hDelta0_pos hDelta0_le_DeltaFine
  have hContData :
      Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact
      ClayContinuumPrimitiveObligation.imply_continuum_gap_data_of_delta0_pos
        hCont hDelta0_pos
  exact
    ⟨DeltaFine, Delta0,
      hDelta0_le_DeltaFine,
      hDelta0_pos,
      hDeltaFine_pos,
      hContData.1,
      hContData.2⟩

end RussoYM

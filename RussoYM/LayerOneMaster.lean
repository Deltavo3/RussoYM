import Mathlib
import RussoYM.ClayCriterion
import RussoYM.LayerOneRedLemmas

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Layer One Master Registry

This file combines the final Clay-compatible algebraic endpoint with the
named registry of remaining analytic red lemmas.

It does not prove the analytic red lemmas. It records the master implication:

red lemma registry
+ Clay YM gap assumptions
=> continuum Yang--Mills gap positivity
   and the named analytic obligations.
-/

/--
Master Layer 1 assumptions.

The four proposition parameters name the remaining analytic obligations.
The numerical parameters are the same as in `ClayYMGapAssumptions`.
-/
structure LayerOneMasterAssumptions
    (curvatureFormCoercivity : Prop)
    (rgRemainderEstimates : Prop)
    (multiscaleMixingSuppression : Prop)
    (gapPreservingContinuumConstruction : Prop)
    (DeltaYM DeltaFine Delta0 dBlock dUV Cmix eps ell : Real)
    (kappa : Nat) : Prop where
  redLemmas :
    LayerOneRedLemmaAssumptions
      curvatureFormCoercivity
      rgRemainderEstimates
      multiscaleMixingSuppression
      gapPreservingContinuumConstruction
  clayGap :
    ClayYMGapAssumptions
      DeltaYM DeltaFine Delta0 dBlock dUV Cmix eps ell kappa

/--
Master Layer 1 endpoint.

The assumptions imply the final Clay-compatible gap conclusion and preserve
the named red-lemma obligations as explicit theorem outputs.
-/
theorem LayerOneMasterAssumptions.imply_master_endpoint
    {curvatureFormCoercivity : Prop}
    {rgRemainderEstimates : Prop}
    {multiscaleMixingSuppression : Prop}
    {gapPreservingContinuumConstruction : Prop}
    {DeltaYM DeltaFine Delta0 dBlock dUV Cmix eps ell : Real}
    {kappa : Nat}
    (h :
      LayerOneMasterAssumptions
        curvatureFormCoercivity
        rgRemainderEstimates
        multiscaleMixingSuppression
        gapPreservingContinuumConstruction
        DeltaYM DeltaFine Delta0 dBlock dUV Cmix eps ell kappa) :
    Delta0 <= DeltaFine
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM
      ∧ curvatureFormCoercivity
      ∧ rgRemainderEstimates
      ∧ multiscaleMixingSuppression
      ∧ gapPreservingContinuumConstruction := by
  have hClay :
      Delta0 <= DeltaFine ∧ 0 < DeltaFine ∧ Delta0 <= DeltaYM ∧ 0 < DeltaYM := by
    exact ClayYMGapAssumptions.imply_clay_gap h.clayGap
  have hRed :
      curvatureFormCoercivity
        ∧ rgRemainderEstimates
        ∧ multiscaleMixingSuppression
        ∧ gapPreservingContinuumConstruction := by
    exact LayerOneRedLemmaAssumptions.imply_all_red_lemmas h.redLemmas
  exact
    ⟨hClay.1,
      hClay.2.1,
      hClay.2.2.1,
      hClay.2.2.2,
      hRed.1,
      hRed.2.1,
      hRed.2.2.1,
      hRed.2.2.2⟩

end RussoYM

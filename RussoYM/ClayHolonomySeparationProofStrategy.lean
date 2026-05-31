import RussoYM.ClayProofStateAudit

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Holonomy Separation Proof Strategy

This file begins converting the original mathematical proof strategy into the
first analytic obligation.

Original proof idea:

  nontrivial compact/admissible holonomy sector
  + exclusion of the trivial identity holonomy
  -> positive distance from identity
  -> uniform holonomy separation.

In Lean, we first formalize the usable consequence of that compactness argument:

  there is a sector `S`,
  every regulator holonomy product lies in `S`,
  and `S` is uniformly separated from identity.

From that, we prove the first analytic obligation:

  ClayHolonomySeparationExistenceAssumptions links.
-/

/--
A sector-level uniform holonomy separation certificate.

This is the formal placeholder for the original compactness/nontrivial-sector
argument:

  admissible sector compact,
  identity/trivial holonomy excluded,
  therefore the sector is uniformly separated from identity.
-/
structure ClayHolonomySectorSeparationCertificate
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R) : Prop where
  exists_sector_data :
    ∃ sector : R -> Prop,
      (forall n, sector ((links n).prod))
        ∧ ∃ delta : Real,
            0 < delta
              ∧ forall U : R, sector U -> delta <= ‖1 - U‖

/--
Sector uniform separation implies regulator holonomy separation.
-/
theorem clay_sector_uniform_separation_to_holonomy_separation
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    (sector : R -> Prop)
    (hContains :
      forall n, sector ((links n).prod))
    (hUniform :
      ∃ delta : Real,
        0 < delta
          ∧ forall U : R, sector U -> delta <= ‖1 - U‖) :
    ClayHolonomySeparationExistenceAssumptions links := by
  rcases hUniform with ⟨delta, hDelta_pos, hSeparated⟩
  exact
    { exists_separation :=
        ⟨delta,
          hDelta_pos,
          fun n => hSeparated ((links n).prod) (hContains n)⟩ }

/--
A sector separation certificate proves the first analytic obligation:
holonomy separation existence.
-/
theorem ClayHolonomySectorSeparationCertificate.to_holonomy_separation_existence
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    (h :
      ClayHolonomySectorSeparationCertificate links) :
    ClayHolonomySeparationExistenceAssumptions links := by
  rcases h.exists_sector_data with ⟨sector, hContains, hUniform⟩
  exact
    clay_sector_uniform_separation_to_holonomy_separation
      sector hContains hUniform

/--
A sector separation certificate exposes the actual delta witness.
-/
theorem ClayHolonomySectorSeparationCertificate.exists_delta_witness
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    (h :
      ClayHolonomySectorSeparationCertificate links) :
    ∃ delta : Real,
      0 < delta
        ∧ forall n, delta <= ‖1 - (links n).prod‖ := by
exact
  (ClayHolonomySectorSeparationCertificate.to_holonomy_separation_existence
    h).exists_separation

/--
Replacing holonomy separation existence by a sector separation certificate,
the remaining six analytic obligations imply positive continuum Yang--Mills gap.
-/
theorem clay_sector_separation_with_remaining_obligations_imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hSector :
      ClayHolonomySectorSeparationCertificate links)
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
  have hSep :
      ClayHolonomySeparationExistenceAssumptions links := by
    exact
      ClayHolonomySectorSeparationCertificate.to_holonomy_separation_existence
        hSector
  exact
    clay_all_sub_obligations_conditional_yang_mills_mass_gap
      hSep
      hControl
      hCoercive
      hGap
      hScaleForWitness
      hSchurForWitness
      hContinuumForWitness

/--
Replacing holonomy separation existence by a sector separation certificate,
the remaining six analytic obligations imply the mass-gap summary.
-/
theorem clay_sector_separation_with_remaining_obligations_imply_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hSector :
      ClayHolonomySectorSeparationCertificate links)
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
  have hSep :
      ClayHolonomySeparationExistenceAssumptions links := by
    exact
      ClayHolonomySectorSeparationCertificate.to_holonomy_separation_existence
      hSector
  exact
    clay_all_sub_obligations_mass_gap_summary
      hSep
      hControl
      hCoercive
      hGap
      hScaleForWitness
      hSchurForWitness
      hContinuumForWitness

end RussoYM

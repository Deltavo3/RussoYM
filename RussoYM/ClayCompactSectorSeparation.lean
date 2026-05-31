import RussoYM.ClayHolonomySeparationProofStrategy

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Compact Sector Separation

This file records the compact/nontrivial-sector version of the holonomy
separation argument.

Original mathematical idea:

  If all regulator holonomies lie in an admissible nontrivial sector,
  and that sector is compact/closed away from the trivial identity holonomy,
  then the sector has positive distance from identity.

In this file, we do not yet formalize the full topology of compactness.  Instead
we isolate the exact consequence needed from compactness:

  there exists `delta > 0` such that every holonomy in the sector has
  `delta <= ‖1 - U‖`.

This is the compact-sector separation certificate.  Later, the analytic/topology
proof should replace this certificate with a theorem from compactness and
identity exclusion.
-/

/--
Compact nontrivial holonomy sector certificate.

This packages the original compactness/nontrivial-sector argument in the exact
form needed for the current Lean proof.

It says there exists an admissible sector containing all regulator holonomy
products, and the sector is uniformly separated from identity.
-/
structure ClayCompactNontrivialHolonomySectorCertificate
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R) : Prop where
  exists_compact_sector_data :
    ∃ sector : R -> Prop,
      (forall n, sector ((links n).prod))
        ∧ ∃ delta : Real,
            0 < delta
              ∧ forall U : R, sector U -> delta <= ‖1 - U‖

/--
A compact nontrivial holonomy sector certificate gives the sector separation
certificate used by the holonomy-separation proof strategy.
-/
theorem ClayCompactNontrivialHolonomySectorCertificate.to_sector_separation_certificate
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    (h :
      ClayCompactNontrivialHolonomySectorCertificate links) :
    ClayHolonomySectorSeparationCertificate links := by
  rcases h.exists_compact_sector_data with
    ⟨sector, hContainsProducts, hPositiveDistance⟩
  exact
    { exists_sector_data :=
        ⟨sector,
          hContainsProducts,
          hPositiveDistance⟩ }

/--
A compact nontrivial holonomy sector certificate proves holonomy separation
existence.
-/
theorem ClayCompactNontrivialHolonomySectorCertificate.to_holonomy_separation_existence
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    (h :
      ClayCompactNontrivialHolonomySectorCertificate links) :
    ClayHolonomySeparationExistenceAssumptions links := by
  exact
    ClayHolonomySectorSeparationCertificate.to_holonomy_separation_existence
      (ClayCompactNontrivialHolonomySectorCertificate.to_sector_separation_certificate h)

/--
A compact nontrivial holonomy sector certificate exposes the delta witness.
-/
theorem ClayCompactNontrivialHolonomySectorCertificate.exists_delta_witness
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    (h :
      ClayCompactNontrivialHolonomySectorCertificate links) :
    ∃ delta : Real,
      0 < delta
        ∧ forall n, delta <= ‖1 - (links n).prod‖ := by
  exact
    (ClayCompactNontrivialHolonomySectorCertificate.to_holonomy_separation_existence
      h).exists_separation

/--
Replacing holonomy separation existence by a compact nontrivial sector
certificate, the remaining six obligations imply the Yang--Mills mass gap.
-/
theorem clay_compact_sector_with_remaining_obligations_imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hCompactSector :
      ClayCompactNontrivialHolonomySectorCertificate links)
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
  have hSector :
      ClayHolonomySectorSeparationCertificate links := by
    exact
      ClayCompactNontrivialHolonomySectorCertificate.to_sector_separation_certificate
      hCompactSector
  exact
    clay_sector_separation_with_remaining_obligations_imply_mass_gap
      hSector hControl hCoercive hGap
      hScaleForWitness hSchurForWitness hContinuumForWitness

/--
Replacing holonomy separation existence by a compact nontrivial sector
certificate, the remaining six obligations imply the mass-gap summary.
-/
theorem clay_compact_sector_with_remaining_obligations_imply_mass_gap_summary
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM : Real}
    (hCompactSector :
      ClayCompactNontrivialHolonomySectorCertificate links)
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
  have hSector :
      ClayHolonomySectorSeparationCertificate links := by
    exact
      ClayCompactNontrivialHolonomySectorCertificate.to_sector_separation_certificate
      hCompactSector
  exact
    clay_sector_separation_with_remaining_obligations_imply_mass_gap_summary
      hSector hControl hCoercive hGap
      hScaleForWitness hSchurForWitness hContinuumForWitness

end RussoYM

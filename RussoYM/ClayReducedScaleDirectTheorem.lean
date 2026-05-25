import RussoYM.ClayDirectRedLemmaTheorem

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Reduced Scale Direct Theorem

This file reduces the positive Layer-One scale packet in the current direct
Clay red-lemma theorem.

The previous scale packet assumed:

  0 < dBlock,
  0 < dUV,
  Delta0 = (1 / 2) * min dBlock dUV.

In the Clay route, the block scale is

  dBlock = mu * (delta / C)^2,

and positivity of this block scale is already a consequence of the holonomy
red-lemma packet.

Therefore this file replaces the scale packet by a reduced scale packet that
only assumes:

  0 < dUV,
  Delta0 = (1 / 2) * min dBlock dUV.
-/

/--
Reduced Layer-One scale assumptions.

The block-scale positivity is intentionally omitted here, because in the Clay
route it is derived from the holonomy red-lemma packet.
-/
structure LayerOneReducedScaleAssumptions
    (Delta0 dBlock dUV : Real) : Prop where
  hUV_pos :
    0 < dUV
  hDelta0_def :
    Delta0 = (1 / 2) * min dBlock dUV

/--
Reduced scale assumptions plus block positivity recover the positive scale
packet.
-/
theorem LayerOneReducedScaleAssumptions.to_positive_scale
    {Delta0 dBlock dUV : Real}
    (hBlock_pos : 0 < dBlock)
    (h :
      LayerOneReducedScaleAssumptions Delta0 dBlock dUV) :
    LayerOnePositiveScaleAssumptions Delta0 dBlock dUV := by
  exact
    { hBlock_pos := hBlock_pos
      hUV_pos := h.hUV_pos
      hDelta0_def := h.hDelta0_def }

/--
The holonomy red-lemma packet supplies positivity of the Clay block scale

  mu * (delta / C)^2.
-/
theorem UniformHolonomyRedLemmaAssumptions.imply_block_scale_positive
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      UniformHolonomyRedLemmaAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    0 < mu * (delta / C)^2 := by
  exact (UniformHolonomyRedLemmaAssumptions.imply_uniform_positive_gap h).2.1

/--
Direct Clay red-lemma assumptions with the scale packet reduced.

The block-scale positivity is recovered from the holonomy packet.
-/
structure ClayReducedScaleDirectAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real)
    (kappa : Nat) : Prop where
  holonomyPacket :
    UniformHolonomyRedLemmaAssumptions
      links Gap Energy curvatureNorm C mu delta
  reducedScalePacket :
    LayerOneReducedScaleAssumptions
      Delta0 (mu * (delta / C)^2) dUV
  mixingSmallness :
    Delta0MixingSmallnessAssumptions Cmix eps ell Delta0 kappa
  fineLowerPacket :
    FineLowerSchurComplementAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  survivalPacket :
    EpsilonContinuumSurvivalAssumptions DeltaYM Gap

/--
The reduced-scale direct assumptions imply the previous direct red-lemma
assumptions.
-/
theorem ClayReducedScaleDirectAssumptions.to_direct_red_lemma_assumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayReducedScaleDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    ClayDirectRedLemmaTheoremAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa := by
  have hBlock_pos :
      0 < mu * (delta / C)^2 := by
    exact UniformHolonomyRedLemmaAssumptions.imply_block_scale_positive h.holonomyPacket
  have hScale :
      LayerOnePositiveScaleAssumptions
        Delta0 (mu * (delta / C)^2) dUV := by
    exact
      LayerOneReducedScaleAssumptions.to_positive_scale
        hBlock_pos h.reducedScalePacket
  exact
    { holonomyPacket := h.holonomyPacket
      scalePacket := hScale
      mixingSmallness := h.mixingSmallness
      fineLowerPacket := h.fineLowerPacket
      survivalPacket := h.survivalPacket }

/--
Reduced-scale direct theorem: full strongest gap data.
-/
theorem ClayReducedScaleDirectAssumptions.imply_full_gap_data
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayReducedScaleDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ (Delta0 <= DeltaFine ∧ 0 < Delta0 ∧ 0 < DeltaFine)
      ∧ (Delta0 <= DeltaYM ∧ 0 < DeltaYM)
      ∧ ((∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
          ∧ 0 < DeltaYM) := by
  exact
    clay_direct_red_lemma_theorem_implies_full_gap_data
      (ClayReducedScaleDirectAssumptions.to_direct_red_lemma_assumptions h)

/--
Reduced-scale direct theorem: strongest conditional mass-gap summary.
-/
theorem ClayReducedScaleDirectAssumptions.imply_mass_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayReducedScaleDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    (∃ Delta : Real, 0 < Delta ∧ forall n, Delta <= Gap n)
      ∧ 0 < DeltaYM := by
  exact
    clay_direct_red_lemma_theorem_implies_mass_gap
      (ClayReducedScaleDirectAssumptions.to_direct_red_lemma_assumptions h)

/--
Reduced-scale direct theorem: positive continuum Yang--Mills gap.
-/
theorem ClayReducedScaleDirectAssumptions.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayReducedScaleDirectAssumptions
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell C mu delta kappa) :
    0 < DeltaYM := by
  exact
    clay_direct_red_lemma_theorem_implies_positive_continuum_gap
      (ClayReducedScaleDirectAssumptions.to_direct_red_lemma_assumptions h)

end RussoYM

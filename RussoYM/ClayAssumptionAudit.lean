import RussoYM.ClayFromHolonomy

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Assumption Audit

This file records the fully named red-lemma route to the Clay-compatible
positive continuum Yang--Mills gap as an explicit assumption audit.

It does not add new analytic content.  It packages the remaining named proof
obligations into a checklist and connects that checklist to the fully named
Clay endpoint.
-/

/--
Audit packet for the fully named red-lemma route to the Clay endpoint.

The remaining proof obligations are organized as:

1. holonomy red lemmas,
2. Layer-One scale red lemmas,
3. mixing red lemmas,
4. fine lower red lemmas,
5. continuum red lemmas.
-/
structure ClayNamedRedLemmaAudit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real)
    (kappa : Nat) : Prop where
  holonomyPacket :
    UniformHolonomyRedLemmaAssumptions
      links Gap Energy curvatureNorm C mu delta
  scalePacket :
    LayerOneScaleRedLemmaAssumptions
      Delta0 (mu * (delta / C)^2) dUV
  mixingPacket :
    LayerOneMixingRedLemmaAssumptions
      (mu * (delta / C)^2) dUV Cmix eps ell rho kappa
  fineLowerPacket :
    FineLowerRedLemmaAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  continuumPacket :
    ContinuumRedLemmaAssumptions DeltaYM Delta0 Gap

/--
The audit packet implies the fully named red-lemma assumptions.
-/
theorem ClayNamedRedLemmaAudit.to_fully_named_red_lemmas
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayNamedRedLemmaAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayFromFullyNamedRedLemmasAssumptions
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact
    { holonomyRedLemmas := h.holonomyPacket
      scaleRedLemmas := h.scalePacket
      mixingRedLemmas := h.mixingPacket
      fineLowerRedLemmas := h.fineLowerPacket
      continuumRedLemmas := h.continuumPacket }

/--
Clay gap endpoint from the named red-lemma audit packet.
-/
theorem ClayNamedRedLemmaAudit.imply_clay_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayNamedRedLemmaAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact
    ClayFromFullyNamedRedLemmasAssumptions.imply_clay_gap
      (ClayNamedRedLemmaAudit.to_fully_named_red_lemmas h)

/--
Positive continuum Yang--Mills gap endpoint from the named red-lemma audit
packet.
-/
theorem ClayNamedRedLemmaAudit.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayNamedRedLemmaAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayFromFullyNamedRedLemmasAssumptions.imply_positive_continuum_gap
      (ClayNamedRedLemmaAudit.to_fully_named_red_lemmas h)

end RussoYM

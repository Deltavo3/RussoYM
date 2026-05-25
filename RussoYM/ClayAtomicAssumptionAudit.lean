import RussoYM.ClayAssumptionAudit

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Atomic Assumption Audit

This file refines the named red-lemma audit by exposing the smaller packets
inside the holonomy, mixing, fine-lower, and continuum red-lemma assumptions.

It does not add new analytic content.  It gives a more atomic checklist of the
remaining proof obligations behind the Clay-compatible Yang--Mills endpoint.
-/

/--
Atomic audit packet for the fully named Clay route.

The remaining obligations are exposed as smaller red-lemma components:

1. uniform holonomy separation,
2. uniform holonomy-curvature control,
3. uniform curvature coercivity,
4. uniform finite gap lower bound,
5. Layer-One scale normalization,
6. finite mixing red lemmas,
7. fine-lower Schur/Feshbach estimate,
8. uniform finite continuum lower bound,
9. epsilon continuum approximation.
-/
structure ClayAtomicRedLemmaAudit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real)
    (kappa : Nat) : Prop where
  holonomySeparation :
    UniformHolonomySeparationAssumptions links delta
  holonomyCurvatureControl :
    UniformHolonomyCurvatureControlAssumptions links curvatureNorm C
  curvatureCoercivity :
    UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu
  finiteGapLower :
    UniformGapLowerBoundAssumptions Gap Energy
  scaleNormalization :
    LayerOneScaleRedLemmaAssumptions
      Delta0 (mu * (delta / C)^2) dUV
  finiteMixing :
    FiniteMixingRedLemmaAssumptions
      Cmix eps ell rho ((1 / 2) * min (mu * (delta / C)^2) dUV) kappa
  fineLowerSchur :
    FineLowerSchurComplementAssumptions
      DeltaFine (mu * (delta / C)^2) dUV Cmix eps ell kappa
  continuumFiniteLower :
    UniformFiniteGapLowerAssumptions Delta0 Gap
  continuumApproximation :
    EpsilonContinuumApproximationAssumptions DeltaYM Gap

/--
The atomic audit packet implies the named red-lemma audit packet.
-/
theorem ClayAtomicRedLemmaAudit.to_named_red_lemma_audit
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayAtomicRedLemmaAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    ClayNamedRedLemmaAudit
      links Gap Energy curvatureNorm
      DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa := by
  exact
    { holonomyPacket :=
        { separation := h.holonomySeparation
          curvatureControl := h.holonomyCurvatureControl
          coercivity := h.curvatureCoercivity
          gapLower := h.finiteGapLower }
      scalePacket := h.scaleNormalization
      mixingPacket :=
        { finiteMixing := h.finiteMixing }
      fineLowerPacket :=
        { schurComplement := h.fineLowerSchur }
      continuumPacket :=
        { finiteLower := h.continuumFiniteLower
          epsilonApproximation := h.continuumApproximation } }

/--
Clay gap endpoint from the atomic audit packet.
-/
theorem ClayAtomicRedLemmaAudit.imply_clay_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayAtomicRedLemmaAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ Delta0 <= DeltaFine
      ∧ 0 < Delta0
      ∧ 0 < DeltaFine
      ∧ Delta0 <= DeltaYM
      ∧ 0 < DeltaYM := by
  exact
    ClayNamedRedLemmaAudit.imply_clay_gap
      (ClayAtomicRedLemmaAudit.to_named_red_lemma_audit h)

/--
Positive continuum Yang--Mills gap endpoint from the atomic audit packet.
-/
theorem ClayAtomicRedLemmaAudit.imply_positive_continuum_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta : Real}
    {kappa : Nat}
    (h :
      ClayAtomicRedLemmaAudit
        links Gap Energy curvatureNorm
        DeltaYM DeltaFine Delta0 dUV Cmix eps ell rho C mu delta kappa) :
    0 < DeltaYM := by
  exact
    ClayNamedRedLemmaAudit.imply_positive_continuum_gap
      (ClayAtomicRedLemmaAudit.to_named_red_lemma_audit h)

end RussoYM

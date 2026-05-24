import Mathlib
import RussoYM.FiniteGapFromHolonomy

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Uniform Finite Gap From Holonomy-Coercivity

This file records the uniform-family version of the finite holonomy-coercivity
gap bridge.

It proves:

if every finite regulator in a family satisfies the same holonomy/coercivity
lower-bound mechanism with fixed constants `C`, `mu`, and `delta`, then every
finite gap in the family is bounded below by the same positive constant

  mu * (delta / C)^2.

This is still finite algebra. It does not prove the analytic construction of
the regulator family.
-/

/--
Uniform finite-gap assumptions from a family of holonomy-coercivity systems.

`Gap n` is the finite gap at regulator index `n`.
`Energy n` and `curvatureNorm n` are the corresponding finite energy and
curvature size.
`links n` is the finite path/product data at regulator `n`.

The constants `C`, `mu`, and `delta` are uniform in `n`.
-/
structure UniformFiniteGapFromHolonomyAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (C mu delta : Real) : Prop where
  finite_gap_assumptions :
    forall n,
      FiniteGapFromHolonomyAssumptions
        (links n)
        (Gap n)
        (Energy n)
        (curvatureNorm n)
        C
        mu
        delta

/--
Uniform finite-gap endpoint.

Every finite gap in the family is bounded below by the same positive constant.
-/
theorem UniformFiniteGapFromHolonomyAssumptions.imply_uniform_positive_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      UniformFiniteGapFromHolonomyAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ 0 < mu * (delta / C)^2
      ∧ forall n, 0 < Gap n := by
  have hlower : forall n, mu * (delta / C)^2 <= Gap n := by
    intro n
    exact (FiniteGapFromHolonomyAssumptions.imply_positive_finite_gap
      (h.finite_gap_assumptions n)).1
  have hpos : 0 < mu * (delta / C)^2 := by
    exact (FiniteGapFromHolonomyAssumptions.imply_positive_finite_gap
      (h.finite_gap_assumptions 0)).2.1
  have hGap_pos : forall n, 0 < Gap n := by
    intro n
    exact lt_of_lt_of_le hpos (hlower n)
  exact ⟨hlower, hpos, hGap_pos⟩

end RussoYM

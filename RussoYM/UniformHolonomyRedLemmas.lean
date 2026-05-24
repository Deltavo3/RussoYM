import Mathlib
import RussoYM.UniformHolonomyCoercivity

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Uniform Holonomy Red Lemmas

This file decomposes the direct uniform holonomy/coercivity assumptions into
separately named red-lemma interfaces.

The goal is to make the remaining analytic obligations explicit:

1. uniform holonomy separation,
2. uniform holonomy-curvature control,
3. uniform curvature coercivity,
4. finite gap lower bound by energy.

Together these imply the direct `UniformHolonomyCoercivityAssumptions`.
-/

/--
Uniform nontrivial holonomy separation.
-/
structure UniformHolonomySeparationAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (delta : Real) : Prop where
  delta_positive :
    0 < delta
  holonomy_separation :
    forall n, delta <= ‖1 - (links n).prod‖

/--
Uniform control of holonomy deviation by curvature size.
-/
structure UniformHolonomyCurvatureControlAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (curvatureNorm : Nat -> Real)
    (C : Real) : Prop where
  C_positive :
    0 < C
  holonomy_curvature_control :
    forall n, ‖1 - (links n).prod‖ <= C * curvatureNorm n

/--
Uniform curvature coercivity.
-/
structure UniformCurvatureCoercivityAssumptions
    (Energy curvatureNorm : Nat -> Real)
    (mu : Real) : Prop where
  mu_positive :
    0 < mu
  energy_coercive :
    forall n, mu * (curvatureNorm n)^2 <= Energy n

/--
Finite gap lower bound by the finite energy lower bound.
-/
structure UniformGapLowerBoundAssumptions
    (Gap Energy : Nat -> Real) : Prop where
  gap_lower_bound :
    forall n, Energy n <= Gap n

/--
Separated red-lemma assumptions for the direct holonomy/coercivity route.
-/
structure UniformHolonomyRedLemmaAssumptions
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    (links : Nat -> List R)
    (Gap Energy curvatureNorm : Nat -> Real)
    (C mu delta : Real) : Prop where
  separation :
    UniformHolonomySeparationAssumptions links delta
  curvatureControl :
    UniformHolonomyCurvatureControlAssumptions links curvatureNorm C
  coercivity :
    UniformCurvatureCoercivityAssumptions Energy curvatureNorm mu
  gapLower :
    UniformGapLowerBoundAssumptions Gap Energy

/--
The decomposed red-lemma assumptions imply the direct uniform
holonomy/coercivity assumptions.
-/
theorem UniformHolonomyRedLemmaAssumptions.imply_uniform_holonomy_coercivity
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      UniformHolonomyRedLemmaAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    UniformHolonomyCoercivityAssumptions
      links Gap Energy curvatureNorm C mu delta := by
  exact
    { C_positive := h.curvatureControl.C_positive
      mu_positive := h.coercivity.mu_positive
      delta_positive := h.separation.delta_positive
      holonomy_separation := h.separation.holonomy_separation
      holonomy_curvature_control :=
        h.curvatureControl.holonomy_curvature_control
      energy_coercive := h.coercivity.energy_coercive
      gap_lower_bound := h.gapLower.gap_lower_bound }

/--
The decomposed red-lemma assumptions imply a uniform positive finite gap.
-/
theorem UniformHolonomyRedLemmaAssumptions.imply_uniform_positive_gap
    {R : Type*}
    [NormedRing R]
    [NormOneClass R]
    {links : Nat -> List R}
    {Gap Energy curvatureNorm : Nat -> Real}
    {C mu delta : Real}
    (h :
      UniformHolonomyRedLemmaAssumptions
        links Gap Energy curvatureNorm C mu delta) :
    (forall n, mu * (delta / C)^2 <= Gap n)
      ∧ 0 < mu * (delta / C)^2
      ∧ forall n, 0 < Gap n := by
  exact UniformHolonomyCoercivityAssumptions.imply_uniform_positive_gap
    (UniformHolonomyRedLemmaAssumptions.imply_uniform_holonomy_coercivity h)

end RussoYM

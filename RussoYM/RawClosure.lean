import Mathlib
import RussoYM.AlgebraCore
import RussoYM.ProofSkeleton
import RussoYM.RGCrossing
import RussoYM.Threshold

set_option linter.style.whitespace false
set_option linter.style.longLine false

namespace RussoYM

/-!
# Raw Closure Skeleton

This file connects the verified RG-crossing algebra to the verified
gap-lifting algebra.

It still does not prove the analytic/RG assumptions.
It proves that, if controlled RG crossing implies the strong-coupling
quadratic condition, then the fine-lattice gap lower bound is positive.
-/

/-
Raw gap closure from controlled RG crossing and block stability.

Inputs:

1. controlled RG recursion for inverse coupling;
2. inverse-coupling relation `y n = 1 / u n`;
3. finite-step crossing below `1 / xstab`;
4. a bridge assumption saying that crossing `xstab < u n` implies the
   strong-coupling quadratic block condition;
5. UV positivity and small mixing.

Conclusion:

the fine-lattice gap lower bound is positive.
-/
theorem raw_gap_from_controlled_rg_and_stability
    (y R u : Nat -> Real)
    {betaLog theta xstab Ccl r Cloc lambdaPhys cUV ell Clift omega : Real}
    {n : Nat}
    (hEq : forall k, y (Nat.succ k) = y k - betaLog + R k)
    (hR : forall k, R k <= theta * betaLog)
    (hRel : forall k, y k = 1 / u k)
    (hxstab : 0 < xstab)
    (hupos : 0 < u n)
    (hcross :
      y 0 - (n : Real) * ((1 - theta) * betaLog) < 1 / xstab)
    (hquad_from_cross :
      xstab < u n ->
        Ccl * Cloc + Ccl * r * (u n) < lambdaPhys * (u n)^2)
    (hcUV : 0 < cUV)
    (hell : 0 < ell)
    (hsmall :
      Clift * omega <
        min
          ((u n) * (lambdaPhys - Ccl * (Cloc / (u n)^2 + r / (u n))))
          (cUV / ell)) :
    0 <
      min
        ((u n) * (lambdaPhys - Ccl * (Cloc / (u n)^2 + r / (u n))))
        (cUV / ell)
      - Clift * omega := by
  have hcoupling : xstab < u n := by
    exact controlled_rg_coupling_crosses y R u hEq hR hRel hxstab hupos hcross
  have hquad :
      Ccl * Cloc + Ccl * r * (u n) < lambdaPhys * (u n)^2 := by
    exact hquad_from_cross hcoupling
  exact raw_gap_algebraic_closure hupos hquad hcUV hell hsmall

/-
Eventual raw gap closure.

Controlled RG eventually crosses the coupling threshold.
If crossing the threshold implies the strong-coupling quadratic block condition,
and the UV/mixing assumptions hold for that crossing step, then there exists
a step `n` where the fine-lattice gap lower bound is positive.
-/
theorem exists_raw_gap_from_eventual_rg
    (y R u : Nat -> Real)
    {betaLog theta xstab Ccl r Cloc lambdaPhys cUV ell Clift omega : Real}
    (hEq : forall k, y (Nat.succ k) = y k - betaLog + R k)
    (hR : forall k, R k <= theta * betaLog)
    (hRel : forall k, y k = 1 / u k)
    (hupos : forall k, 0 < u k)
    (hxstab : 0 < xstab)
    (hTheta : theta < 1)
    (hBeta : 0 < betaLog)
    (hquad_from_cross :
      forall k,
        xstab < u k ->
          Ccl * Cloc + Ccl * r * (u k) < lambdaPhys * (u k)^2)
    (hcUV : 0 < cUV)
    (hell : 0 < ell)
    (hsmall :
      forall k,
        xstab < u k ->
          Clift * omega <
            min
              ((u k) * (lambdaPhys - Ccl * (Cloc / (u k)^2 + r / (u k))))
              (cUV / ell)) :
    exists n : Nat,
      0 <
        min
          ((u n) * (lambdaPhys - Ccl * (Cloc / (u n)^2 + r / (u n))))
          (cUV / ell)
        - Clift * omega := by
  obtain ⟨n, hcross⟩ :=
    controlled_rg_eventually_coupling_crosses
      y R u hEq hR hRel hupos hxstab hTheta hBeta
  use n
  have hquad :
      Ccl * Cloc + Ccl * r * (u n) < lambdaPhys * (u n)^2 := by
    exact hquad_from_cross n hcross
  have hsmall_n :
      Clift * omega <
        min
          ((u n) * (lambdaPhys - Ccl * (Cloc / (u n)^2 + r / (u n))))
          (cUV / ell) := by
    exact hsmall n hcross
  exact raw_gap_algebraic_closure (hupos n) hquad hcUV hell hsmall_n

/-
Raw gap closure using the actual square-root stability threshold.

This removes the abstract bridge assumption

  hquad_from_cross

and instead uses the threshold formula directly:

  xstab =
    (Ccl*r + sqrt((Ccl*r)^2 + 4*lambdaPhys*Ccl*Cloc))
      / (2*lambdaPhys).

If controlled RG crosses this threshold, then the block-gap lower bound is
positive, and the gap-lifting algebra gives a positive fine-lattice gap lower
bound.
-/
theorem raw_gap_from_controlled_rg_and_sqrt_threshold
    (y R u : Nat -> Real)
    {betaLog theta xstab Ccl r Cloc lambdaPhys cUV ell Clift omega : Real}
    {n : Nat}
    (hEq : forall k, y (Nat.succ k) = y k - betaLog + R k)
    (hR : forall k, R k <= theta * betaLog)
    (hRel : forall k, y k = 1 / u k)
    (hxstab_def :
      xstab =
        (Ccl * r + Real.sqrt ((Ccl * r)^2 + 4 * lambdaPhys * Ccl * Cloc))
          / (2 * lambdaPhys))
    (hxstab : 0 < xstab)
    (hupos : 0 < u n)
    (hcross :
      y 0 - (n : Real) * ((1 - theta) * betaLog) < 1 / xstab)
    (hCcl : 0 < Ccl)
    (hCloc : 0 < Cloc)
    (hlambda : 0 < lambdaPhys)
    (hcUV : 0 < cUV)
    (hell : 0 < ell)
    (hsmall :
      Clift * omega <
        min
          ((u n) * (lambdaPhys - Ccl * (Cloc / (u n)^2 + r / (u n))))
          (cUV / ell)) :
    0 <
      min
        ((u n) * (lambdaPhys - Ccl * (Cloc / (u n)^2 + r / (u n))))
        (cUV / ell)
      - Clift * omega := by
  have hcoupling : xstab < u n := by
    exact controlled_rg_coupling_crosses y R u hEq hR hRel hxstab hupos hcross
  have hthreshold :
      (Ccl * r + Real.sqrt ((Ccl * r)^2 + 4 * lambdaPhys * Ccl * Cloc))
          / (2 * lambdaPhys) < u n := by
    simpa [hxstab_def] using hcoupling
  have hBlock :
      0 < (u n) * (lambdaPhys - Ccl * (Cloc / (u n)^2 + r / (u n))) := by
    exact block_gap_positive_from_sqrt_threshold hCcl hCloc hlambda hupos hthreshold
  exact gap_lifting_with_uv_scale hBlock hcUV hell hsmall

end RussoYM

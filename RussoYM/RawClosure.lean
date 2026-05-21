import Mathlib
import RussoYM.AlgebraCore
import RussoYM.ProofSkeleton
import RussoYM.RGCrossing

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

end RussoYM

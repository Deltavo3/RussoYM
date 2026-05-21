import Mathlib
import RussoYM.RawClosure
import RussoYM.Threshold

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Mass Gap Criterion

This file packages the verified algebraic raw-gap closure into named
definitions.

It does not prove the analytic red lemmas.
It states the clean conditional algebraic criterion:

controlled RG crossing of the square-root threshold
+ UV positivity
+ small mixing
=> existence of a positive fine-gap lower bound.
-/

/-
The square-root strong-coupling stability threshold:

  xstab =
    (Ccl*r + sqrt((Ccl*r)^2 + 4*lambdaPhys*Ccl*Cloc))
      / (2*lambdaPhys).
-/
noncomputable def xstabSqrt
    (Ccl r Cloc lambdaPhys : Real) : Real :=
  (Ccl * r + Real.sqrt ((Ccl * r)^2 + 4 * lambdaPhys * Ccl * Cloc))
    / (2 * lambdaPhys)

/-
The block-gap lower-bound expression:

  u * (lambdaPhys - Ccl * (Cloc/u^2 + r/u)).
-/
noncomputable def blockGapLower
    (u Ccl r Cloc lambdaPhys : Real) : Real :=
  u * (lambdaPhys - Ccl * (Cloc / u^2 + r / u))

/-
The fine-lattice gap lower bound after gap lifting:

  min(blockGapLower, cUV/ell) - Clift*omega.
-/
noncomputable def fineGapLower
    (u Ccl r Cloc lambdaPhys cUV ell Clift omega : Real) : Real :=
  min (blockGapLower u Ccl r Cloc lambdaPhys) (cUV / ell)
    - Clift * omega

/-
Clean algebraic raw mass-gap criterion.

If controlled RG eventually crosses the square-root threshold, and the UV/mixing
assumptions hold, then there exists some RG step where the fine-gap lower bound
is positive.
-/
theorem exists_positive_fine_gap_from_controlled_rg
    (y R u : Nat -> Real)
    {betaLog theta Ccl r Cloc lambdaPhys cUV ell Clift omega : Real}
    (hEq : forall k, y (Nat.succ k) = y k - betaLog + R k)
    (hR : forall k, R k <= theta * betaLog)
    (hRel : forall k, y k = 1 / u k)
    (hupos : forall k, 0 < u k)
    (hxstab_pos : 0 < xstabSqrt Ccl r Cloc lambdaPhys)
    (hTheta : theta < 1)
    (hBeta : 0 < betaLog)
    (hCcl : 0 < Ccl)
    (hCloc : 0 < Cloc)
    (hlambda : 0 < lambdaPhys)
    (hcUV : 0 < cUV)
    (hell : 0 < ell)
    (hsmall :
      forall k,
        xstabSqrt Ccl r Cloc lambdaPhys < u k ->
          Clift * omega <
            min
              (blockGapLower (u k) Ccl r Cloc lambdaPhys)
              (cUV / ell)) :
    exists n : Nat,
      0 < fineGapLower (u n) Ccl r Cloc lambdaPhys cUV ell Clift omega := by
  have hraw :
      exists n : Nat,
        0 <
          min
            ((u n) * (lambdaPhys - Ccl * (Cloc / (u n)^2 + r / (u n))))
            (cUV / ell)
          - Clift * omega := by
    exact exists_raw_gap_from_eventual_rg_and_sqrt_threshold
      y R u
      (xstab := xstabSqrt Ccl r Cloc lambdaPhys)
      hEq hR hRel hupos
      (by rfl)
      hxstab_pos
      hTheta hBeta
      hCcl hCloc hlambda
      hcUV hell
      (by
        intro k hk
        exact hsmall k hk)
  simpa [fineGapLower, blockGapLower] using hraw

end RussoYM

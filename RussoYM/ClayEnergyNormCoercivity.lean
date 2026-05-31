import RussoYM.ClayReducedAnalyticRoadmap

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.emptyLine false

namespace RussoYM

/-!
# Clay Energy-Norm Coercivity

This file Lean-verifies the definition-level coercivity discharge coming from
the energy-norm convention.

If

  Energy n = (curvatureNorm n)^2

for every regulator level `n`, then the curvature coercivity obligation holds
with witness `mu = 1`.

This does not prove a spectral gap.  It only records that, under the chosen
definition of `curvatureNorm`, energy controls curvature squared by identity.
-/

/--
Energy-norm identity gives the curvature coercivity existence obligation with
witness `mu = 1`.
-/
theorem ClayCurvatureCoercivityExistenceAssumptions.of_energy_norm_identity
    {Energy curvatureNorm : Nat -> Real}
    (hEnergyDef :
      forall n, Energy n = (curvatureNorm n)^2) :
    ClayCurvatureCoercivityExistenceAssumptions
      Energy curvatureNorm := by
  exact
    { exists_coercivity :=
        ⟨1,
          by norm_num,
          by
            intro n
            rw [hEnergyDef n]
            simp⟩ }

/--
Energy-norm identity exposes the concrete `mu = 1` coercivity witness.
-/
theorem energy_norm_identity_mu_one_witness
    {Energy curvatureNorm : Nat -> Real}
    (hEnergyDef :
      forall n, Energy n = (curvatureNorm n)^2) :
    0 < (1 : Real)
      ∧ forall n, (1 : Real) * (curvatureNorm n)^2 <= Energy n := by
  constructor
  · norm_num
  · intro n
    rw [hEnergyDef n]
    simp

/--
Energy-norm identity gives the explicit existential coercivity witness.
-/
theorem exists_coercivity_of_energy_norm_identity
    {Energy curvatureNorm : Nat -> Real}
    (hEnergyDef :
      forall n, Energy n = (curvatureNorm n)^2) :
    ∃ mu : Real,
      0 < mu
        ∧ forall n, mu * (curvatureNorm n)^2 <= Energy n := by
  exact
    (ClayCurvatureCoercivityExistenceAssumptions.of_energy_norm_identity
      hEnergyDef).exists_coercivity

end RussoYM

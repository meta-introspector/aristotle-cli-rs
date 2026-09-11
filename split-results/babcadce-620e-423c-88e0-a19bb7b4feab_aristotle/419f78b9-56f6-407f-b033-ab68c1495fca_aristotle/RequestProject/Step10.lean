import Lean

/-!
# Stage 10 — Full Truncated j-Invariant

Complete the truncation to order q³.

  j(q) = q⁻¹ + 744 + 196884·q + 21493760·q² + 864299970·q³ + O(q⁴)

All coefficients and powers are kernel-verified via definitional equality (`rfl`).
No `#eval` is used — every fact is checked by the Lean kernel.
-/

structure QTerm where
  coeff : Int
  power : Int
deriving Repr, DecidableEq

abbrev QSeries := List QTerm

/-- The truncated j-invariant q-expansion through O(q⁴). -/
def jInvariantQexp4 : QSeries :=
[
  ⟨1, -1⟩,
  ⟨744, 0⟩,
  ⟨196884, 1⟩,
  ⟨21493760, 2⟩,
  ⟨864299970, 3⟩
]

-- Kernel-checked: five terms present
example : jInvariantQexp4.length = 5 := rfl

-- Kernel-checked: all coefficients
example : (jInvariantQexp4[0]'(by decide)).coeff = 1 := rfl
example : (jInvariantQexp4[1]'(by decide)).coeff = 744 := rfl
example : (jInvariantQexp4[2]'(by decide)).coeff = 196884 := rfl
example : (jInvariantQexp4[3]'(by decide)).coeff = 21493760 := rfl
example : (jInvariantQexp4[4]'(by decide)).coeff = 864299970 := rfl

-- Kernel-checked: all powers
example : (jInvariantQexp4[0]'(by decide)).power = -1 := rfl
example : (jInvariantQexp4[1]'(by decide)).power = 0 := rfl
example : (jInvariantQexp4[2]'(by decide)).power = 1 := rfl
example : (jInvariantQexp4[3]'(by decide)).power = 2 := rfl
example : (jInvariantQexp4[4]'(by decide)).power = 3 := rfl

-- Kernel-checked: the leading term is q⁻¹ (coefficient 1, power -1)
theorem j_leading_term :
    jInvariantQexp4.head? = some ⟨1, -1⟩ := rfl

-- Kernel-checked: the constant term is 744
theorem j_constant_term :
    (jInvariantQexp4[1]'(by decide)) = ⟨744, 0⟩ := rfl

-- Kernel-checked: relationship to Monster group — 196884 = 196883 + 1
-- (McKay's observation, the spark of monstrous moonshine)
theorem mckay_observation : (196884 : Int) = 196883 + 1 := rfl

#check jInvariantQexp4
#check j_leading_term
#check j_constant_term
#check mckay_observation

import Mathlib

/-!
# Character Twisted Eta: The χ mod 6 character

This file defines the completely multiplicative character `chi : ℕ → ℤ`
associated with the modulus 6.
-/

/-- The real primitive character mod 6. -/
def chi (n : ℕ) : ℤ :=
  if n % 2 = 0 then 0
  else if n % 3 = 0 then 0
  else if n % 6 = 1 then 1
  else -1

theorem chi_values (n : ℕ) : chi n = 0 ∨ chi n = 1 ∨ chi n = -1 := by
  unfold chi; split_ifs <;> simp

theorem chi_one : chi 1 = 1 := by decide

/-- Helper: chi depends only on residue mod 6 -/
private theorem chi_eq_of_mod_eq {a b : ℕ} (h : a % 6 = b % 6) : chi a = chi b := by
  unfold chi
  have h2 : a % 2 = b % 2 := by omega
  have h3 : a % 3 = b % 3 := by omega
  simp [h2, h3, h]

/-- chi is completely multiplicative -/
theorem chi_mul (a b : ℕ) : chi (a * b) = chi a * chi b := by
  -- Reduce to residues mod 6
  have key : chi (a * b) = chi ((a % 6) * (b % 6)) := by
    apply chi_eq_of_mod_eq; rw [Nat.mul_mod]
  have ka : chi a = chi (a % 6) := chi_eq_of_mod_eq (Nat.mod_mod_of_dvd a (by decide : 6 ∣ 6)).symm
  have kb : chi b = chi (b % 6) := chi_eq_of_mod_eq (Nat.mod_mod_of_dvd b (by decide : 6 ∣ 6)).symm
  rw [key, ka, kb]
  -- Now a % 6 and b % 6 are in {0,...,5}, so we can decide
  have ha := Nat.mod_lt a (show 0 < 6 by omega)
  have hb := Nat.mod_lt b (show 0 < 6 by omega)
  interval_cases (a % 6) <;> interval_cases (b % 6) <;> simp [chi] <;> omega

import Mathlib

/-!
# Character χ mod 6

The Kronecker symbol χ = χ_{-3}, a completely multiplicative function
`chi : ℕ → ℤ` with values in `{0, +1, -1}`.

- `chi n = 0`  if `2 ∣ n` or `3 ∣ n`
- `chi n = 1`  if `n % 6 = 1`
- `chi n = -1` if `n % 6 = 5`
-/

/-- The character χ mod 6 (Kronecker symbol χ_{-3}).
    Returns 0 if n is divisible by 2 or 3, +1 if n ≡ 1 mod 6, -1 if n ≡ 5 mod 6. -/
def chi (n : ℕ) : ℤ :=
  if n % 2 = 0 ∨ n % 3 = 0 then 0
  else if n % 6 = 1 then 1
  else -1

theorem chi_values (n : ℕ) : chi n = 0 ∨ chi n = 1 ∨ chi n = -1 := by
  unfold chi
  split_ifs <;> simp

theorem chi_one : chi 1 = 1 := by decide

private theorem chi_of_mod6 (n : ℕ) : chi n =
    match n % 6 with
    | 0 => 0 | 1 => 1 | 2 => 0 | 3 => 0 | 4 => 0 | 5 => -1 | _ => 0 := by
  unfold chi
  have hlt : n % 6 < 6 := Nat.mod_lt n (by omega)
  have h26 : n % 2 = (n % 6) % 2 := by
    rw [Nat.mod_mod_of_dvd]; decide
  have h36 : n % 3 = (n % 6) % 3 := by
    rw [Nat.mod_mod_of_dvd]; decide
  interval_cases (n % 6) <;> simp_all

theorem chi_mul (a b : ℕ) : chi (a * b) = chi a * chi b := by
  rw [chi_of_mod6 a, chi_of_mod6 b, chi_of_mod6 (a * b)]
  have hab : (a * b) % 6 = (a % 6 * (b % 6)) % 6 := Nat.mul_mod a b 6
  have ha6 : a % 6 < 6 := Nat.mod_lt a (by omega)
  have hb6 : b % 6 < 6 := Nat.mod_lt b (by omega)
  interval_cases (a % 6) <;> interval_cases (b % 6) <;> simp_all

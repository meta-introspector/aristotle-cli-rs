import Mathlib

/-!
# DULA Theorem — Corrected Formalization in Lean 4
==============================================================================

This file formalizes the DULA grading φ : M₆ → ℤ/2ℤ and its connection to
the Dirichlet character χ₃ (mod 3).
-/

open ArithmeticFunction Finset Nat

noncomputable section

/-! ## 1. The DULA Grading -/

/-- Total exponent (with multiplicity) of all primes ≡ 5 (mod 6) dividing n.
    Defined to be 0 when n = 0. -/
def dulaM (n : ℕ) : ℕ :=
  if n = 0 then 0
  else (Nat.factorization n).sum fun p e => if p % 6 = 5 then e else 0

/-- The DULA grading φ(n) ≡ dulaM(n) (mod 2). On the multiplicative monoid
    M₆ of integers coprime to 6, φ is a homomorphism to ℤ/2ℤ.
    Defined as 0 for n = 0. -/
def dulaPhi (n : ℕ) : ZMod 2 :=
  if n = 0 then 0
  else (Nat.factorization n).sum fun p e => if p % 6 = 5 then (e : ZMod 2) else 0

/-
`dulaM` is additive on multiplication of nonzero naturals.
-/
theorem dulaM_additive {a b : ℕ} (ha : a ≠ 0) (hb : b ≠ 0) :
    dulaM (a * b) = dulaM a + dulaM b := by
  unfold dulaM;
  rw [ Nat.factorization_mul ha hb, Finsupp.sum_add_index' ] <;> aesop

/-
φ is additive on multiplication of nonzero naturals.
-/
theorem dulaPhi_additive {a b : ℕ} (ha : a ≠ 0) (hb : b ≠ 0) :
    dulaPhi (a * b) = dulaPhi a + dulaPhi b := by
  unfold dulaPhi;
  simp_all +decide [ Nat.factorization_mul ];
  rw [ Finsupp.sum_add_index' ] <;> aesop

/-! ## 2. The Arithmetic Function dulaChar -/

/-- `dulaChar n` = (-1)^{dulaM(n)} when gcd(n,6)=1, else 0. -/
def dulaChar (n : ℕ) : ℤ :=
  if Nat.gcd n 6 = 1 then (-1 : ℤ) ^ dulaM n else 0

lemma gcd_mul_six {a b : ℕ} (ha : Nat.gcd a 6 = 1) (hb : Nat.gcd b 6 = 1) :
    Nat.gcd (a * b) 6 = 1 := by
  exact Nat.Coprime.mul_left ha hb

/-- `dulaChar` is completely multiplicative on integers coprime to 6. -/
theorem dulaChar_mul (a b : ℕ) (ha : Nat.gcd a 6 = 1) (hb : Nat.gcd b 6 = 1) :
    dulaChar (a * b) = dulaChar a * dulaChar b := by
  have ha0 : a ≠ 0 := by intro h; subst h; simp at ha
  have hb0 : b ≠ 0 := by intro h; subst h; simp at hb
  have hab : Nat.gcd (a * b) 6 = 1 := gcd_mul_six ha hb
  unfold dulaChar
  rw [if_pos hab, if_pos ha, if_pos hb]
  rw [dulaM_additive ha0 hb0, pow_add]

/-! ## 3. The CORRECT Key Identity -/

/-- **The key identity, correctly stated.** -/
theorem key_identity_general (f : ArithmeticFunction ℝ) :
    (f * vonMangoldt) * (↑zeta : ArithmeticFunction ℝ) =
      f * ArithmeticFunction.log := by
  rw [mul_assoc, vonMangoldt_mul_zeta]

/-- Cast of `dulaChar` to an ℝ-valued `ArithmeticFunction`. -/
def dulaCharReal : ArithmeticFunction ℝ where
  toFun n := (dulaChar n : ℝ)
  map_zero' := by simp [dulaChar]

/-- The DULA key identity, specialized to `dulaCharReal`. -/
theorem dula_key_identity :
    (dulaCharReal * vonMangoldt) * (↑zeta : ArithmeticFunction ℝ) =
      dulaCharReal * ArithmeticFunction.log :=
  key_identity_general dulaCharReal

/-! ## 4. dulaChar at primes -/

/-
For a prime `p > 3`, `dulaChar p` is +1 if `p ≡ 1 (mod 6)` and -1 if
    `p ≡ 5 (mod 6)`.
-/
theorem dulaChar_at_prime (p : ℕ) (hp : Nat.Prime p) (hp3 : 3 < p) :
    dulaChar p = if p % 6 = 1 then (1 : ℤ) else -1 := by
  unfold dulaChar dulaM;
  have := Nat.mod_lt p ( by decide : 6 > 0 );
  interval_cases _ : p % 6 <;> simp_all +decide;
  all_goals have := Nat.Prime.eq_two_or_odd hp; simp_all +decide [ ← Nat.mod_mod_of_dvd p ( by decide : 2 ∣ 6 ) ];
  · rw [ ← Nat.mod_add_div p 6, ‹p % 6 = _› ] ; norm_num;
  · exact absurd ( Nat.dvd_of_mod_eq_zero ( show p % 3 = 0 by norm_num [ ← Nat.mod_mod_of_dvd p ( by decide : 3 ∣ 6 ), * ] ) ) ( by rw [ hp.dvd_iff_eq ] <;> linarith );
  · rw [ if_pos ( by rw [ ← Nat.mod_add_div p 6, ‹p % 6 = _› ] ; norm_num ), if_neg ( by linarith ) ]

/-! ## 5. Summary -/

/-- Summary of what this file establishes. -/
theorem dula_theorem_summary :
    (dulaCharReal * vonMangoldt) * (↑zeta : ArithmeticFunction ℝ) =
      dulaCharReal * ArithmeticFunction.log :=
  dula_key_identity

end

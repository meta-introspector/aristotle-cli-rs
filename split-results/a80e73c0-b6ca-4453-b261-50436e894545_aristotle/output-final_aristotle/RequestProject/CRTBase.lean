import Mathlib

/-!
# Base CRT over {47, 59, 71}

The Monster group's dimension 196883 = 47 × 59 × 71 gives rise to a canonical
CRT decomposition ℤ/196883 ≅ ℤ/47 × ℤ/59 × ℤ/71.

The three CRT idempotents are:
- e₄₇ = 33512  (≡ 1 mod 47, ≡ 0 mod 59, ≡ 0 mod 71)
- e₅₉ = 113458 (≡ 0 mod 47, ≡ 1 mod 59, ≡ 0 mod 71)
- e₇₁ = 49914  (≡ 0 mod 47, ≡ 0 mod 59, ≡ 1 mod 71)

These satisfy:
- e₄₇ + e₅₉ + e₇₁ ≡ 1 (mod 196883)
- eᵢ² ≡ eᵢ (mod 196883)        [idempotency]
- eᵢ · eⱼ ≡ 0 (mod 196883)     [orthogonality, i ≠ j]
-/

/-! ## Factorization of 196883 -/

theorem factorization_196883 : 196883 = 47 * 59 * 71 := by norm_num

theorem prime_47 : Nat.Prime 47 := by decide
theorem prime_59 : Nat.Prime 59 := by decide
theorem prime_71 : Nat.Prime 71 := by decide

/-! ## CRT Idempotent Values -/

/-- The CRT idempotent for the mod-47 component: e₄₇ = (59 × 71) × ((59 × 71)⁻¹ mod 47) -/
abbrev e47 : ZMod 196883 := 33512

/-- The CRT idempotent for the mod-59 component: e₅₉ = (47 × 71) × ((47 × 71)⁻¹ mod 59) -/
abbrev e59 : ZMod 196883 := 113458

/-- The CRT idempotent for the mod-71 component: e₇₁ = (47 × 59) × ((47 × 59)⁻¹ mod 71) -/
abbrev e71 : ZMod 196883 := 49914

/-! ## Construction verification -/

theorem e47_construction : (59 * 71 : ℕ) = 4189 := by norm_num
theorem e59_construction : (47 * 71 : ℕ) = 3337 := by norm_num
theorem e71_construction : (47 * 59 : ℕ) = 2773 := by norm_num

theorem e47_value : (4189 * 8 : ℕ) = 33512 := by norm_num
theorem e59_value : (3337 * 34 : ℕ) = 113458 := by norm_num
theorem e71_value : (2773 * 18 : ℕ) = 49914 := by norm_num

/-! ## Inverse verification: (M/p)⁻¹ mod p -/

theorem inv_4189_mod_47 : (4189 : ZMod 47) * 8 = 1 := by native_decide
theorem inv_3337_mod_59 : (3337 : ZMod 59) * 34 = 1 := by native_decide
theorem inv_2773_mod_71 : (2773 : ZMod 71) * 18 = 1 := by native_decide

/-! ## Canonical projections from ℤ/196883 -/

noncomputable def proj47 : ZMod 196883 →+* ZMod 47 :=
  ZMod.castHom (by norm_num : (47 : ℕ) ∣ 196883) (ZMod 47)

noncomputable def proj59 : ZMod 196883 →+* ZMod 59 :=
  ZMod.castHom (by norm_num : (59 : ℕ) ∣ 196883) (ZMod 59)

noncomputable def proj71 : ZMod 196883 →+* ZMod 71 :=
  ZMod.castHom (by norm_num : (71 : ℕ) ∣ 196883) (ZMod 71)

/-! ## Idempotent congruence properties -/

/-- e₄₇ ≡ 1 (mod 47) -/
theorem e47_proj47 : proj47 e47 = 1 := by unfold proj47; native_decide

/-- e₄₇ ≡ 0 (mod 59) -/
theorem e47_proj59 : proj59 e47 = 0 := by unfold proj59; native_decide

/-- e₄₇ ≡ 0 (mod 71) -/
theorem e47_proj71 : proj71 e47 = 0 := by unfold proj71; native_decide

/-- e₅₉ ≡ 0 (mod 47) -/
theorem e59_proj47 : proj47 e59 = 0 := by unfold proj47; native_decide

/-- e₅₉ ≡ 1 (mod 59) -/
theorem e59_proj59 : proj59 e59 = 1 := by unfold proj59; native_decide

/-- e₅₉ ≡ 0 (mod 71) -/
theorem e59_proj71 : proj71 e59 = 0 := by unfold proj71; native_decide

/-- e₇₁ ≡ 0 (mod 47) -/
theorem e71_proj47 : proj47 e71 = 0 := by unfold proj47; native_decide

/-- e₇₁ ≡ 0 (mod 59) -/
theorem e71_proj59 : proj59 e71 = 0 := by unfold proj59; native_decide

/-- e₇₁ ≡ 1 (mod 71) -/
theorem e71_proj71 : proj71 e71 = 1 := by unfold proj71; native_decide

/-! ## Partition of unity -/

/-- The three idempotents sum to 1 in ℤ/196883. -/
theorem idempotent_sum : e47 + e59 + e71 = (1 : ZMod 196883) := by native_decide

/-! ## Idempotency -/

theorem e47_idempotent : e47 * e47 = e47 := by native_decide
theorem e59_idempotent : e59 * e59 = e59 := by native_decide
theorem e71_idempotent : e71 * e71 = e71 := by native_decide

/-! ## Orthogonality -/

theorem e47_e59_orthogonal : e47 * e59 = 0 := by native_decide
theorem e47_e71_orthogonal : e47 * e71 = 0 := by native_decide
theorem e59_e71_orthogonal : e59 * e71 = 0 := by native_decide

/-! ## CRT coordinate reconstruction

For a triple (a₄₇, a₅₉, a₇₁), the global address is:
  X ≡ a₄₇ · e₄₇ + a₅₉ · e₅₉ + a₇₁ · e₇₁ (mod 196883)
-/

/-- Reconstruct a global address from CRT coordinates. -/
def crtAddress (a47' a59' a71' : ℕ) : ZMod 196883 :=
  a47' • e47 + a59' • e59 + a71' • e71

/-- Row 192 example: (1,1,1) ↦ 1 (since 33512 + 113458 + 49914 = 196884 ≡ 1 mod 196883) -/
theorem row192_address : crtAddress 1 1 1 = 1 := by
  unfold crtAddress; native_decide

/-- Row 174 example: (1,1,0) ↦ 146970 -/
theorem row174_address : crtAddress 1 1 0 = (146970 : ZMod 196883) := by
  unfold crtAddress; native_decide

/-! ## CRT Round-Trip Theorems

The key property: projecting the global address back to each factor
recovers the original coordinate.
-/

theorem crt_roundtrip_47 (a47' a59' a71' : ℕ) :
    proj47 (crtAddress a47' a59' a71') = (a47' : ZMod 47) := by
  unfold crtAddress; simp +decide [*, add_assoc]
  rw [e47_proj47, e59_proj47, e71_proj47]; ring

theorem crt_roundtrip_59 (a47' a59' a71' : ℕ) :
    proj59 (crtAddress a47' a59' a71') = (a59' : ZMod 59) := by
  unfold crtAddress;
  simp +decide [ e47_proj59, e59_proj59, e71_proj59 ]

theorem crt_roundtrip_71 (a47' a59' a71' : ℕ) :
    proj71 (crtAddress a47' a59' a71') = (a71' : ZMod 71) := by
  unfold crtAddress;
  simp +decide [ e47_proj71, e59_proj71, e71_proj71 ]
/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import Mathlib
import RequestProject.Imported.OutputFinal3.GroupA5

/-!
# The von Dyck group `(2,3,5)` is `A₅`

Klein's icosahedral relations `a⁵ = b² = (ab)³ = 1` present the alternating group `A₅`.  This
file proves that, in the form that is needed to identify concrete matrix groups:

* `ArtinA5Even.VonDyck.card_closure_le` — in **any** group, two elements `a`, `b` with
  `a⁵ = b² = (ab)³ = 1` generate a subgroup with at most `60` elements.  The proof is an
  explicit Todd–Coxeter coset enumeration: twelve coset representatives `w₀, …, w₁₁` (words in
  `a` and `b`) are written down, and the two identities `a·wⱼ = wⱼ' · aᵏ`, `b·wⱼ = wⱼ' · aᵏ`
  are *derived from the three relations* for every `j`.  Hence the set
  `{wⱼ aⁱ : j < 12, i < 5}` is stable under left multiplication by `a` and `b` and contains
  the subgroup they generate.
* `ArtinA5Even.VonDyck.deltaEquivAlternating` — the presented group
  `Δ(2,3,5) = ⟨x, y | x⁵, y², (xy)³⟩` is isomorphic to `A₅`: it has at most `60` elements by the
  above, and it surjects onto `A₅` because a five-cycle `permA` and a double transposition
  `permB` satisfy the relations and generate a subgroup of order divisible by `15`
  (`ArtinA5Even.alternating_le_of_fifteen_dvd`), hence all of `A₅`.  So
  `ArtinA5Even.VonDyck.card_delta : Nat.card Δ(2,3,5) = 60`.
* `ArtinA5Even.VonDyck.closureEquivAlternating` — consequently, for any group `G` and any
  `a b : G` satisfying the three relations with `a ≠ 1`, the subgroup `⟨a, b⟩` **is** `A₅`:
  the homomorphism `Δ(2,3,5) →* G` with `x ↦ a`, `y ↦ b` has range `⟨a, b⟩`, and its kernel is
  a normal subgroup of the simple group `Δ(2,3,5) ≅ A₅`, so it is trivial.
* `ArtinA5Even.VonDyck.card_closure_eq_sixty` — in particular `|⟨a, b⟩| = 60`.

Nothing here is arithmetic: this is pure finite group theory.
-/

namespace ArtinA5Even

namespace VonDyck

variable {G : Type*} [Group G] {a b : G}

/-! ## Consequences of the three relations -/

theorem b_mul_b (hb : b ^ 2 = 1) : b * b = 1 := by rw [← sq]; exact hb

theorem inv_b (hb : b ^ 2 = 1) : b⁻¹ = b := inv_eq_of_mul_eq_one_right (b_mul_b hb)

theorem inv_a (ha : a ^ 5 = 1) : a⁻¹ = a ^ 4 :=
  inv_eq_of_mul_eq_one_right (by rw [← pow_succ']; exact ha)

theorem pow_mod_five (ha : a ^ 5 = 1) (i : ℕ) : a ^ i = a ^ (i % 5) := by
  conv_lhs => rw [← Nat.div_add_mod i 5]
  rw [pow_add, pow_mul, ha, one_pow, one_mul]

theorem a4_a4 (ha : a ^ 5 = 1) : a ^ 4 * a ^ 4 = a ^ 3 := by
  rw [← pow_add, show (4 + 4 : ℕ) = 3 + 5 from rfl, pow_add, ha, mul_one]

theorem a4_a3 (ha : a ^ 5 = 1) : a ^ 4 * a ^ 3 = a ^ 2 := by
  rw [← pow_add, show (4 + 3 : ℕ) = 2 + 5 from rfl, pow_add, ha, mul_one]

theorem a4_a2 (ha : a ^ 5 = 1) : a ^ 4 * a ^ 2 = a := by
  rw [← pow_add, show (4 + 2 : ℕ) = 1 + 5 from rfl, pow_add, ha, mul_one, pow_one]

theorem a4_a1 (ha : a ^ 5 = 1) : a ^ 4 * a = 1 := by
  rw [← pow_succ]; exact ha

theorem a3_a2 (ha : a ^ 5 = 1) : a ^ 3 * a ^ 2 = 1 := by
  rw [← pow_add]; exact ha

theorem aba_mul_bab (hab : (a * b) ^ 3 = 1) : (a * b * a) * (b * a * b) = 1 := by
  calc (a * b * a) * (b * a * b) = (a * b) ^ 3 := by rw [pow_succ, pow_succ, pow_one]; group
    _ = 1 := hab

/-- `a b a = b a⁴ b`, one form of the relation `(ab)³ = 1`. -/
theorem key_aba (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) :
    a * b * a = b * a ^ 4 * b := by
  have h : a * b * a = (b * a * b)⁻¹ := eq_inv_of_mul_eq_one_left (aba_mul_bab hab)
  rw [h]
  simp only [mul_inv_rev, inv_b hb, inv_a ha]
  group

/-- `b a b = a⁴ b a⁴`, the other form of the relation `(ab)³ = 1`. -/
theorem key_bab (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) :
    b * a * b = a ^ 4 * b * a ^ 4 := by
  have h : b * a * b = (a * b * a)⁻¹ := eq_inv_of_mul_eq_one_right (aba_mul_bab hab)
  rw [h]
  simp only [mul_inv_rev, inv_b hb, inv_a ha]
  group

/-! ## The six nontrivial entries of the coset table

With `w₀ = 1`, `w₁ = b`, `w₂ = ab`, `w₃ = a²b`, `w₄ = bab`, `w₅ = a³b`, `w₆ = ba²b`,
`w₇ = ba³b`, `w₈ = aba³b`, `w₉ = a²ba³b`, `w₁₀ = baba³b`, `w₁₁ = ba²ba³b`, the products
`a·wⱼ` and `b·wⱼ` all lie again in `wⱼ' ⟨a⟩`.  All but six of the twenty-four verifications are
immediate from `b² = 1` and `a⁵ = 1`; the six that use `(ab)³ = 1` are proved here. -/

section Table

variable (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1)
include ha hb hab

theorem tbl4a : a * (b * a * b) = b * a ^ 4 := by
  calc a * (b * a * b) = (a * b * a) * b := by group
    _ = (b * a ^ 4 * b) * b := by rw [key_aba ha hb hab]
    _ = b * a ^ 4 * (b * b) := by group
    _ = b * a ^ 4 * 1 := by rw [b_mul_b hb]
    _ = b * a ^ 4 := by group

theorem tbl5a : a * (a ^ 3 * b) = b * a * b * a := by
  calc a * (a ^ 3 * b) = a ^ 4 * b * (a ^ 4 * a) := by rw [a4_a1 ha]; group
    _ = (a ^ 4 * b * a ^ 4) * a := by group
    _ = (b * a * b) * a := by rw [← key_bab ha hb hab]
    _ = b * a * b * a := by group

theorem tbl6a : a * (b * a ^ 2 * b) = b * a ^ 3 * b * a ^ 4 := by
  calc a * (b * a ^ 2 * b) = (a * b * a) * (a * b) := by simp [sq, mul_assoc]
    _ = (b * a ^ 4 * b) * (a * b) := by rw [key_aba ha hb hab]
    _ = b * a ^ 4 * (b * a * b) := by group
    _ = b * a ^ 4 * (a ^ 4 * b * a ^ 4) := by rw [key_bab ha hb hab]
    _ = b * (a ^ 4 * a ^ 4) * b * a ^ 4 := by group
    _ = b * a ^ 3 * b * a ^ 4 := by rw [a4_a4 ha]

theorem tbl9a : a * (a ^ 2 * b * a ^ 3 * b) = b * a * b * a ^ 3 * b * a := by
  calc a * (a ^ 2 * b * a ^ 3 * b) = (a ^ 4 * a ^ 4) * b * ((a ^ 4 * a ^ 4) * b) := by
        rw [a4_a4 ha]; group
    _ = a ^ 4 * ((a ^ 4 * b * a ^ 4) * (a ^ 4 * b)) := by group
    _ = a ^ 4 * ((b * a * b) * (a ^ 4 * b)) := by rw [← key_bab ha hb hab]
    _ = a ^ 4 * b * a * (b * a ^ 4 * b) := by group
    _ = a ^ 4 * b * a * (a * b * a) := by rw [← key_aba ha hb hab]
    _ = (a ^ 4 * b * (a ^ 4 * a ^ 3)) * b * a := by rw [a4_a3 ha]; simp [sq, mul_assoc]
    _ = (a ^ 4 * b * a ^ 4) * a ^ 3 * b * a := by group
    _ = (b * a * b) * a ^ 3 * b * a := by rw [← key_bab ha hb hab]
    _ = b * a * b * a ^ 3 * b * a := by group

theorem tbl10a : a * (b * a * b * a ^ 3 * b) = b * a ^ 2 * b := by
  calc a * (b * a * b * a ^ 3 * b) = (a * b * a) * (b * a ^ 3 * b) := by group
    _ = (b * a ^ 4 * b) * (b * a ^ 3 * b) := by rw [key_aba ha hb hab]
    _ = b * a ^ 4 * (b * b) * a ^ 3 * b := by group
    _ = b * a ^ 4 * 1 * a ^ 3 * b := by rw [b_mul_b hb]
    _ = b * (a ^ 4 * a ^ 3) * b := by group
    _ = b * a ^ 2 * b := by rw [a4_a3 ha]

theorem tbl11a : a * (b * a ^ 2 * b * a ^ 3 * b) = b * a ^ 2 * b * a ^ 3 * b * a ^ 4 := by
  calc a * (b * a ^ 2 * b * a ^ 3 * b) = (a * b * a) * (a * b * a ^ 3 * b) := by
        simp [sq, mul_assoc]
    _ = (b * a ^ 4 * b) * (a * b * a ^ 3 * b) := by rw [key_aba ha hb hab]
    _ = b * a ^ 4 * (b * a * b) * a ^ 3 * b := by group
    _ = b * a ^ 4 * (a ^ 4 * b * a ^ 4) * a ^ 3 * b := by rw [key_bab ha hb hab]
    _ = b * (a ^ 4 * a ^ 4) * b * (a ^ 4 * a ^ 3) * b := by group
    _ = b * a ^ 3 * b * a ^ 2 * b := by rw [a4_a4 ha, a4_a3 ha]
    _ = b * a ^ 2 * (a * b * a) * (a * b) := by
        simp only [pow_succ, pow_zero, one_mul, mul_assoc]
    _ = b * a ^ 2 * (b * a ^ 4 * b) * (a * b) := by rw [key_aba ha hb hab]
    _ = b * a ^ 2 * b * a ^ 4 * (b * a * b) := by group
    _ = b * a ^ 2 * b * a ^ 4 * (a ^ 4 * b * a ^ 4) := by rw [key_bab ha hb hab]
    _ = b * a ^ 2 * b * (a ^ 4 * a ^ 4) * b * a ^ 4 := by group
    _ = b * a ^ 2 * b * a ^ 3 * b * a ^ 4 := by rw [a4_a4 ha]

end Table


/-! ## The twelve coset representatives and the upper bound `|⟨a,b⟩| ≤ 60` -/

section Upper

/-- The twelve representatives of the cosets of `⟨a⟩` in `⟨a, b⟩` (values outside `[0,12)` are
irrelevant and set to `1`). -/
def cosetRep (a b : G) : ℕ → G
  | 0 => 1
  | 1 => b
  | 2 => a * b
  | 3 => a ^ 2 * b
  | 4 => b * a * b
  | 5 => a ^ 3 * b
  | 6 => b * a ^ 2 * b
  | 7 => b * a ^ 3 * b
  | 8 => a * b * a ^ 3 * b
  | 9 => a ^ 2 * b * a ^ 3 * b
  | 10 => b * a * b * a ^ 3 * b
  | 11 => b * a ^ 2 * b * a ^ 3 * b
  | _ => 1

/-- The set of the sixty products `wⱼ aⁱ`, `j < 12`, `i < 5`. -/
def cosetSet (a b : G) : Set G :=
  Set.range fun p : Fin 12 × Fin 5 => cosetRep a b p.1.val * a ^ p.2.val

theorem mem_cosetSet {j : ℕ} (hj : j < 12) (i : ℕ) :
    cosetRep a b j * a ^ (i % 5) ∈ cosetSet a b :=
  ⟨(⟨j, hj⟩, ⟨i % 5, Nat.mod_lt _ (by norm_num)⟩), rfl⟩

theorem one_mem_cosetSet : (1 : G) ∈ cosetSet a b := by
  have := mem_cosetSet (a := a) (b := b) (j := 0) (by norm_num) 0
  simpa [cosetRep] using this

/-- The `a`-column of the coset table. -/
theorem exists_a_mul_cosetRep (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1)
    {j : ℕ} (hj : j < 12) :
    ∃ j' < 12, ∃ k : ℕ, a * cosetRep a b j = cosetRep a b j' * a ^ k := by
  interval_cases j
  · exact ⟨0, by norm_num, 1, by simp [cosetRep]⟩
  · exact ⟨2, by norm_num, 0, by simp [cosetRep]⟩
  · exact ⟨3, by norm_num, 0, by
      simp only [cosetRep, pow_zero, mul_one, pow_succ, pow_zero, one_mul, mul_assoc]⟩
  · exact ⟨5, by norm_num, 0, by
      simp only [cosetRep, pow_zero, mul_one, pow_succ, pow_zero, one_mul, mul_assoc]⟩
  · exact ⟨1, by norm_num, 4, by simpa [cosetRep] using tbl4a ha hb hab⟩
  · exact ⟨4, by norm_num, 1, by
      simpa [cosetRep, mul_assoc] using tbl5a ha hb hab⟩
  · exact ⟨7, by norm_num, 4, by
      simpa [cosetRep, mul_assoc] using tbl6a ha hb hab⟩
  · exact ⟨8, by norm_num, 0, by
      simp only [cosetRep, pow_zero, mul_one, mul_assoc]⟩
  · exact ⟨9, by norm_num, 0, by
      simp only [cosetRep, pow_zero, mul_one, pow_succ, pow_zero, one_mul, mul_assoc]⟩
  · exact ⟨10, by norm_num, 1, by
      simpa [cosetRep, mul_assoc] using tbl9a ha hb hab⟩
  · exact ⟨6, by norm_num, 0, by
      simpa [cosetRep, mul_assoc] using tbl10a ha hb hab⟩
  · exact ⟨11, by norm_num, 4, by
      simpa [cosetRep, mul_assoc] using tbl11a ha hb hab⟩

/-- The `b`-column of the coset table; only `b² = 1` is used. -/
theorem exists_b_mul_cosetRep (hb : b ^ 2 = 1) {j : ℕ} (hj : j < 12) :
    ∃ j' < 12, ∃ k : ℕ, b * cosetRep a b j = cosetRep a b j' * a ^ k := by
  have hbb : b * b = 1 := b_mul_b hb
  interval_cases j
  · exact ⟨1, by norm_num, 0, by simp [cosetRep]⟩
  · exact ⟨0, by norm_num, 0, by simp [cosetRep, hbb]⟩
  · exact ⟨4, by norm_num, 0, by simp only [cosetRep, pow_zero, mul_one, mul_assoc]⟩
  · exact ⟨6, by norm_num, 0, by simp only [cosetRep, pow_zero, mul_one, mul_assoc]⟩
  · exact ⟨2, by norm_num, 0, by
      simp only [cosetRep, pow_zero, mul_one, ← mul_assoc, hbb, one_mul]⟩
  · exact ⟨7, by norm_num, 0, by simp only [cosetRep, pow_zero, mul_one, mul_assoc]⟩
  · exact ⟨3, by norm_num, 0, by
      simp only [cosetRep, pow_zero, mul_one, ← mul_assoc, hbb, one_mul]⟩
  · exact ⟨5, by norm_num, 0, by
      simp only [cosetRep, pow_zero, mul_one, ← mul_assoc, hbb, one_mul]⟩
  · exact ⟨10, by norm_num, 0, by simp only [cosetRep, pow_zero, mul_one, mul_assoc]⟩
  · exact ⟨11, by norm_num, 0, by simp only [cosetRep, pow_zero, mul_one, mul_assoc]⟩
  · exact ⟨8, by norm_num, 0, by
      simp only [cosetRep, pow_zero, mul_one, ← mul_assoc, hbb, one_mul]⟩
  · exact ⟨9, by norm_num, 0, by
      simp only [cosetRep, pow_zero, mul_one, ← mul_assoc, hbb, one_mul]⟩

/-! ### `⟨a, b⟩` is contained in the sixty-element set -/

theorem a_mul_mem_cosetSet (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) {s : G}
    (hs : s ∈ cosetSet a b) : a * s ∈ cosetSet a b := by
  obtain ⟨⟨j, i⟩, rfl⟩ := hs
  obtain ⟨j', hj', k, hk⟩ := exists_a_mul_cosetRep ha hb hab j.isLt
  show a * (cosetRep a b j.val * a ^ i.val) ∈ cosetSet a b
  have he : a * (cosetRep a b j.val * a ^ i.val) = cosetRep a b j' * a ^ ((k + i.val) % 5) := by
    rw [← mul_assoc, hk, mul_assoc, ← pow_add, pow_mod_five ha]
  rw [he]
  exact mem_cosetSet hj' (k + i.val)

theorem b_mul_mem_cosetSet (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) {s : G}
    (hs : s ∈ cosetSet a b) : b * s ∈ cosetSet a b := by
  obtain ⟨⟨j, i⟩, rfl⟩ := hs
  obtain ⟨j', hj', k, hk⟩ := exists_b_mul_cosetRep (a := a) hb j.isLt
  show b * (cosetRep a b j.val * a ^ i.val) ∈ cosetSet a b
  have he : b * (cosetRep a b j.val * a ^ i.val) = cosetRep a b j' * a ^ ((k + i.val) % 5) := by
    rw [← mul_assoc, hk, mul_assoc, ← pow_add, pow_mod_five ha]
  rw [he]
  exact mem_cosetSet hj' (k + i.val)

theorem inv_a_mul_mem_cosetSet (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) {s : G}
    (hs : s ∈ cosetSet a b) : a⁻¹ * s ∈ cosetSet a b := by
  have h4 : a⁻¹ * s = a * (a * (a * (a * s))) := by
    rw [inv_a ha]; simp only [pow_succ, pow_zero, one_mul, mul_assoc]
  rw [h4]
  exact a_mul_mem_cosetSet ha hb hab (a_mul_mem_cosetSet ha hb hab
    (a_mul_mem_cosetSet ha hb hab (a_mul_mem_cosetSet ha hb hab hs)))

theorem inv_b_mul_mem_cosetSet (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) {s : G}
    (hs : s ∈ cosetSet a b) : b⁻¹ * s ∈ cosetSet a b := by
  rw [inv_b hb]
  exact b_mul_mem_cosetSet ha hb hs

/-- Every element of `⟨a, b⟩` is one of the sixty products `wⱼ aⁱ`. -/
theorem closure_subset_cosetSet (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) :
    (Subgroup.closure ({a, b} : Set G) : Set G) ⊆ cosetSet a b := by
  have key : ∀ g ∈ Subgroup.closure ({a, b} : Set G),
      (∀ s ∈ cosetSet a b, g * s ∈ cosetSet a b) ∧
        (∀ s ∈ cosetSet a b, g⁻¹ * s ∈ cosetSet a b) := by
    intro g hg
    induction hg using Subgroup.closure_induction with
    | mem x hx =>
        rcases hx with rfl | rfl
        · exact ⟨fun s hs => a_mul_mem_cosetSet ha hb hab hs,
            fun s hs => inv_a_mul_mem_cosetSet ha hb hab hs⟩
        · exact ⟨fun s hs => b_mul_mem_cosetSet ha hb hs,
            fun s hs => inv_b_mul_mem_cosetSet ha hb hs⟩
    | one => exact ⟨fun s hs => by simpa using hs, fun s hs => by simpa using hs⟩
    | mul x y _ _ ihx ihy =>
        refine ⟨fun s hs => ?_, fun s hs => ?_⟩
        · rw [mul_assoc]; exact ihx.1 _ (ihy.1 _ hs)
        · rw [mul_inv_rev, mul_assoc]; exact ihy.2 _ (ihx.2 _ hs)
    | inv x _ ihx =>
        exact ⟨fun s hs => ihx.2 _ hs, fun s hs => by rw [inv_inv]; exact ihx.1 _ hs⟩
  intro g hg
  simpa using (key g hg).1 1 one_mem_cosetSet

theorem cosetSet_finite : (cosetSet a b).Finite := Set.finite_range _

theorem cosetSet_ncard_le : (cosetSet a b).ncard ≤ 60 := by
  rw [cosetSet, ← Set.image_univ]
  calc ((fun p : Fin 12 × Fin 5 => cosetRep a b p.1.val * a ^ p.2.val) '' Set.univ).ncard
      ≤ (Set.univ : Set (Fin 12 × Fin 5)).ncard := Set.ncard_image_le Set.finite_univ
    _ = 60 := by simp [Set.ncard_univ]

theorem closure_finite (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) :
    ((Subgroup.closure ({a, b} : Set G) : Set G)).Finite :=
  cosetSet_finite.subset (closure_subset_cosetSet ha hb hab)

/-- **Upper bound.**  Two elements satisfying the icosahedral relations `a⁵ = b² = (ab)³ = 1`
generate a subgroup with at most `60` elements. -/
theorem card_closure_le (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) :
    Nat.card (Subgroup.closure ({a, b} : Set G)) ≤ 60 := by
  have h1 : Nat.card (Subgroup.closure ({a, b} : Set G))
      = ((Subgroup.closure ({a, b} : Set G) : Set G)).ncard := rfl
  rw [h1]
  exact le_trans (Set.ncard_le_ncard (closure_subset_cosetSet ha hb hab) cosetSet_finite)
    cosetSet_ncard_le

theorem finite_closure_subtype (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) :
    Finite (Subgroup.closure ({a, b} : Set G)) :=
  (closure_finite ha hb hab).to_subtype

end Upper

/-! ## Realisation in `A₅`: the lower bound

A five-cycle and a double transposition of `Fin 5` satisfying the same three relations; they
generate a subgroup of order divisible by `15`, hence all of `A₅`. -/

section Alternating

open Equiv

/-- The five-cycle `(0 1 2 3 4)`. -/
def permA : Perm (Fin 5) := finRotate 5

/-- The double transposition `(1 2)(3 4)`; it is chosen so that `permA * permB` has order `3`. -/
def permB : Perm (Fin 5) := Equiv.swap 1 2 * Equiv.swap 3 4

theorem permA_pow_five : permA ^ 5 = 1 := by decide

theorem permB_sq : permB ^ 2 = 1 := by decide

theorem permAB_pow_three : (permA * permB) ^ 3 = 1 := by decide

theorem permA_ne_one : permA ≠ 1 := by decide

theorem permAB_ne_one : permA * permB ≠ 1 := by decide

theorem permA_mem_alternating : permA ∈ alternatingGroup (Fin 5) := by
  rw [Equiv.Perm.mem_alternatingGroup]; decide

theorem permB_mem_alternating : permB ∈ alternatingGroup (Fin 5) := by
  rw [Equiv.Perm.mem_alternatingGroup]; decide

theorem orderOf_permA : orderOf permA = 5 := by
  haveI : Fact (Nat.Prime 5) := ⟨by norm_num⟩
  exact orderOf_eq_prime permA_pow_five permA_ne_one

theorem orderOf_permAB : orderOf (permA * permB) = 3 := by
  haveI : Fact (Nat.Prime 3) := ⟨by norm_num⟩
  exact orderOf_eq_prime permAB_pow_three permAB_ne_one

theorem fifteen_dvd_card_closure_perm :
    15 ∣ Nat.card (Subgroup.closure ({permA, permB} : Set (Perm (Fin 5)))) := by
  set H := Subgroup.closure ({permA, permB} : Set (Perm (Fin 5))) with hH
  have hA : permA ∈ H := Subgroup.subset_closure (by simp)
  have hB : permB ∈ H := Subgroup.subset_closure (by simp)
  have hAB : permA * permB ∈ H := H.mul_mem hA hB
  have h5 : 5 ∣ Nat.card H := by
    have h := orderOf_dvd_natCard (⟨permA, hA⟩ : H)
    rwa [Subgroup.orderOf_mk, orderOf_permA] at h
  have h3 : 3 ∣ Nat.card H := by
    have h := orderOf_dvd_natCard (⟨permA * permB, hAB⟩ : H)
    rwa [Subgroup.orderOf_mk, orderOf_permAB] at h
  exact Nat.Coprime.mul_dvd_of_dvd_of_dvd (by norm_num) h3 h5

/-- The five-cycle and the double transposition generate exactly `A₅`. -/
theorem closure_permA_permB :
    Subgroup.closure ({permA, permB} : Set (Perm (Fin 5))) = alternatingGroup (Fin 5) := by
  refine le_antisymm ?_ (alternating_le_of_fifteen_dvd fifteen_dvd_card_closure_perm)
  refine (Subgroup.closure_le _).mpr ?_
  rintro x hx
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hx
  rcases hx with rfl | rfl
  · exact permA_mem_alternating
  · exact permB_mem_alternating

end Alternating

/-! ## The von Dyck group `Δ(2,3,5) = ⟨x, y | x⁵, y², (xy)³⟩` -/

section Presented

/-- The three relators `x⁵`, `y²`, `(xy)³` inside the free group on two generators. -/
def rels235 : Set (FreeGroup (Fin 2)) :=
  {FreeGroup.of 0 ^ 5, FreeGroup.of 1 ^ 2, (FreeGroup.of 0 * FreeGroup.of 1) ^ 3}

/-- The von Dyck group `Δ(2,3,5)`. -/
abbrev Delta235 : Type := PresentedGroup rels235

/-- The generator of order five. -/
def xGen : Delta235 := PresentedGroup.of 0

/-- The generator of order two. -/
def yGen : Delta235 := PresentedGroup.of 1

theorem xGen_pow_five : xGen ^ 5 = 1 := by
  have h : PresentedGroup.mk rels235 (FreeGroup.of 0 ^ 5) = 1 :=
    PresentedGroup.one_of_mem (by simp [rels235])
  rw [map_pow] at h
  exact h

theorem yGen_sq : yGen ^ 2 = 1 := by
  have h : PresentedGroup.mk rels235 (FreeGroup.of 1 ^ 2) = 1 :=
    PresentedGroup.one_of_mem (by simp [rels235])
  rw [map_pow] at h
  exact h

theorem xyGen_pow_three : (xGen * yGen) ^ 3 = 1 := by
  have h : PresentedGroup.mk rels235 ((FreeGroup.of 0 * FreeGroup.of 1) ^ 3) = 1 :=
    PresentedGroup.one_of_mem (by simp [rels235])
  rw [map_pow, map_mul] at h
  exact h

theorem range_of_eq_pair :
    Set.range (PresentedGroup.of : Fin 2 → Delta235) = {xGen, yGen} := by
  ext g
  constructor
  · rintro ⟨i, rfl⟩
    fin_cases i
    · exact Or.inl rfl
    · exact Or.inr rfl
  · rintro (rfl | rfl)
    · exact ⟨0, rfl⟩
    · exact ⟨1, rfl⟩

theorem closure_gens_eq_top :
    Subgroup.closure ({xGen, yGen} : Set Delta235) = ⊤ := by
  rw [← range_of_eq_pair, PresentedGroup.closure_range_of]

theorem card_delta_le : Nat.card Delta235 ≤ 60 := by
  have h := card_closure_le xGen_pow_five yGen_sq xyGen_pow_three
  rw [closure_gens_eq_top] at h
  rwa [Nat.card_congr (Subgroup.topEquiv (G := Delta235)).toEquiv] at h

instance : Finite Delta235 := by
  have h := finite_closure_subtype xGen_pow_five yGen_sq xyGen_pow_three
  rw [closure_gens_eq_top] at h
  exact Finite.of_equiv _ (Subgroup.topEquiv (G := Delta235)).toEquiv

/-- The universal property of `Δ(2,3,5)`: any two elements satisfying the icosahedral relations
receive a homomorphism from `Δ(2,3,5)`. -/
theorem lift_rels_of_relations (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) :
    ∀ r ∈ rels235, FreeGroup.lift ![a, b] r = 1 := by
  rintro r hr
  simp only [rels235, Set.mem_insert_iff, Set.mem_singleton_iff] at hr
  rcases hr with rfl | rfl | rfl <;>
    simp only [map_pow, map_mul, FreeGroup.lift_apply_of, Matrix.cons_val_zero,
      Matrix.cons_val_one]
  exacts [ha, hb, hab]

/-- The homomorphism `Δ(2,3,5) → G` determined by `x ↦ a`, `y ↦ b`. -/
def vonDyckHom (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) : Delta235 →* G :=
  PresentedGroup.toGroup (lift_rels_of_relations ha hb hab)

@[simp] theorem vonDyckHom_x (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) :
    vonDyckHom ha hb hab xGen = a :=
  PresentedGroup.toGroup.of (f := ![a, b]) (lift_rels_of_relations ha hb hab) (x := 0)

@[simp] theorem vonDyckHom_y (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) :
    vonDyckHom ha hb hab yGen = b :=
  PresentedGroup.toGroup.of (f := ![a, b]) (lift_rels_of_relations ha hb hab) (x := 1)

theorem range_vonDyckHom (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1) :
    (vonDyckHom ha hb hab).range = Subgroup.closure ({a, b} : Set G) := by
  rw [MonoidHom.range_eq_map, ← closure_gens_eq_top, MonoidHom.map_closure]
  congr 1
  rw [Set.image_pair, vonDyckHom_x, vonDyckHom_y]

/-! ### `Δ(2,3,5) ≃* A₅` -/

/-- The homomorphism `Δ(2,3,5) → S₅` sending `x` to a five-cycle and `y` to a double
transposition. -/
def deltaToPerm : Delta235 →* Equiv.Perm (Fin 5) :=
  vonDyckHom permA_pow_five permB_sq permAB_pow_three

theorem range_deltaToPerm : deltaToPerm.range = alternatingGroup (Fin 5) := by
  rw [deltaToPerm, range_vonDyckHom, closure_permA_permB]

theorem card_delta : Nat.card Delta235 = 60 := by
  have hsurj : Function.Surjective deltaToPerm.rangeRestrict :=
    MonoidHom.rangeRestrict_surjective _
  have hle : Nat.card deltaToPerm.range ≤ Nat.card Delta235 :=
    Nat.card_le_card_of_surjective _ hsurj
  rw [range_deltaToPerm, card_alternatingGroup_five] at hle
  exact le_antisymm card_delta_le hle

/-- **`Δ(2,3,5) ≅ A₅`.** -/
noncomputable def deltaEquivAlternating : Delta235 ≃* alternatingGroup (Fin 5) := by
  have hsurj : Function.Surjective deltaToPerm.rangeRestrict :=
    MonoidHom.rangeRestrict_surjective _
  have hcard : Nat.card Delta235 = Nat.card deltaToPerm.range := by
    rw [range_deltaToPerm, card_alternatingGroup_five, card_delta]
  have hbij : Function.Bijective deltaToPerm.rangeRestrict :=
    (Nat.bijective_iff_surjective_and_card _).mpr ⟨hsurj, hcard⟩
  exact (MulEquiv.ofBijective _ hbij).trans (MulEquiv.subgroupCongr range_deltaToPerm)

instance : IsSimpleGroup Delta235 := MulEquiv.isSimpleGroup deltaEquivAlternating

end Presented

/-! ## The main theorem: `|⟨a, b⟩| = 60` -/

section Main

theorem ker_vonDyckHom_eq_bot (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1)
    (ha1 : a ≠ 1) : (vonDyckHom ha hb hab).ker = ⊥ := by
  rcases IsSimpleGroup.eq_bot_or_eq_top_of_normal (vonDyckHom ha hb hab).ker inferInstance with
    h | h
  · exact h
  · exfalso
    have hx : xGen ∈ (vonDyckHom ha hb hab).ker := by rw [h]; trivial
    rw [MonoidHom.mem_ker, vonDyckHom_x] at hx
    exact ha1 hx

/-- **Klein's theorem, group-theoretic form.**  If `a⁵ = b² = (ab)³ = 1` and `a ≠ 1`, then the
subgroup generated by `a` and `b` is isomorphic to `A₅`. -/
noncomputable def closureEquivAlternating (ha : a ^ 5 = 1) (hb : b ^ 2 = 1)
    (hab : (a * b) ^ 3 = 1) (ha1 : a ≠ 1) :
    Subgroup.closure ({a, b} : Set G) ≃* alternatingGroup (Fin 5) :=
  let hinj : Function.Injective (vonDyckHom ha hb hab) :=
    (MonoidHom.ker_eq_bot_iff _).mp (ker_vonDyckHom_eq_bot ha hb hab ha1)
  let e : Delta235 ≃* (vonDyckHom ha hb hab).range :=
    MulEquiv.ofBijective _ ⟨fun _ _ h => hinj (congrArg Subtype.val h),
      MonoidHom.rangeRestrict_surjective _⟩
  ((MulEquiv.subgroupCongr (range_vonDyckHom ha hb hab)).symm.trans e.symm).trans
    deltaEquivAlternating

/-- **`|⟨a, b⟩| = 60`** for two elements satisfying the icosahedral relations with `a ≠ 1`. -/
theorem card_closure_eq_sixty (ha : a ^ 5 = 1) (hb : b ^ 2 = 1) (hab : (a * b) ^ 3 = 1)
    (ha1 : a ≠ 1) : Nat.card (Subgroup.closure ({a, b} : Set G)) = 60 := by
  rw [Nat.card_congr (closureEquivAlternating ha hb hab ha1).toEquiv,
    card_alternatingGroup_five]

end Main

end VonDyck

end ArtinA5Even

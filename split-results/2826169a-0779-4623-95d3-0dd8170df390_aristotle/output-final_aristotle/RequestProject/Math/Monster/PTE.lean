import Mathlib

/-!
# Number Theory in Quantum Physics: the degree-3 Prouhet–Tarry–Escott problem

This file formalizes the central, machine-verifiable mathematical content underlying
*"Number Theory in Quantum Physics: Minicharged Particles and the Prouhet–Tarry–Escott
Problem"* by J. Lee, F. Takahashi and Y.-D. Tsai (arXiv:2603.12320).

The physics input is that, in a chiral `U(1)_H × U(1)_X` minicharged-particle sector, the
gauge anomaly-cancellation conditions for the `U(1)_X` charges `a₁,…,aₙ` (set `A`) and
`b₁,…,bₙ` (set `B`) are

* `U(1)_X`–grav–grav :     `∑ aᵢ   = ∑ bᵢ`     (degree 1)
* `(U(1)_X)²`–`U(1)_H` :   `∑ aᵢ²  = ∑ bᵢ²`    (degree 2)
* `(U(1)_X)³` :            `∑ aᵢ³  = ∑ bᵢ³`    (degree 3)

These are exactly the equations of the **degree `k = 3` Prouhet–Tarry–Escott problem**:
two integer multisets with equal power sums up to order `3`.

We formalize:
* `PowerSum`, `PTE` : the power sums and the degree-`k` PTE predicate.
* The ten ideal `n = 4` solutions from Table I of the paper.
* `mirror_PTE3` : the *symmetric solution* theorem — sign-paired multisets `{±aᵢ}`,
  `{±bᵢ}` automatically satisfy the degree-1 and degree-3 conditions, so the whole
  degree-3 PTE problem collapses to the single quadratic condition `∑ aᵢ² = ∑ bᵢ²`.
* The Landau-pole-minimal solution `A = {-3,0,1,4}`, `B = {-2,-2,3,3}` with `∑ q² = 52`.
* Arithmetic facts mentioned in the surrounding discussion (the "Oggorial", `196883`, `253`).
-/

open scoped BigOperators

namespace PTE

/-- The `ℓ`-th power sum of a list of integer charges. -/
def PowerSum (A : List ℤ) (ℓ : ℕ) : ℤ := (A.map (· ^ ℓ)).sum

/-- The degree-`k` Prouhet–Tarry–Escott condition on two integer multisets `A`, `B`
(represented as lists): equal length and equal power sums for every order `1 ≤ ℓ ≤ k`.
For `k = 3` this is precisely the set of anomaly-cancellation conditions of the paper. -/
structure IsPTE (A B : List ℤ) (k : ℕ) : Prop where
  length : A.length = B.length
  power  : ∀ ℓ, 1 ≤ ℓ → ℓ ≤ k → PowerSum A ℓ = PowerSum B ℓ

/-! ## Verification of Table I (ideal `n = 4`, degree `k = 3` solutions) -/

theorem table_no1 : IsPTE [0, 4, 7, 11] [1, 2, 9, 10] 3 :=
  ⟨rfl, by intro ℓ h1 h3; interval_cases ℓ <;> decide⟩

theorem table_no2 : IsPTE [0, 6, 7, 13] [1, 3, 10, 12] 3 :=
  ⟨rfl, by intro ℓ h1 h3; interval_cases ℓ <;> decide⟩

theorem table_no3 : IsPTE [0, 5, 10, 15] [1, 3, 12, 14] 3 :=
  ⟨rfl, by intro ℓ h1 h3; interval_cases ℓ <;> decide⟩

theorem table_no4 : IsPTE [0, 7, 9, 16] [1, 4, 12, 15] 3 :=
  ⟨rfl, by intro ℓ h1 h3; interval_cases ℓ <;> decide⟩

theorem table_no5 : IsPTE [0, 8, 9, 17] [2, 3, 14, 15] 3 :=
  ⟨rfl, by intro ℓ h1 h3; interval_cases ℓ <;> decide⟩

theorem table_no6 : IsPTE [0, 7, 11, 18] [2, 3, 15, 16] 3 :=
  ⟨rfl, by intro ℓ h1 h3; interval_cases ℓ <;> decide⟩

theorem table_no7 : IsPTE [0, 6, 13, 19] [1, 4, 15, 18] 3 :=
  ⟨rfl, by intro ℓ h1 h3; interval_cases ℓ <;> decide⟩

theorem table_no8 : IsPTE [0, 8, 11, 19] [1, 5, 14, 18] 3 :=
  ⟨rfl, by intro ℓ h1 h3; interval_cases ℓ <;> decide⟩

theorem table_no9 : IsPTE [0, 10, 11, 21] [1, 6, 15, 20] 3 :=
  ⟨rfl, by intro ℓ h1 h3; interval_cases ℓ <;> decide⟩

/-- Solution No. 10 is the unique *non-symmetric* entry in Table I. -/
theorem table_no10 : IsPTE [0, 11, 13, 22] [1, 7, 18, 20] 3 :=
  ⟨rfl, by intro ℓ h1 h3; interval_cases ℓ <;> decide⟩

/-! ## Symmetric (sign-paired) solutions -/

/-- The sign-paired ("symmetric") multiset built from a half-list of positive charges:
`mirror [a₁,…,aₘ] = [a₁,…,aₘ, -a₁,…,-aₘ] = {±aᵢ}`. -/
def mirror (a : List ℤ) : List ℤ := a ++ a.map (fun x => -x)

@[simp] theorem mirror_length (a : List ℤ) : (mirror a).length = 2 * a.length := by
  simp [mirror, two_mul]

/-- Odd power sums of a sign-paired multiset vanish: `∑ (±aᵢ)^ℓ = 0` for odd `ℓ`. -/
theorem mirror_odd_powersum (a : List ℤ) (ℓ : ℕ) (hodd : Odd ℓ) :
    PowerSum (mirror a) ℓ = 0 := by
  unfold PowerSum mirror
  rw [List.map_append, List.sum_append, List.map_map]
  have h : (a.map ((· ^ ℓ) ∘ (fun x => -x))) = (a.map (· ^ ℓ)).map (fun y => -y) := by
    rw [List.map_map]
    exact List.map_congr_left fun x _ => by simp [Function.comp, hodd.neg_pow]
  rw [h, ← List.sum_neg]; ring

/-- Even power sums of a sign-paired multiset double the half-list sum:
`∑ (±aᵢ)^ℓ = 2 ∑ aᵢ^ℓ` for even `ℓ`. -/
theorem mirror_even_powersum (a : List ℤ) (ℓ : ℕ) (heven : Even ℓ) :
    PowerSum (mirror a) ℓ = 2 * PowerSum a ℓ := by
  unfold PowerSum mirror
  rw [List.map_append, List.sum_append, List.map_map]
  have h : (a.map ((· ^ ℓ) ∘ (fun x => -x))) = a.map (fun x => x ^ ℓ) := by
    exact List.map_congr_left fun x _ => by simp [Function.comp, heven.neg_pow]
  rw [h]; ring

/-- **Symmetric solution theorem.** For sign-paired charge multisets `{±aᵢ}`, `{±bᵢ}`
(with equally many half-charges), the full degree-3 Prouhet–Tarry–Escott / anomaly
conditions hold **iff** the single quadratic condition `∑ aᵢ² = ∑ bᵢ²` holds: the
degree-1 and degree-3 (odd) conditions are satisfied automatically. -/
theorem mirror_PTE3 (a b : List ℤ) (hlen : a.length = b.length) :
    IsPTE (mirror a) (mirror b) 3 ↔ PowerSum a 2 = PowerSum b 2 := by
  constructor
  · intro h
    have h2 := h.power 2 (by norm_num) (by norm_num)
    rw [mirror_even_powersum a 2 (by decide), mirror_even_powersum b 2 (by decide)] at h2
    exact mul_left_cancel₀ (by norm_num) h2
  · intro h2
    refine ⟨by simp [hlen], ?_⟩
    intro ℓ h1 h3
    interval_cases ℓ
    · rw [mirror_odd_powersum a 1 (by decide), mirror_odd_powersum b 1 (by decide)]
    · rw [mirror_even_powersum a 2 (by decide), mirror_even_powersum b 2 (by decide), h2]
    · rw [mirror_odd_powersum a 3 (by decide), mirror_odd_powersum b 3 (by decide)]

/-- The Landau-pole-minimal solution of the paper, `A = {-3,0,1,4}`, `B = {-2,-2,3,3}`,
is a genuine degree-3 PTE / anomaly-free solution. -/
theorem landau_minimal : IsPTE [-3, 0, 1, 4] [-2, -2, 3, 3] 3 :=
  ⟨rfl, by intro ℓ h1 h3; interval_cases ℓ <;> decide⟩

/-- For the Landau-pole-minimal solution the total sum of squared `U(1)_X` charges
(over all `2n = 8` Weyl fermions, i.e. `A` and `B` together) is `52`. -/
theorem landau_minimal_sumsq :
    PowerSum [-3, 0, 1, 4] 2 + PowerSum [-2, -2, 3, 3] 2 = 52 := by decide

/-! ## Arithmetic facts from the surrounding discussion -/

/-- The "Oggorial": the product of the 15 supersingular (Ogg) primes. -/
theorem oggorial_value :
    2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71
      = 1618964990108856390 := by norm_num

/-- The smallest faithful Monster dimension factors over the three largest
supersingular primes: `196883 = 47 · 59 · 71`. -/
theorem dim_196883 : 47 * 59 * 71 = 196883 := by norm_num

/-- `253 = 11 · 23 = C(23,2)`, the product of the two missing supersingular primes
at the discussed "hub" and the dimension of the smallest nontrivial `M₂₃` representation. -/
theorem two_five_three : 11 * 23 = 253 ∧ Nat.choose 23 2 = 253 := by
  refine ⟨by norm_num, by decide⟩

end PTE

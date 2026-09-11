/-
Copyright (c) 2026 DULA / PIE Formalization Team.
Released under Apache 2.0 license.

# DULA Core — Algebraic Foundation

The multiplicative monoid `S` of positive integers all of whose prime
factors lie in the DULA prime set `P = P1 ∪ P5` (primes ≡ ±1 mod 6,
restricted to p > 3), together with the additive grading
`φ : S → ℤ/2ℤ` and its ±1-valued realization `ψ : S → ℤ`.

The eight algebraic theorems below establish the multiplicative
character ψ = θ ∘ φ where φ is an additive monoid homomorphism and
θ : ℤ/2ℤ → ℤ is the isomorphism `0 ↦ +1, 1 ↦ −1`.

Note: This file builds the DULA grading abstractly. The identification
`ψ(n) = χ₃(n)` for the non-trivial Dirichlet character mod 3 (when n
is coprime to 6) lives in a separate file (`dula_phi6_is_chi3`) and is
not asserted here.
-/

import Mathlib

open Finsupp in
/-- Primes ≡ 1 (mod 6), greater than 3. -/
def P1 : Set ℕ := {p | Nat.Prime p ∧ p > 3 ∧ p ≡ 1 [MOD 6]}

/-- Primes ≡ 5 (mod 6), greater than 3. -/
def P5 : Set ℕ := {p | Nat.Prime p ∧ p > 3 ∧ p ≡ 5 [MOD 6]}

instance : DecidablePred (· ∈ P5) := fun p => by
  unfold P5; simp only [Set.mem_setOf_eq]
  infer_instance

/-- The DULA prime set: primes coprime to 6 (i.e., > 3 and ≢ 0 mod 2, 3). -/
def P : Set ℕ := P1 ∪ P5

/-- Positive integers whose prime factors all lie in `P`. -/
def has_P_primes_only (n : ℕ) : Prop :=
  0 < n ∧ ∀ (p : ℕ), Nat.Prime p → p ∣ n → p ∈ P

/-- `S`: the multiplicative monoid of positive integers with prime factors
only in `P`. This is the natural carrier of the DULA grading. -/
def S := Subtype has_P_primes_only

namespace S

instance : Coe S ℕ := ⟨Subtype.val⟩

lemma one_mem : has_P_primes_only 1 := by
  constructor
  · exact Nat.one_pos
  · intro p hp hdvd
    exact absurd (Nat.le_of_dvd Nat.one_pos hdvd) (not_le.mpr hp.one_lt)

lemma mul_mem (a b : S) : has_P_primes_only (a.val * b.val) := by
  constructor
  · exact Nat.mul_pos a.property.1 b.property.1
  · intro p hp hdvd
    rcases hp.dvd_mul.mp hdvd with h | h
    · exact a.property.2 p hp h
    · exact b.property.2 p hp h

noncomputable instance : Monoid S where
  one := ⟨1, one_mem⟩
  mul a b := ⟨a.val * b.val, mul_mem a b⟩
  mul_assoc a b c := by
    apply Subtype.ext
    exact Nat.mul_assoc a.val b.val c.val
  one_mul a := by
    apply Subtype.ext
    exact Nat.one_mul a.val
  mul_one a := by
    apply Subtype.ext
    exact Nat.mul_one a.val

@[simp] lemma mul_val (a b : S) : (a * b).val = a.val * b.val := rfl
@[simp] lemma one_val : (1 : S).val = 1 := rfl

/-- `m(n)`: the count (with multiplicity) of P5-prime factors of `n`,
implemented as a sum of p-adic valuations restricted to P5. -/
noncomputable def m (n : S) : ℕ :=
  n.val.factorization.sum (fun p e => if p ∈ P5 then e else 0)

/-- `φ(n) = m(n) mod 2`: the DULA grading, a ℤ/2-valued additive function. -/
noncomputable def phi (n : S) : ZMod 2 := (m n : ZMod 2)

/-- `ψ(n) = (-1)^{m(n)}`: the ±1-valued multiplicative realization. -/
noncomputable def psi (n : S) : ℤ := (-1) ^ (m n)

/-- `θ : ℤ/2 → ℤ`, the isomorphism with `{±1}` viewed in ℤ. -/
def theta (x : ZMod 2) : ℤ := if x = 0 then 1 else -1

variable (a b : S)

/-! ### The eight algebraic theorems

These establish that ψ factors as θ ∘ φ, where φ is additive on S and
θ is the ℤ/2 ↔ {±1} isomorphism. Together they make ψ a multiplicative
character S → {±1}.
-/

/-
`m` is additive: `m(ab) = m(a) + m(b)`.
-/
theorem m_mul : m (a * b) = m a + m b := by
  unfold S.m;
  -- Apply the factorization sum lemma to the product of the two numbers.
  have h_sum : Nat.factorization (a.val * b.val) = Nat.factorization a.val + Nat.factorization b.val := by
    exact Nat.factorization_mul ( ne_of_gt a.prop.1 ) ( ne_of_gt b.prop.1 );
  erw [ h_sum, Finsupp.sum_add_index' ] <;> aesop

/-
`φ` is an additive monoid homomorphism `S → ℤ/2`.
-/
theorem phi_mul : phi (a * b) = phi a + phi b := by
  -- By definition of $phi$, we have $phi(a * b) = m(a * b)$ and $phi(a) + phi(b) = m(a) + m(b)$.
  simp [phi, m_mul]

theorem phi_one : phi 1 = 0 := by
  unfold phi m;
  simp +decide [ Finsupp.sum ]

/-
`ψ` is multiplicative `S → ℤ`.
-/
theorem psi_mul : psi (a * b) = psi a * psi b := by
  norm_num [ S.psi, S.m_mul ];
  rw [ pow_add ]

theorem psi_one : psi 1 = 1 := by
  unfold psi;
  unfold m;
  norm_num

/-
The compatibility identity: `ψ = θ ∘ φ`.
-/
theorem comm_psi_theta_phi : psi a = theta (phi a) := by
  unfold S.psi S.phi S.theta;
  rcases Nat.even_or_odd' a.m with ⟨ c, d | d ⟩ <;> simp +decide [ d ];
  norm_num [ Int.add_emod ];
  grind

theorem theta_injective : Function.Injective theta := by
  native_decide +revert

variable (x y : ZMod 2)

/-
`θ` is multiplicative `ℤ/2 → ℤ` (sending + to ·).
-/
theorem theta_mul : theta (x + y) = theta x * theta y := by
  native_decide +revert

end S

open S

/-- `χ₃ functional`: the ±1-valued multiplicative character `S → ℤ` given
by `ψ`. The identification with the Dirichlet character `χ₃` mod 3 on
integers coprime to 6 is proved in a separate file
(`dula_phi6_is_chi3`); here we only assert the abstract algebraic shape. -/
noncomputable def chi3 (n : S) : ℤ := psi n

/-
`χ₃² = 1`: squaring the ±1-valued character is the identity.
-/
theorem chi3_sq_one (n : S) : chi3 n ^ 2 = 1 := by
  unfold chi3;
  unfold S.psi;
  norm_num [ ← pow_mul ]
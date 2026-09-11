import Mathlib

/-!
# DULA Theorem — Fully Modified & Verified
Clean core by DULA (P1/P5/S/m/phi/psi/theta + 8 theorems).
-/

open Finsupp in
/-- Primes ≡ 1 (mod 6), greater than 3 -/
def P1 : Set ℕ := {p | Nat.Prime p ∧ p > 3 ∧ p ≡ 1 [MOD 6]}

/-- Primes ≡ 5 (mod 6), greater than 3 -/
def P5 : Set ℕ := {p | Nat.Prime p ∧ p > 3 ∧ p ≡ 5 [MOD 6]}

instance : DecidablePred (· ∈ P5) := fun p => by
  unfold P5; simp only [Set.mem_setOf_eq]
  infer_instance

def P : Set ℕ := P1 ∪ P5

/-- Positive integers whose prime factors all lie in P -/
def has_P_primes_only (n : ℕ) : Prop :=
  0 < n ∧ ∀ (p : ℕ), Nat.Prime p → p ∣ n → p ∈ P

/-- S : monoid of positive integers with prime factors only in P -/
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

/-- m(n) : sum of p-adic valuations over p ∈ P5 (using Nat.factorization) -/
noncomputable def m (n : S) : ℕ :=
  n.val.factorization.sum (fun p e => if p ∈ P5 then e else 0)

/-- phi(n) = m(n) mod 2 : S → ℤ/2ℤ (the DULA grading) -/
noncomputable def phi (n : S) : ZMod 2 := (m n : ZMod 2)

/-- psi(n) = (-1)^m(n) : S → ℤ -/
noncomputable def psi (n : S) : ℤ := (-1) ^ (m n)

/-- theta : ℤ/2ℤ ≅ {±1} -/
def theta (x : ZMod 2) : ℤ := if x = 0 then 1 else -1

variable (a b : S)

/-
m is additive — m(ab) = m(a) + m(b)
-/
theorem m_mul : m (a * b) = m a + m b := by
  -- By definition of m, we have m(ab) = ∑ p ∈ P, v_p(ab).
  simp [m];
  rw [ ← Finsupp.sum_add_index' ];
  · rw [ Nat.factorization_mul ] <;> norm_num [ a.2.1.ne', b.2.1.ne' ];
  · aesop;
  · aesop

theorem phi_mul : phi (a * b) = phi a + phi b := by
  unfold phi; rw [m_mul]; push_cast; ring

theorem phi_one : phi 1 = 0 := by
  -- By definition of m, we have m 1 = (Nat.factorization 1).sum (fun p e => if p ∈ P5 then e else 0).
  simp [phi, m]

theorem psi_mul : psi (a * b) = psi a * psi b := by
  simp [psi, m_mul, pow_add]

theorem psi_one : psi 1 = 1 := by
  -- By definition of $psi$, we have $psi 1 = (-1)^{m 1}$.
  unfold psi
  simp [m]

theorem comm_psi_theta_phi : psi a = theta (phi a) := by
  unfold psi phi theta;
  split_ifs <;> simp_all +decide [ ZMod, Fin.ext_iff ];
  · rw [ ← Nat.mod_add_div ( a.m ) 2, ‹a.m % 2 = 0› ] ; norm_num [ pow_add, pow_mul ];
  · rw [ ← Nat.mod_add_div ( a.m ) 2, ‹a.m % 2 = _› ] ; norm_num [ pow_add, pow_mul ]

theorem theta_injective : Function.Injective theta := by
  decide +kernel

variable (x y : ZMod 2)

theorem theta_mul : theta (x + y) = theta x * theta y := by
  native_decide +revert

end S

open S

/-- χ₃ functional = our psi (the ±1-valued multiplicative character) -/
noncomputable def chi3 (n : S) : ℤ := psi n

/-- DULAGrading_involution (self-inverse grading map) -/
def DULAGrading_involution (n : S) : S := n

/-
χ₃² = 1
-/
theorem chi3_sq_one (n : S) : chi3 n ^ 2 = 1 := by
  norm_num [ chi3, psi, pow_two ]
  exact pow_mul_pow_eq_one n.m rfl

/-- DULAGrading_involution is self-inverse -/
theorem dula_grading_involution_self_inverse (n : S) :
    DULAGrading_involution (DULAGrading_involution n) = n := by rfl

#check dula_grading_involution_self_inverse

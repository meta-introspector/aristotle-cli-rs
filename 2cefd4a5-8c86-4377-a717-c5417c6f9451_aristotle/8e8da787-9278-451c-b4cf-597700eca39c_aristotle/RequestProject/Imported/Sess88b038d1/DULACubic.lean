import Mathlib

/-!
# DULA Cubic: Primes p > 3 modulo 9

The three cubic-residue classes modulo 9 partition the primes p > 3.
We realise the grading via the homomorphism
  χ₉ : (ℤ/9ℤ)^* → ℤ/3ℤ
sending the cosets {1,8} ↦ 0, {2,7} ↦ 1, {4,5} ↦ 2.
-/

noncomputable section

namespace DULACubic

/-! ### The cubic character χ₉ : ℕ → ZMod 3 -/

/-- Cubic residue class of n (mod 9) when gcd(n,3)=1; 0 otherwise. -/
def chi9 (n : ℕ) : ZMod 3 :=
  if Nat.gcd n 3 ≠ 1 then 0 else
  match n % 9 with
  | 1 | 8 => 0
  | 2 | 7 => 1
  | 4 | 5 => 2
  | _     => 0   -- unreachable when gcd n 3 = 1

@[simp] theorem chi9_zero : chi9 0 = 0 := by decide
@[simp] theorem chi9_one  : chi9 1 = 0 := by decide
@[simp] theorem chi9_two  : chi9 2 = 1 := by decide
@[simp] theorem chi9_four : chi9 4 = 2 := by decide
@[simp] theorem chi9_five : chi9 5 = 2 := by decide
@[simp] theorem chi9_seven: chi9 7 = 1 := by decide
@[simp] theorem chi9_eight: chi9 8 = 0 := by decide

/-
χ₉ is completely multiplicative on integers coprime to 3.
-/
set_option maxHeartbeats 800000 in
theorem chi9_mul {a b : ℕ} (ha : Nat.gcd a 3 = 1) (hb : Nat.gcd b 3 = 1) :
    chi9 (a * b) = chi9 a + chi9 b := by
  unfold chi9;
  rw [ Nat.gcd_comm a 3, Nat.gcd_comm b 3 ] at *;
  rw [ ← Nat.mod_add_div a 9, ← Nat.mod_add_div b 9 ] at *; have := Nat.mod_lt a ( by decide : 0 < 9 ) ; have := Nat.mod_lt b ( by decide : 0 < 9 ) ; interval_cases a % 9 <;> interval_cases b % 9 <;> simp +decide at ha hb ⊢;
  all_goals norm_num [ Nat.add_mod, Nat.mul_mod, Nat.gcd_rec 3 ] at *;
  all_goals norm_num [ Nat.add_mod, Nat.mul_mod, Nat.gcd_comm, Nat.gcd_rec 3 ] ;
  all_goals rfl;

/-! ### The three cubic lanes -/

def isCoprimeThree (n : ℕ) : Prop := 0 < n ∧ Nat.gcd n 3 = 1

def Lane0 : Set ℕ := { n | isCoprimeThree n ∧ chi9 n = 0 }
def Lane1 : Set ℕ := { n | isCoprimeThree n ∧ chi9 n = 1 }
def Lane2 : Set ℕ := { n | isCoprimeThree n ∧ chi9 n = 2 }

theorem mem_Lane0_iff (n : ℕ) :
    n ∈ Lane0 ↔ 0 < n ∧ Nat.gcd n 3 = 1 ∧ n % 9 ∈ ({1,8} : Finset ℕ) := by
  constructor <;> intro hn <;> simp_all +decide [ Lane0 ];
  · rcases hn with ⟨ ⟨ hn₁, hn₂ ⟩, hn₃ ⟩ ; rw [ chi9 ] at hn₃; split_ifs at hn₃ <;> simp_all +decide ;
    rw [ Nat.gcd_comm ] at hn₂; rw [ Nat.gcd_rec ] at hn₂; ( rw [ ← Nat.mod_mod_of_dvd n ( by decide : 3 ∣ 9 ) ] at hn₂; ( have := Nat.mod_lt n ( by decide : 0 < 9 ) ; interval_cases n % 9 <;> trivial; ) );
  · unfold isCoprimeThree chi9; aesop;

theorem mem_Lane1_iff (n : ℕ) :
    n ∈ Lane1 ↔ 0 < n ∧ Nat.gcd n 3 = 1 ∧ n % 9 ∈ ({2,7} : Finset ℕ) := by
  constructor <;> intro hn <;> simp_all +decide [ Lane1 ];
  · rcases hn with ⟨ ⟨ hn₁, hn₂ ⟩, hn₃ ⟩;
    unfold chi9 at hn₃;
    have := Nat.mod_lt n ( by decide : 0 < 9 ) ; interval_cases _ : n % 9 <;> simp_all +decide ;
  · cases hn.2.2 <;> simp_all +decide [ isCoprimeThree ];
    · unfold chi9; aesop;
    · unfold chi9; aesop

theorem mem_Lane2_iff (n : ℕ) :
    n ∈ Lane2 ↔ 0 < n ∧ Nat.gcd n 3 = 1 ∧ n % 9 ∈ ({4,5} : Finset ℕ) := by
  constructor <;> intro hn <;> simp_all +decide [ Lane2 ];
  · rcases hn with ⟨ ⟨ hn₁, hn₂ ⟩, hn₃ ⟩;
    unfold chi9 at hn₃;
    have := Nat.mod_lt n ( by decide : 0 < 9 ) ; interval_cases _ : n % 9 <;> simp_all +decide ;
  · unfold isCoprimeThree chi9; aesop;

/-
Every integer coprime to 3 lies in exactly one lane.
-/
theorem coprimeThree_partition :
    ∀ n, isCoprimeThree n →
      (n ∈ Lane0 ∧ n ∉ Lane1 ∧ n ∉ Lane2) ∨
      (n ∈ Lane1 ∧ n ∉ Lane0 ∧ n ∉ Lane2) ∨
      (n ∈ Lane2 ∧ n ∉ Lane0 ∧ n ∉ Lane1) := by
  intro n hn; rcases hn with ⟨ hn0, hn3 ⟩ ; simp +decide [ Lane0, Lane1, Lane2 ] ;
  unfold chi9; split_ifs <;> simp_all +decide [ isCoprimeThree ] ;
  rw [ ← Nat.mod_add_div n 9 ] at *; have := Nat.mod_lt n ( by decide : 0 < 9 ) ; interval_cases n % 9 <;> simp_all +decide ;

/-! ### Primes p > 3 lie in exactly one lane -/

/-
Every prime p > 3 is coprime to 3 and therefore belongs to precisely one cubic lane.
-/
theorem prime_gt_three_in_exactly_one_lane
    {p : ℕ} (hp : p.Prime) (h3 : 3 < p) :
    (p ∈ Lane0 ∨ p ∈ Lane1 ∨ p ∈ Lane2) ∧
    (p ∈ Lane0 → p ∉ Lane1 ∧ p ∉ Lane2) ∧
    (p ∈ Lane1 → p ∉ Lane0 ∧ p ∉ Lane2) ∧
    (p ∈ Lane2 → p ∉ Lane0 ∧ p ∉ Lane1) := by
  -- First, show that p is coprime to 3.
  have h_coprime : Nat.gcd p 3 = 1 := by
    exact hp.coprime_iff_not_dvd.mpr fun h => by have := Nat.le_of_dvd ( by decide ) h; interval_cases p;
  have h_pos : 0 < p := by
    linarith
  have h_coprime_three : isCoprimeThree p := by
    exact ⟨ h_pos, h_coprime ⟩
  have h_partition : (p ∈ Lane0 ∧ p ∉ Lane1 ∧ p ∉ Lane2) ∨ (p ∈ Lane1 ∧ p ∉ Lane0 ∧ p ∉ Lane2) ∨ (p ∈ Lane2 ∧ p ∉ Lane0 ∧ p ∉ Lane1) := by
    exact coprimeThree_partition p h_coprime_three
  aesop

end DULACubic

end
import Mathlib

open Nat

namespace DulaTheorem

set_option linter.unusedVariables false

def P₁ : Set ℕ := { p | Nat.Prime p ∧ p ≡ 1 [MOD 6] }

def P₅ : Set ℕ := { p | Nat.Prime p ∧ p ≡ 5 [MOD 6] }

def P : Set ℕ := P₁ ∪ P₅

structure S where
  val : ℕ
  pos : val > 0
  factors : ∀ {p : ℕ}, Nat.Prime p → p ∣ val → p ∈ P

def negOneUnit : Units ℤ := -1

instance : Mul S where
  mul a b := {
    val := a.val * b.val,
    pos := Nat.mul_pos a.pos b.pos,
    factors := by
      intro p hp hpdvd
      rcases hp.dvd_mul.mp hpdvd with ha | hb
      · exact a.factors hp ha
      · exact b.factors hp hb
  }

instance : One S where
  one := {
    val := 1,
    pos := Nat.one_pos,
    factors := by
      intro p hp hpdvd
      exact absurd (Nat.eq_one_of_dvd_one hpdvd) hp.ne_one
  }

@[simp] lemma val_mul (a b : S) : (a * b).val = a.val * b.val := rfl
@[simp] lemma val_one : (1 : S).val = 1 := rfl

@[ext] lemma S.ext {a b : S} (h : a.val = b.val) : a = b := by
  cases a; cases b; simp at h; subst h; rfl

instance : Monoid S where
  mul_one a := S.ext (Nat.mul_one a.val)
  one_mul a := S.ext (Nat.one_mul a.val)
  mul_assoc a b c := S.ext (Nat.mul_assoc a.val b.val c.val)

noncomputable def m (n : S) : ℕ :=
  n.val.factorization.sum fun p k => if (Nat.Prime p ∧ p ≡ 5 [MOD 6]) then k else 0

abbrev MulZ₂ := Units ℤ

noncomputable def phi (n : S) : Multiplicative (ZMod 2) :=
  Multiplicative.ofAdd (m n : ZMod 2)

noncomputable def psi (n : S) : MulZ₂ :=
  negOneUnit ^ m n

lemma m_mul (a b : S) : m (a * b) = m a + m b := by
  simp +decide [ m, Nat.factorization_mul a.pos.ne' b.pos.ne' ];
  rw [ Finsupp.sum_add_index' ] <;> aesop

noncomputable def phiHom : S →* Multiplicative (ZMod 2) where
  toFun := phi
  map_one' := by
    simp [phi, m, Nat.factorization_one]
  map_mul' a b := by
    simp only [phi, m_mul, Nat.cast_add]
    rfl

noncomputable def psiHom : S →* MulZ₂ where
  toFun := psi
  map_one' := by simp [psi, m, Nat.factorization_one]
  map_mul' a b := by simp [psi, m_mul, pow_add]

noncomputable def theta : Multiplicative (ZMod 2) →* MulZ₂ where
  toFun z := negOneUnit ^ (Multiplicative.toAdd z).val
  map_one' := by simp
  map_mul' x y := by
    fin_cases x <;> fin_cases y <;> rfl

theorem dula_theorem_commutes (n : S) : psi n = theta (phi n) := by
  unfold theta phi psi;
  have : negOneUnit ^ (m n) = negOneUnit ^ (m n % 2) := by
    rw [ ← Nat.mod_add_div ( m n ) 2, pow_add, pow_mul ] ; norm_num [ negOneUnit ];
  cases Nat.mod_two_eq_zero_or_one ( m n ) <;> simp_all +decide

open ArithmeticFunction

lemma coprime_six_factors {n : ℕ} (hn : n ≠ 0) (hc : n.Coprime 6) :
    ∀ {p : ℕ}, Nat.Prime p → p ∣ n → p ∈ P := by
  intros p hp hpn
  have h_coprime : Nat.gcd p 6 = 1 := by
    exact Nat.Coprime.coprime_dvd_left hpn hc
  have h_mod : p % 6 = 1 ∨ p % 6 = 5 := by
    rw [ Nat.gcd_comm, Nat.gcd_rec ] at h_coprime; have := Nat.mod_lt p ( by decide : 6 > 0 ) ; interval_cases _ : p % 6 <;> simp_all +decide [ ← Nat.dvd_iff_mod_eq_zero, hp.dvd_iff_eq ] ;
  exact (by
  exact h_mod.elim ( fun h => Or.inl ⟨ hp, h ⟩ ) fun h => Or.inr ⟨ hp, h ⟩)

noncomputable def dulaChar : ArithmeticFunction ℤ where
  toFun n := if h : n = 0 then 0
             else if h_coprime : n.Coprime 6 then
               (psi ⟨n, Nat.pos_of_ne_zero h, coprime_six_factors h h_coprime⟩ : ℤ)
             else 0
  map_zero' := dif_pos rfl

noncomputable def dulaSigma : ArithmeticFunction ℤ :=
  dulaChar * ArithmeticFunction.id

noncomputable def dulaVonMangoldt : ArithmeticFunction ℝ :=
  (↑dulaChar : ArithmeticFunction ℝ) * ArithmeticFunction.vonMangoldt

theorem dula_vonMangoldt_conv_zeta :
    dulaVonMangoldt * (↑(ArithmeticFunction.zeta) : ArithmeticFunction ℝ) =
    (↑dulaChar : ArithmeticFunction ℝ) * ArithmeticFunction.log := by
  unfold dulaVonMangoldt dulaChar;
  ext; simp [mul_assoc]

end DulaTheorem

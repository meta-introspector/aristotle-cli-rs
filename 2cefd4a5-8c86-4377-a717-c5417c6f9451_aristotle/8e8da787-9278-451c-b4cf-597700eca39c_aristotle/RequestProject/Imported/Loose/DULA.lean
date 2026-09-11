import Mathlib

namespace DULA

/-! ## Part 1: The DULA Core — Fully Verified -/

def M6 : Set ℕ := {n | Nat.Coprime n 6}

def phi6 (n : ℕ) : ZMod 2 :=
  if n % 3 = 1 then 0 else 1

noncomputable def chi3 : DirichletCharacter ℂ 3 :=
  (quadraticChar (ZMod 3)).ringHomComp (Int.castRingHom ℂ)

theorem dula_phi6_is_chi3 (n : ℕ) (hn : n ∈ M6) :
    chi3 n = if phi6 n = 0 then 1 else -1 := by
  unfold M6 at hn; simp_all +decide [Nat.Coprime, Nat.gcd_succ, Nat.gcd_comm]
  rw [← Nat.mod_add_div n 6] at *
  have := Nat.mod_lt n (by decide : 6 > 0)
  interval_cases n % 6 <;> simp_all +decide [Nat.coprime_mul_iff_left, Nat.coprime_mul_iff_right]
  · unfold phi6; norm_num [Nat.add_mod, Nat.mul_mod]
    erw [show (1 + 6 * ↑(n / 6) : ZMod 3) = 1 by erw [show (6 : ZMod 3) = 0 by rfl]; simp +decide]
    norm_num [chi3]
  · norm_cast; norm_num [Nat.add_mod, Nat.mul_mod, Nat.pow_mod]
    ring_nf; simp +decide [chi3, phi6]; norm_num [quadraticCharFun]
    ring_nf; norm_num [Nat.add_mod, Nat.mul_mod]; aesop

def M1 : Matrix (Fin 6) (Fin 6) ℝ := 1

def M5 : Matrix (Fin 6) (Fin 6) ℝ :=
  !![1, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 1, 0, 0, 0, 0]

theorem M5_square_is_I : M5 * M5 = M1 := by
  unfold M5 M1; ext i j; simp +decide [Fin.sum_univ_succ, Fin.sum_univ_zero, Matrix.mul_apply]
  ring; fin_cases i <;> fin_cases j <;> simp +decide [Matrix.one_apply]

theorem det_M5_is_one : M5.det = 1 := by
  unfold M5; rw [← Matrix.det_transpose]
  norm_num [Fin.forall_fin_succ, Matrix.det_succ_row_zero]
  simp +decide [Fin.sum_univ_succ, Fin.succAbove] at *

noncomputable def U : Module.End ℝ (Fin 6 → ℝ) := Matrix.toLin' M5

/-! ## Part 2: The A₂ Lattice -/

def Q (x y : ℤ) : ℤ := x^2 + x * y + y^2

theorem Q_nonneg (x y : ℤ) : 0 ≤ Q x y := by
  simp [Q]; nlinarith [sq_nonneg (x + y)]

theorem Q_pos_def (x y : ℤ) (h : ¬(x = 0 ∧ y = 0)) : 0 < Q x y := by
  have key : 4 * Q x y = (2 * x + y) ^ 2 + 3 * y ^ 2 := by unfold Q; ring
  rcases not_and_or.mp h with hx | hy
  · by_contra h'
    have : Q x y = 0 := le_antisymm (not_lt.mp h') (Q_nonneg x y)
    have h4 : (2 * x + y) ^ 2 + 3 * y ^ 2 = 0 := by linarith
    have hy0 : y = 0 := by nlinarith [sq_nonneg (2 * x + y), sq_nonneg y]
    have hx0 : x = 0 := by nlinarith [sq_nonneg (2 * x + y)]
    exact hx hx0
  · by_contra h'
    have : Q x y = 0 := le_antisymm (not_lt.mp h') (Q_nonneg x y)
    have h4 : (2 * x + y) ^ 2 + 3 * y ^ 2 = 0 := by linarith
    have hy0 : y = 0 := by nlinarith [sq_nonneg (2 * x + y), sq_nonneg y]
    exact hy hy0

noncomputable def r_Q (n : ℕ) : ℕ :=
  Finset.card (Finset.filter (fun p : ℤ × ℤ => Q p.1 p.2 = ↑n ∧ p.1.natAbs ≤ 2 * n ∧ p.2.natAbs ≤ 2 * n)
    (Finset.Icc ((-2*↑n, -2*↑n) : ℤ × ℤ) ((2*↑n, 2*↑n) : ℤ × ℤ)))

theorem r_Q_nonneg (n : ℕ) : 0 ≤ r_Q n := Nat.zero_le _

/-
PROVIDED SOLUTION
Show r_Q n = 0 when n % 3 = 2. r_Q counts integer pairs (a,b) with Q a b = n in a bounded range. Q(a,b) = a² + ab + b² mod 3 can only be 0 or 1 (check all 9 combinations of a%3, b%3), never 2. So if n%3=2, no solutions exist, hence the count is 0. Use Finset.card_eq_zero and show the filter is empty by showing no element satisfies the predicate, using the mod 3 argument on Q.
-/
theorem r_Q_zero_of_mod3_eq2 (n : ℕ) (hn : n % 3 = 2) : r_Q n = 0 := by
  -- Since $Q(a, b) \equiv 0 \text{ or } 1 \pmod{3}$ for any integers $a$ and $b$, and $n \equiv 2 \pmod{3}$, the equation $Q(a, b) = n$ has no solutions.
  have h_no_solutions : ∀ a b : ℤ, Q a b % 3 ≠ 2 := by
    exact fun a b => by unfold Q; norm_num [ Int.add_emod, Int.mul_emod, sq ] ; have := Int.emod_nonneg a three_ne_zero; have := Int.emod_nonneg b three_ne_zero; have := Int.emod_lt_of_pos a zero_lt_three; have := Int.emod_lt_of_pos b zero_lt_three; interval_cases a % 3 <;> interval_cases b % 3 <;> trivial;
  unfold r_Q;
  simp [hn, h_no_solutions];
  intro a b _ _ _ _ h₁ h₂; specialize h_no_solutions a b; omega;

/-! ## Part 3: The Embedded Hexagon in the Cubic Lattice -/

abbrev CubeVertex : Type := Fin 8

def hexagon_cycle : List CubeVertex :=
  [0, 2, 6, 4, 5, 1]  -- 6-cycle using face diagonals of the unit cube

theorem hexagon_is_6_cycle : hexagon_cycle.length = 6 := rfl

-- The original statement `hexagon_is_closed` claimed head! = getLast!, but for [0,...,1] that is
-- 0 = 1 in Fin 8, which is false. Commenting out the original incorrect statement.
-- theorem hexagon_is_closed : hexagon_cycle.head! = hexagon_cycle.getLast! := by decide

-- The original `hexagon_M5_invariant` statement is ill-typed: M5 is a 6×6 real matrix while
-- hexagon_cycle elements are Fin 8. The scalar action (•) does not meaningfully apply here.
-- Commenting it out.
-- theorem hexagon_M5_invariant :
--     ∀ v ∈ hexagon_cycle, M5 • v ∈ hexagon_cycle := by sorry

theorem hexagon_symmetry_matches_DULA : hexagon_cycle.length = 6 := rfl

/-! ## Part 4: The Telescoping Conjecture -/

-- `E_error` is not defined, so the telescoping conjecture and its implication cannot be stated.
-- These are open conjectures (related to GRH for L(s, χ₃)) and cannot be formalized without
-- first defining the error term E_error and establishing significant analytic number theory
-- infrastructure not present in Mathlib.

-- theorem telescoping_conjecture :
--     ∀ ε : ℝ, 0 < ε → ∃ C : ℝ, ∀ R : ℝ, 1 ≤ R →
--       |E_error R| ≤ C * R ^ (1/2 + ε) := by
--   sorry

-- theorem telescoping_implies_GRH_chi3
--     (h : ∀ ε : ℝ, 0 < ε → ∃ C : ℝ, ∀ R : ℝ, 1 ≤ R →
--       |E_error R| ≤ C * R ^ (1/2 + ε)) :
--     ∀ ρ : ℂ, DirichletCharacter.LFunction chi3 ρ = 0 →
--       ρ.re = 1/2 ∨ (∃ n : ℤ, ρ = -2 * n) := by
--   sorry

/-! ## Verification Checks -/

#check dula_phi6_is_chi3
#check M5_square_is_I
#check det_M5_is_one
#check Q_pos_def
#check r_Q_nonneg
#check r_Q_zero_of_mod3_eq2
#check hexagon_is_6_cycle
#check hexagon_symmetry_matches_DULA

end DULA
import Mathlib
import RequestProject.Imported.CharTwistedEta.CharTwistedEta_Root
import RequestProject.Imported.CharTwistedEta.DULAGradedMonoid_Root

/-!
# Bridge: `chi` ↔ `DirichletCharacter ℂ 6`

This file constructs a Dirichlet character `chiDir : DirichletCharacter ℂ 6`
matching the arithmetic function `chi : ℕ → ℤ` from `CharTwistedEta.lean`,
and proves the bridge theorem connecting them.
-/

noncomputable section

open Complex

namespace DULABridge

/-! ### Direct ZMod 6 → ℂ definition matching `chi` -/

/-- The value of `chi` lifted to `ZMod 6 → ℂ`. -/
def chiZMod6 : ZMod 6 → ℂ := fun n =>
  match (n : ZMod 6).val with
  | 1 => 1
  | 5 => -1
  | _ => 0

private theorem val0 : (0 : ZMod 6).val = 0 := rfl
private theorem val1 : (1 : ZMod 6).val = 1 := rfl
private theorem val2 : (2 : ZMod 6).val = 2 := rfl
private theorem val3 : (3 : ZMod 6).val = 3 := rfl
private theorem val4 : (4 : ZMod 6).val = 4 := rfl
private theorem val5 : (5 : ZMod 6).val = 5 := rfl

@[simp] theorem chiZMod6_zero : chiZMod6 0 = 0 := by simp [chiZMod6, val0]
@[simp] theorem chiZMod6_one : chiZMod6 1 = 1 := by simp [chiZMod6, val1]
@[simp] theorem chiZMod6_two : chiZMod6 2 = 0 := by simp [chiZMod6, val2]
@[simp] theorem chiZMod6_three : chiZMod6 3 = 0 := by simp [chiZMod6, val3]
@[simp] theorem chiZMod6_four : chiZMod6 4 = 0 := by simp [chiZMod6, val4]
@[simp] theorem chiZMod6_five : chiZMod6 5 = -1 := by simp [chiZMod6, val5]

/-
The multiplicativity of `chiZMod6` on the full `ZMod 6`.
-/
theorem chiZMod6_mul (a b : ZMod 6) : chiZMod6 (a * b) = chiZMod6 a * chiZMod6 b := by
  -- By checking all possible pairs (a, b) in ZMod 6, we can verify that chiZMod6 (a * b) = chiZMod6 a * chiZMod6 b.
  fin_cases a <;> fin_cases b <;> simp +decide [chiZMod6];
  · norm_num [ ZMod.val ];
  · norm_num [ ZMod.val ];
  · norm_num [ ZMod.val ];
  · norm_num [ ZMod.val ]

/-
`chiZMod6` sends non-units of `ZMod 6` to 0.
-/
theorem chiZMod6_map_nonunit (a : ZMod 6) (ha : ¬IsUnit a) : chiZMod6 a = 0 := by
  fin_cases a <;> simp_all +decide

/-! ### Promotion to `DirichletCharacter ℂ 6` -/

/-- `chi` packaged as a `DirichletCharacter ℂ 6`. -/
def chiDir : DirichletCharacter ℂ 6 :=
  { toFun := chiZMod6
    map_one' := chiZMod6_one
    map_mul' := chiZMod6_mul
    map_nonunit' := chiZMod6_map_nonunit }

/-- `chiDir` agrees with `chiZMod6` by construction. -/
theorem chiDir_apply_zMod6 (n : ZMod 6) : chiDir n = chiZMod6 n := rfl

/-! ### Bridge: chiZMod6 agrees with chi on natural numbers -/

/-
`chiZMod6` evaluated at `(n : ZMod 6)` equals `(chi n : ℂ)`.
-/
theorem chiZMod6_natCast_eq_chi (n : ℕ) :
    chiZMod6 (n : ZMod 6) = (chi n : ℂ) := by
  unfold chiZMod6 chi; norm_cast;
  norm_num [ ZMod.val_natCast ];
  rw [ ← Nat.mod_mod_of_dvd n ( by decide : 2 ∣ 6 ), ← Nat.mod_mod_of_dvd n ( by decide : 3 ∣ 6 ) ] ; have := Nat.mod_lt n ( by decide : 6 > 0 ) ; interval_cases n % 6 <;> trivial;

/-! ### The bridge theorem -/

/-- `chiDir` evaluated at `(n : ZMod 6)` equals `(chi n : ℂ)`. -/
theorem chiDir_apply_natCast (n : ℕ) :
    chiDir (n : ZMod 6) = (chi n : ℂ) := by
  rw [chiDir_apply_zMod6]
  exact chiZMod6_natCast_eq_chi n

/-! ### Cleaner statement: `chiDir` agrees with `chi` on `coprimeSixSet` -/

theorem chiDir_eq_pm_one_on_coprime
    {n : ℕ} (h : n ∈ DULAGradedMonoid.coprimeSixSet) :
    chiDir (n : ZMod 6) = 1 ∨ chiDir (n : ZMod 6) = -1 := by
  rw [chiDir_apply_natCast]
  rcases DULAGradedMonoid.chi_eq_pm_one_of_coprime h with h1 | h_neg
  · left; rw [h1]; norm_num
  · right; rw [h_neg]; norm_num

/-! ### Connection to Mathlib's L-function machinery -/

/-- For `Re s > 1`, the analytic L-function of `chiDir` agrees with the
    naive Dirichlet series of `chi`. -/
theorem LFunction_chiDir_eq_LSeries_chi (s : ℂ) (hs : 1 < s.re) :
    DirichletCharacter.LFunction chiDir s
      = LSeries (fun n => (chi n : ℂ)) s := by
  rw [DirichletCharacter.LFunction_eq_LSeries chiDir hs]
  congr 1
  ext n
  exact chiDir_apply_natCast n

end DULABridge

end
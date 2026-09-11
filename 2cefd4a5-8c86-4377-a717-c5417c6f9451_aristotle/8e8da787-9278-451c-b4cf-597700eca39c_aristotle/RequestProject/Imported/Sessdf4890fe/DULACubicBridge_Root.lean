import Mathlib
import RequestProject.Imported.Sessdf4890fe.DULACubic_Root

/-!
# Bridge: chi9 ↔ DirichletCharacter ℂ 9

This file constructs the Dirichlet character `chi9Dir : DirichletCharacter ℂ 9`
corresponding to the cubic residue character χ₉ of conductor 9,
and proves the bridge theorems connecting it to the arithmetic function `chi9`.
-/

set_option maxHeartbeats 800000

noncomputable section

open Complex

namespace DULACubicBridge

/-! ### Primitive third root of unity -/

def zeta3 : ℂ := exp (2 * Real.pi * I / 3)

/-! ### Direct ZMod 9 → ℂ definition matching chi9 -/

/-- The cubic character lifted to ZMod 9 → ℂ. -/
def chi9ZMod9 : ZMod 9 → ℂ := fun n =>
  if (n : ZMod 9).val % 3 ≠ 0 then
    zeta3 ^ (DULACubic.chi9 (n : ZMod 9).val).val
  else 0

@[simp] theorem chi9ZMod9_zero : chi9ZMod9 0 = 0 := by
  simp [chi9ZMod9]

@[simp] theorem chi9ZMod9_one : chi9ZMod9 1 = 1 := by
  unfold chi9ZMod9
  have h1 : (1 : ZMod 9).val = 1 := by native_decide
  have h2 : DULACubic.chi9 1 = 0 := DULACubic.chi9_one
  simp [h1, h2, zeta3]

@[simp] theorem chi9ZMod9_two : chi9ZMod9 2 = zeta3 := by
  unfold chi9ZMod9
  have h1 : (2 : ZMod 9).val = 2 := by native_decide
  have h2 : DULACubic.chi9 2 = 1 := DULACubic.chi9_two
  simp [h1, h2]

@[simp] theorem chi9ZMod9_three : chi9ZMod9 3 = 0 := by
  unfold chi9ZMod9
  have h1 : (3 : ZMod 9).val = 3 := by native_decide
  simp [h1]

@[simp] theorem chi9ZMod9_four : chi9ZMod9 4 = zeta3 ^ 2 := by
  unfold chi9ZMod9
  have h1 : (4 : ZMod 9).val = 4 := by native_decide
  have h2 : DULACubic.chi9 4 = 2 := DULACubic.chi9_four
  simp [h1, h2]

@[simp] theorem chi9ZMod9_five : chi9ZMod9 5 = zeta3 ^ 2 := by
  unfold chi9ZMod9
  have h1 : (5 : ZMod 9).val = 5 := by native_decide
  have h2 : DULACubic.chi9 5 = 2 := DULACubic.chi9_five
  simp [h1, h2]

@[simp] theorem chi9ZMod9_six : chi9ZMod9 6 = 0 := by
  unfold chi9ZMod9
  have h1 : (6 : ZMod 9).val = 6 := by native_decide
  simp [h1]

@[simp] theorem chi9ZMod9_seven : chi9ZMod9 7 = zeta3 := by
  unfold chi9ZMod9
  have h1 : (7 : ZMod 9).val = 7 := by native_decide
  have h2 : DULACubic.chi9 7 = 1 := DULACubic.chi9_seven
  simp [h1, h2]

@[simp] theorem chi9ZMod9_eight : chi9ZMod9 8 = 1 := by
  unfold chi9ZMod9
  have h1 : (8 : ZMod 9).val = 8 := by native_decide
  have h2 : DULACubic.chi9 8 = 0 := DULACubic.chi9_eight
  simp [h1, h2, zeta3]

/-
chi9ZMod9 sends non-units of ZMod 9 to 0.
-/
theorem chi9ZMod9_map_nonunit (a : ZMod 9) (ha : ¬IsUnit a) : chi9ZMod9 a = 0 := by
  fin_cases a <;> simp_all +decide

/-
Multiplicativity of chi9ZMod9 on ZMod 9.
-/
theorem chi9ZMod9_mul (a b : ZMod 9) : chi9ZMod9 (a * b) = chi9ZMod9 a * chi9ZMod9 b := by
  fin_cases a <;> fin_cases b <;> simp +decide [ chi9ZMod9 ];
  all_goals norm_num [ DULACubic.chi9, ZMod.val ];
  all_goals norm_num [ ← Complex.exp_nat_mul, mul_div_cancel₀, zeta3 ];
  all_goals norm_num [ ← Complex.exp_add ] ; ring;
  all_goals norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, mul_two ];
  · norm_num [ ( by ring : Real.pi * ( 2 / 3 ) = Real.pi - Real.pi / 3 ), ( by ring : Real.pi * ( 8 / 3 ) = 2 * Real.pi + 2 * Real.pi / 3 ), Real.cos_add, Real.sin_add, Real.cos_two_mul, Real.sin_two_mul, mul_div_assoc ];
    ring;
  · norm_num [ ( by ring : Real.pi * ( 2 / 3 ) = Real.pi - Real.pi / 3 ), ( by ring : Real.pi * ( 8 / 3 ) = 2 * Real.pi + 2 * Real.pi / 3 ), Real.cos_add, Real.sin_add, Real.cos_two_mul, Real.sin_two_mul, mul_div_assoc ];
    ring;
  · norm_num [ ( by ring : Real.pi * ( 2 / 3 ) = Real.pi - Real.pi / 3 ), ( by ring : Real.pi * ( 8 / 3 ) = 2 * Real.pi + 2 * Real.pi / 3 ), Real.cos_add, Real.sin_add, Real.cos_two_mul, Real.sin_two_mul, mul_div_assoc ];
    ring;
  · norm_num [ ( by ring : Real.pi * ( 2 / 3 ) = Real.pi - Real.pi / 3 ), ( by ring : Real.pi * ( 8 / 3 ) = 2 * Real.pi + 2 * Real.pi / 3 ), Real.cos_add, Real.sin_add, Real.cos_two_mul, Real.sin_two_mul, mul_div_assoc ];
    ring

/-! ### Promotion to DirichletCharacter ℂ 9 -/

def chi9Dir : DirichletCharacter ℂ 9 :=
  { toFun := chi9ZMod9
    map_one' := chi9ZMod9_one
    map_mul' := chi9ZMod9_mul
    map_nonunit' := chi9ZMod9_map_nonunit }

/-- chi9Dir agrees with chi9ZMod9 by construction. -/
theorem chi9Dir_apply_zMod9 (n : ZMod 9) : chi9Dir n = chi9ZMod9 n := rfl

/-! ### Bridge theorems -/

/-
chi9ZMod9 (n : ZMod 9) equals zeta3 ^ (chi9 n).val for n coprime to 3.
-/
theorem chi9ZMod9_natCast_eq_chi9 (n : ℕ) (hcop : Nat.gcd n 3 = 1) :
    chi9ZMod9 (n : ZMod 9) = zeta3 ^ (DULACubic.chi9 n).val := by
  -- By definition of chi9ZMod9, if n is coprime to 3, then chi9ZMod9 n = zeta3 ^ (chi9 n).val.
  simp [chi9ZMod9];
  rw [ if_neg ( by intro h; have := Nat.dvd_gcd ( Nat.dvd_of_mod_eq_zero h ) ( by decide : 3 ∣ 3 ) ; simp_all +decide ) ];
  unfold DULACubic.chi9; norm_num [ Nat.mod_mod ] ;

/-- Main bridge: chi9Dir (n : ZMod 9) = zeta3 ^ (DULACubic.chi9 n).val for n coprime to 3. -/
theorem chi9Dir_apply_natCast (n : ℕ) (hcop : Nat.gcd n 3 = 1) :
    chi9Dir (n : ZMod 9) = zeta3 ^ (DULACubic.chi9 n).val := by
  rw [chi9Dir_apply_zMod9]
  exact chi9ZMod9_natCast_eq_chi9 n hcop

/-- chi9Dir agrees with chi9 on integers coprime to 3 (values in {1, ζ₃, ζ₃²}). -/
theorem chi9Dir_eq_on_coprimeThree
    {n : ℕ} (h : DULACubic.isCoprimeThree n) :
    chi9Dir (n : ZMod 9) = 1 ∨
    chi9Dir (n : ZMod 9) = zeta3 ∨
    chi9Dir (n : ZMod 9) = zeta3 ^ 2 := by
  have hcop : Nat.gcd n 3 = 1 := h
  rw [chi9Dir_apply_natCast n hcop]
  have hv := (DULACubic.chi9 n).isLt
  interval_cases (DULACubic.chi9 n).val <;> simp_all

/-! ### Connection to L-function machinery -/

/-- For Re s > 1, the analytic L-function of chi9Dir agrees with the
    Dirichlet series using chi9Dir values. -/
theorem LFunction_chi9Dir_eq_LSeries (s : ℂ) (hs : 1 < s.re) :
    DirichletCharacter.LFunction chi9Dir s
      = LSeries (fun n => chi9Dir (n : ZMod 9)) s := by
  rw [DirichletCharacter.LFunction_eq_LSeries chi9Dir hs]

end DULACubicBridge

end
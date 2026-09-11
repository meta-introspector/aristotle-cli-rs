/-
# CliffordCl09Rels — Generator Relations for Cl(0,9) via SPerm Lifting

Instead of doing native_decide on 32×32 matrix products (too slow),
we lift from the SPerm-level properties already verified in CliffordCl09SPerm.
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordCl09SPerm

set_option maxHeartbeats 1600000

/-! ## §1. SPerm 32 to Matrix Conversion -/

def SPerm32.toMatrix' (sp : SPerm 32) : Matrix (Fin 32) (Fin 32) ℤ :=
  Matrix.of fun i j => if sp.perm i = j then (if sp.sign i then 1 else -1) else 0

/-! ## §2. SPerm multiplication corresponds to matrix multiplication -/

theorem sperm32_mul_toMatrix (a b : SPerm 32) :
    SPerm32.toMatrix' (a * b) = SPerm32.toMatrix' a * SPerm32.toMatrix' b := by
  -- By definition of matrix multiplication, we can expand the product of the matrices corresponding to a and b.
  ext i j; simp [Matrix.mul_apply, SPerm32.toMatrix'];
  rw [ Finset.sum_eq_single ( a.perm i ) ] <;> simp +decide [ Finset.sum_ite ];
  · split_ifs <;> simp_all +decide [ xor ];
    all_goals simp_all +decide [ show ( a * b ).perm = fun i => b.perm ( a.perm i ) from rfl, show ( a * b ).sign = fun i => !( xor ( a.sign i ) ( b.sign ( a.perm i ) ) ) from rfl ];
  · aesop

theorem sperm32_one_toMatrix :
    SPerm32.toMatrix' (1 : SPerm 32) = (1 : Matrix (Fin 32) (Fin 32) ℤ) := by
  ext i j; aesop

theorem sperm32_neg_id_toMatrix :
    ∀ (sp : SPerm 32),
    sp.perm = id → (∀ j : Fin 32, sp.sign j = false) →
    SPerm32.toMatrix' sp = -(1 : Matrix (Fin 32) (Fin 32) ℤ) := by
  unfold SPerm32.toMatrix';
  aesop

/-! ## §3. Generator squares to -I -/

def gammaZ32' (k : Fin 9) : Matrix (Fin 32) (Fin 32) ℤ := SPerm32.toMatrix' (gamSP32 k)

theorem gammaZ32_sq' (k : Fin 9) : gammaZ32' k * gammaZ32' k = -1 := by
  show SPerm32.toMatrix' (gamSP32 k) * SPerm32.toMatrix' (gamSP32 k) = -1
  rw [← sperm32_mul_toMatrix]
  have h := gamSP32_sq_neg_id k
  exact sperm32_neg_id_toMatrix _ h.1 h.2

/-! ## §4. Anticommutativity -/

theorem sperm32_anticommute_toMatrix {a b : SPerm 32}
    (h : ∀ k : Fin 32, (a * b).perm k = (b * a).perm k ∧
      (a * b).sign k ≠ (b * a).sign k) :
    SPerm32.toMatrix' a * SPerm32.toMatrix' b +
    SPerm32.toMatrix' b * SPerm32.toMatrix' a = 0 := by
  rw [← sperm32_mul_toMatrix, ← sperm32_mul_toMatrix]
  ext i j; simp +decide [ SPerm32.toMatrix' ] ;
  grind

theorem gammaZ32_anticommute' {a b : Fin 9} (hab : a ≠ b) :
    gammaZ32' a * gammaZ32' b + gammaZ32' b * gammaZ32' a = 0 := by
  exact sperm32_anticommute_toMatrix (gamSP32_anticommute a b hab)
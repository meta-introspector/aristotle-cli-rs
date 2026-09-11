/-
# CliffordCl10Rels — Generator Relations for Cl(0,10) via SPerm Lifting

Lifts from SPerm-level properties already verified in CliffordCl10SPerm.
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordCl10SPerm

set_option maxHeartbeats 1600000

/-! ## §1. SPerm 64 to Matrix Conversion -/

def SPerm64.toMatrix' (sp : SPerm 64) : Matrix (Fin 64) (Fin 64) ℤ :=
  Matrix.of fun i j => if sp.perm i = j then (if sp.sign i then 1 else -1) else 0

/-! ## §2. SPerm multiplication corresponds to matrix multiplication -/

theorem sperm64_mul_toMatrix (a b : SPerm 64) :
    SPerm64.toMatrix' (a * b) = SPerm64.toMatrix' a * SPerm64.toMatrix' b := by
  ext i j; simp [Matrix.mul_apply, SPerm64.toMatrix'];
  rw [ Finset.sum_eq_single ( a.perm i ) ] <;> simp +decide [ Finset.sum_ite ];
  · split_ifs <;> simp_all +decide [ xor ];
    all_goals simp_all +decide [ show ( a * b ).perm = fun i => b.perm ( a.perm i ) from rfl, show ( a * b ).sign = fun i => !( xor ( a.sign i ) ( b.sign ( a.perm i ) ) ) from rfl ];
  · aesop

theorem sperm64_one_toMatrix :
    SPerm64.toMatrix' (1 : SPerm 64) = (1 : Matrix (Fin 64) (Fin 64) ℤ) := by
  ext i j; aesop

theorem sperm64_neg_id_toMatrix :
    ∀ (sp : SPerm 64),
    sp.perm = id → (∀ j : Fin 64, sp.sign j = false) →
    SPerm64.toMatrix' sp = -(1 : Matrix (Fin 64) (Fin 64) ℤ) := by
  unfold SPerm64.toMatrix';
  aesop

/-! ## §3. Generator squares to -I -/

def gammaZ64' (k : Fin 10) : Matrix (Fin 64) (Fin 64) ℤ := SPerm64.toMatrix' (gamSP64 k)

theorem gammaZ64_sq' (k : Fin 10) : gammaZ64' k * gammaZ64' k = -1 := by
  show SPerm64.toMatrix' (gamSP64 k) * SPerm64.toMatrix' (gamSP64 k) = -1
  rw [← sperm64_mul_toMatrix]
  have h := gamSP64_sq_neg_id k
  exact sperm64_neg_id_toMatrix _ h.1 h.2

/-! ## §4. Anticommutativity -/

theorem sperm64_anticommute_toMatrix {a b : SPerm 64}
    (h : ∀ k : Fin 64, (a * b).perm k = (b * a).perm k ∧
      (a * b).sign k ≠ (b * a).sign k) :
    SPerm64.toMatrix' a * SPerm64.toMatrix' b +
    SPerm64.toMatrix' b * SPerm64.toMatrix' a = 0 := by
  rw [← sperm64_mul_toMatrix, ← sperm64_mul_toMatrix]
  ext i j; simp +decide [ SPerm64.toMatrix' ] ;
  grind

theorem gammaZ64_anticommute' {a b : Fin 10} (hab : a ≠ b) :
    gammaZ64' a * gammaZ64' b + gammaZ64' b * gammaZ64' a = 0 := by
  exact sperm64_anticommute_toMatrix (gamSP64_anticommute a b hab)

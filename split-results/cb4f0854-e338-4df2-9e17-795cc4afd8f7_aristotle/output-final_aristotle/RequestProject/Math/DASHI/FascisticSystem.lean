/-
  FascisticSystem.lean — Port of FascisticSystem.agda and AntiFascistSystem.agda.
-/
import Mathlib

namespace DASHI

/-! ## §1. Fascistic system: projection operators -/

structure Projection (S : Type*) where
  K : S → S
  H : S → ℕ
  idemp : ∀ s, K (K s) = K s
  contract : ∀ s, H (K s) ≤ H s

structure FascisticSys (S : Type*) where
  Ktotal : S → S
  H : S → ℕ
  monotone : ∀ s, H (Ktotal s) ≤ H s
  strict_decrease : ∀ s, H (Ktotal s) < H s ∨ Ktotal s = s

def FascisticSys.Attractor {S : Type*} (sys : FascisticSys S) :=
  { s : S // sys.Ktotal s = s }

def FascisticSys.iter {S : Type*} (sys : FascisticSys S) : ℕ → S → S
  | 0, s => s
  | n + 1, s => sys.Ktotal (sys.iter n s)

theorem FascisticSys.iter_monotone {S : Type*} (sys : FascisticSys S)
    (n : ℕ) (s : S) : sys.H (sys.iter n s) ≤ sys.H s := by
  induction n with
  | zero => simp [iter]
  | succ n ih => simp only [iter]; exact le_trans (sys.monotone _) ih

/-! ## §2. Anti-fascistic system: invertible operators -/

structure InvertibleOp (S : Type*) where
  U : S → S
  U_inv : S → S
  left_inv : ∀ s, U_inv (U s) = s
  right_inv : ∀ s, U (U_inv s) = s

structure AntiFascisticSys (S : Type*) where
  op : InvertibleOp S
  H : S → ℕ
  entropy_preserved : ∀ s, H (op.U s) = H s

/-! ## §3. Incompatibility theorem -/

theorem projection_vs_unitary {S : Type*} (U : S → S) (H : S → ℕ)
    (s : S) (h_preserved : H (U s) = H s) (h_strict : H (U s) < H s) : False := by
  omega

end DASHI

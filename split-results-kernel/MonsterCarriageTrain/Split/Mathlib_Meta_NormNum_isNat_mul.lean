import Split.NonAssocSemiring_toAddCommMonoidWithOne
import Split.Mathlib_Meta_NormNum_IsNat
import Split.HMul_hMul
import Split.Mathlib_Meta_NormNum_IsNat_mk
import Split.AddMonoidWithOne_toNatCast
import Split.instMulNat
import Split.AddCommMonoidWithOne_toAddMonoidWithOne
import Split.Nat_cast
import Split.Nat_cast_mul
import Split.Distrib_toMul
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Nat
import Split.Semiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Nat_mul
import Split.Eq_symm
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.instHMul

-- Mathlib.Meta.NormNum.isNat_mul from environment
-- theorem Mathlib.Meta.NormNum.isNat_mul : forall {α : Type.{u_1}} [inst._@.Mathlib.Tactic.NormNum.Basic.2176342526._hygCtx._hyg.3 : Semiring.{u_1} α] {f : α -> α -> α} {a : α} {b : α} {a' : Nat} {b' : Nat} {c : Nat}, (Eq.{succ u_1} (α -> α -> α) f (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (Distrib.toMul.{u_1} α (NonUnitalNonAssocSemiring.toDistrib.{u_1} α (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} α (Semiring.toNonAssocSemiring.{u_1} α inst._@.Mathlib.Tactic.NormNum.Basic.2176342526._hygCtx._hyg.3))))))) -> (Mathlib.Meta.NormNum.IsNat.{u_1} α (AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} α (NonAssocSemiring.toAddCommMonoidWithOne.{u_1} α (Semiring.toNonAssocSemiring.{u_1} α inst._@.Mathlib.Tactic.NormNum.Basic.2176342526._hygCtx._hyg.3))) a a') -> (Mathlib.Meta.NormNum.IsNat.{u_1} α (AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} α (NonAssocSemiring.toAddCommMonoidWithOne.{u_1} α (Semiring.toNonAssocSemiring.{u_1} α inst._@.Mathlib.Tactic.NormNum.Basic.2176342526._hygCtx._hyg.3))) b b') -> (Eq.{1} Nat (Nat.mul a' b') c) -> (Mathlib.Meta.NormNum.IsNat.{u_1} α (AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} α (NonAssocSemiring.toAddCommMonoidWithOne.{u_1} α (Semiring.toNonAssocSemiring.{u_1} α inst._@.Mathlib.Tactic.NormNum.Basic.2176342526._hygCtx._hyg.3))) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (Distrib.toMul.{u_1} α (NonUnitalNonAssocSemiring.toDistrib.{u_1} α (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} α (Semiring.toNonAssocSemiring.{u_1} α inst._@.Mathlib.Tactic.NormNum.Basic.2176342526._hygCtx._hyg.3))))) a b) c)

-- Stub: this file represents the declaration `Mathlib.Meta.NormNum.isNat_mul`.
-- In a full split, the body would be extracted from the environment.

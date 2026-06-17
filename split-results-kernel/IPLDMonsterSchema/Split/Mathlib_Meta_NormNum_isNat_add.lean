import Split.Mathlib_Meta_NormNum_IsNat
import Split.AddMonoid_toAddSemigroup
import Split.Mathlib_Meta_NormNum_IsNat_mk
import Split.AddMonoidWithOne_toNatCast
import Split.Nat_cast
import Split.Nat_cast_add
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.AddMonoidWithOne_toAddMonoid
import Split.Eq_symm
import Split.Eq
import Split.Nat_add
import Split.AddMonoidWithOne

-- Mathlib.Meta.NormNum.isNat_add from environment
-- theorem Mathlib.Meta.NormNum.isNat_add : forall {α : Type.{u_1}} [inst._@.Mathlib.Tactic.NormNum.Basic.1499119607._hygCtx._hyg.3 : AddMonoidWithOne.{u_1} α] {f : α -> α -> α} {a : α} {b : α} {a' : Nat} {b' : Nat} {c : Nat}, (Eq.{succ u_1} (α -> α -> α) f (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α (AddSemigroup.toAdd.{u_1} α (AddMonoid.toAddSemigroup.{u_1} α (AddMonoidWithOne.toAddMonoid.{u_1} α inst._@.Mathlib.Tactic.NormNum.Basic.1499119607._hygCtx._hyg.3)))))) -> (Mathlib.Meta.NormNum.IsNat.{u_1} α inst._@.Mathlib.Tactic.NormNum.Basic.1499119607._hygCtx._hyg.3 a a') -> (Mathlib.Meta.NormNum.IsNat.{u_1} α inst._@.Mathlib.Tactic.NormNum.Basic.1499119607._hygCtx._hyg.3 b b') -> (Eq.{1} Nat (Nat.add a' b') c) -> (Mathlib.Meta.NormNum.IsNat.{u_1} α inst._@.Mathlib.Tactic.NormNum.Basic.1499119607._hygCtx._hyg.3 (f a b) c)

-- Stub: this file represents the declaration `Mathlib.Meta.NormNum.isNat_add`.
-- In a full split, the body would be extracted from the environment.

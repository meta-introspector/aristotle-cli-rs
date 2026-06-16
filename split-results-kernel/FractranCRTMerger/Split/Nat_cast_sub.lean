import Split.Eq_mpr
import Split.AddMonoid_toAddSemigroup
import Split.AddGroupWithOne_toAddGroup
import Split.congrArg
import Split.eq_sub_of_add_eq
import Split.AddMonoid_toAddZeroClass
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.HSub_hSub
import Split.AddZeroClass_toAddZero
import Split.id
import Split.AddMonoidWithOne_toNatCast
import Split.instSubNat
import Split.LE_le
import Split.instLENat
import Split.Nat_cast
import Split.SubNegMonoid_toSub
import Split.Nat_cast_add
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.Nat_sub_add_cancel
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.AddZero_toAdd
import Split.Eq_refl
import Split.AddGroupWithOne
import Split.AddMonoidWithOne_toAddMonoid
import Split.SubNegMonoid_toAddMonoid
import Split.Eq_symm
import Split.Eq

-- Nat.cast_sub from environment
-- theorem Nat.cast_sub : forall {R : Type.{u}} [inst._@.Mathlib.Data.Int.Cast.Basic.549007943._hygCtx._hyg.3 : AddGroupWithOne.{u} R] {m : Nat} {n : Nat}, (LE.le.{0} Nat instLENat m n) -> (Eq.{succ u} R (Nat.cast.{u} R (AddMonoidWithOne.toNatCast.{u} R (AddGroupWithOne.toAddMonoidWithOne.{u} R inst._@.Mathlib.Data.Int.Cast.Basic.549007943._hygCtx._hyg.3)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m)) (HSub.hSub.{u, u, u} R R R (instHSub.{u} R (SubNegMonoid.toSub.{u} R (AddGroup.toSubNegMonoid.{u} R (AddGroupWithOne.toAddGroup.{u} R inst._@.Mathlib.Data.Int.Cast.Basic.549007943._hygCtx._hyg.3)))) (Nat.cast.{u} R (AddMonoidWithOne.toNatCast.{u} R (AddGroupWithOne.toAddMonoidWithOne.{u} R inst._@.Mathlib.Data.Int.Cast.Basic.549007943._hygCtx._hyg.3)) n) (Nat.cast.{u} R (AddMonoidWithOne.toNatCast.{u} R (AddGroupWithOne.toAddMonoidWithOne.{u} R inst._@.Mathlib.Data.Int.Cast.Basic.549007943._hygCtx._hyg.3)) m)))

-- Stub: this file represents the declaration `Nat.cast_sub`.
-- In a full split, the body would be extracted from the environment.

import Split.AddMonoid_toAddSemigroup
import Split.AddMonoidWithOne_toNatCast
import Split.AddMonoidWithOne_natCast_succ
import Split.Nat_cast
import Split.AddMonoidWithOne_toOne
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.One_toOfNat1
import Split.AddMonoidWithOne_toAddMonoid
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.AddMonoidWithOne

-- Nat.cast_succ from environment
-- theorem Nat.cast_succ : forall {R : Type.{u_1}} [inst._@.Mathlib.Data.Nat.Cast.Defs.2541071451._hygCtx._hyg.3 : AddMonoidWithOne.{u_1} R] (n : Nat), Eq.{succ u_1} R (Nat.cast.{u_1} R (AddMonoidWithOne.toNatCast.{u_1} R inst._@.Mathlib.Data.Nat.Cast.Defs.2541071451._hygCtx._hyg.3) (Nat.succ n)) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R (AddSemigroup.toAdd.{u_1} R (AddMonoid.toAddSemigroup.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R inst._@.Mathlib.Data.Nat.Cast.Defs.2541071451._hygCtx._hyg.3)))) (Nat.cast.{u_1} R (AddMonoidWithOne.toNatCast.{u_1} R inst._@.Mathlib.Data.Nat.Cast.Defs.2541071451._hygCtx._hyg.3) n) (OfNat.ofNat.{u_1} R 1 (One.toOfNat1.{u_1} R (AddMonoidWithOne.toOne.{u_1} R inst._@.Mathlib.Data.Nat.Cast.Defs.2541071451._hygCtx._hyg.3))))

-- Stub: this file represents the declaration `Nat.cast_succ`.
-- In a full split, the body would be extracted from the environment.

import Split.Int_cast
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.AddMonoidWithOne_toNatCast
import Split.Int
import Split.AddGroupWithOne_toIntCast
import Split.Nat_cast
import Split.Nat
import Split.AddGroupWithOne
import Split.instNatCastInt
import Split.AddGroupWithOne_intCast_ofNat
import Split.Eq

-- Int.cast_natCast from environment
-- theorem Int.cast_natCast : forall {R : Type.{u}} [inst._@.Mathlib.Data.Int.Cast.Basic.1650398053._hygCtx._hyg.3 : AddGroupWithOne.{u} R] (n : Nat), Eq.{succ u} R (Int.cast.{u} R (AddGroupWithOne.toIntCast.{u} R inst._@.Mathlib.Data.Int.Cast.Basic.1650398053._hygCtx._hyg.3) (Nat.cast.{0} Int instNatCastInt n)) (Nat.cast.{u} R (AddMonoidWithOne.toNatCast.{u} R (AddGroupWithOne.toAddMonoidWithOne.{u} R inst._@.Mathlib.Data.Int.Cast.Basic.1650398053._hygCtx._hyg.3)) n)

-- Stub: this file represents the declaration `Int.cast_natCast`.
-- In a full split, the body would be extracted from the environment.

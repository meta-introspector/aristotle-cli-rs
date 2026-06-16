import Split.False_elim
import Split.InvImage
import Split.Nat_rec
import Split.Nat
import Split.LT_lt
import Split.Nat_zero
import Split.instLTNat
import Split.Nat_succ

-- WellFounded.Nat.fix.go from environment
-- def WellFounded.Nat.fix.go : forall {α : Sort.{u}} {motive : α -> Sort.{v}} (h : α -> Nat), (forall (x : α), (forall (y : α), (InvImage.{u, 1} α Nat (fun (x1._@.Init.WF.1007480251._hygCtx._hyg.20 : Nat) (x2._@.Init.WF.1007480251._hygCtx._hyg.20 : Nat) => LT.lt.{0} Nat instLTNat x1._@.Init.WF.1007480251._hygCtx._hyg.20 x2._@.Init.WF.1007480251._hygCtx._hyg.20) h y x) -> (motive y)) -> (motive x)) -> (forall (fuel : Nat) (x : α), (LT.lt.{0} Nat instLTNat (h x) fuel) -> (motive x))
-- (definition body omitted)

-- Stub: this file represents the declaration `WellFounded.Nat.fix.go`.
-- In a full split, the body would be extracted from the environment.

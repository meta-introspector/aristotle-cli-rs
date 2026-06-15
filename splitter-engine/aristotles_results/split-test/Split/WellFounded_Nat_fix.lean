import Split.InvImage
import Split.WellFounded_Nat_eager
import Split.instOfNatNat
import Split.WellFounded_Nat_fix_go
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.instLTNat
import Split.OfNat_ofNat

-- WellFounded.Nat.fix from environment
-- def WellFounded.Nat.fix : forall {α : Sort.{u}} {motive : α -> Sort.{v}} (h : α -> Nat), (forall (x : α), (forall (y : α), (InvImage.{u, 1} α Nat (fun (x1._@.Init.WF.1007480251._hygCtx._hyg.20 : Nat) (x2._@.Init.WF.1007480251._hygCtx._hyg.20 : Nat) => LT.lt.{0} Nat instLTNat x1._@.Init.WF.1007480251._hygCtx._hyg.20 x2._@.Init.WF.1007480251._hygCtx._hyg.20) h y x) -> (motive y)) -> (motive x)) -> (forall (x : α), motive x)
-- (definition body omitted)

-- Stub: this file represents the declaration `WellFounded.Nat.fix`.
-- In a full split, the body would be extracted from the environment.

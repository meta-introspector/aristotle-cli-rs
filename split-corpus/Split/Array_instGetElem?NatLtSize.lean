import Mathlib

set_option pp.all true
-- spec: Array.instGetElem?NatLtSize : forall {α : Type.{u_1}}, GetElem?.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs))
def Array.instGetElem?NatLtSize : forall {α : Type.{u_1}}, GetElem?.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) :=
  fun {α : Type.{u_1}} => GetElem?.mk.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) (fun (xs : Array.{u_1} α) (i : Nat) => decidableGetElem?.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) xs i (Nat.decLt i (Array.size.{u_1} α xs))) (fun [inst._@.Init.GetElem.365082188._hygCtx.28.Init.GetElem.953206093._hygCtx._hyg.37 : Inhabited.{succ u_1} α] (xs : Array.{u_1} α) (i : Nat) => Array.get!Internal.{u_1} α inst._@.Init.GetElem.365082188._hygCtx.28.Init.GetElem.953206093._hygCtx._hyg.37 xs i)

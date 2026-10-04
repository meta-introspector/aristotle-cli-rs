import Mathlib

set_option pp.all true
-- spec: Array.back! : forall {α : Type.{u}} [inst._@.Init.Data.Array.Basic.3552202959._hygCtx._hyg.3 : Inhabited.{succ u} α], (Array.{u} α) -> α
def Array.back! : forall {α : Type.{u}} [inst._@.Init.Data.Array.Basic.3552202959._hygCtx._hyg.3 : Inhabited.{succ u} α], (Array.{u} α) -> α :=
  fun {α : Type.{u}} [inst._@.Init.Data.Array.Basic.3552202959._hygCtx._hyg.3 : Inhabited.{succ u} α] (xs : Array.{u} α) => GetElem?.getElem!.{u, 0, u} (Array.{u} α) Nat α (fun (xs : Array.{u} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u} α xs)) (Array.instGetElem?NatLtSize.{u} α) inst._@.Init.Data.Array.Basic.3552202959._hygCtx._hyg.3 xs (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Array.size.{u} α xs) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))

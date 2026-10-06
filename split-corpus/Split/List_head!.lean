import Mathlib

set_option pp.all true
-- spec: List.head! : forall {α : Type.{u_1}} [inst._@.Init.Data.List.BasicAux.2940584282._hygCtx._hyg.5 : Inhabited.{succ u_1} α], (List.{u_1} α) -> α
def List.head! : forall {α : Type.{u_1}} [inst._@.Init.Data.List.BasicAux.2940584282._hygCtx._hyg.5 : Inhabited.{succ u_1} α], (List.{u_1} α) -> α :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.List.BasicAux.2940584282._hygCtx._hyg.5 : Inhabited.{succ u_1} α] (x._@.Init.Data.List.BasicAux.2940584282._hygCtx._hyg.12 : List.{u_1} α) => List.getLast!.match_1.{u_1, succ u_1} α (fun (x._@.Init.Data.List.BasicAux.2940584282._hygCtx.12.Init.Data.List.BasicAux.2940584282._hygCtx._hyg.23 : List.{u_1} α) => α) x._@.Init.Data.List.BasicAux.2940584282._hygCtx._hyg.12 (fun (_ : Unit) => panicWithPosWithDecl.{succ u_1} α inst._@.Init.Data.List.BasicAux.2940584282._hygCtx._hyg.5 "Init.Data.List.BasicAux" "List.head!" (OfNat.ofNat.{0} Nat 80 (instOfNatNat 80)) (OfNat.ofNat.{0} Nat 12 (instOfNatNat 12)) "empty list") (fun (a : α) (tail._@.Init.Data.List.BasicAux.2940584282._hygCtx._hyg.45 : List.{u_1} α) => a)

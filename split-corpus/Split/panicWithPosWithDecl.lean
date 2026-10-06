import Mathlib

set_option pp.all true
-- spec: panicWithPosWithDecl : forall {α : Sort.{u}} [inst._@.Init.Util.950093165._hygCtx._hyg.3 : Inhabited.{u} α], String -> String -> Nat -> Nat -> String -> α
def panicWithPosWithDecl : forall {α : Sort.{u}} [inst._@.Init.Util.950093165._hygCtx._hyg.3 : Inhabited.{u} α], String -> String -> Nat -> Nat -> String -> α :=
  fun {α : Sort.{u}} [inst._@.Init.Util.950093165._hygCtx._hyg.3 : Inhabited.{u} α] (modName : String) (declName : String) (line : Nat) (col : Nat) (msg : String) => panic.{u} α inst._@.Init.Util.950093165._hygCtx._hyg.3 (mkPanicMessageWithDecl modName declName line col msg)

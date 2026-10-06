import Mathlib

set_option pp.all true
-- spec: Lean.profileitIO : forall {ε : Type} {α : Type}, String -> Lean.Options -> (EIO ε α) -> (optParam.{1} Lean.Name Lean.Name.anonymous) -> (EIO ε α)
def Lean.profileitIO : forall {ε : Type} {α : Type}, String -> Lean.Options -> (EIO ε α) -> (optParam.{1} Lean.Name Lean.Name.anonymous) -> (EIO ε α) :=
  fun {ε : Type} {α : Type} (category : String) (opts : Lean.Options) (act : EIO ε α) (decl : Lean.Name) => act

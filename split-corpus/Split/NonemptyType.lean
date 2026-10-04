import Mathlib

set_option pp.all true
-- spec: NonemptyType : Sort.{max 1 (succ (succ u))}
def NonemptyType : Sort.{max 1 (succ (succ u))} :=
  Subtype.{succ (succ u)} Type.{u} (fun (α : Type.{u}) => Nonempty.{succ u} α)

import Mathlib

set_option pp.all true
-- spec: NonemptyType.type : NonemptyType.{u} -> Type.{u}
def NonemptyType.type : NonemptyType.{u} -> Type.{u} :=
  fun (type : NonemptyType.{u}) => Subtype.val.{succ (succ u)} Type.{u} (fun (α : Type.{u}) => Nonempty.{succ u} α) type

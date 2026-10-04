import Mathlib

set_option pp.all true
-- spec: instInhabitedNonemptyType : Inhabited.{succ (succ u)} NonemptyType.{u}
def instInhabitedNonemptyType : Inhabited.{succ (succ u)} NonemptyType.{u} :=
  Inhabited.mk.{succ (succ u)} NonemptyType.{u} (Subtype.mk.{succ (succ u)} Type.{u} (fun (α : Type.{u}) => Nonempty.{succ u} α) PUnit.{succ u} (Nonempty.intro.{succ u} PUnit.{succ u} PUnit.unit.{succ u}))

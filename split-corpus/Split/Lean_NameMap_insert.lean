import Mathlib

set_option pp.all true
-- spec: Lean.NameMap.insert : forall {α : Type}, (Lean.NameMap α) -> Lean.Name -> α -> (Std.TreeMap.{0, 0} Lean.Name α Lean.Name.quickCmp)
def Lean.NameMap.insert : forall {α : Type}, (Lean.NameMap α) -> Lean.Name -> α -> (Std.TreeMap.{0, 0} Lean.Name α Lean.Name.quickCmp) :=
  fun {α : Type} (m : Lean.NameMap α) (n : Lean.Name) (a : α) => Std.TreeMap.insert.{0, 0} Lean.Name α Lean.Name.quickCmp m n a

import Mathlib

set_option pp.all true
-- spec: Lean.NameMap.find? : forall {α : Type}, (Lean.NameMap α) -> Lean.Name -> (Option.{0} α)
def Lean.NameMap.find? : forall {α : Type}, (Lean.NameMap α) -> Lean.Name -> (Option.{0} α) :=
  fun {α : Type} (m : Lean.NameMap α) (n : Lean.Name) => Std.TreeMap.get?.{0, 0} Lean.Name α Lean.Name.quickCmp m n

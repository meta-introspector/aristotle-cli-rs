import Mathlib

set_option pp.all true
-- spec: Lean.NameMap.instInhabited : forall (α : Type), Inhabited.{1} (Lean.NameMap α)
def Lean.NameMap.instInhabited : forall (α : Type), Inhabited.{1} (Lean.NameMap α) :=
  fun (α : Type) => Inhabited.mk.{1} (Lean.NameMap α) (EmptyCollection.emptyCollection.{0} (Lean.NameMap α) (Lean.NameMap.instEmptyCollection α))

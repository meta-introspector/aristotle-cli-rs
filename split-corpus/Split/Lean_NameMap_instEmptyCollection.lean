import Mathlib

set_option pp.all true
-- spec: Lean.NameMap.instEmptyCollection : forall (α : Type), EmptyCollection.{0} (Lean.NameMap α)
def Lean.NameMap.instEmptyCollection : forall (α : Type), EmptyCollection.{0} (Lean.NameMap α) :=
  fun (α : Type) => EmptyCollection.mk.{0} (Lean.NameMap α) (Lean.mkNameMap α)

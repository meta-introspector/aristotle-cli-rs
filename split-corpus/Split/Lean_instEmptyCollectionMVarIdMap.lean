import Mathlib

set_option pp.all true
-- spec: Lean.instEmptyCollectionMVarIdMap : forall {α : Type}, EmptyCollection.{0} (Lean.MVarIdMap α)
def Lean.instEmptyCollectionMVarIdMap : forall {α : Type}, EmptyCollection.{0} (Lean.MVarIdMap α) :=
  fun {α : Type} => EmptyCollection.mk.{0} (Lean.MVarIdMap α) (Lean.instEmptyCollectionMVarIdMap._aux_1 α)

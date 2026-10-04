import Mathlib

set_option pp.all true
-- spec: Lean.instEmptyCollectionFVarIdMap : forall {α : Type}, EmptyCollection.{0} (Lean.FVarIdMap α)
def Lean.instEmptyCollectionFVarIdMap : forall {α : Type}, EmptyCollection.{0} (Lean.FVarIdMap α) :=
  fun {α : Type} => EmptyCollection.mk.{0} (Lean.FVarIdMap α) (Lean.instEmptyCollectionFVarIdMap._aux_1 α)

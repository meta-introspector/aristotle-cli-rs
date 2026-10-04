import Mathlib

-- spec: opaque ST.Prim.Ref.set : forall {σ : Type} {α : Type}, ([mdata borrowed:1 ST.Ref σ α]) -> α -> (ST σ Unit)
opaque ST.Prim.Ref.set : forall {σ : Type} {α : Type}, ([mdata borrowed:1 ST.Ref σ α]) -> α -> (ST σ Unit) :=
  fun {σ : Type} {α : Type} (r : ST.Ref σ α) (a : α) => Inhabited.default.{1} (ST σ Unit) (instInhabitedST σ Unit instInhabitedPUnit.{1})

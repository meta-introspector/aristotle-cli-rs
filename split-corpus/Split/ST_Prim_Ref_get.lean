import Mathlib

-- spec: opaque ST.Prim.Ref.get : forall {σ : Type} {α : Type}, ([mdata borrowed:1 ST.Ref σ α]) -> (ST σ α)
opaque ST.Prim.Ref.get : forall {σ : Type} {α : Type}, ([mdata borrowed:1 ST.Ref σ α]) -> (ST σ α) :=
  fun {σ : Type} {α : Type} (r : ST.Ref σ α) => _private.Init.System.ST.0.ST.Prim.inhabitedFromRef σ α r

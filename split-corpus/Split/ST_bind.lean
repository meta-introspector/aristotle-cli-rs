import Mathlib

set_option pp.all true
-- spec: ST.bind : forall {σ : Type} {α : Type} {β : Type}, (ST σ α) -> (α -> (ST σ β)) -> (ST σ β)
def ST.bind : forall {σ : Type} {α : Type} {β : Type}, (ST σ α) -> (α -> (ST σ β)) -> (ST σ β) :=
  fun {σ : Type} {α : Type} {β : Type} (x : ST σ α) (f : α -> (ST σ β)) (s : Void σ) => _private.Init.System.ST.0.ST.bind.match_1.{1} σ α (fun (x._@.Init.System.ST.3640351540._hygCtx._hyg.37 : ST.Out σ α) => ST.Out σ β) (x s) (fun (x : α) (s : Void σ) => f x s)

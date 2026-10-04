import Mathlib

set_option pp.all true
-- spec: ST.pure : forall {α : Type} {σ : Type}, α -> (ST σ α)
def ST.pure : forall {α : Type} {σ : Type}, α -> (ST σ α) :=
  fun {α : Type} {σ : Type} (x : α) (s : Void σ) => ST.Out.mk σ α x s

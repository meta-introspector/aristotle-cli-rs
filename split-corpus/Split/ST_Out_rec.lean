import Mathlib

-- spec: recursor ST.Out.rec : forall {σ : Type} {α : Type} {motive : (ST.Out σ α) -> Sort.{u}}, (forall (val : α) (state : Void σ), motive (ST.Out.mk σ α val state)) -> (forall (t : ST.Out σ α), motive t)

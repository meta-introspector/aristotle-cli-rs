import Mathlib

set_option pp.all true
-- spec: ST.Out.casesOn : forall {σ : Type} {α : Type} {motive : (ST.Out σ α) -> Sort.{u}} (t : ST.Out σ α), (forall (val : α) (state : Void σ), motive (ST.Out.mk σ α val state)) -> (motive t)
def ST.Out.casesOn : forall {σ : Type} {α : Type} {motive : (ST.Out σ α) -> Sort.{u}} (t : ST.Out σ α), (forall (val : α) (state : Void σ), motive (ST.Out.mk σ α val state)) -> (motive t) :=
  fun {σ : Type} {α : Type} {motive : (ST.Out σ α) -> Sort.{u}} (t : ST.Out σ α) (mk : forall (val : α) (state : Void σ), motive (ST.Out.mk σ α val state)) => ST.Out.rec.{u} σ α motive (fun (val : α) (state : Void σ) => mk val state) t

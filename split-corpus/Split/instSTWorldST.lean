import Mathlib

set_option pp.all true
-- spec: instSTWorldST : forall {σ : Type}, STWorld σ (ST σ)
def instSTWorldST : forall {σ : Type}, STWorld σ (ST σ) :=
  fun {σ : Type} => STWorld.mk σ (ST σ)

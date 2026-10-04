import Mathlib

set_option pp.all true
-- spec: EStateM.nonBacktrackable : forall {σ : Type.{u}}, EStateM.Backtrackable.{u} PUnit.{succ u} σ
def EStateM.nonBacktrackable : forall {σ : Type.{u}}, EStateM.Backtrackable.{u} PUnit.{succ u} σ :=
  fun {σ : Type.{u}} => EStateM.Backtrackable.mk.{u} PUnit.{succ u} σ (EStateM.dummySave.{u, succ u} σ) (EStateM.dummyRestore.{u, succ u} σ)

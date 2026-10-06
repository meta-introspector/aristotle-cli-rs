import Mathlib

set_option pp.all true
-- spec: runST : forall {α : Type}, (forall (σ : Type), ST σ α) -> α
def runST : forall {α : Type}, (forall (σ : Type), ST σ α) -> α :=
  fun {α : Type} (x : forall (σ : Type), ST σ α) => _private.Init.System.ST.0.runST.match_1.{1} α (fun (x._@.Init.System.ST.1949546199._hygCtx._hyg.23 : ST.Out Unit α) => α) (x Unit (Void.mk Unit Unit.unit)) (fun (a : α) (state._@.Init.System.ST.1949546199._hygCtx._hyg.31 : Void Unit) => a)

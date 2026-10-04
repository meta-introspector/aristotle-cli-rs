import Mathlib

set_option pp.all true
-- spec: instInhabitedST : forall {σ : Type} {α : Type} [inst._@.Init.System.ST.1035734954._hygCtx._hyg.4 : Inhabited.{1} α], Inhabited.{1} (ST σ α)
def instInhabitedST : forall {σ : Type} {α : Type} [inst._@.Init.System.ST.1035734954._hygCtx._hyg.4 : Inhabited.{1} α], Inhabited.{1} (ST σ α) :=
  fun {σ : Type} {α : Type} [inst._@.Init.System.ST.1035734954._hygCtx._hyg.4 : Inhabited.{1} α] => Inhabited.mk.{1} (ST σ α) (fun (s : Void σ) => ST.Out.mk σ α (Inhabited.default.{1} α inst._@.Init.System.ST.1035734954._hygCtx._hyg.4) s)

import Split.LawfulFunctor
import Split.Functor
import Split.Function_comp
import Split.id
import Split.Functor_mapConst
import Split.Function_const
import Split.Eq
import Split.Functor_map

-- LawfulFunctor.mk from environment
-- constructor LawfulFunctor.mk : forall {f : Type.{u} -> Type.{v}} [inst._@.Init.Control.Lawful.Basic.3059025466._hygCtx._hyg.5 : Functor.{u, v} f], (forall {α : Type.{u}} {β : Type.{u}}, Eq.{max (succ u) (succ v)} (α -> (f β) -> (f α)) (Functor.mapConst.{u, v} f inst._@.Init.Control.Lawful.Basic.3059025466._hygCtx._hyg.5 α β) (Function.comp.{succ u, succ u, succ v} α (β -> α) ((f β) -> (f α)) (Functor.map.{u, v} f inst._@.Init.Control.Lawful.Basic.3059025466._hygCtx._hyg.5 β α) (Function.const.{succ u, succ u} α β))) -> (forall {α : Type.{u}} (x : f α), Eq.{succ v} (f α) (Functor.map.{u, v} f inst._@.Init.Control.Lawful.Basic.3059025466._hygCtx._hyg.5 α α (id.{succ u} α) x) x) -> (forall {α : Type.{u}} {β : Type.{u}} {γ : Type.{u}} (g : α -> β) (h : β -> γ) (x : f α), Eq.{succ v} (f γ) (Functor.map.{u, v} f inst._@.Init.Control.Lawful.Basic.3059025466._hygCtx._hyg.5 α γ (Function.comp.{succ u, succ u, succ u} α β γ h g) x) (Functor.map.{u, v} f inst._@.Init.Control.Lawful.Basic.3059025466._hygCtx._hyg.5 β γ h (Functor.map.{u, v} f inst._@.Init.Control.Lawful.Basic.3059025466._hygCtx._hyg.5 α β g x))) -> (LawfulFunctor.{u, v} f inst._@.Init.Control.Lawful.Basic.3059025466._hygCtx._hyg.5)

-- Stub: this file represents the declaration `LawfulFunctor.mk`.
-- In a full split, the body would be extracted from the environment.

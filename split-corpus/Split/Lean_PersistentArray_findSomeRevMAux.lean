import Mathlib

-- spec: opaque Lean.PersistentArray.findSomeRevMAux : forall {α : Type.{u}} {m : Type.{v} -> Type.{w}} [inst._@.Lean.Data.PersistentArray.3545740837._hygCtx._hyg.6 : Monad.{v, w} m] {β : Type.{v}}, (α -> (m (Option.{v} β))) -> (Lean.PersistentArrayNode.{u} α) -> (m (Option.{v} β))
opaque Lean.PersistentArray.findSomeRevMAux : forall {α : Type.{u}} {m : Type.{v} -> Type.{w}} [inst._@.Lean.Data.PersistentArray.3545740837._hygCtx._hyg.6 : Monad.{v, w} m] {β : Type.{v}}, (α -> (m (Option.{v} β))) -> (Lean.PersistentArrayNode.{u} α) -> (m (Option.{v} β)) :=
  fun {α : Type.{u}} {m : Type.{v} -> Type.{w}} [inst._@.Lean.Data.PersistentArray.3545740837._hygCtx._hyg.6 : Monad.{v, w} m] {β : Type.{v}} (f : α -> (m (Option.{v} β))) (a._@._internal._hyg.0 : Lean.PersistentArrayNode.{u} α) => Inhabited.default.{succ w} (m (Option.{v} β)) (instInhabitedOfMonad.{v, w} (Option.{v} β) m inst._@.Lean.Data.PersistentArray.3545740837._hygCtx._hyg.6 (instInhabitedOption.{v} β))

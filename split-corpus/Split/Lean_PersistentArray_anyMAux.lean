import Mathlib

-- spec: opaque Lean.PersistentArray.anyMAux : forall {α : Type.{u}} {m : Type -> Type.{w}} [inst._@.Lean.Data.PersistentArray.1367341782._hygCtx._hyg.6 : Monad.{0, w} m], (α -> (m Bool)) -> (Lean.PersistentArrayNode.{u} α) -> (m Bool)
opaque Lean.PersistentArray.anyMAux : forall {α : Type.{u}} {m : Type -> Type.{w}} [inst._@.Lean.Data.PersistentArray.1367341782._hygCtx._hyg.6 : Monad.{0, w} m], (α -> (m Bool)) -> (Lean.PersistentArrayNode.{u} α) -> (m Bool) :=
  fun {α : Type.{u}} {m : Type -> Type.{w}} [inst._@.Lean.Data.PersistentArray.1367341782._hygCtx._hyg.6 : Monad.{0, w} m] (p : α -> (m Bool)) (a._@._internal._hyg.0 : Lean.PersistentArrayNode.{u} α) => Inhabited.default.{succ w} (m Bool) (instInhabitedOfMonad.{0, w} Bool m inst._@.Lean.Data.PersistentArray.1367341782._hygCtx._hyg.6 instInhabitedBool)

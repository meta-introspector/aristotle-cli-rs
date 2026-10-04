import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.anyM : forall {α : Type.{u}} {m : Type -> Type.{w}} [inst._@.Lean.Data.PersistentArray.3460736927._hygCtx._hyg.6 : Monad.{0, w} m], (Lean.PersistentArray.{u} α) -> (α -> (m Bool)) -> (m Bool)
def Lean.PersistentArray.anyM : forall {α : Type.{u}} {m : Type -> Type.{w}} [inst._@.Lean.Data.PersistentArray.3460736927._hygCtx._hyg.6 : Monad.{0, w} m], (Lean.PersistentArray.{u} α) -> (α -> (m Bool)) -> (m Bool) :=
  fun {α : Type.{u}} {m : Type -> Type.{w}} [inst._@.Lean.Data.PersistentArray.3460736927._hygCtx._hyg.6 : Monad.{0, w} m] (t : Lean.PersistentArray.{u} α) (p : α -> (m Bool)) => orM.{0, w} m Bool inst._@.Lean.Data.PersistentArray.3460736927._hygCtx._hyg.6 instToBoolBool (Lean.PersistentArray.anyMAux.{u, w} α m inst._@.Lean.Data.PersistentArray.3460736927._hygCtx._hyg.6 p (Lean.PersistentArray.root.{u} α t)) (Array.anyM.{u, w} α m inst._@.Lean.Data.PersistentArray.3460736927._hygCtx._hyg.6 p (Lean.PersistentArray.tail.{u} α t) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{u} α (Lean.PersistentArray.tail.{u} α t)))

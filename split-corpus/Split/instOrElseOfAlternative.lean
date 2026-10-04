import Mathlib

set_option pp.all true
-- spec: instOrElseOfAlternative : forall (f : Type.{u} -> Type.{v}) (α : Type.{u}) [inst._@.Init.Control.Basic.2596980911._hygCtx._hyg.6 : Alternative.{u, v} f], OrElse.{v} (f α)
def instOrElseOfAlternative : forall (f : Type.{u} -> Type.{v}) (α : Type.{u}) [inst._@.Init.Control.Basic.2596980911._hygCtx._hyg.6 : Alternative.{u, v} f], OrElse.{v} (f α) :=
  fun (f : Type.{u} -> Type.{v}) (α : Type.{u}) [inst._@.Init.Control.Basic.2596980911._hygCtx._hyg.6 : Alternative.{u, v} f] => OrElse.mk.{v} (f α) (Alternative.orElse.{u, v} f inst._@.Init.Control.Basic.2596980911._hygCtx._hyg.6 α)

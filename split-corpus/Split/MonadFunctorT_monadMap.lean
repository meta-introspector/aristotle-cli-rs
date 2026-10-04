import Mathlib

set_option pp.all true
-- spec: MonadFunctorT.monadMap : forall {m : Type.{u} -> Type.{v}} {n : Type.{u} -> Type.{w}} [self : MonadFunctorT.{u, v, w} m n] {α : Type.{u}}, (forall {β : Type.{u}}, (m β) -> (m β)) -> (n α) -> (n α)
def MonadFunctorT.monadMap : forall {m : Type.{u} -> Type.{v}} {n : Type.{u} -> Type.{w}} [self : MonadFunctorT.{u, v, w} m n] {α : Type.{u}}, (forall {β : Type.{u}}, (m β) -> (m β)) -> (n α) -> (n α) :=
  fun (m : Type.{u} -> Type.{v}) (n : Type.{u} -> Type.{w}) [self : MonadFunctorT.{u, v, w} m n] => self.1

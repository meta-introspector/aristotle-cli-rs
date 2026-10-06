import Mathlib

set_option pp.all true
-- spec: MonadControlT.restoreM : forall {m : Type.{u} -> Type.{v}} {n : Type.{u} -> Type.{w}} [self : MonadControlT.{u, v, w} m n] {α : Type.{u}}, (MonadControlT.stM.{u, v, w} m n self α) -> (n α)
def MonadControlT.restoreM : forall {m : Type.{u} -> Type.{v}} {n : Type.{u} -> Type.{w}} [self : MonadControlT.{u, v, w} m n] {α : Type.{u}}, (MonadControlT.stM.{u, v, w} m n self α) -> (n α) :=
  fun (m : Type.{u} -> Type.{v}) (n : Type.{u} -> Type.{w}) [self : MonadControlT.{u, v, w} m n] => self.3

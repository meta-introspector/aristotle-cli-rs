import Mathlib

set_option pp.all true
-- spec: MonadControlT.liftWith : forall {m : Type.{u} -> Type.{v}} {n : Type.{u} -> Type.{w}} [self : MonadControlT.{u, v, w} m n] {α : Type.{u}}, ((forall {β : Type.{u}}, (n β) -> (m (MonadControlT.stM.{u, v, w} m n self β))) -> (m α)) -> (n α)
def MonadControlT.liftWith : forall {m : Type.{u} -> Type.{v}} {n : Type.{u} -> Type.{w}} [self : MonadControlT.{u, v, w} m n] {α : Type.{u}}, ((forall {β : Type.{u}}, (n β) -> (m (MonadControlT.stM.{u, v, w} m n self β))) -> (m α)) -> (n α) :=
  fun (m : Type.{u} -> Type.{v}) (n : Type.{u} -> Type.{w}) [self : MonadControlT.{u, v, w} m n] => self.2

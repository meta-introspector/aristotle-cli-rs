import Mathlib

set_option pp.all true
-- spec: MonadLiftT.monadLift : forall {m : Type.{u} -> Type.{v}} {n : Type.{u} -> Type.{w}} [self : MonadLiftT.{u, v, w} m n] {α : Type.{u}}, (m α) -> (n α)
def MonadLiftT.monadLift : forall {m : Type.{u} -> Type.{v}} {n : Type.{u} -> Type.{w}} [self : MonadLiftT.{u, v, w} m n] {α : Type.{u}}, (m α) -> (n α) :=
  fun (m : Type.{u} -> Type.{v}) (n : Type.{u} -> Type.{w}) [self : MonadLiftT.{u, v, w} m n] => self.1

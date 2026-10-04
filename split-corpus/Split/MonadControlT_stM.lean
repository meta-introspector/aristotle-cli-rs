import Mathlib

set_option pp.all true
-- spec: MonadControlT.stM : forall (m : Type.{u} -> Type.{v}) (n : Type.{u} -> Type.{w}) [self : MonadControlT.{u, v, w} m n], Type.{u} -> Type.{u}
def MonadControlT.stM : forall (m : Type.{u} -> Type.{v}) (n : Type.{u} -> Type.{w}) [self : MonadControlT.{u, v, w} m n], Type.{u} -> Type.{u} :=
  fun (m : Type.{u} -> Type.{v}) (n : Type.{u} -> Type.{w}) [self : MonadControlT.{u, v, w} m n] => self.1

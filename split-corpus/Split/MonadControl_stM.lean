import Mathlib

set_option pp.all true
-- spec: MonadControl.stM : forall (m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})) (n : Type.{u} -> Type.{w}) [self : MonadControl.{u, v, w} m n], Type.{u} -> Type.{u}
def MonadControl.stM : forall (m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})) (n : Type.{u} -> Type.{w}) [self : MonadControl.{u, v, w} m n], Type.{u} -> Type.{u} :=
  fun (m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})) (n : Type.{u} -> Type.{w}) [self : MonadControl.{u, v, w} m n] => self.1

import Mathlib

set_option pp.all true
-- spec: MonadControl.restoreM : forall {m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})} {n : Type.{u} -> Type.{w}} [self : MonadControl.{u, v, w} m n] {α : Type.{u}}, (m (MonadControl.stM.{u, v, w} m n self α)) -> (n α)
def MonadControl.restoreM : forall {m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})} {n : Type.{u} -> Type.{w}} [self : MonadControl.{u, v, w} m n] {α : Type.{u}}, (m (MonadControl.stM.{u, v, w} m n self α)) -> (n α) :=
  fun (m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})) (n : Type.{u} -> Type.{w}) [self : MonadControl.{u, v, w} m n] => self.3

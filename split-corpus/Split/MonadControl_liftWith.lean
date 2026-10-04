import Mathlib

set_option pp.all true
-- spec: MonadControl.liftWith : forall {m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})} {n : Type.{u} -> Type.{w}} [self : MonadControl.{u, v, w} m n] {α : Type.{u}}, ((forall {β : Type.{u}}, (n β) -> (m (MonadControl.stM.{u, v, w} m n self β))) -> (m α)) -> (n α)
def MonadControl.liftWith : forall {m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})} {n : Type.{u} -> Type.{w}} [self : MonadControl.{u, v, w} m n] {α : Type.{u}}, ((forall {β : Type.{u}}, (n β) -> (m (MonadControl.stM.{u, v, w} m n self β))) -> (m α)) -> (n α) :=
  fun (m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})) (n : Type.{u} -> Type.{w}) [self : MonadControl.{u, v, w} m n] => self.2

import Mathlib

set_option pp.all true
-- spec: MonadLift.monadLift : forall {m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})} {n : Type.{u} -> Type.{w}} [self : MonadLift.{u, v, w} m n] {α : Type.{u}}, (m α) -> (n α)
def MonadLift.monadLift : forall {m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})} {n : Type.{u} -> Type.{w}} [self : MonadLift.{u, v, w} m n] {α : Type.{u}}, (m α) -> (n α) :=
  fun (m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})) (n : Type.{u} -> Type.{w}) [self : MonadLift.{u, v, w} m n] => self.1

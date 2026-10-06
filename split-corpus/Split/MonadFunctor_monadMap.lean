import Mathlib

set_option pp.all true
-- spec: MonadFunctor.monadMap : forall {m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})} {n : Type.{u} -> Type.{w}} [self : MonadFunctor.{u, v, w} m n] {α : Type.{u}}, (forall {β : Type.{u}}, (m β) -> (m β)) -> (n α) -> (n α)
def MonadFunctor.monadMap : forall {m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})} {n : Type.{u} -> Type.{w}} [self : MonadFunctor.{u, v, w} m n] {α : Type.{u}}, (forall {β : Type.{u}}, (m β) -> (m β)) -> (n α) -> (n α) :=
  fun (m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})) (n : Type.{u} -> Type.{w}) [self : MonadFunctor.{u, v, w} m n] => self.1

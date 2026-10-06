import Mathlib

set_option pp.all true
-- spec: liftM : forall {m : Type.{u_1} -> Type.{u_2}} {n : Type.{u_1} -> Type.{u_3}} [self : MonadLiftT.{u_1, u_2, u_3} m n] {α : Type.{u_1}}, (m α) -> (n α)
def liftM : forall {m : Type.{u_1} -> Type.{u_2}} {n : Type.{u_1} -> Type.{u_3}} [self : MonadLiftT.{u_1, u_2, u_3} m n] {α : Type.{u_1}}, (m α) -> (n α) :=
  MonadLiftT.monadLift.{u_1, u_2, u_3}

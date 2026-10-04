import Mathlib

set_option pp.all true
-- spec: MonadFinally.tryFinally' : forall {m : Type.{u} -> Type.{v}} [self : MonadFinally.{u, v} m] {α : Type.{u}} {β : Type.{u}}, (m α) -> ((Option.{u} α) -> (m β)) -> (m (Prod.{u, u} α β))
def MonadFinally.tryFinally' : forall {m : Type.{u} -> Type.{v}} [self : MonadFinally.{u, v} m] {α : Type.{u}} {β : Type.{u}}, (m α) -> ((Option.{u} α) -> (m β)) -> (m (Prod.{u, u} α β)) :=
  fun (m : Type.{u} -> Type.{v}) [self : MonadFinally.{u, v} m] => self.1

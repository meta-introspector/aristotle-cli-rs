import Split.MonadFinally
import Split.Prod
import Split.Option

-- MonadFinally.tryFinally' from environment
-- def MonadFinally.tryFinally' : forall {m : Type.{u} -> Type.{v}} [self : MonadFinally.{u, v} m] {α : Type.{u}} {β : Type.{u}}, (m α) -> ((Option.{u} α) -> (m β)) -> (m (Prod.{u, u} α β))
-- (definition body omitted)

-- Stub: this file represents the declaration `MonadFinally.tryFinally'`.
-- In a full split, the body would be extracted from the environment.

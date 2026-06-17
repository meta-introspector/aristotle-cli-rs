import Split.outParam
import Split.MonadState
import Split.PUnit
import Split.Prod

-- MonadState.mk from environment
-- constructor MonadState.mk : forall {σ : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}}, (m σ) -> (σ -> (m PUnit.{succ u})) -> (forall {α : Type.{u}}, (σ -> (Prod.{u, u} α σ)) -> (m α)) -> (MonadState.{u, v} σ m)

-- Stub: this file represents the declaration `MonadState.mk`.
-- In a full split, the body would be extracted from the environment.

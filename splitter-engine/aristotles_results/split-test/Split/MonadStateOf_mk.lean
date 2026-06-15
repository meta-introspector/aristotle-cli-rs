import Split.MonadStateOf
import Split.semiOutParam
import Split.PUnit
import Split.Prod

-- MonadStateOf.mk from environment
-- constructor MonadStateOf.mk : forall {σ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}}, (m σ) -> (σ -> (m PUnit.{succ u})) -> (forall {α : Type.{u}}, (σ -> (Prod.{u, u} α σ)) -> (m α)) -> (MonadStateOf.{u, v} σ m)

-- Stub: this file represents the declaration `MonadStateOf.mk`.
-- In a full split, the body would be extracted from the environment.

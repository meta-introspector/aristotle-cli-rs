import Split.semiOutParam
import Split.MonadExceptOf

-- MonadExceptOf.mk from environment
-- constructor MonadExceptOf.mk : forall {ε : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{v} -> Type.{w}}, (forall {α : Type.{v}}, ε -> (m α)) -> (forall {α : Type.{v}}, (m α) -> (ε -> (m α)) -> (m α)) -> (MonadExceptOf.{u, v, w} ε m)

-- Stub: this file represents the declaration `MonadExceptOf.mk`.
-- In a full split, the body would be extracted from the environment.

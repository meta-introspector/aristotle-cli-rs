import Split.semiOutParam
import Split.MonadExceptOf

-- MonadExceptOf.tryCatch from environment
-- def MonadExceptOf.tryCatch : forall {ε : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{v} -> Type.{w}} [self : MonadExceptOf.{u, v, w} ε m] {α : Type.{v}}, (m α) -> (ε -> (m α)) -> (m α)
-- (definition body omitted)

-- Stub: this file represents the declaration `MonadExceptOf.tryCatch`.
-- In a full split, the body would be extracted from the environment.

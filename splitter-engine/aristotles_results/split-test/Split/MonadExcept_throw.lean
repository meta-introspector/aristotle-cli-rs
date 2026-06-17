import Split.outParam
import Split.MonadExcept

-- MonadExcept.throw from environment
-- def MonadExcept.throw : forall {ε : outParam.{succ (succ u)} Type.{u}} {m : Type.{v} -> Type.{w}} [self : MonadExcept.{u, v, w} ε m] {α : Type.{v}}, ε -> (m α)
-- (definition body omitted)

-- Stub: this file represents the declaration `MonadExcept.throw`.
-- In a full split, the body would be extracted from the environment.

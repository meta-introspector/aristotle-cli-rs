import Split.GetElem
import Split.outParam

-- GetElem.getElem from environment
-- def GetElem.getElem : forall {coll : Type.{u}} {idx : Type.{v}} {elem : outParam.{succ (succ w)} Type.{w}} {valid : outParam.{max (succ u) (succ v)} (coll -> idx -> Prop)} [self : GetElem.{u, v, w} coll idx elem valid] (xs : coll) (i : idx), (valid xs i) -> elem
-- (definition body omitted)

-- Stub: this file represents the declaration `GetElem.getElem`.
-- In a full split, the body would be extracted from the environment.

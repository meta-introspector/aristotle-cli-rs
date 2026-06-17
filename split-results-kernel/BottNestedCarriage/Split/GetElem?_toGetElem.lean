import Split.GetElem
import Split.GetElem?
import Split.outParam

-- GetElem?.toGetElem from environment
-- def GetElem?.toGetElem : forall {coll : Type.{u}} {idx : Type.{v}} {elem : outParam.{succ (succ w)} Type.{w}} {valid : outParam.{max (succ u) (succ v)} (coll -> idx -> Prop)} [self : GetElem?.{u, v, w} coll idx elem valid], GetElem.{u, v, w} coll idx elem valid
-- (definition body omitted)

-- Stub: this file represents the declaration `GetElem?.toGetElem`.
-- In a full split, the body would be extracted from the environment.

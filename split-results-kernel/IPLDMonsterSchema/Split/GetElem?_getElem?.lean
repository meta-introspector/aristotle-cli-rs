import Split.GetElem?
import Split.outParam
import Split.Option

-- GetElem?.getElem? from environment
-- def GetElem?.getElem? : forall {coll : Type.{u}} {idx : Type.{v}} {elem : outParam.{succ (succ w)} Type.{w}} {valid : outParam.{max (succ u) (succ v)} (coll -> idx -> Prop)} [self : GetElem?.{u, v, w} coll idx elem valid], coll -> idx -> (Option.{w} elem)
-- (definition body omitted)

-- Stub: this file represents the declaration `GetElem?.getElem?`.
-- In a full split, the body would be extracted from the environment.

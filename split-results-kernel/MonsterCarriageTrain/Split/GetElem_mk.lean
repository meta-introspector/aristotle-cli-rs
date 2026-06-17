import Split.GetElem
import Split.outParam

-- GetElem.mk from environment
-- constructor GetElem.mk : forall {coll : Type.{u}} {idx : Type.{v}} {elem : outParam.{succ (succ w)} Type.{w}} {valid : outParam.{max (succ u) (succ v)} (coll -> idx -> Prop)}, (forall (xs : coll) (i : idx), (valid xs i) -> elem) -> (GetElem.{u, v, w} coll idx elem valid)

-- Stub: this file represents the declaration `GetElem.mk`.
-- In a full split, the body would be extracted from the environment.

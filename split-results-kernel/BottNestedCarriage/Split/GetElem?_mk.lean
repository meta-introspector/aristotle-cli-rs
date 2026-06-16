import Split.GetElem
import Split.GetElem?
import Split.outParam
import Split.Inhabited
import Split.Option

-- GetElem?.mk from environment
-- constructor GetElem?.mk : forall {coll : Type.{u}} {idx : Type.{v}} {elem : outParam.{succ (succ w)} Type.{w}} {valid : outParam.{max (succ u) (succ v)} (coll -> idx -> Prop)} [toGetElem : GetElem.{u, v, w} coll idx elem valid], (coll -> idx -> (Option.{w} elem)) -> (forall [inst._@.Init.GetElem.365082188._hygCtx._hyg.28 : Inhabited.{succ w} elem], coll -> idx -> elem) -> (GetElem?.{u, v, w} coll idx elem valid)

-- Stub: this file represents the declaration `GetElem?.mk`.
-- In a full split, the body would be extracted from the environment.

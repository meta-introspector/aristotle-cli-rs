import Split.GetElem?
import Split.GetElem?_toGetElem
import Split.outParam
import Split.Decidable
import Split.Option_some
import Split.dite
import Split.GetElem_getElem
import Split.Option_none
import Split.GetElem?_getElem?
import Split.Eq
import Split.Not
import Split.Option
import Split.LawfulGetElem

-- LawfulGetElem.getElem?_def from environment
-- theorem LawfulGetElem.getElem?_def : forall {cont : Type.{u}} {idx : Type.{v}} {elem : outParam.{succ (succ w)} Type.{w}} {dom : outParam.{max (succ u) (succ v)} (cont -> idx -> Prop)} {ge : GetElem?.{u, v, w} cont idx elem dom} [self : LawfulGetElem.{u, v, w} cont idx elem dom ge] (c : cont) (i : idx) [inst._@.Init.GetElem.2227206122._hygCtx._hyg.24 : Decidable (dom c i)], Eq.{succ w} (Option.{w} elem) (GetElem?.getElem?.{u, v, w} cont idx elem dom ge c i) (dite.{succ w} (Option.{w} elem) (dom c i) inst._@.Init.GetElem.2227206122._hygCtx._hyg.24 (fun (h : dom c i) => Option.some.{w} elem (GetElem.getElem.{u, v, w} cont idx elem dom (GetElem?.toGetElem.{u, v, w} cont idx elem dom ge) c i h)) (fun (h : Not (dom c i)) => Option.none.{w} elem))

-- Stub: this file represents the declaration `LawfulGetElem.getElem?_def`.
-- In a full split, the body would be extracted from the environment.

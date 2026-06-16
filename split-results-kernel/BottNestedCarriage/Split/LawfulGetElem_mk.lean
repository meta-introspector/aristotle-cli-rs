import Split.Inhabited_default
import Split.GetElem?
import Split.GetElem?_toGetElem
import Split.outParam
import Split.Decidable
import Split.Option_some
import Split.autoParam
import Split.dite
import Split.GetElem_getElem
import Split.Option_none
import Split.Unit
import Split.GetElem?_match_1
import Split.Inhabited
import Split.GetElem?_getElem?
import Split.Eq
import Split.GetElem?_getElem!
import Split.Not
import Split.Option
import Split.LawfulGetElem

-- LawfulGetElem.mk from environment
-- constructor LawfulGetElem.mk : forall {cont : Type.{u}} {idx : Type.{v}} {elem : outParam.{succ (succ w)} Type.{w}} {dom : outParam.{max (succ u) (succ v)} (cont -> idx -> Prop)} [ge : GetElem?.{u, v, w} cont idx elem dom], (autoParam.{0} (forall (c : cont) (i : idx) [inst._@.Init.GetElem.2227206122._hygCtx._hyg.24 : Decidable (dom c i)], Eq.{succ w} (Option.{w} elem) (GetElem?.getElem?.{u, v, w} cont idx elem dom ge c i) (dite.{succ w} (Option.{w} elem) (dom c i) inst._@.Init.GetElem.2227206122._hygCtx._hyg.24 (fun (h : dom c i) => Option.some.{w} elem (GetElem.getElem.{u, v, w} cont idx elem dom (GetElem?.toGetElem.{u, v, w} cont idx elem dom ge) c i h)) (fun (h : Not (dom c i)) => Option.none.{w} elem))) LawfulGetElem.getElem?_def._autoParam) -> (autoParam.{0} (forall [inst._@.Init.GetElem.2227206122._hygCtx._hyg.67 : Inhabited.{succ w} elem] (c : cont) (i : idx), Eq.{succ w} elem (GetElem?.getElem!.{u, v, w} cont idx elem dom ge inst._@.Init.GetElem.2227206122._hygCtx._hyg.67 c i) ([mdata save_info:1 GetElem?.match_1.{w, succ w} elem (fun (x._@.Init.GetElem.2227206122._hygCtx._hyg.92 : Option.{w} elem) => elem) (GetElem?.getElem?.{u, v, w} cont idx elem dom ge c i) (fun (e : elem) => e) (fun (_ : Unit) => Inhabited.default.{succ w} elem inst._@.Init.GetElem.2227206122._hygCtx._hyg.67)])) LawfulGetElem.getElem!_def._autoParam) -> (LawfulGetElem.{u, v, w} cont idx elem dom ge)

-- Stub: this file represents the declaration `LawfulGetElem.mk`.
-- In a full split, the body would be extracted from the environment.

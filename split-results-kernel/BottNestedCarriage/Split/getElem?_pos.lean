import Split.Decidable_isTrue
import Split.Eq_mpr
import Split.GetElem?
import Split.GetElem?_toGetElem
import Split.congrArg
import Split.Decidable
import Split.Option_some
import Split.dif_pos
import Split.id
import Split.dite
import Split.GetElem_getElem
import Split.Option_none
import Split.LawfulGetElem_getElem?_def
import Split.GetElem?_getElem?
import Split.Eq
import Split.Not
import Split.Option
import Split.LawfulGetElem

-- getElem?_pos from environment
-- theorem getElem?_pos : forall {cont : Type.{u_1}} {idx : Type.{u_2}} {elem : Type.{u_3}} {dom : cont -> idx -> Prop} [inst._@.Init.GetElem.3643885190._hygCtx._hyg.20 : GetElem?.{u_1, u_2, u_3} cont idx elem dom] [inst._@.Init.GetElem.3643885190._hygCtx._hyg.26 : LawfulGetElem.{u_1, u_2, u_3} cont idx elem dom inst._@.Init.GetElem.3643885190._hygCtx._hyg.20] (c : cont) (i : idx) (h : dom c i), Eq.{succ u_3} (Option.{u_3} elem) (GetElem?.getElem?.{u_1, u_2, u_3} cont idx elem dom inst._@.Init.GetElem.3643885190._hygCtx._hyg.20 c i) (Option.some.{u_3} elem (GetElem.getElem.{u_1, u_2, u_3} cont idx elem dom (GetElem?.toGetElem.{u_1, u_2, u_3} cont idx elem dom inst._@.Init.GetElem.3643885190._hygCtx._hyg.20) c i h))

-- Stub: this file represents the declaration `getElem?_pos`.
-- In a full split, the body would be extracted from the environment.

import Split.Eq_mpr
import Split.False
import Split.Decidable_casesOn
import Split.GetElem?
import Split.GetElem?_toGetElem
import Split.eq_false
import Split.congrArg
import Split.False_elim
import Split.Decidable
import Split.noConfusion_of_Nat
import Split.Option_some
import Split.Eq_mp
import Split.Option_get_congr_simp
import Split.dif_pos
import Split.id
import Split.dif_neg
import Split.dite
import Split.GetElem_getElem
import Split.Bool_ctorIdx
import Split.Bool_true
import Split.Option_none
import Split.Option_get
import Split.eq_self
import Split.Bool
import Split.of_eq_true
import Split.LawfulGetElem_getElem?_def
import Split.Eq_ndrec
import Split.congrFun'
import Split.GetElem?_getElem?
import Split.Option_isSome
import Split.dite_cond_eq_false
import Split.Bool_false
import Split.eq_false'
import Split.Eq
import Split.Not
import Split.Eq_trans
import Split.Option
import Split.LawfulGetElem

-- get_getElem? from environment
-- theorem get_getElem? : forall {cont : Type.{u_1}} {idx : Type.{u_2}} {elem : Type.{u_3}} {dom : cont -> idx -> Prop} [inst._@.Init.GetElem.1342855934._hygCtx._hyg.20 : GetElem?.{u_1, u_2, u_3} cont idx elem dom] [inst._@.Init.GetElem.1342855934._hygCtx._hyg.26 : LawfulGetElem.{u_1, u_2, u_3} cont idx elem dom inst._@.Init.GetElem.1342855934._hygCtx._hyg.20] (c : cont) (i : idx) [inst._@.Init.GetElem.1342855934._hygCtx._hyg.34 : Decidable (dom c i)] (h : Eq.{1} Bool (Option.isSome.{u_3} elem (GetElem?.getElem?.{u_1, u_2, u_3} cont idx elem dom inst._@.Init.GetElem.1342855934._hygCtx._hyg.20 c i)) Bool.true), Eq.{succ u_3} elem (Option.get.{u_3} elem (GetElem?.getElem?.{u_1, u_2, u_3} cont idx elem dom inst._@.Init.GetElem.1342855934._hygCtx._hyg.20 c i) h) (GetElem.getElem.{u_1, u_2, u_3} cont idx elem dom (GetElem?.toGetElem.{u_1, u_2, u_3} cont idx elem dom inst._@.Init.GetElem.1342855934._hygCtx._hyg.20) c i (get_getElem?._proof_1.{u_3, u_1, u_2} cont idx elem dom inst._@.Init.GetElem.1342855934._hygCtx._hyg.20 inst._@.Init.GetElem.1342855934._hygCtx._hyg.26 c i inst._@.Init.GetElem.1342855934._hygCtx._hyg.34 h))

-- Stub: this file represents the declaration `get_getElem?`.
-- In a full split, the body would be extracted from the environment.

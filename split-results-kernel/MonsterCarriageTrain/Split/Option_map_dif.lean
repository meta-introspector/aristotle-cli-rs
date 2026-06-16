import Split.Eq_mpr
import Split.Decidable_casesOn
import Split.congrArg
import Split.Decidable
import Split.Option_some
import Split.dif_pos
import Split.id
import Split.dif_neg
import Split.dite
import Split.Option_none
import Split.Option_map
import Split.congr
import Split.Eq_refl
import Split.Eq
import Split.Not
import Split.Option

-- Option.map_dif from environment
-- theorem Option.map_dif : forall {α : Type.{u_1}} {β : Type.{u_2}} {c : Prop} {f : α -> β} {x._@.Init.Data.Option.Lemmas.817606247._hygCtx._hyg.16 : Decidable c} {a : c -> α}, Eq.{succ u_2} (Option.{u_2} β) (Option.map.{u_1, u_2} α β f (dite.{succ u_1} (Option.{u_1} α) c x._@.Init.Data.Option.Lemmas.817606247._hygCtx._hyg.16 (fun (h : c) => Option.some.{u_1} α (a h)) (fun (h : Not c) => Option.none.{u_1} α))) (dite.{succ u_2} (Option.{u_2} β) c x._@.Init.Data.Option.Lemmas.817606247._hygCtx._hyg.16 (fun (h : c) => Option.some.{u_2} β (f (a h))) (fun (h : Not c) => Option.none.{u_2} β))

-- Stub: this file represents the declaration `Option.map_dif`.
-- In a full split, the body would be extracted from the environment.

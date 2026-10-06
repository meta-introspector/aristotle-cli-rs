import Mathlib

set_option pp.all true
-- spec: iteInduction : forall {α : Sort.{u_1}} {c : Prop} [inst : Decidable c] {motive : α -> Sort.{u_2}} {t : α} {e : α}, (c -> (motive t)) -> ((Not c) -> (motive e)) -> (motive (ite.{u_1} α c inst t e))
def iteInduction : forall {α : Sort.{u_1}} {c : Prop} [inst : Decidable c] {motive : α -> Sort.{u_2}} {t : α} {e : α}, (c -> (motive t)) -> ((Not c) -> (motive e)) -> (motive (ite.{u_1} α c inst t e)) :=
  fun {α : Sort.{u_1}} {c : Prop} [inst : Decidable c] {motive : α -> Sort.{u_2}} {t : α} {e : α} (hpos : c -> (motive t)) (hneg : (Not c) -> (motive e)) => Decidable.byCases.match_1.{u_2} c (fun (inst._@.Init.Core.1281892205._hygCtx._hyg.40 : Decidable c) => motive (ite.{u_1} α c inst._@.Init.Core.1281892205._hygCtx._hyg.40 t e)) inst (fun (h : c) => hpos h) (fun (h : Not c) => hneg h)

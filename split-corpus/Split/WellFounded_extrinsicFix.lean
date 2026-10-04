import Mathlib

set_option pp.all true
-- spec: WellFounded.extrinsicFix : forall {α : Sort.{u_1}} {C : α -> Sort.{u_2}} [inst._@.Init.WFExtrinsicFix.1430884489._hygCtx._hyg.31 : forall (a : α), Nonempty.{u_2} (C a)] (R : α -> α -> Prop), (forall (a : α), (forall (a' : α), (R a' a) -> (C a')) -> (C a)) -> (forall (a : α), C a)
def WellFounded.extrinsicFix : forall {α : Sort.{u_1}} {C : α -> Sort.{u_2}} [inst._@.Init.WFExtrinsicFix.1430884489._hygCtx._hyg.31 : forall (a : α), Nonempty.{u_2} (C a)] (R : α -> α -> Prop), (forall (a : α), (forall (a' : α), (R a' a) -> (C a')) -> (C a)) -> (forall (a : α), C a) :=
  fun {α : Sort.{u_1}} {C : α -> Sort.{u_2}} [inst._@.Init.WFExtrinsicFix.1430884489._hygCtx._hyg.31 : forall (a : α), Nonempty.{u_2} (C a)] (R : α -> α -> Prop) (F : forall (a : α), (forall (a' : α), (R a' a) -> (C a')) -> (C a)) (a : α) => dite.{u_2} (C a) (WellFounded.{u_1} α R) (Classical.propDecidable (WellFounded.{u_1} α R)) (fun (h : WellFounded.{u_1} α R) => WellFounded.fix.{u_1, u_2} α C R h F a) (fun (h : Not (WellFounded.{u_1} α R)) => _private.Init.WFExtrinsicFix.0.WellFounded.opaqueFix.{u_1, u_2} α C inst._@.Init.WFExtrinsicFix.1430884489._hygCtx._hyg.31 R F a)

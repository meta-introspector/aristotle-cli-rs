import Mathlib

-- spec: theorem WellFounded.apply : forall {α : Sort.{u}} {r : α -> α -> Prop}, (WellFounded.{u} α r) -> (forall (a : α), Acc.{u} α r a)
theorem WellFounded.apply : forall {α : Sort.{u}} {r : α -> α -> Prop}, (WellFounded.{u} α r) -> (forall (a : α), Acc.{u} α r a) :=
  fun {α : Sort.{u}} {r : α -> α -> Prop} (wf : WellFounded.{u} α r) (a : α) => WellFounded.rec.{0, u} α r (fun (x._@.Init.WF.2049973126._hygCtx._hyg.17 : WellFounded.{u} α r) => forall (x._@.Init.WF.2049973126._hygCtx._hyg.16 : α), Acc.{u} α r x._@.Init.WF.2049973126._hygCtx._hyg.16) (fun (p : forall (a : α), Acc.{u} α r a) => p) wf a

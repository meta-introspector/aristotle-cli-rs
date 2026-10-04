import Mathlib

-- spec: theorem Subrelation.accessible : forall {α : Sort.{u}} {r : α -> α -> Prop} {q : α -> α -> Prop} {a : α}, (Subrelation.{u} α q r) -> (Acc.{u} α r a) -> (Acc.{u} α q a)
theorem Subrelation.accessible : forall {α : Sort.{u}} {r : α -> α -> Prop} {q : α -> α -> Prop} {a : α}, (Subrelation.{u} α q r) -> (Acc.{u} α r a) -> (Acc.{u} α q a) :=
  fun {α : Sort.{u}} {r : α -> α -> Prop} {q : α -> α -> Prop} {a : α} (h₁ : Subrelation.{u} α q r) (ac : Acc.{u} α r a) => Acc.rec.{0, u} α r (fun {a : α} (ac : Acc.{u} α r a) => Acc.{u} α q a) (fun (x : α) (h._@.Init.WF.2312124874._hygCtx._hyg.28 : forall (y : α), (r y x) -> (Acc.{u} α r y)) (ih : forall (y : α), (r y x) -> (Acc.{u} α q y)) => Acc.intro.{u} α q x (fun (y : α) (h : q y x) => ih y (h₁ y x h))) a ac

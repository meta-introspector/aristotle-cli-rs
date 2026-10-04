import Mathlib

set_option pp.all true
-- spec: noConfusionTypeEnum : forall {α : Sort.{u}} {β : Sort.{v}} [inst : DecidableEq.{v} β], (α -> β) -> Sort.{w} -> α -> α -> Sort.{w}
def noConfusionTypeEnum : forall {α : Sort.{u}} {β : Sort.{v}} [inst : DecidableEq.{v} β], (α -> β) -> Sort.{w} -> α -> α -> Sort.{w} :=
  fun {α : Sort.{u}} {β : Sort.{v}} [inst : DecidableEq.{v} β] (f : α -> β) (P : Sort.{w}) (x : α) (y : α) => Decidable.casesOn.{succ w} (Eq.{v} β (f x) (f y)) (fun (x._@.Init.Core.3169952898._hygCtx._hyg.29 : Decidable (Eq.{v} β (f x) (f y))) => Sort.{w}) (inst (f x) (f y)) (fun (x._@.Init.Core.3169952898._hygCtx._hyg.34 : Not (Eq.{v} β (f x) (f y))) => P) (fun (x._@.Init.Core.3169952898._hygCtx._hyg.41 : Eq.{v} β (f x) (f y)) => P -> P)

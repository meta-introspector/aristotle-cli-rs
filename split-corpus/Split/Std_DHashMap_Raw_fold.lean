import Mathlib

set_option pp.all true
-- spec: Std.DHashMap.Raw.fold : forall {α : Type.{u}} {β : α -> Type.{v}} {δ : Type.{w}}, (δ -> (forall (a : α), (β a) -> δ)) -> δ -> (Std.DHashMap.Raw.{u, v} α β) -> δ
def Std.DHashMap.Raw.fold : forall {α : Type.{u}} {β : α -> Type.{v}} {δ : Type.{w}}, (δ -> (forall (a : α), (β a) -> δ)) -> δ -> (Std.DHashMap.Raw.{u, v} α β) -> δ :=
  fun {α : Type.{u}} {β : α -> Type.{v}} {δ : Type.{w}} (f : δ -> (forall (a : α), (β a) -> δ)) (init : δ) (b : Std.DHashMap.Raw.{u, v} α β) => Id.run.{w} δ (Std.DHashMap.Raw.foldM.{u, v, w, w} α β δ Id.{w} Id.instMonad.{w} (fun (x1._@.Std.Data.DHashMap.RawDef.1543631599._hygCtx._hyg.29 : δ) (x2._@.Std.Data.DHashMap.RawDef.1543631599._hygCtx._hyg.29 : α) (x3._@.Std.Data.DHashMap.RawDef.1543631599._hygCtx._hyg.29 : β x2._@.Std.Data.DHashMap.RawDef.1543631599._hygCtx._hyg.29) => Pure.pure.{w, w} Id.{w} (Applicative.toPure.{w, w} Id.{w} (Monad.toApplicative.{w, w} Id.{w} Id.instMonad.{w})) δ (f x1._@.Std.Data.DHashMap.RawDef.1543631599._hygCtx._hyg.29 x2._@.Std.Data.DHashMap.RawDef.1543631599._hygCtx._hyg.29 x3._@.Std.Data.DHashMap.RawDef.1543631599._hygCtx._hyg.29)) init b)

import Mathlib

set_option pp.all true
-- spec: Std.PlausibleIterStep : forall {α : Type.{u}} {β : Type.{w}}, ((Std.IterStep.{succ u, succ w} α β) -> Prop) -> Sort.{max 1 (succ u) (succ w)}
def Std.PlausibleIterStep : forall {α : Type.{u}} {β : Type.{w}}, ((Std.IterStep.{succ u, succ w} α β) -> Prop) -> Sort.{max 1 (succ u) (succ w)} :=
  fun {α : Type.{u}} {β : Type.{w}} (IsPlausibleStep : (Std.IterStep.{succ u, succ w} α β) -> Prop) => Subtype.{max (succ u) (succ w)} (Std.IterStep.{succ u, succ w} α β) IsPlausibleStep

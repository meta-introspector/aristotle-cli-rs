import Mathlib

-- spec: constructor Std.Iterator.mk : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : outParam.{succ (succ w)} Type.{w}} (IsPlausibleStep : (Std.IterM.{w, w'} α m β) -> (Std.IterStep.{succ w, succ w} (Std.IterM.{w, w'} α m β) β) -> Prop), (forall (it : Std.IterM.{w, w'} α m β), m (Std.Shrink.{w} (Std.PlausibleIterStep.{w, w} (Std.IterM.{w, w'} α m β) β (IsPlausibleStep it)))) -> (Std.Iterator.{w, w'} α m β)

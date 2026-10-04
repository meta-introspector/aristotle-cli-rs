import Mathlib

set_option pp.all true
-- spec: Std.Iterator.IsPlausibleStep : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : outParam.{succ (succ w)} Type.{w}} [self : Std.Iterator.{w, w'} α m β], (Std.IterM.{w, w'} α m β) -> (Std.IterStep.{succ w, succ w} (Std.IterM.{w, w'} α m β) β) -> Prop
def Std.Iterator.IsPlausibleStep : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : outParam.{succ (succ w)} Type.{w}} [self : Std.Iterator.{w, w'} α m β], (Std.IterM.{w, w'} α m β) -> (Std.IterStep.{succ w, succ w} (Std.IterM.{w, w'} α m β) β) -> Prop :=
  fun (α : Type.{w}) (m : Type.{w} -> Type.{w'}) {β : outParam.{succ (succ w)} Type.{w}} [self : Std.Iterator.{w, w'} α m β] => self.1

import Mathlib

set_option pp.all true
-- spec: Std.Iterator.step : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : outParam.{succ (succ w)} Type.{w}} [self : Std.Iterator.{w, w'} α m β] (it : Std.IterM.{w, w'} α m β), m (Std.Shrink.{w} (Std.PlausibleIterStep.{w, w} (Std.IterM.{w, w'} α m β) β (Std.Iterator.IsPlausibleStep.{w, w'} α m β self it)))
def Std.Iterator.step : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : outParam.{succ (succ w)} Type.{w}} [self : Std.Iterator.{w, w'} α m β] (it : Std.IterM.{w, w'} α m β), m (Std.Shrink.{w} (Std.PlausibleIterStep.{w, w} (Std.IterM.{w, w'} α m β) β (Std.Iterator.IsPlausibleStep.{w, w'} α m β self it))) :=
  fun (α : Type.{w}) (m : Type.{w} -> Type.{w'}) {β : outParam.{succ (succ w)} Type.{w}} [self : Std.Iterator.{w, w'} α m β] => self.2

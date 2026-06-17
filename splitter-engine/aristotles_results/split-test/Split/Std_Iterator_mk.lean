import Split.Std_IterStep
import Split.outParam
import Split.Std_Shrink
import Split.Std_PlausibleIterStep
import Split.Std_Iterator
import Split.Std_IterM

-- Std.Iterator.mk from environment
-- constructor Std.Iterator.mk : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : outParam.{succ (succ w)} Type.{w}} (IsPlausibleStep : (Std.IterM.{w, w'} α m β) -> (Std.IterStep.{succ w, succ w} (Std.IterM.{w, w'} α m β) β) -> Prop), (forall (it : Std.IterM.{w, w'} α m β), m (Std.Shrink.{w} (Std.PlausibleIterStep.{w, w} (Std.IterM.{w, w'} α m β) β (IsPlausibleStep it)))) -> (Std.Iterator.{w, w'} α m β)

-- Stub: this file represents the declaration `Std.Iterator.mk`.
-- In a full split, the body would be extracted from the environment.

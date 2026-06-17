import Split.outParam
import Split.Std_Shrink
import Split.Std_PlausibleIterStep
import Split.Std_Iterator
import Split.Std_Iterator_IsPlausibleStep
import Split.Std_IterM

-- Std.Iterator.step from environment
-- def Std.Iterator.step : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : outParam.{succ (succ w)} Type.{w}} [self : Std.Iterator.{w, w'} α m β] (it : Std.IterM.{w, w'} α m β), m (Std.Shrink.{w} (Std.PlausibleIterStep.{w, w} (Std.IterM.{w, w'} α m β) β (Std.Iterator.IsPlausibleStep.{w, w'} α m β self it)))
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.Iterator.step`.
-- In a full split, the body would be extracted from the environment.

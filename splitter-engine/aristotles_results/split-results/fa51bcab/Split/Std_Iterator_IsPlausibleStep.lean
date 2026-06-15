import Split.Std_IterStep
import Split.outParam
import Split.Std_Iterator
import Split.Std_IterM

-- Std.Iterator.IsPlausibleStep from environment
-- def Std.Iterator.IsPlausibleStep : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : outParam.{succ (succ w)} Type.{w}} [self : Std.Iterator.{w, w'} α m β], (Std.IterM.{w, w'} α m β) -> (Std.IterStep.{succ w, succ w} (Std.IterM.{w, w'} α m β) β) -> Prop
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.Iterator.IsPlausibleStep`.
-- In a full split, the body would be extracted from the environment.

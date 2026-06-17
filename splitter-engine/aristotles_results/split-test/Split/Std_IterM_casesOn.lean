import Split.Std_IterM_mk
import Split.Std_IterM
import Split.Std_IterM_rec

-- Std.IterM.casesOn from environment
-- def Std.IterM.casesOn : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} {motive : (Std.IterM.{w, w'} α m β) -> Sort.{u}} (t : Std.IterM.{w, w'} α m β), (forall (internalState : α), motive (Std.IterM.mk.{w, w'} α m β internalState)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.IterM.casesOn`.
-- In a full split, the body would be extracted from the environment.

import Split.Std_IterM_mk
import Split.Std_IterM

-- Std.IterM.rec from environment
-- recursor Std.IterM.rec : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} {motive : (Std.IterM.{w, w'} α m β) -> Sort.{u}}, (forall (internalState : α), motive (Std.IterM.mk.{w, w'} α m β internalState)) -> (forall (t : Std.IterM.{w, w'} α m β), motive t)

-- Stub: this file represents the declaration `Std.IterM.rec`.
-- In a full split, the body would be extracted from the environment.

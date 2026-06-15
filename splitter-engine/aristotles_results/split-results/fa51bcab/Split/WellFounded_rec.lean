import Split.Acc
import Split.WellFounded_intro
import Split.WellFounded

-- WellFounded.rec from environment
-- recursor WellFounded.rec : forall {α : Sort.{u}} {r : α -> α -> Prop} {motive : (WellFounded.{u} α r) -> Sort.{u_1}}, (forall (h : forall (a : α), Acc.{u} α r a), motive (WellFounded.intro.{u} α r h)) -> (forall (t : WellFounded.{u} α r), motive t)

-- Stub: this file represents the declaration `WellFounded.rec`.
-- In a full split, the body would be extracted from the environment.

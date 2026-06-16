import Split.WellFounded_apply
import Split.WellFounded_fixF
import Split.WellFounded

-- WellFounded.fix from environment
-- def WellFounded.fix : forall {α : Sort.{u}} {C : α -> Sort.{v}} {r : α -> α -> Prop}, (WellFounded.{u} α r) -> (forall (x : α), (forall (y : α), (r y x) -> (C y)) -> (C x)) -> (forall (x : α), C x)
-- (definition body omitted)

-- Stub: this file represents the declaration `WellFounded.fix`.
-- In a full split, the body would be extracted from the environment.

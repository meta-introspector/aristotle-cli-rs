import Split.Quot_sound
import Split.congrArg
import Split.Quot_liftOn
import Split.id
import Split.Quot
import Split.Eq
import Split.Quot_mk

-- funext from environment
-- theorem funext : forall {α : Sort.{u}} {β : α -> Sort.{v}} {f : forall (x : α), β x} {g : forall (x : α), β x}, (forall (x : α), Eq.{v} (β x) (f x) (g x)) -> (Eq.{imax u v} (forall (x : α), β x) f g)

-- Stub: this file represents the declaration `funext`.
-- In a full split, the body would be extracted from the environment.

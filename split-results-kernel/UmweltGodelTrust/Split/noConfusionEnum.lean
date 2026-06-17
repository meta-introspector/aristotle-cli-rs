import Split.Decidable_casesOn
import Split.False_elim
import Split.Decidable
import Split.noConfusionTypeEnum
import Split.Decidable_isFalse
import Split.Eq
import Split.Not
import Split.DecidableEq

-- noConfusionEnum from environment
-- def noConfusionEnum : forall {α : Sort.{u}} {β : Sort.{v}} [inst : DecidableEq.{v} β] (f : α -> β) {P : Sort.{w}} {x : α} {y : α}, (Eq.{u} α x y) -> (noConfusionTypeEnum.{u, v, w} α β inst f P x y)
-- (definition body omitted)

-- Stub: this file represents the declaration `noConfusionEnum`.
-- In a full split, the body would be extracted from the environment.

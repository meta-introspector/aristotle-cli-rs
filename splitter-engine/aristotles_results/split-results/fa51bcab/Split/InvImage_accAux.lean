import Split.InvImage
import Split.Eq_rec
import Split.Acc
import Split.Acc_recOn
import Split.Eq
import Split.rfl
import Split.Acc_intro

-- InvImage.accAux from environment
-- theorem InvImage.accAux : forall {α : Sort.{u}} {β : Sort.{v}} {r : β -> β -> Prop} (f : α -> β) {b : β}, (Acc.{v} β r b) -> (forall (x : α), (Eq.{v} β (f x) b) -> (Acc.{u} α (InvImage.{u, v} α β r f) x))

-- Stub: this file represents the declaration `InvImage.accAux`.
-- In a full split, the body would be extracted from the environment.

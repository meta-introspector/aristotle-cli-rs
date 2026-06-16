import Split.Quotient_lift₂
import Split.Setoid
import Split.Quotient_mk
import Split.Quotient
import Split.HasEquiv_Equiv
import Split.instHasEquivOfSetoid

-- Quotient.map₂ from environment
-- def Quotient.map₂ : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {sa : Setoid.{u_1} α} {sb : Setoid.{u_2} β} {γ : Sort.{u_4}} {sc : Setoid.{u_4} γ} (f : α -> β -> γ), (forall {{a₁ : α}} {{a₂ : α}}, (HasEquiv.Equiv.{u_1, 0} α (instHasEquivOfSetoid.{u_1} α sa) a₁ a₂) -> (forall {{b₁ : β}} {{b₂ : β}}, (HasEquiv.Equiv.{u_2, 0} β (instHasEquivOfSetoid.{u_2} β sb) b₁ b₂) -> (HasEquiv.Equiv.{u_4, 0} γ (instHasEquivOfSetoid.{u_4} γ sc) (f a₁ b₁) (f a₂ b₂)))) -> (Quotient.{u_1} α sa) -> (Quotient.{u_2} β sb) -> (Quotient.{u_4} γ sc)
-- (definition body omitted)

-- Stub: this file represents the declaration `Quotient.map₂`.
-- In a full split, the body would be extracted from the environment.

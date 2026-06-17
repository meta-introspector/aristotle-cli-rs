import Split.Setoid
import Split.Quotient
import Split.HasEquiv_Equiv
import Split.instHasEquivOfSetoid
import Split.Quotient_lift
import Split.Eq

-- Quotient.lift₂ from environment
-- def Quotient.lift₂ : forall {α : Sort.{uA}} {β : Sort.{uB}} {φ : Sort.{uC}} {s₁ : Setoid.{uA} α} {s₂ : Setoid.{uB} β} (f : α -> β -> φ), (forall (a₁ : α) (b₁ : β) (a₂ : α) (b₂ : β), (HasEquiv.Equiv.{uA, 0} α (instHasEquivOfSetoid.{uA} α s₁) a₁ a₂) -> (HasEquiv.Equiv.{uB, 0} β (instHasEquivOfSetoid.{uB} β s₂) b₁ b₂) -> (Eq.{uC} φ (f a₁ b₁) (f a₂ b₂))) -> (Quotient.{uA} α s₁) -> (Quotient.{uB} β s₂) -> φ
-- (definition body omitted)

-- Stub: this file represents the declaration `Quotient.lift₂`.
-- In a full split, the body would be extracted from the environment.

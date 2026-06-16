import Split.Quotient_lift₂
import Split.Setoid
import Split.Quotient
import Split.HasEquiv_Equiv
import Split.instHasEquivOfSetoid
import Split.Eq

-- Quotient.liftOn₂ from environment
-- def Quotient.liftOn₂ : forall {α : Sort.{uA}} {β : Sort.{uB}} {φ : Sort.{uC}} {s₁ : Setoid.{uA} α} {s₂ : Setoid.{uB} β}, (Quotient.{uA} α s₁) -> (Quotient.{uB} β s₂) -> (forall (f : α -> β -> φ), (forall (a₁ : α) (b₁ : β) (a₂ : α) (b₂ : β), (HasEquiv.Equiv.{uA, 0} α (instHasEquivOfSetoid.{uA} α s₁) a₁ a₂) -> (HasEquiv.Equiv.{uB, 0} β (instHasEquivOfSetoid.{uB} β s₂) b₁ b₂) -> (Eq.{uC} φ (f a₁ b₁) (f a₂ b₂))) -> φ)
-- (definition body omitted)

-- Stub: this file represents the declaration `Quotient.liftOn₂`.
-- In a full split, the body would be extracted from the environment.

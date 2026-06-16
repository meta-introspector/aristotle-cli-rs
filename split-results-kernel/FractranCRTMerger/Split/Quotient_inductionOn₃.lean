import Split.Setoid
import Split.Quotient_ind
import Split.Quotient_mk
import Split.Quotient

-- Quotient.inductionOn₃ from environment
-- theorem Quotient.inductionOn₃ : forall {α : Sort.{uA}} {β : Sort.{uB}} {φ : Sort.{uC}} {s₁ : Setoid.{uA} α} {s₂ : Setoid.{uB} β} {s₃ : Setoid.{uC} φ} {motive : (Quotient.{uA} α s₁) -> (Quotient.{uB} β s₂) -> (Quotient.{uC} φ s₃) -> Prop} (q₁ : Quotient.{uA} α s₁) (q₂ : Quotient.{uB} β s₂) (q₃ : Quotient.{uC} φ s₃), (forall (a : α) (b : β) (c : φ), motive (Quotient.mk.{uA} α s₁ a) (Quotient.mk.{uB} β s₂ b) (Quotient.mk.{uC} φ s₃ c)) -> (motive q₁ q₂ q₃)

-- Stub: this file represents the declaration `Quotient.inductionOn₃`.
-- In a full split, the body would be extracted from the environment.

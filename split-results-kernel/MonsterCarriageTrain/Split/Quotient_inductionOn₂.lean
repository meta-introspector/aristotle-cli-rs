import Split.Setoid
import Split.Quotient_ind
import Split.Quotient_mk
import Split.Quotient

-- Quotient.inductionOn₂ from environment
-- theorem Quotient.inductionOn₂ : forall {α : Sort.{uA}} {β : Sort.{uB}} {s₁ : Setoid.{uA} α} {s₂ : Setoid.{uB} β} {motive : (Quotient.{uA} α s₁) -> (Quotient.{uB} β s₂) -> Prop} (q₁ : Quotient.{uA} α s₁) (q₂ : Quotient.{uB} β s₂), (forall (a : α) (b : β), motive (Quotient.mk.{uA} α s₁ a) (Quotient.mk.{uB} β s₂ b)) -> (motive q₁ q₂)

-- Stub: this file represents the declaration `Quotient.inductionOn₂`.
-- In a full split, the body would be extracted from the environment.

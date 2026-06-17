import Split.Eq_rec
import Split.PSigma_mk
import Split.Eq_ndrec
import Split.Eq_refl
import Split.PSigma
import Split.Eq
import Split.rfl

-- PSigma.eta from environment
-- theorem PSigma.eta : forall {α : Sort.{u}} {β : α -> Sort.{v}} {a₁ : α} {a₂ : α} {b₁ : β a₁} {b₂ : β a₂} (h₁ : Eq.{u} α a₁ a₂), (Eq.{v} (β a₂) (Eq.ndrec.{v, u} α a₁ β b₁ a₂ h₁) b₂) -> (Eq.{max (max 1 u) v} (PSigma.{u, v} α β) (PSigma.mk.{u, v} α β a₁ b₁) (PSigma.mk.{u, v} α β a₂ b₂))

-- Stub: this file represents the declaration `PSigma.eta`.
-- In a full split, the body would be extracted from the environment.

import Split.Decidable_isTrue
import Split.Decidable
import Split.dite
import Split.absurd
import Split.Decidable_isFalse
import Split.Eq
import Split.Not
import Split.rfl

-- dif_pos from environment
-- theorem dif_pos : forall {c : Prop} {h : Decidable c} (hc : c) {α : Sort.{u}} {t : c -> α} {e : (Not c) -> α}, Eq.{u} α (dite.{u} α c h t e) (t hc)

-- Stub: this file represents the declaration `dif_pos`.
-- In a full split, the body would be extracted from the environment.

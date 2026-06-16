import Split.Decidable_isTrue
import Split.Decidable
import Split.dite
import Split.absurd
import Split.Decidable_isFalse
import Split.Eq
import Split.Not
import Split.rfl

-- dif_neg from environment
-- theorem dif_neg : forall {c : Prop} {h : Decidable c} (hnc : Not c) {α : Sort.{u}} {t : c -> α} {e : (Not c) -> α}, Eq.{u} α (dite.{u} α c h t e) (e hnc)

-- Stub: this file represents the declaration `dif_neg`.
-- In a full split, the body would be extracted from the environment.

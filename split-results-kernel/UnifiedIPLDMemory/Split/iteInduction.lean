import Split.Decidable_byCases_match_1
import Split.Decidable
import Split.Not
import Split.ite

-- iteInduction from environment
-- def iteInduction : forall {α : Sort.{u_1}} {c : Prop} [inst : Decidable c] {motive : α -> Sort.{u_2}} {t : α} {e : α}, (c -> (motive t)) -> ((Not c) -> (motive e)) -> (motive (ite.{u_1} α c inst t e))
-- (definition body omitted)

-- Stub: this file represents the declaration `iteInduction`.
-- In a full split, the body would be extracted from the environment.

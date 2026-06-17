import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.List
import Split.Decidable_isFalse
import Split.List_Lex
import Split.Not

-- List.decidableLex.match_7 from environment
-- def List.decidableLex.match_7 : forall {α : Type.{u_1}} (r : α -> α -> Prop) (as : List.{u_1} α) (bs : List.{u_1} α) (motive : (Decidable (List.Lex.{u_1} α r as bs)) -> Sort.{u_2}) (x._@.Init.Data.List.Basic.1295814327._hygCtx._hyg.226 : Decidable (List.Lex.{u_1} α r as bs)), (forall (h₃ : List.Lex.{u_1} α r as bs), motive (Decidable.isTrue (List.Lex.{u_1} α r as bs) h₃)) -> (forall (h₃ : Not (List.Lex.{u_1} α r as bs)), motive (Decidable.isFalse (List.Lex.{u_1} α r as bs) h₃)) -> (motive x._@.Init.Data.List.Basic.1295814327._hygCtx._hyg.226)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.decidableLex.match_7`.
-- In a full split, the body would be extracted from the environment.

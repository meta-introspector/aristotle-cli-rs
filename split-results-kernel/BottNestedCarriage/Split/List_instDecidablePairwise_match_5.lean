import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.List_Pairwise
import Split.Decidable
import Split.List
import Split.Decidable_isFalse
import Split.Not

-- List.instDecidablePairwise.match_5 from environment
-- def List.instDecidablePairwise.match_5 : forall {α : Type.{u_1}} {R : α -> α -> Prop} (tl : List.{u_1} α) (motive : (Decidable (List.Pairwise.{u_1} α R tl)) -> Sort.{u_2}) (x._@.Init.Data.List.Basic.3979818597._hygCtx._hyg.58 : Decidable (List.Pairwise.{u_1} α R tl)), (forall (ht : List.Pairwise.{u_1} α R tl), motive (Decidable.isTrue (List.Pairwise.{u_1} α R tl) ht)) -> (forall (hf : Not (List.Pairwise.{u_1} α R tl)), motive (Decidable.isFalse (List.Pairwise.{u_1} α R tl) hf)) -> (motive x._@.Init.Data.List.Basic.3979818597._hygCtx._hyg.58)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.instDecidablePairwise.match_5`.
-- In a full split, the body would be extracted from the environment.

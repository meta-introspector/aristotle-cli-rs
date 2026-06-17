import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.Char_val
import Split.UInt32
import Split.Char
import Split.Decidable_isFalse
import Split.Eq
import Split.Not

-- instDecidableEqChar.match_1 from environment
-- def instDecidableEqChar.match_1 : forall (c : Char) (d : Char) (motive : (Decidable (Eq.{1} UInt32 (Char.val c) (Char.val d))) -> Sort.{u_1}) (x._@.Init.Prelude.2769770332._hygCtx._hyg.17 : Decidable (Eq.{1} UInt32 (Char.val c) (Char.val d))), (forall (h : Eq.{1} UInt32 (Char.val c) (Char.val d)), motive (Decidable.isTrue (Eq.{1} UInt32 (Char.val c) (Char.val d)) h)) -> (forall (h : Not (Eq.{1} UInt32 (Char.val c) (Char.val d))), motive (Decidable.isFalse (Eq.{1} UInt32 (Char.val c) (Char.val d)) h)) -> (motive x._@.Init.Prelude.2769770332._hygCtx._hyg.17)
-- (definition body omitted)

-- Stub: this file represents the declaration `instDecidableEqChar.match_1`.
-- In a full split, the body would be extracted from the environment.

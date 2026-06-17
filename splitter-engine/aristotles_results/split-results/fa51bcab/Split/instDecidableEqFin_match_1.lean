import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.Fin_val
import Split.Nat
import Split.Decidable_isFalse
import Split.Fin
import Split.Eq
import Split.Not

-- instDecidableEqFin.match_1 from environment
-- def instDecidableEqFin.match_1 : forall (n : Nat) (i : Fin n) (j : Fin n) (motive : (Decidable (Eq.{1} Nat (Fin.val n i) (Fin.val n j))) -> Sort.{u_1}) (x._@.Init.Prelude.3376441715._hygCtx._hyg.21 : Decidable (Eq.{1} Nat (Fin.val n i) (Fin.val n j))), (forall (h : Eq.{1} Nat (Fin.val n i) (Fin.val n j)), motive (Decidable.isTrue (Eq.{1} Nat (Fin.val n i) (Fin.val n j)) h)) -> (forall (h : Not (Eq.{1} Nat (Fin.val n i) (Fin.val n j))), motive (Decidable.isFalse (Eq.{1} Nat (Fin.val n i) (Fin.val n j)) h)) -> (motive x._@.Init.Prelude.3376441715._hygCtx._hyg.21)
-- (definition body omitted)

-- Stub: this file represents the declaration `instDecidableEqFin.match_1`.
-- In a full split, the body would be extracted from the environment.

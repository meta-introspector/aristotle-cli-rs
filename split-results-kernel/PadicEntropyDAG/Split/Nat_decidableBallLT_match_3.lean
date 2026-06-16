import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.Nat_lt_succ_of_lt
import Split.instLTNat
import Split.Decidable_isFalse
import Split.OfNat_ofNat
import Split.Not

-- Nat.decidableBallLT.match_3 from environment
-- def Nat.decidableBallLT.match_3 : forall (n : Nat) (P : forall (k : Nat), (LT.lt.{0} Nat instLTNat k (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) -> Prop) (motive : (Decidable (forall (n_1 : Nat) (h : LT.lt.{0} Nat instLTNat n_1 n), P n_1 (Nat.lt_succ_of_lt n_1 n h))) -> Sort.{u_1}) (x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.130 : Decidable (forall (n_1 : Nat) (h : LT.lt.{0} Nat instLTNat n_1 n), P n_1 (Nat.lt_succ_of_lt n_1 n h))), (forall (h : Not (forall (n_1 : Nat) (h : LT.lt.{0} Nat instLTNat n_1 n), P n_1 (Nat.lt_succ_of_lt n_1 n h))), motive (Decidable.isFalse (forall (n_1 : Nat) (h : LT.lt.{0} Nat instLTNat n_1 n), P n_1 (Nat.lt_succ_of_lt n_1 n h)) h)) -> (forall (h : forall (n_1 : Nat) (h : LT.lt.{0} Nat instLTNat n_1 n), P n_1 (Nat.lt_succ_of_lt n_1 n h)), motive (Decidable.isTrue (forall (n_1 : Nat) (h : LT.lt.{0} Nat instLTNat n_1 n), P n_1 (Nat.lt_succ_of_lt n_1 n h)) h)) -> (motive x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.130)
-- (definition body omitted)

-- Stub: this file represents the declaration `Nat.decidableBallLT.match_3`.
-- In a full split, the body would be extracted from the environment.

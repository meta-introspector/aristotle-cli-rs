import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.Nat_le_refl
import Split.instLTNat
import Split.Decidable_isFalse
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Not

-- Nat.decidableBallLT.match_1 from environment
-- def Nat.decidableBallLT.match_1 : forall (n : Nat) (P : forall (k : Nat), (LT.lt.{0} Nat instLTNat k (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) -> Prop) (motive : (Decidable (P n (Nat.le.refl (Nat.succ n)))) -> Sort.{u_1}) (x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.167 : Decidable (P n (Nat.le.refl (Nat.succ n)))), (forall (p : Not (P n (Nat.le.refl (Nat.succ n)))), motive (Decidable.isFalse (P n (Nat.le.refl (Nat.succ n))) p)) -> (forall (p : P n (Nat.le.refl (Nat.succ n))), motive (Decidable.isTrue (P n (Nat.le.refl (Nat.succ n))) p)) -> (motive x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.167)
-- (definition body omitted)

-- Stub: this file represents the declaration `Nat.decidableBallLT.match_1`.
-- In a full split, the body would be extracted from the environment.

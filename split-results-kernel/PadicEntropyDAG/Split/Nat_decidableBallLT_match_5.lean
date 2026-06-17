import Split.Decidable
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.Nat_zero
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Nat_casesOn

-- Nat.decidableBallLT.match_5 from environment
-- def Nat.decidableBallLT.match_5 : forall (motive : forall (x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.36.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.63 : Nat) (x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.37.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.66 : forall (k : Nat), (LT.lt.{0} Nat instLTNat k x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.36.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.63) -> Prop), (forall (n : Nat) (h : LT.lt.{0} Nat instLTNat n x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.36.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.63), Decidable (x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.37.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.66 n h)) -> Sort.{u_1}) (x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.36.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.63 : Nat) (x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.37.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.66 : forall (k : Nat), (LT.lt.{0} Nat instLTNat k x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.36.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.63) -> Prop) (x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.38.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.69 : forall (n : Nat) (h : LT.lt.{0} Nat instLTNat n x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.36.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.63), Decidable (x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.37.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.66 n h)), (forall (x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.80 : forall (k : Nat), (LT.lt.{0} Nat instLTNat k (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> Prop) (x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.79 : forall (n : Nat) (h : LT.lt.{0} Nat instLTNat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))), Decidable (x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.80 n h)), motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.80 x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.79) -> (forall (n : Nat) (P : forall (k : Nat), (LT.lt.{0} Nat instLTNat k (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) -> Prop) (H : forall (n_1 : Nat) (h : LT.lt.{0} Nat instLTNat n_1 (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))), Decidable (P n_1 h)), motive (Nat.succ n) P H) -> (motive x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.36.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.63 x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.37.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.66 x._@.Init.Data.Nat.Lemmas.3005474379._hygCtx.38.Init.Data.Nat.Lemmas.3005474379._hygCtx._hyg.69)
-- (definition body omitted)

-- Stub: this file represents the declaration `Nat.decidableBallLT.match_5`.
-- In a full split, the body would be extracted from the environment.

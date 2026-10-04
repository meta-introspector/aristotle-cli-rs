import Mathlib

set_option pp.all true
-- spec: instDecidableEqFin : forall (n : Nat), DecidableEq.{1} (Fin n)
def instDecidableEqFin : forall (n : Nat), DecidableEq.{1} (Fin n) :=
  fun (n : Nat) (i : Fin n) (j : Fin n) => instDecidableEqFin.match_1.{1} n i j (fun (x._@.Init.Prelude.3376441715._hygCtx._hyg.21 : Decidable (Eq.{1} Nat (Fin.val n i) (Fin.val n j))) => Decidable (Eq.{1} (Fin n) i j)) (decEq.{1} Nat instDecidableEqNat (Fin.val n i) (Fin.val n j)) (fun (h : Eq.{1} Nat (Fin.val n i) (Fin.val n j)) => Decidable.isTrue (Eq.{1} (Fin n) i j) (Fin.eq_of_val_eq n i j h)) (fun (h : Not (Eq.{1} Nat (Fin.val n i) (Fin.val n j))) => Decidable.isFalse (Eq.{1} (Fin n) i j) (instDecidableEqFin._proof_1 n i j h))

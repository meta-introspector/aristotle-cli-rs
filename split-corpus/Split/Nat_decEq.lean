import Mathlib

set_option pp.all true
-- spec: Nat.decEq : forall (n : [mdata borrowed:1 Nat]) (m : [mdata borrowed:1 Nat]), Decidable (Eq.{1} ([mdata borrowed:1 Nat]) n m)
def Nat.decEq : forall (n : [mdata borrowed:1 Nat]) (m : [mdata borrowed:1 Nat]), Decidable (Eq.{1} ([mdata borrowed:1 Nat]) n m) :=
  fun (n : Nat) (m : Nat) => Nat.decEq.match_1.{1} (fun (x._@.Init.Prelude.18944136._hygCtx._hyg.21 : Bool) => Decidable (Eq.{1} ([mdata borrowed:1 Nat]) n m)) (Nat.beq n m) (fun (h : Eq.{1} Bool (Nat.beq n m) Bool.true) => Decidable.isTrue (Eq.{1} ([mdata borrowed:1 Nat]) n m) (Nat.eq_of_beq_eq_true n m h)) (fun (h : Eq.{1} Bool (Nat.beq n m) Bool.false) => Decidable.isFalse (Eq.{1} ([mdata borrowed:1 Nat]) n m) (Nat.ne_of_beq_eq_false n m h))

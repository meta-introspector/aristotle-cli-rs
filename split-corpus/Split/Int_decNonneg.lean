import Mathlib

set_option pp.all true
-- spec: Int.decNonneg : forall (m : [mdata borrowed:1 Int]), Decidable (Int.NonNeg m)
def Int.decNonneg : forall (m : [mdata borrowed:1 Int]), Decidable (Int.NonNeg m) :=
  fun (m : Int) => Int.neg.match_1.{1} (fun (m._@.Init.Data.Int.Basic.3174098164._hygCtx._hyg.12 : Int) => Decidable (Int.NonNeg m._@.Init.Data.Int.Basic.3174098164._hygCtx._hyg.12)) m (fun (m : Nat) => Decidable.isTrue (Int.NonNeg (Int.ofNat m)) (Int.NonNeg.mk m)) (fun (i : Nat) => Decidable.isFalse (Int.NonNeg (Int.negSucc i)) (Int.decNonneg._proof_1 i))

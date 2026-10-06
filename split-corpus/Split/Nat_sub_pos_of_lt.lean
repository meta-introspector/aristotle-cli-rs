import Mathlib

-- spec: theorem Nat.sub_pos_of_lt : forall {m : Nat} {n : Nat}, (LT.lt.{0} Nat instLTNat m n) -> (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m))
theorem Nat.sub_pos_of_lt : forall {m : Nat} {n : Nat}, (LT.lt.{0} Nat instLTNat m n) -> (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m)) :=
  fun {m : Nat} {n : Nat} (h : LT.lt.{0} Nat instLTNat m n) => Iff.mpr (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m)) (Ne.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Nat.pos_iff_ne_zero (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m)) (Nat.sub_ne_zero_of_lt m n h)

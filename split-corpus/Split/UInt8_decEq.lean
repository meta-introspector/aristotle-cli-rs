import Mathlib

set_option pp.all true
-- spec: UInt8.decEq : forall (a : UInt8) (b : UInt8), Decidable (Eq.{1} UInt8 a b)
def UInt8.decEq : forall (a : UInt8) (b : UInt8), Decidable (Eq.{1} UInt8 a b) :=
  fun (a : UInt8) (b : UInt8) => UInt8.decEq.match_1.{1} (fun (a._@.Init.Prelude.18944138._hygCtx._hyg.14 : UInt8) (b._@.Init.Prelude.18944138._hygCtx._hyg.16 : UInt8) => Decidable (Eq.{1} UInt8 a._@.Init.Prelude.18944138._hygCtx._hyg.14 b._@.Init.Prelude.18944138._hygCtx._hyg.16)) a b (fun (n : BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (m : BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) => dite.{1} (Decidable (Eq.{1} UInt8 (UInt8.ofBitVec n) (UInt8.ofBitVec m))) (Eq.{1} (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) n m) (instDecidableEqBitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) n m) (fun (h : Eq.{1} (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) n m) => Decidable.isTrue (Eq.{1} UInt8 (UInt8.ofBitVec n) (UInt8.ofBitVec m)) (UInt8.decEq._proof_1 n m h)) (fun (h : Not (Eq.{1} (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) n m)) => Decidable.isFalse (Eq.{1} UInt8 (UInt8.ofBitVec n) (UInt8.ofBitVec m)) (UInt8.decEq._proof_2 n m h)))

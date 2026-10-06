import Mathlib

-- spec: theorem ByteArray.size_empty : Eq.{1} Nat (ByteArray.size ByteArray.empty) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
theorem ByteArray.size_empty : Eq.{1} Nat (ByteArray.size ByteArray.empty) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) :=
  of_eq_true (Eq.{1} Nat (ByteArray.size ByteArray.empty) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Eq.trans.{1} Prop (Eq.{1} Nat (ByteArray.size ByteArray.empty) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Eq.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) True (congrFun'.{1, 1} Nat Prop (Eq.{1} Nat (ByteArray.size ByteArray.empty)) (Eq.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (congrArg.{1, 1} Nat (Nat -> Prop) (ByteArray.size ByteArray.empty) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Eq.{1} Nat) (List.size_toArray.{0} UInt8 (List.nil.{0} UInt8))) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (eq_self.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))))

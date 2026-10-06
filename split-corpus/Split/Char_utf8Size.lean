import Mathlib

set_option pp.all true
-- spec: Char.utf8Size : Char -> Nat
def Char.utf8Size : Char -> Nat :=
  fun (c : Char) => have v : UInt32 := Char.val c; ite.{1} Nat (LE.le.{0} UInt32 instLEUInt32 v (UInt32.ofNatLT (OfNat.ofNat.{0} ([mdata borrowed:1 Nat]) 127 (instOfNatNat 127)) Char.utf8Size._proof_1)) (UInt32.decLe v (UInt32.ofNatLT (OfNat.ofNat.{0} ([mdata borrowed:1 Nat]) 127 (instOfNatNat 127)) Char.utf8Size._proof_1)) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (ite.{1} Nat (LE.le.{0} UInt32 instLEUInt32 v (UInt32.ofNatLT (OfNat.ofNat.{0} ([mdata borrowed:1 Nat]) 2047 (instOfNatNat 2047)) Char.utf8Size._proof_2)) (UInt32.decLe v (UInt32.ofNatLT (OfNat.ofNat.{0} ([mdata borrowed:1 Nat]) 2047 (instOfNatNat 2047)) Char.utf8Size._proof_2)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (ite.{1} Nat (LE.le.{0} UInt32 instLEUInt32 v (UInt32.ofNatLT (OfNat.ofNat.{0} ([mdata borrowed:1 Nat]) 65535 (instOfNatNat 65535)) Char.utf8Size._proof_3)) (UInt32.decLe v (UInt32.ofNatLT (OfNat.ofNat.{0} ([mdata borrowed:1 Nat]) 65535 (instOfNatNat 65535)) Char.utf8Size._proof_3)) (OfNat.ofNat.{0} Nat 3 (instOfNatNat 3)) (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4))))

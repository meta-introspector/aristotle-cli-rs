import Mathlib

set_option pp.all true
-- spec: Lean.PersistentHashMap.branching : USize
def Lean.PersistentHashMap.branching : USize :=
  USize.ofNat (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (USize.toNat Lean.PersistentHashMap.shift))

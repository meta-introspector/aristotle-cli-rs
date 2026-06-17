import Mathlib

set_option pp.all true
-- spec: AddressType.ofNat : Nat -> AddressType
def AddressType.ofNat : Nat -> AddressType :=
  fun (n : Nat) => cond.{1} AddressType (Nat.ble n 3) (cond.{1} AddressType (Nat.ble n 1) (cond.{1} AddressType (Nat.ble n 0) AddressType.monsterWalk AddressType.astNode) (cond.{1} AddressType (Nat.ble n 2) AddressType.protocol AddressType.nestedCID)) (cond.{1} AddressType (Nat.ble n 5) (cond.{1} AddressType (Nat.ble n 4) AddressType.harmonicPath AddressType.shardId) (cond.{1} AddressType (Nat.ble n 6) AddressType.eigenspace AddressType.hauptmodul))

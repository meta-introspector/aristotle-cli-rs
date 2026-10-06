import Mathlib

set_option pp.all true
-- spec: instInhabitedUInt64 : Inhabited.{1} UInt64
def instInhabitedUInt64 : Inhabited.{1} UInt64 :=
  Inhabited.mk.{1} UInt64 (UInt64.ofNatLT (OfNat.ofNat.{0} ([mdata borrowed:1 Nat]) 0 (instOfNatNat 0)) instInhabitedUInt64._proof_1)

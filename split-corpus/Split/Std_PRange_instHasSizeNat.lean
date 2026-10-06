import Mathlib

set_option pp.all true
-- spec: Std.PRange.instHasSizeNat : Std.Rxc.HasSize.{0} Nat
def Std.PRange.instHasSizeNat : Std.Rxc.HasSize.{0} Nat :=
  Std.Rxc.HasSize.mk.{0} Nat (fun (lo : Nat) (hi : Nat) => HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) hi (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) lo)

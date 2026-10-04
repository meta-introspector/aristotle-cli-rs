import Mathlib

set_option pp.all true
-- spec: Std.PRange.instUpwardEnumerableNat : Std.PRange.UpwardEnumerable.{0} Nat
def Std.PRange.instUpwardEnumerableNat : Std.PRange.UpwardEnumerable.{0} Nat :=
  Std.PRange.UpwardEnumerable.mk.{0} Nat (fun (n : Nat) => Option.some.{0} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (fun (k : Nat) (n : Nat) => Option.some.{0} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n k))

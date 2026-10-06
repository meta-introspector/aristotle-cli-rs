import Mathlib

set_option pp.all true
-- spec: instToStringFormat : ToString.{0} Std.Format
def instToStringFormat : ToString.{0} Std.Format :=
  ToString.mk.{0} Std.Format (fun (f : Std.Format) => Std.Format.pretty f Std.Format.defWidth (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))

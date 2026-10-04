import Mathlib

set_option pp.all true
-- spec: Repr.addAppParen : Std.Format -> Nat -> Std.Format
def Repr.addAppParen : Std.Format -> Nat -> Std.Format :=
  fun (f : Std.Format) (prec : Nat) => ite.{1} Std.Format (GE.ge.{0} Nat instLENat prec (OfNat.ofNat.{0} Nat 1024 (instOfNatNat 1024))) (Nat.decLe (OfNat.ofNat.{0} Nat 1024 (instOfNatNat 1024)) prec) (Std.Format.paren f) f

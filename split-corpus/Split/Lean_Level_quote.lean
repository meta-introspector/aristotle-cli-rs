import Mathlib

set_option pp.all true
-- spec: Lean.Level.quote : Lean.Level -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Bool Bool.true) -> Lean.Syntax.Level
def Lean.Level.quote : Lean.Level -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Bool Bool.true) -> Lean.Syntax.Level :=
  fun (u : Lean.Level) (prec : Nat) (mvars : Bool) => Lean.Level.PP.Result.quote (Lean.Level.PP.toResult u mvars) prec

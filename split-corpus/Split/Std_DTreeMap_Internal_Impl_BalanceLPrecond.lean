import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.Internal.Impl.BalanceLPrecond : Nat -> Nat -> Prop
def Std.DTreeMap.Internal.Impl.BalanceLPrecond : Nat -> Nat -> Prop :=
  fun (left : Nat) (right : Nat) => Or (Std.DTreeMap.Internal.Impl.BalancedAtRoot left right) (And (LE.le.{0} Nat instLENat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) left) (Std.DTreeMap.Internal.Impl.BalancedAtRoot (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) left (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) right))

import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.Internal.Impl.BalancedAtRoot : Nat -> Nat -> Prop
def Std.DTreeMap.Internal.Impl.BalancedAtRoot : Nat -> Nat -> Prop :=
  fun (left : Nat) (right : Nat) => Or (LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) left right) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (And (LE.le.{0} Nat instLENat left (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) Std.DTreeMap.Internal.delta right)) (LE.le.{0} Nat instLENat right (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) Std.DTreeMap.Internal.delta left)))

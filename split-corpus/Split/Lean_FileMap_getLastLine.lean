import Mathlib

set_option pp.all true
-- spec: Lean.FileMap.getLastLine : Lean.FileMap -> Nat
def Lean.FileMap.getLastLine : Lean.FileMap -> Nat :=
  fun (fmap : Lean.FileMap) => HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Array.size.{0} String.Pos.Raw (Lean.FileMap.positions fmap)) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))

import Mathlib

set_option pp.all true
-- spec: Lean.NameGenerator.next : Lean.NameGenerator -> Lean.NameGenerator
def Lean.NameGenerator.next : Lean.NameGenerator -> Lean.NameGenerator :=
  fun (g : Lean.NameGenerator) => Lean.NameGenerator.mk (Lean.NameGenerator.namePrefix g) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Lean.NameGenerator.idx g) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))

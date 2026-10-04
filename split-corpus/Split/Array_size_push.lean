import Mathlib

-- spec: theorem Array.size_push : forall {α : Type.{u}} {xs : Array.{u} α} (v : α), Eq.{1} Nat (Array.size.{u} α (Array.push.{u} α xs v)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Array.size.{u} α xs) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))
theorem Array.size_push : forall {α : Type.{u}} {xs : Array.{u} α} (v : α), Eq.{1} Nat (Array.size.{u} α (Array.push.{u} α xs v)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Array.size.{u} α xs) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) :=
  fun {α : Type.{u}} {xs : Array.{u} α} (v : α) => List.length_concat.{u} α (Array.toList.{u} α xs) v

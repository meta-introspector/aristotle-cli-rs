import Mathlib

-- spec: theorem Array.size_empty : forall {α : Type.{u_1}}, Eq.{1} Nat (Array.size.{u_1} α (List.toArray.{u_1} α (List.nil.{u_1} α))) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
theorem Array.size_empty : forall {α : Type.{u_1}}, Eq.{1} Nat (Array.size.{u_1} α (List.toArray.{u_1} α (List.nil.{u_1} α))) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) :=
  fun {α : Type.{u_1}} => rfl.{1} Nat (Array.size.{u_1} α (List.toArray.{u_1} α (List.nil.{u_1} α)))

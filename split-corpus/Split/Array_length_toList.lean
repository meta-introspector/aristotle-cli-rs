import Mathlib

-- spec: theorem Array.length_toList : forall {α : Type.{u_1}} {xs : Array.{u_1} α}, Eq.{1} Nat (List.length.{u_1} α (Array.toList.{u_1} α xs)) (Array.size.{u_1} α xs)
theorem Array.length_toList : forall {α : Type.{u_1}} {xs : Array.{u_1} α}, Eq.{1} Nat (List.length.{u_1} α (Array.toList.{u_1} α xs)) (Array.size.{u_1} α xs) :=
  fun {α : Type.{u_1}} {xs : Array.{u_1} α} => rfl.{1} Nat (List.length.{u_1} α (Array.toList.{u_1} α xs))

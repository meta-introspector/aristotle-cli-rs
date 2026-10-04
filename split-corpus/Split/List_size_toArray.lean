import Mathlib

-- spec: theorem List.size_toArray : forall {α : Type.{u}} {as : List.{u} α}, Eq.{1} Nat (Array.size.{u} α (List.toArray.{u} α as)) (List.length.{u} α as)
theorem List.size_toArray : forall {α : Type.{u}} {as : List.{u} α}, Eq.{1} Nat (Array.size.{u} α (List.toArray.{u} α as)) (List.length.{u} α as) :=
  fun {α : Type.{u}} {as : List.{u} α} => of_eq_true (Eq.{1} Nat (List.length.{u} α as) (List.length.{u} α as)) (eq_self.{1} Nat (List.length.{u} α as))

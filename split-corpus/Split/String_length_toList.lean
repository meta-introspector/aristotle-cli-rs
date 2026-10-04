import Mathlib

-- spec: theorem String.length_toList : forall {s : String}, Eq.{1} Nat (List.length.{0} Char (String.toList s)) (String.length s)
theorem String.length_toList : forall {s : String}, Eq.{1} Nat (List.length.{0} Char (String.toList s)) (String.length s) :=
  fun {s : String} => rfl.{1} Nat (List.length.{0} Char (String.toList s))

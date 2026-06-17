import Mathlib

-- spec: theorem String.toByteArray_ofList : forall {l : List.{0} Char}, Eq.{1} ByteArray (String.toByteArray (String.ofList l)) (List.utf8Encode l)
theorem String.toByteArray_ofList : forall {l : List.{0} Char}, Eq.{1} ByteArray (String.toByteArray (String.ofList l)) (List.utf8Encode l) :=
  fun {l : List.{0} Char} => of_eq_true (Eq.{1} ByteArray (List.utf8Encode l) (List.utf8Encode l)) (eq_self.{1} ByteArray (List.utf8Encode l))

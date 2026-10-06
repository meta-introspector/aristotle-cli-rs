import Mathlib

-- spec: theorem String.Pos.Raw.byteIdx_offsetBy : forall {p : String.Pos.Raw} {offset : String.Pos.Raw}, Eq.{1} Nat (String.Pos.Raw.byteIdx (String.Pos.Raw.offsetBy p offset)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (String.Pos.Raw.byteIdx offset) (String.Pos.Raw.byteIdx p))
theorem String.Pos.Raw.byteIdx_offsetBy : forall {p : String.Pos.Raw} {offset : String.Pos.Raw}, Eq.{1} Nat (String.Pos.Raw.byteIdx (String.Pos.Raw.offsetBy p offset)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (String.Pos.Raw.byteIdx offset) (String.Pos.Raw.byteIdx p)) :=
  fun {p : String.Pos.Raw} {offset : String.Pos.Raw} => rfl.{1} Nat (String.Pos.Raw.byteIdx (String.Pos.Raw.offsetBy p offset))

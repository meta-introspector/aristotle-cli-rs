import Mathlib

-- spec: theorem String.Pos.isValid : forall {s : String} (self : String.Pos s), String.Pos.Raw.IsValid s (String.Pos.offset s self)
theorem String.Pos.isValid : forall {s : String} (self : String.Pos s), String.Pos.Raw.IsValid s (String.Pos.offset s self) :=
  fun (s : String) (self : String.Pos s) => self.2

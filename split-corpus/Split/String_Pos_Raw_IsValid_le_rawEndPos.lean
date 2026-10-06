import Mathlib

-- spec: theorem String.Pos.Raw.IsValid.le_rawEndPos : forall {s : String} {off : String.Pos.Raw}, (String.Pos.Raw.IsValid s off) -> (LE.le.{0} String.Pos.Raw String.instLERaw off (String.rawEndPos s))
theorem String.Pos.Raw.IsValid.le_rawEndPos : forall {s : String} {off : String.Pos.Raw}, (String.Pos.Raw.IsValid s off) -> (LE.le.{0} String.Pos.Raw String.instLERaw off (String.rawEndPos s)) :=
  fun (s : String) (off : String.Pos.Raw) (self : String.Pos.Raw.IsValid s off) => self.1

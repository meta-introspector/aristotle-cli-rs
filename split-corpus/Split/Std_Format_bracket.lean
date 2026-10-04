import Mathlib

set_option pp.all true
-- spec: Std.Format.bracket : String -> Std.Format -> String -> Std.Format
def Std.Format.bracket : String -> Std.Format -> String -> Std.Format :=
  fun (l : String) (f : Std.Format) (r : String) => Std.Format.group (Std.Format.nest (Nat.cast.{0} Int instNatCastInt (String.Internal.length l)) (HAppend.hAppend.{0, 0, 0} Std.Format Std.Format Std.Format (instHAppendOfAppend.{0} Std.Format Std.Format.instAppend) (HAppend.hAppend.{0, 0, 0} Std.Format Std.Format Std.Format (instHAppendOfAppend.{0} Std.Format Std.Format.instAppend) (Std.Format.text l) f) (Std.Format.text r))) Std.Format.FlattenBehavior.allOrNone

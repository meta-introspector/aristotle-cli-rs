import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Formatter.concat : (Lean.PrettyPrinter.FormatterM Unit) -> (Lean.PrettyPrinter.FormatterM Unit)
def Lean.PrettyPrinter.Formatter.concat : (Lean.PrettyPrinter.FormatterM Unit) -> (Lean.PrettyPrinter.FormatterM Unit) :=
  fun (x : Lean.PrettyPrinter.FormatterM Unit) => Lean.PrettyPrinter.Formatter.fold (fun (as : Array.{0} Std.Format) => Array.foldl.{0, 0} Std.Format Std.Format (fun (acc : Std.Format) (f : Std.Format) => [mdata save_info:1 ite.{1} Std.Format (Eq.{1} Bool (Std.Format.isNil acc) Bool.true) (instDecidableEqBool (Std.Format.isNil acc) Bool.true) f (HAppend.hAppend.{0, 0, 0} Std.Format Std.Format Std.Format (instHAppendOfAppend.{0} Std.Format Std.Format.instAppend) f acc)]) Std.Format.nil as (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{0} Std.Format as)) x

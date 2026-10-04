import Mathlib

-- spec: opaque Lean.Syntax.formatStxAux : (Option.{0} Nat) -> Bool -> Nat -> Lean.Syntax -> Std.Format
opaque Lean.Syntax.formatStxAux : (Option.{0} Nat) -> Bool -> Nat -> Lean.Syntax -> Std.Format :=
  fun (maxDepth : Option.{0} Nat) (showInfo : Bool) (depth : Nat) (a._@._internal._hyg.0 : Lean.Syntax) => Inhabited.default.{1} Std.Format Std.instInhabitedFormat

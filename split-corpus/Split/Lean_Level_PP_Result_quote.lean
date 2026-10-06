import Mathlib

-- spec: opaque Lean.Level.PP.Result.quote : Lean.Level.PP.Result -> Nat -> Lean.Syntax.Level
opaque Lean.Level.PP.Result.quote : Lean.Level.PP.Result -> Nat -> Lean.Syntax.Level :=
  fun (r : Lean.Level.PP.Result) (prec : Nat) => Inhabited.default.{1} Lean.Syntax.Level (Lean.instInhabitedTSyntax (List.cons.{0} Lean.SyntaxNodeKind (Lean.Name.mkStr1 "level") (List.nil.{0} Lean.SyntaxNodeKind)))

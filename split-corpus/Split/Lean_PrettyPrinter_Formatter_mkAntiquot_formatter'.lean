import Mathlib

-- spec: opaque Lean.PrettyPrinter.Formatter.mkAntiquot.formatter' : String -> Lean.SyntaxNodeKind -> (optParam.{1} Bool Bool.true) -> (optParam.{1} Bool Bool.false) -> Lean.PrettyPrinter.Formatter
opaque Lean.PrettyPrinter.Formatter.mkAntiquot.formatter' : String -> Lean.SyntaxNodeKind -> (optParam.{1} Bool Bool.true) -> (optParam.{1} Bool Bool.false) -> Lean.PrettyPrinter.Formatter :=
  fun (name : String) (kind : Lean.SyntaxNodeKind) (anonymous : Bool) (isPseudoKind : Bool) => Inhabited.default.{1} Lean.PrettyPrinter.Formatter (instInhabitedReaderT.{0, 0} Lean.PrettyPrinter.Formatter.Context (StateRefT' IO.RealWorld Lean.PrettyPrinter.Formatter.State Lean.Core.CoreM) Unit (instInhabitedOfMonad.{0, 0} Unit (StateRefT' IO.RealWorld Lean.PrettyPrinter.Formatter.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.PrettyPrinter.Formatter.State Lean.Core.CoreM Lean.Core.instMonadCoreM) instInhabitedPUnit.{1}))

import Mathlib

-- spec: opaque Lean.PrettyPrinter.Formatter.formatterForKind : Lean.SyntaxNodeKind -> Lean.PrettyPrinter.Formatter
opaque Lean.PrettyPrinter.Formatter.formatterForKind : Lean.SyntaxNodeKind -> Lean.PrettyPrinter.Formatter :=
  fun (k : Lean.SyntaxNodeKind) => Inhabited.default.{1} Lean.PrettyPrinter.Formatter (instInhabitedReaderT.{0, 0} Lean.PrettyPrinter.Formatter.Context (StateRefT' IO.RealWorld Lean.PrettyPrinter.Formatter.State Lean.Core.CoreM) Unit (instInhabitedOfMonad.{0, 0} Unit (StateRefT' IO.RealWorld Lean.PrettyPrinter.Formatter.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.PrettyPrinter.Formatter.State Lean.Core.CoreM Lean.Core.instMonadCoreM) instInhabitedPUnit.{1}))

import Mathlib

-- spec: opaque Lean.PrettyPrinter.Parenthesizer.parenthesizeCategoryCore : Lean.Name -> Nat -> Lean.PrettyPrinter.Parenthesizer
opaque Lean.PrettyPrinter.Parenthesizer.parenthesizeCategoryCore : Lean.Name -> Nat -> Lean.PrettyPrinter.Parenthesizer :=
  fun (cat : Lean.Name) (_prec : Nat) => Inhabited.default.{1} Lean.PrettyPrinter.Parenthesizer (instInhabitedReaderT.{0, 0} Lean.PrettyPrinter.Parenthesizer.Context (StateRefT' IO.RealWorld Lean.PrettyPrinter.Parenthesizer.State Lean.Core.CoreM) Unit (instInhabitedOfMonad.{0, 0} Unit (StateRefT' IO.RealWorld Lean.PrettyPrinter.Parenthesizer.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.PrettyPrinter.Parenthesizer.State Lean.Core.CoreM Lean.Core.instMonadCoreM) instInhabitedPUnit.{1}))

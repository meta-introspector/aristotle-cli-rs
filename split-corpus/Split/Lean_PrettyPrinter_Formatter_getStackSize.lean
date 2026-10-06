import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Formatter.getStackSize : Lean.PrettyPrinter.FormatterM Nat
def Lean.PrettyPrinter.Formatter.getStackSize : Lean.PrettyPrinter.FormatterM Nat :=
  Bind.bind.{0, 0} Lean.PrettyPrinter.FormatterM (Monad.toBind.{0, 0} Lean.PrettyPrinter.FormatterM (ReaderT.instMonad.{0, 0} Lean.PrettyPrinter.Formatter.Context (StateRefT' IO.RealWorld Lean.PrettyPrinter.Formatter.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.PrettyPrinter.Formatter.State Lean.Core.CoreM Lean.Core.instMonadCoreM))) (Array.{0} Std.Format) Nat Lean.PrettyPrinter.Formatter.getStack (fun (stack : Array.{0} Std.Format) => Pure.pure.{0, 0} Lean.PrettyPrinter.FormatterM (Applicative.toPure.{0, 0} Lean.PrettyPrinter.FormatterM (ReaderT.instApplicativeOfMonad.{0, 0} Lean.PrettyPrinter.Formatter.Context (StateRefT' IO.RealWorld Lean.PrettyPrinter.Formatter.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.PrettyPrinter.Formatter.State Lean.Core.CoreM Lean.Core.instMonadCoreM))) Nat (Array.size.{0} Std.Format stack))

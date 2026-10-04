import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.ppCategory : Lean.Name -> Lean.Syntax -> (Lean.Core.CoreM Std.Format)
def Lean.PrettyPrinter.ppCategory : Lean.Name -> Lean.Syntax -> (Lean.Core.CoreM Std.Format) :=
  fun (cat : Lean.Name) (stx : Lean.Syntax) => Bind.bind.{0, 0} Lean.Core.CoreM (Monad.toBind.{0, 0} Lean.Core.CoreM Lean.Core.instMonadCoreM) Lean.Options Std.Format (Lean.MonadOptions.getOptions Lean.Core.CoreM Lean.Core.instMonadOptionsCoreM) (fun (opts : Lean.Options) => have stx : Id.{0} Lean.Syntax := StateT.run'.{0, 0} Lean.NameSanitizerState Id.{0} (Applicative.toFunctor.{0, 0} Id.{0} (Monad.toApplicative.{0, 0} Id.{0} Id.instMonad.{0})) Lean.Syntax (Lean.sanitizeSyntax stx) (Lean.NameSanitizerState.mk opts (EmptyCollection.emptyCollection.{0} (Lean.NameMap Nat) (Lean.NameMap.instEmptyCollection Nat)) (EmptyCollection.emptyCollection.{0} (Lean.NameMap Lean.Name) (Lean.NameMap.instEmptyCollection Lean.Name))); Bind.bind.{0, 0} Lean.Core.CoreM (Monad.toBind.{0, 0} Lean.Core.CoreM Lean.Core.instMonadCoreM) Lean.Syntax Std.Format (Lean.PrettyPrinter.parenthesizeCategory cat stx) (Lean.PrettyPrinter.formatCategory cat))

import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Term.elabTerm : Lean.Syntax -> (Option.{0} Lean.Expr) -> (optParam.{1} Bool Bool.true) -> (optParam.{1} Bool Bool.true) -> (Lean.Elab.Term.TermElabM Lean.Expr)
def Lean.Elab.Term.elabTerm : Lean.Syntax -> (Option.{0} Lean.Expr) -> (optParam.{1} Bool Bool.true) -> (optParam.{1} Bool Bool.true) -> (Lean.Elab.Term.TermElabM Lean.Expr) :=
  fun (stx : Lean.Syntax) (expectedType? : Option.{0} Lean.Expr) (catchExPostpone : Bool) (implicitLambda : Bool) => Lean.withRef Lean.Elab.Term.TermElabM Lean.Elab.Term.instMonadTermElabM (Lean.MonadQuotation.toMonadRef Lean.Elab.Term.TermElabM (Lean.Elab.MonadMacroAdapter.toMonadQuotation Lean.Elab.Term.TermElabM Lean.Elab.Term.instMonadMacroAdapterTermElabM)) Lean.Expr stx (_private.Lean.Elab.Term.TermElabM.0.Lean.Elab.Term.elabTermAux expectedType? catchExPostpone implicitLambda stx)

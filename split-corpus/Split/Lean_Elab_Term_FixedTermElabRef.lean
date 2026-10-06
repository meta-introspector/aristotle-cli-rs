import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Term.FixedTermElabRef : Type
def Lean.Elab.Term.FixedTermElabRef : Type :=
  NonemptyType.type.{0} _private.Lean.Elab.Term.TermElabM.0.Lean.Elab.Term.FixedTermElabRefPointed
